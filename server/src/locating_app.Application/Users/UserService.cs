using AutoMapper;
using locating_app.DataResponse;
using locating_app.Localization;
using locating_app.LocationLogs;
using locating_app.Models.DataResponse;
using locating_app.UserDevices;
using locating_app.UserRelationships;
using locating_app.Utils;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Localization;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Volo.Abp.Application.Services;
using Volo.Abp.DependencyInjection;
using Volo.Abp.Domain.Repositories;
using Volo.Abp.EventBus.Distributed;

namespace locating_app.Users
{
    [Route("api/user")]
    public class UserService : 
        ApplicationService, 
        ITransientDependency
    {
        private readonly IRepository<User, Guid> _userRepository;

        private readonly IRepository<UserDevice, Guid> _userDeviceRepository;

        private readonly IRepository<UserRelationship, Guid> _userRelationshipRepository;

        private readonly IStringLocalizer<locating_appResource> _localizer;

        public UserService(
            IRepository<User, Guid> userRepository,
            IRepository<UserDevice, Guid> userDeviceRepository,
            IRepository<UserRelationship, Guid> userRelationshipRepository,
            IStringLocalizer<locating_appResource> localizer)
        {
            _userRepository = userRepository;
            _userDeviceRepository = userDeviceRepository;
            _userRelationshipRepository = userRelationshipRepository;
            _localizer = localizer;
        }

        [HttpGet]
        public async Task<DataResponse<List<UserDto>>> getAll()
        {
            var users = await _userRepository.GetListAsync();

            var usersDto = ObjectMapper.Map<List<User>, List<UserDto>>(users);

            return new DataResponse<List<UserDto>>(
                code: StatusCode.SUCCESS,
                message: "success",
                data: usersDto
            );
        }

        [Route("share/{userId}")]
        [HttpPut]
        public virtual async Task<DataResponse<object>> shareLocation(Guid userId)
        {
            var user = await _userRepository.FirstOrDefaultAsync(m => m.user_id == userId);

            if (user is null)
            {
                return new DataResponse<object>(
                    code: StatusCode.FAILURE,
                    message: "user_not_found",
                    data: null
                );
            }

            var userLastLog = user.last_location_log;

            if (userLastLog is null)
            {
                return new DataResponse<object>(
                    code: StatusCode.FAILURE,
                    message: "user_has_no_log",
                    data: null
                );
            }

            var metadata = $"{userLastLog.lat} {userLastLog.lng} {userLastLog.created_at}";

            var hash_code = metadata.GetHashCode();

            userLastLog.hash_share_code = hash_code.ToString();

            user.last_location_log = userLastLog;

            await _userRepository.UpdateAsync(user);

            return new DataResponse<object>(
                code: StatusCode.SUCCESS,
                message: "success",
                data: new
                {
                    hash_code = hash_code.ToString()
                }
            );
        }

        [Route("last-log/{userId}")]
        [HttpPut]
        public async Task<DataResponse<object>> getLastLog(Guid userId)
        {
            var user = await _userRepository.FirstOrDefaultAsync(m => m.user_id == userId);

            if (user is null)
            {
                return new DataResponse<object>(
                    code: StatusCode.FAILURE,
                    message: "user_not_found",
                    data: null
                );
            }

            var userLastLog = user.last_location_log;

            return new DataResponse<object>(
                code: StatusCode.SUCCESS,
                message: "success",
                data: userLastLog
            );
        }

        [HttpGet("status/{userId}")]
        public async Task<DataResponse<object>> getUserStatus(Guid userId)
        {
            var user = await _userRepository.FirstOrDefaultAsync(m => m.user_id == userId);

            if (user is null)
            {
                return new DataResponse<object>(
                    code: StatusCode.FAILURE,
                    message: "user_not_found",
                    data: null
                );
            }

            return new DataResponse<object>(
                code: StatusCode.SUCCESS,
                message: "success",
                data: new
                {
                    status = user.status,
                    last_time_update_status = user.last_time_update_status
                }
            );
        }

        [HttpGet("call-for-help/{userId}")]
        public async Task<DataResponse<object>> callForHelp(Guid userId)
        {
            var user = await _userRepository.FirstOrDefaultAsync(m => m.user_id == userId);

            if (user is null)
            {
                return new DataResponse<object>(
                    code: StatusCode.FAILURE,
                    message: "user_not_found",
                    data: null
                );
            }

            var queryable = await _userRelationshipRepository.GetQueryableAsync();

            var listRelationShip = queryable.Where(x => userId == x.user_id_1 || userId == x.user_id_2).ToList();

            var idListFriend = listRelationShip.Select(x => x.user_id_1 == userId ? x.user_id_2 : x.user_id_1);

            var listFriend = _userRepository.Where(x => idListFriend.Contains(x.user_id)).ToList();

            foreach (var friend in listFriend)
            {
                Thread.CurrentThread.CurrentUICulture = CultureInfo.GetCultureInfo(friend.settings.language);

                var listFriendDevice = _userDeviceRepository.Where(
                    m => m.user_id == friend.user_id
                    && m.app_name == "locating");

                var message = $"{_localizer["CallForHelp"]} {user.first_name} {user.last_name}";

                var title = _localizer["Notification"];

                var data = new
                {
                    user_id = user.user_id,
                    notification_type = "ASK_FOR_HELP"
                };

                foreach (var device in listFriendDevice)
                {
                    await PushNotification.pushNotification(message, title, data, device.metadata.firebase.token);
                }
            }

            return new DataResponse<object>(
                code: StatusCode.SUCCESS,
                message: "success",
                data: null
            );
        }
    }
}
