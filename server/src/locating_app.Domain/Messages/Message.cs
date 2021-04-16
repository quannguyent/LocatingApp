using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.Domain.Entities.Auditing;

namespace locating_app.Messages
{
    [BsonIgnoreExtraElements]
    public class Message : AuditedAggregateRoot<Guid>
    {
        public Guid conversation_id { get; set; }

        public Guid sender_id { get; set; }

        [BsonDefaultValue(0)]
        public int count { get; set; }

        public double created_at { get; set; }

        public string reply { get; set; }
    }
}
