using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.Domain.Entities.Auditing;

namespace locating_app.UserRelationships
{
    [BsonIgnoreExtraElements]
    public class UserRelationship : AuditedAggregateRoot<Guid>
    {
        public Guid user_id_1 { get; set; }

        public Guid user_id_2 { get; set; }

        [BsonElement("user_1_metadata")]
        public Metadata user_1_metadata { get; set; }

        [BsonElement("user_2_metadata")]
        public Metadata user_2_metadata { get; set; }
    }
}
