using AutoMapper;
using locating_app.DataResponse;
using locating_app.Localization;
using locating_app.Models.DataResponse;
using locating_app.Places;
using locating_app.Placetrackings;
using locating_app.PlaceTrackings;
using locating_app.UserDevices;
using locating_app.Users;
using locating_app.Utils;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Localization;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;
using Volo.Abp.Application.Services;
using Volo.Abp.DependencyInjection;
using Volo.Abp.Domain.Repositories;
using Volo.Abp.Uow;

namespace locating_app.LocationLogs
{
    [Route("api/location-log")]
    public class LocationLogService : ApplicationService, ITransientDependency
    {

        private readonly IRepository<LocationLog, Guid> _locationLogRepository;

        /*private readonly IUserRepository _userRepository;*/

        private readonly IRepository<User, Guid> _userRepository;

        private readonly IRepository<Place, Guid> _placeRepository;

        private readonly IRepository<PlaceTracking, Guid> _placeTrackingRepository;

        private readonly IRepository<UserDevice, Guid> _userDeviceRepository;

        private readonly IStringLocalizer<locating_appResource> _localizer;

        public LocationLogService(
            IRepository<LocationLog, Guid> locationLogRepository,
            IRepository<User, Guid> userRepository,
            IRepository<Place, Guid> placeRepository,
            IRepository<PlaceTracking, Guid> placeTrackingRepository,
            IRepository<UserDevice, Guid> userDeviceRepository,
            IStringLocalizer<locating_appResource> localizer)
        {
            _locationLogRepository = locationLogRepository;
            _userRepository = userRepository;
            _placeRepository = placeRepository;
            _placeTrackingRepository = placeTrackingRepository;
            _userDeviceRepository = userDeviceRepository;
            _localizer = localizer;
        }

        [HttpGet]
        public async Task<DataResponse<List<LocationLog>>> getAll()
        {
            var locationLogs = await _locationLogRepository.GetListAsync();

            return new DataResponse<List<LocationLog>>(
                code: StatusCode.SUCCESS,
                message: "success",
                data: locationLogs
            );
        }

        [HttpGet("{userId}")]
        public async Task<DataResponse<List<LocationLog>>> getByUserId(
            Guid userId, 
            double sTime,
            double eTime,
            double topRightPointLat, 
            double topRightPointLng, 
            double bottomLeftPointLat, 
            double bottomLeftPointLng)
        {

            var firstLog = await _locationLogRepository.FirstOrDefaultAsync(m => m.user_id == userId && m.created_at >= sTime && m.created_at <= eTime);

            if (firstLog != null)
            {
                var lastLog = firstLog;

                for (var lamda = 10; eTime - lamda > firstLog.created_at; lamda *= 2)
                {
                    lastLog = _locationLogRepository.Where(
                            m => m.user_id == userId
                            && m.created_at >= eTime - lamda
                            && m.created_at <= eTime
                        ).OrderByDescending(m => m.created_at).FirstOrDefault();

                    if (lastLog != null) break;

                    if (eTime - lamda * 2 < firstLog.created_at)
                    {
                        lastLog = _locationLogRepository.Where(
                            m => m.user_id == userId
                            && m.created_at >= sTime
                            && m.created_at <= eTime
                        ).OrderByDescending(m => m.created_at).FirstOrDefault();
                    }
                }

                List<LocationLog> list = new List<LocationLog>();

                if (lastLog is null)
                {
                    list.Add(firstLog);

                    return new DataResponse<List<LocationLog>>(
                        code: StatusCode.SUCCESS,
                        message: "success",
                        data: list
                    );
                }

                var firstIndex = firstLog.count;
                var lastIndex = lastLog.count;

                var temp = (lastIndex - firstIndex) / 15 > 1 ? (lastIndex - firstIndex) / 15 : 1;
                List<int> listIndexToGetLog = new List<int>();
                List<int> listFixedIndexToGetLog = new List<int>();

                for (
                    var i = firstIndex;
                    i < lastIndex;
                    i += temp)
                {
                    listFixedIndexToGetLog.Add(i);
                    for (
                        var j = i; 
                        j < i + temp;
                        j += temp / 15 > 1 ? temp / 15 : 1)
                    {
                        listIndexToGetLog.Add(j);
                    }
                }

                listFixedIndexToGetLog.Add(lastIndex);
                listIndexToGetLog.RemoveAll(listFixedIndexToGetLog);

                var locationLogs = _locationLogRepository.Where(
                    m => m.user_id == userId
                    && (listFixedIndexToGetLog.Contains(m.count) 
                    || listIndexToGetLog.Contains(m.count))
                ).ToList();

                foreach (var log in locationLogs)
                {
                    if (GeoCoordinate.filterLogInsideScreen(log.lat, log.lng, topRightPointLat, topRightPointLng, bottomLeftPointLat, bottomLeftPointLng)
                        || listFixedIndexToGetLog.Contains(log.count))
                    {
                        list.Add(log);
                    }
                }

                return new DataResponse<List<LocationLog>>(
                    code: StatusCode.SUCCESS,
                    message: "success",
                    data: list
                );
            }

            return new DataResponse<List<LocationLog>>(
                code: StatusCode.SUCCESS,
                message: "user_has_no_log",
                data: null
            );
        }

