using locating_app.MongoDB;
using Xunit;

namespace locating_app
{
    [CollectionDefinition(locating_appTestConsts.CollectionDefinitionName)]
    public class locating_appApplicationCollection : locating_appMongoDbCollectionFixtureBase
    {

    }
}
