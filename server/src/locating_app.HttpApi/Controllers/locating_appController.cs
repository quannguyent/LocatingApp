using locating_app.Localization;
using Volo.Abp.AspNetCore.Mvc;

namespace locating_app.Controllers
{
    /* Inherit your controllers from this class.
     */
    public abstract class locating_appController : AbpController
    {
        protected locating_appController()
        {
            LocalizationResource = typeof(locating_appResource);
        }
    }
}