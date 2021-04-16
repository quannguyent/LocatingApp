using Volo.Abp.Settings;

namespace locating_app.Settings
{
    public class locating_appSettingDefinitionProvider : SettingDefinitionProvider
    {
        public override void Define(ISettingDefinitionContext context)
        {
            //Define your own settings here. Example:
            //context.Add(new SettingDefinition(locating_appSettings.MySetting1));
        }
    }
}
