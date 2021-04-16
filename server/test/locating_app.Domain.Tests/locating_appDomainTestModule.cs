using locating_app.MongoDB;
using Volo.Abp.Modularity;

namespace locating_app
{
    [DependsOn(
        typeof(locating_appMongoDbTestModule)
        )]
    public class locating_appDomainTestModule : AbpModule
    {

    }
}