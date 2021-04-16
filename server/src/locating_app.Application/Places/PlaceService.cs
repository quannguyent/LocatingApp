using locating_app.DataResponse;
using locating_app.LocationLogs;
using locating_app.Models.DataResponse;
using locating_app.Models.Place;
using locating_app.Placetrackings;
using locating_app.PlaceTrackings;
using locating_app.UserRelationships;
using locating_app.Users;
using locating_app.Utils;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.Application.Services;
using Volo.Abp.DependencyInjection;
using Volo.Abp.Domain.Repositories;

namespace locating_app.Places
{
    [Route("api/place")]
    public class PlaceService : ApplicationService, ITransientDependency
    {
        private readonly IRepository<Place, Guid> _placeRepository;

        private readonly IRepository<PlaceTracking> _placeTrackingRepository;

        private readonly IRepository<UserRelationship, Guid> _userRelationshipRepository;

        private readonly IRepository<User, Guid> _userRepository;

        private readonly IRepository<LocationLog, Guid> _locationLog;

        public PlaceService(
            IRepository<Place, Guid> placeRepository,
            IRepository<User, Guid> userRepository,
            IRepository<PlaceTracking> placeTrackingRepository,
            IRepository<UserRelationship, Guid> userRelationships) 
        {
            _placeRepository = placeRepository;
            _userRepository = userRepository;
            _placeTrackingRepository = placeTrackingRepository;
            _userRelationshipRepository = userRelationships;
        }

        [HttpGet]
        public async Task<DataResponse<List<Place>>> GetByUserId(Guid userId, Guid followingId)
        {
            try
            {
                var user = await _userRepository.FirstOrDefaultAsync(m => m.user_id == userId);

                var following = await _userRepository.FirstOrDefaultAsync(m => m.user_id == followingId);

                if (user is null || following is null)
                {
                    return new DataResponse<List<Place>>(
                        code: StatusCode.FAILURE,
                        message: "user_or_following_not_found",
                        data: null
                    );
                }

                var placeTrackings = _placeTrackingRepository.Where(m => m.user_id == userId && m.following_id == followingId).ToList();

                List<Place> places = new List<Place>();

                foreach (var placeTracking in placeTrackings)
                {
                    var place = await _placeRepository.FirstOrDefaultAsync(m => m.Id == placeTracking.place_id);
                    if (place != null) 
                        places.Add(place);
                }

                return new DataResponse<List<Place>>(
                    code: StatusCode.SUCCESS,
                    message: "success",
                    data: places
                );
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);

                return new DataResponse<List<Place>>(
                    code: StatusCode.FAILURE,
                    message: "error",
                    data: null
                );
            }
        }

        [HttpPost]
        public async Task<DataResponse<Place>> Create(Place_PlaceTracking place_PlaceTracking)
        {
            try
            {
                var user = await _userRepository.FirstOrDefaultAsync(m => m.user_id == place_PlaceTracking.user_id);

                var following = await _userRepository.FirstOrDefaultAsync(m => m.user_id == place_PlaceTracking.following_id);

                if (user is null || following is null)
                {
                    return new DataResponse<Place>(
                        code: StatusCode.FAILURE,
                        message: "user_or_following_not_found",
                        data: null
                    );
                }

                var relationship = await _userRelationshipRepository.FirstOrDefaultAsync(
                    m => (m.user_id_1 == place_PlaceTracking.user_id 
                    && m.user_id_2 == place_PlaceTracking.following_id)
                    || (m.user_id_1 == place_PlaceTracking.following_id
                    && m.user_id_2 == place_PlaceTracking.user_id));

                if (relationship == null)
                {
                    return new DataResponse<Place>(
                        code: StatusCode.FAILURE,
                        message: "relationship_not_found",
                        data: null
                    );
                }

                Place place = new Place
                {
                    lat = place_PlaceTracking.lat,
                    name = place_PlaceTracking.name,
                    address = place_PlaceTracking.address,
                    rad = place_PlaceTracking.rad,
                    lng = place_PlaceTracking.lng,
                    created_at = DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1)).TotalSeconds,
                };

