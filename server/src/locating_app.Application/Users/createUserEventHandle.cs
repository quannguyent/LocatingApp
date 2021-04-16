using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.DependencyInjection;
using Volo.Abp.Domain.Repositories;
using Volo.Abp.EventBus.Distributed;

namespace locating_app.Users
{
    public class createUserEventHandle :
        ITransientDependency,
        IDistributedEventHandler<ChangeUserDto>
    {
        private readonly IRepository<User, Guid> _userRepository;

        public createUserEventHandle(IRepository<User, Guid> userRepository)
        {
            _userRepository = userRepository;
        }

        public async Task HandleEventAsync(ChangeUserDto eventData)
        {
            Console.WriteLine("Handle event create user ...");

            var user = new User
            {
                user_id = eventData.user_id,
                first_name = eventData.first_name,
                last_name = eventData.last_name,
                settings = new Setting
                {
                    language = eventData.language
                }
            };

            var existedUser = await _userRepository.FirstOrDefaultAsync(m => m.user_id == eventData.user_id);

            if (existedUser is null)
            {
                await _userRepository.InsertAsync(user);
            }
            else
            {
                Console.WriteLine("User already exist!");

                return;
            }

            Console.WriteLine("create user success!");
        }
    }
}
