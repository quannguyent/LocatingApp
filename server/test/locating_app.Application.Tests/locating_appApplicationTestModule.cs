using Volo.Abp.Modularity;

namespace locating_app
{
    [DependsOn(
        typeof(locating_appApplicationModule),
        typeof(locating_appDomainTestModule)
        )]
    public class locating_appApplicationTestModule : AbpModule
    {

    }
}