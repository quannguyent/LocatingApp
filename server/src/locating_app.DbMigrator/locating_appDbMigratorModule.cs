using locating_app.MongoDB;
using Volo.Abp.Autofac;
using Volo.Abp.BackgroundJobs;
using Volo.Abp.Modularity;

namespace locating_app.DbMigrator
{
    [DependsOn(
        typeof(AbpAutofacModule),
        typeof(locating_appMongoDbModule),
        typeof(locating_appApplicationContractsModule)
        )]
    public class locating_appDbMigratorModule : AbpModule
    {
        public override void ConfigureServices(ServiceConfigurationContext context)
        {
            Configure<AbpBackgroundJobOptions>(options => options.IsJobExecutionEnabled = false);
        }
    }
}
