using Volo.Abp.DependencyInjection;
using Volo.Abp.Ui.Branding;

namespace locating_app
{
    [Dependency(ReplaceServices = true)]
    public class locating_appBrandingProvider : DefaultBrandingProvider
    {
        public override string AppName => "locating_app";
    }
}
