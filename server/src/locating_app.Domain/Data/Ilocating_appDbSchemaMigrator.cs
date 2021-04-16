using System.Threading.Tasks;

namespace locating_app.Data
{
    public interface Ilocating_appDbSchemaMigrator
    {
        Task MigrateAsync();
    }
}