                await _placeRepository.InsertAsync(place);

                var userLastLog = following.last_location_log;

                var distance = GeoCoordinate.Calculate(
                        place.lat,
                        place.lng,
                        userLastLog.lat,
                        userLastLog.lng);

                PlaceTracking placeTracking = new PlaceTracking
                {
                    user_id = place_PlaceTracking.user_id,
                    following_id = place_PlaceTracking.following_id,
                    place_id = place.Id,
                    status = distance > place_PlaceTracking.rad ? PlaceStatus.LEFT : PlaceStatus.ARRIVED,
                };

                await _placeTrackingRepository.InsertAsync(placeTracking);

                return new DataResponse<Place>(
                    code: StatusCode.SUCCESS,
                    message: "success",
                    data: place
                );
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);

                return new DataResponse<Place>(
                    code: StatusCode.FAILURE,
                    message: "error",
                    data: null
                );
            }
        }

        [HttpPut]
        public async Task<DataResponse<Place>> Update(Guid placeId, Place_PlaceTracking place_PlaceTracking)
        {
            try
            {
                PlaceTracking placeTracking = await _placeTrackingRepository.FirstOrDefaultAsync(
                    m => m.place_id == placeId && 
                    m.user_id == place_PlaceTracking.user_id && 
                    m.following_id == place_PlaceTracking.following_id);

                if (placeTracking == null)
                {
                    return new DataResponse<Place>(
                       code: StatusCode.FAILURE,
                       message: "place_tracking_not_found",
                       data: null
                   );
                }

                Place place = await _placeRepository.FirstOrDefaultAsync(m => m.Id == placeId); 
                if (place == null)
                {
                    return new DataResponse<Place>(
                        code: StatusCode.FAILURE,
                        message: "place_not_found",
                        data: null
                    );
                }
                else
                {
                    place.name = place_PlaceTracking.name;
                    place.address = place_PlaceTracking.address;
                    place.rad = place_PlaceTracking.rad;
                    place.lat = place_PlaceTracking.lat;
                    place.lng = place_PlaceTracking.lng;
                }

                var following = await _userRepository.FirstOrDefaultAsync(m => m.user_id == place_PlaceTracking.following_id);
                if (following == null)
                {
                    return new DataResponse<Place>(
                        code: StatusCode.FAILURE,
                        message: "following_user_not_found",
                        data: null
                    );
                }

                var userLastLog = following.last_location_log;

                var distance = GeoCoordinate.Calculate(
                        place.lat,
                        place.lng,
                        userLastLog.lat,
                        userLastLog.lng);

                if (distance > place.rad)
                    placeTracking.status = PlaceStatus.LEFT;
                else placeTracking.status = PlaceStatus.ARRIVED;

                await _placeRepository.UpdateAsync(place);
                await _placeTrackingRepository.UpdateAsync(placeTracking);

                return new DataResponse<Place>(
                    code: StatusCode.SUCCESS,
                    message: "success",
                    data: place
                );
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);

                return new DataResponse<Place>(
                    code: StatusCode.FAILURE,
                    message: "error",
                    data: null
                );
            }
        }

        [HttpDelete]
        public async Task<DataResponse<PlaceTrackingDto>> Delete(Guid userId, Guid followingId, Guid placeId)
        {
            try
            {
                var placeTracking = await _placeTrackingRepository.FirstOrDefaultAsync(
                    m => m.user_id == userId
                    && m.following_id == followingId
                    && m.place_id == placeId);

                if (placeTracking == null)
                {
                    return new DataResponse<PlaceTrackingDto>(
                        code: StatusCode.FAILURE,
                        message: "place_tracking_not_found",
                        data: null
                    );
                }

                Place place = await _placeRepository.FirstOrDefaultAsync(m => m.Id == placeId);

                if (place == null)
                {
                    return new DataResponse<PlaceTrackingDto>(
                        code: StatusCode.FAILURE,
                        message: "place_not_found",
                        data: null
                    );
                }

                await _placeRepository.DeleteAsync(place);
                await _placeTrackingRepository.DeleteAsync(placeTracking);

                return new DataResponse<PlaceTrackingDto>(
                    code: StatusCode.SUCCESS,
                    message: "success",
                    data: null
                );
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);

                return new DataResponse<PlaceTrackingDto>(
                    code: StatusCode.FAILURE,
                    message: "error",
                    data: null
                );
            }
        }

        [HttpPost("track")]
        public async Task<DataResponse<PlaceTrackingDto>> Track(PlaceTrackingDto placeTrackingDto)
        {
            try
            {
                PlaceTracking placeTracking = await _placeTrackingRepository.FirstOrDefaultAsync(
                    m => m.place_id == placeTrackingDto.place_id &&
                    m.user_id == placeTrackingDto.user_id &&
                    m.following_id == placeTrackingDto.following_id); 
                
                var user = await _userRepository.FirstOrDefaultAsync(m => m.user_id == placeTrackingDto.user_id);
                if (user is null)
                {
                    return new DataResponse<PlaceTrackingDto>(
                        code: StatusCode.FAILURE,
                        message: "user_not_found",
                        data: null
                    );
                }

                var following = await _userRepository.FirstOrDefaultAsync(m => m.user_id == placeTrackingDto.following_id);
                if (following is null)
                {
                    return new DataResponse<PlaceTrackingDto>(
                        code: StatusCode.FAILURE,
                        message: "following_user_not_found",
                        data: null
                    );
                }

                var relationship = await _userRelationshipRepository
                    .FirstOrDefaultAsync(m => m.user_id_1 == placeTrackingDto.user_id && m.user_id_2 == placeTrackingDto.following_id);
                if (relationship == null)
                {
                    return new DataResponse<PlaceTrackingDto>(
                        code: StatusCode.FAILURE,
                        message: "relationship_not_found",
                        data: null
                    );
                }

                Place place = await _placeRepository.FirstOrDefaultAsync(m => m.Id == placeTrackingDto.place_id);
                if (place == null)
                {
                    return new DataResponse<PlaceTrackingDto>(
                        code: StatusCode.FAILURE,
                        message: "place_not_found",
                        data: null
                    );
                }

                var userLastLog = user.last_location_log;

                var distance = GeoCoordinate.Calculate(
                    place.lat,
                    place.lng,
                    userLastLog.lat,
                    userLastLog.lng);

                if (distance < place.rad && placeTrackingDto.status == PlaceStatus.ARRIVED)
                {
                    return new DataResponse<PlaceTrackingDto>(
                        code: StatusCode.SUCCESS,
                        message: "user_hasnt_left",
                        data: null
                    );
                }
                else if (distance >= place.rad && placeTrackingDto.status == PlaceStatus.LEFT)
                {
                    return new DataResponse<PlaceTrackingDto>(
                        code: StatusCode.SUCCESS,
                        message: "user_hasnt_arrived",
                        data: null
                    );
                }
                else if (distance < place.rad && placeTrackingDto.status == PlaceStatus.LEFT)
                {
                    placeTracking.status = PlaceStatus.ARRIVED;
                    await _placeRepository.UpdateAsync(place);
                    return new DataResponse<PlaceTrackingDto>(
                        code: StatusCode.SUCCESS,
                        message: "user_has_arrived",
                        data: null
                    );
                }
                else if (distance >= place.rad && placeTrackingDto.status == PlaceStatus.ARRIVED)
                {
                    placeTracking.status = PlaceStatus.LEFT;
                    await _placeRepository.UpdateAsync(place); 
                    return new DataResponse<PlaceTrackingDto>(
                        code: StatusCode.SUCCESS,
                        message: "user_has_left",
                        data: null
                    );
                }

                else 
                    return new DataResponse<PlaceTrackingDto>(
                        code: StatusCode.FAILURE,
                        message: "cant_locate_user",
                        data: null
                    );
            }
            catch (Exception ex)
            {
                return new DataResponse<PlaceTrackingDto>(
                    code: StatusCode.FAILURE,
                    message: "error",
                    data: null
                );
            }
        }
    }
}
