using System;
using System.Collections.Generic;
using System.Text;
using locating_app.Localization;
using Volo.Abp.Application.Services;

namespace locating_app
{
    /* Inherit your application services from this class.
     */
    public abstract class locating_appAppService : ApplicationService
    {
        protected locating_appAppService()
        {
            LocalizationResource = typeof(locating_appResource);
        }
    }
}