        [HttpPost]
        public virtual async Task<DataResponse<LocationLogDto>> create(LocationLogDto input)
        {
            try
            {

                var user = await _userRepository.FirstOrDefaultAsync(m => m.user_id == input.user_id);

                if (user is null)
                {
                    return new DataResponse<LocationLogDto>(
                        code: StatusCode.FAILURE,
                        message: "user_not_found",
                        data: null
                    );
                }

                var locationLog = new LocationLog
                {
                    user_id = input.user_id,
                    content = input.content,
                    created_at = DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1)).TotalSeconds,
                    lat = input.lat,
                    lng = input.lng,
                    hash_share_code = input.hash_share_code,
                    place_id = input.place_id,
                    count = user.total_logs + 1
                };

                var userLastLog = user.last_location_log;

                if (userLastLog != null)
                {
                    var last_log_time = userLastLog.created_at;
                    var time_between = locationLog.created_at - last_log_time;

                    //check khoang thoi gian giua 2 lan req
                    if (time_between < 2)
                    {
                        return new DataResponse<LocationLogDto>(
                            code: StatusCode.FAILURE,
                            message: "time_between_req_very_little",
                            data: null
                        );
                    }

                    var distance = GeoCoordinate.Calculate(
                        input.lat,
                        input.lng,
                        userLastLog.lat,
                        userLastLog.lng);

                    //check vi tri cua nguoi dung xem ho co di chuyen > 10m k
                    if (distance < 5)
                    {
                        return new DataResponse<LocationLogDto>(
                            code: StatusCode.FAILURE,
                            message: "user_has_not_moved",
                            data: null
                        );
                    }
                }

                await _locationLogRepository.InsertAsync(locationLog);

                user.last_location_log = locationLog;

                user.total_logs += 1;

                await _userRepository.UpdateAsync(user);

                var listFollower = _placeTrackingRepository.Where(m => m.following_id == locationLog.user_id);

                foreach (var follower in listFollower)
                {
                    var place = await _placeRepository.FirstOrDefaultAsync(m => m.Id == follower.place_id);

                    if (place is null) break;

                    var distance = GeoCoordinate.Calculate(
                        place.lat,
                        place.lng,
                        locationLog.lat,
                        locationLog.lng);

                    var userDevice = _userDeviceRepository.Where(
                        m => m.user_id == follower.user_id
                        && m.app_name == "locating");

                    var userFollow = await _userRepository.FirstOrDefaultAsync(m => m.user_id == follower.user_id);

                    Thread.CurrentThread.CurrentUICulture = CultureInfo.GetCultureInfo(userFollow.settings.language);

                    if (distance >= place.rad && follower.status == PlaceStatus.ARRIVED)    
                    {
                        follower.status = PlaceStatus.LEFT;

                        await _placeTrackingRepository.UpdateAsync(follower);

                        var message = $"{user.first_name} {user.last_name} {_localizer["UserLeft"]}!";

                        var title = _localizer["Notification"];

                        var data = new
                        {
                            user_id = userFollow.user_id
                        };

                        foreach (var device in userDevice)
                        {
                            await PushNotification.pushNotification(message, title, data, device.metadata.firebase.token);
                        }

                        Console.WriteLine("user left");
                    }
                    else if (distance < place.rad && follower.status == PlaceStatus.LEFT)
                    {
                        follower.status = PlaceStatus.ARRIVED;

                        await _placeTrackingRepository.UpdateAsync(follower);

                        var message = $"{user.first_name} {user.last_name} {_localizer["UserArrived"]}!";

                        var title = _localizer["Notification"];

                        var data = new
                        {
                            user_id = userFollow.user_id
                        };

                        foreach (var device in userDevice)
                        {
                            await PushNotification.pushNotification(message, title, data, device.metadata.firebase.token);
                        }

                        Console.WriteLine("user arrived");
                    }
                }

                var locationLogDto = ObjectMapper.Map<LocationLog, LocationLogDto>(locationLog);

                return new DataResponse<LocationLogDto>(
                    code: StatusCode.SUCCESS,
                    message: "success",
                    data: locationLogDto
                );
            }
            catch (Exception e)
            {
                Console.WriteLine(e);

                return new DataResponse<LocationLogDto>(
                    code: StatusCode.FAILURE,
                    message: "error",
                    data: input
                );
            }
        }
    }
}
