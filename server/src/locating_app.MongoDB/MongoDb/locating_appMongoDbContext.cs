using MongoDB.Driver;
using locating_app.Users;
using Volo.Abp.Data;
using Volo.Abp.MongoDB;
using locating_app.LocationLogs;
using locating_app.Places;
using locating_app.PlaceTrackings;
using locating_app.Reports;
using locating_app.UserRelationships;
using locating_app.UserAnnotations;
using locating_app.Conversations;
using locating_app.ConnectionHubs;
using locating_app.UserDevices;
using locating_app.Messages;

namespace locating_app.MongoDB
{
    [ConnectionStringName("Default")]
    public class locating_appMongoDbContext : AbpMongoDbContext
    {
        /*public IMongoCollection<AppUser> Users => Collection<AppUser>();*/

        public IMongoCollection<User> Users => Collection<User>();

        public IMongoCollection<Conversation> Conversations => Collection<Conversation>();

        public IMongoCollection<LocationLog> LocationLogs => Collection<LocationLog>();

        public IMongoCollection<Place> Places => Collection<Place>();

        public IMongoCollection<PlaceTracking> PlaceTrackings => Collection<PlaceTracking>();

        public IMongoCollection<Report> Reports => Collection<Report>();

        public IMongoCollection<UserRelationship> UserRelationships => Collection<UserRelationship>();

        public IMongoCollection<UserAnnotation> UserAnnotations => Collection<UserAnnotation>();

        public IMongoCollection<ConnectionHub> ConnectionHubs => Collection<ConnectionHub>();

        public IMongoCollection<UserDevice> UserDevices => Collection<UserDevice>();

        public IMongoCollection<Message> Messages => Collection<Message>();

        protected override void CreateModel(IMongoModelBuilder modelBuilder)
        {
            base.CreateModel(modelBuilder);

            modelBuilder.Entity<AppUser>(b =>
            {
                /* Sharing the same "AbpUsers" collection
                 * with the Identity module's IdentityUser class. */
                b.CollectionName = "AbpUsers";
            });

            /*modelBuilder.Entity<LocationLog>(b =>
            {
                b.CollectionName = "LocationLogs";
            });

            modelBuilder.Entity<User>(b =>
            {
                b.CollectionName = "Users";
            });

            modelBuilder.Entity<Chat>(b =>
            {
                b.CollectionName = "Chats";
            });

            modelBuilder.Entity<Place>(b =>
            {
                b.CollectionName = "Places";
            });

            modelBuilder.Entity<PlaceTracking>(b =>
            {
                b.CollectionName = "PlaceTrackings";
            });

            modelBuilder.Entity<Report>(b =>
            {
                b.CollectionName = "Reports";
            });

            modelBuilder.Entity<UserRelationship>(b =>
            {
                b.CollectionName = "UserRelationships";
            });*/
        }
    }
}
