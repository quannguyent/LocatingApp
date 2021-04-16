using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using locating_app.DataResponse;
using locating_app.LocationLogs;
using locating_app.Models.DataResponse;
using locating_app.Places;
using locating_app.Placetrackings;
using locating_app.PlaceTrackings;
using locating_app.UserDevices;
using locating_app.UserRelationships;
using locating_app.Users;
using locating_app.Utils;
using Microsoft.AspNetCore.SignalR;
using Newtonsoft.Json;
using Volo.Abp.AspNetCore.SignalR;
using Volo.Abp.Domain.Repositories;

namespace locating_app.HttpApi.Host.Hub
{
    [HubRoute("/location-hub")]
    public class LocationHub : AbpHub
    {
        private readonly IRepository<UserRelationship, Guid> _userRelationshipRepository;

        private readonly IRepository<User, Guid> _userRepository;

        private readonly IRepository<Place, Guid> _placeRepository;

        private readonly IRepository<PlaceTracking> _placeTrackingRepository;

        private readonly IRepository<UserDevice, Guid> _userDeviceRepository;

        public LocationHub(
            IRepository<User, Guid> userRepository,
            IRepository<UserRelationship, Guid> userRelationshipRepository,
            IRepository<Place, Guid> placeRepository,
            IRepository<PlaceTracking> placeTrackingRepository,
            IRepository<UserDevice, Guid> userDeviceRepository
        )
        {
            _userRelationshipRepository = userRelationshipRepository;
            _userRepository = userRepository;
            _placeRepository = placeRepository;
            _placeTrackingRepository = placeTrackingRepository;
            _userDeviceRepository = userDeviceRepository;
        }
            
        public async Task RegisterFriendLocation(Guid id)
        {
            while (true)
            {
                var listFriendLocationLog = await LocationData.GetFriendLocation(id, _userRelationshipRepository, _userRepository, _placeTrackingRepository);

                await Clients.Caller.SendAsync(
                    "ReceiveFriendLocation",
                    listFriendLocationLog
                );
            }
        }
    }

    public class LocationData
    {
        public static async Task<DataResponse<List<object>>> GetFriendLocation(
            Guid id,
            IRepository<UserRelationship, Guid> _userRelationshipRepository,
            IRepository<User, Guid> _userRepository,
            IRepository<PlaceTracking> _placeTrackingRepository
        )
        {
            var queryable = await _userRelationshipRepository.GetQueryableAsync();

            var listRelationShip = queryable.Where(x => id == x.user_id_1 || id == x.user_id_2).ToList();

            var idListFriend = listRelationShip.Select(x => x.user_id_1 == id ? x.user_id_2 : x.user_id_1);

            var listFriend = _userRepository.Where(x => idListFriend.Contains(x.user_id));

            var result = new List<object>();

            foreach (var friend in listFriend)
            {
                if (friend.last_location_log is null) break;

                var placeTracking = await _placeTrackingRepository.FirstOrDefaultAsync(
                    m => m.user_id == id
                    && m.following_id == friend.user_id
                    && m.status == PlaceStatus.ARRIVED);

                if (placeTracking is null)
                {
                    result.Add(new
                    {
                        last_location_log = friend.last_location_log
                    });
                }
                else
                {
                    result.Add(new
                    {
                        last_location_log = friend.last_location_log,
                        place_id = placeTracking.place_id,
                        status = placeTracking.status
                    });
                }

            }

            return new DataResponse<List<object>>(
                code: StatusCode.SUCCESS,
                message: "success",
                data: result
            );
        }

    }
}
