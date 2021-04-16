using locating_app.Localization;
using Volo.Abp.Authorization.Permissions;
using Volo.Abp.Localization;

namespace locating_app.Permissions
{
    public class locating_appPermissionDefinitionProvider : PermissionDefinitionProvider
    {
        public override void Define(IPermissionDefinitionContext context)
        {
            var myGroup = context.AddGroup(locating_appPermissions.GroupName);

            //Define your own permissions here. Example:
            //myGroup.AddPermission(locating_appPermissions.MyPermission1, L("Permission:MyPermission1"));
        }

        private static LocalizableString L(string name)
        {
            return LocalizableString.Create<locating_appResource>(name);
        }
    }
}
