using locating_app.Users;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.DependencyInjection;
using Volo.Abp.Domain.Repositories;
using Volo.Abp.EventBus.Distributed;

namespace locating_app.UserDevices
{
    public class GetUserDeviceEventHandle :
        ITransientDependency,
        IDistributedEventHandler<GetUserDeviceEto>
    {
        private readonly IRepository<UserDevice, Guid> _userDeviceRepository;

        private readonly IRepository<User, Guid> _userRepository;

        public GetUserDeviceEventHandle(
            IRepository<UserDevice, Guid> userDeviceRepository,
            IRepository<User, Guid> userRepository)
        {
            _userDeviceRepository = userDeviceRepository;
            _userRepository = userRepository;
        }

        public async Task HandleEventAsync(GetUserDeviceEto eventData)
        {
            Console.WriteLine("Handle event get user device ...");

            var user = await _userRepository.FirstOrDefaultAsync(m => m.user_id == eventData.user_id);

            if (user is null)
            {
                Console.WriteLine("Get user device: User not found!");

                return;
            }

            var existedUserDevice = await _userDeviceRepository.FirstOrDefaultAsync(
                m => m.user_id == eventData.user_id
                && m.device_id == eventData.device_id
                && m.app_name == eventData.app_name);

            var userDevice = new UserDevice
            {   
                user_id = eventData.user_id,
                device_id = eventData.device_id,
                app_name = eventData.app_name,
                status = eventData.status,
                metadata = new Metadata
                {
                    firebase = new Firebase
                    {
                        token = eventData.metadata.firebase.token
                    }
                }
            };

            if (existedUserDevice is null)
            {
                await _userDeviceRepository.InsertAsync(userDevice);
            }
            else
            {
                existedUserDevice.metadata = userDevice.metadata;
                existedUserDevice.status = userDevice.status;

                await _userDeviceRepository.UpdateAsync(existedUserDevice);
            }

            Console.WriteLine("Get user device success!");
        }
    }
}
