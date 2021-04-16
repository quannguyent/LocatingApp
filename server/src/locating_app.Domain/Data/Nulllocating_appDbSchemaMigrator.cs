using System.Threading.Tasks;
using Volo.Abp.DependencyInjection;

namespace locating_app.Data
{
    /* This is used if database provider does't define
     * Ilocating_appDbSchemaMigrator implementation.
     */
    public class Nulllocating_appDbSchemaMigrator : Ilocating_appDbSchemaMigrator, ITransientDependency
    {
        public Task MigrateAsync()
        {
            return Task.CompletedTask;
        }
    }
}