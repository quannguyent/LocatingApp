using System;
using Volo.Abp.Data;
using Volo.Abp.Modularity;

namespace locating_app.MongoDB
{
    [DependsOn(
        typeof(locating_appTestBaseModule),
        typeof(locating_appMongoDbModule)
        )]
    public class locating_appMongoDbTestModule : AbpModule
    {
        public override void ConfigureServices(ServiceConfigurationContext context)
        {
            var stringArray = locating_appMongoDbFixture.ConnectionString.Split('?');
                        var connectionString = stringArray[0].EnsureEndsWith('/')  +
                                                   "Db_" +
                                               Guid.NewGuid().ToString("N") + "/?" + stringArray[1];

            Configure<AbpDbConnectionOptions>(options =>
            {
                options.ConnectionStrings.Default = connectionString;
            });
        }
    }
}
