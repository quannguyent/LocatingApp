using locating_app.MongoDB;
using Xunit;

namespace locating_app
{
    [CollectionDefinition(locating_appTestConsts.CollectionDefinitionName)]
    public class locating_appDomainCollection : locating_appMongoDbCollectionFixtureBase
    {

    }
}
