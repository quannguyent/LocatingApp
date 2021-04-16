using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.Domain.Entities.Auditing;

namespace locating_app.UserDevices
{
    [BsonIgnoreExtraElements]
    public class UserDevice : AuditedAggregateRoot<Guid>
    {
        public Guid user_id { get; set; }

        public string device_id { get; set; }

        public string app_name { get; set; }

        public string status { get; set; }

        public Metadata metadata { get; set; }
    }

    public class Metadata
    {
        public Firebase firebase { get; set; }
    }

    public class Firebase
    {
        public string token { get; set; }
    }
}
