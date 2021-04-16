using locating_app.Users;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.Data;
using Volo.Abp.DependencyInjection;
using Volo.Abp.Domain.Repositories;

namespace locating_app
{
    class UsersDataSeederContributor
        : IDataSeedContributor, ITransientDependency
    {

        private readonly IRepository<User, Guid> _userRepository;

        public UsersDataSeederContributor(IRepository<User, Guid> userRepository)
        {
            _userRepository = userRepository;
        }

        public async Task SeedAsync(DataSeedContext context)
        {
            if (await _userRepository.GetCountAsync() <= 0)
            {
                await _userRepository.InsertAsync(
                    new User
                    {
                        user_id = Guid.NewGuid(),
                        /* avatar_id = Guid.NewGuid(),
                         phone = "0123456789",*/
                        last_location_log = { }
                    },
                    autoSave: true
                );
            }
        }
    }
}
