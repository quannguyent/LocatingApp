using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.Domain.Entities.Auditing;
using System.Text.Json;
using System.Text.Json.Serialization;
using MongoDB.Bson.Serialization.Attributes;

namespace locating_app.LocationLogs
{
    [BsonIgnoreExtraElements]
    public class LocationLog : AuditedAggregateRoot<Guid>
    {
        public Guid user_id { get; set; }

        [BsonElement("content")]
        public string content { get; set; }

        public double created_at { get; set; }

        public double lat { get; set; }

        public double lng { get; set; }

        public string hash_share_code { get; set; }

        [BsonDefaultValue(0)]
        public int count { get; set; }

        public Guid place_id { get; set; }

    }
}
