using locating_app.LocationLogs;
using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;
using Volo.Abp.Application.Dtos;
using Volo.Abp.Domain.Entities.Auditing;

namespace locating_app.Users
{
    [BsonIgnoreExtraElements]
    public class UserDto : AuditedEntityDto<Guid>
    {
        public Guid user_id { get; set; }

        /*public Guid avatar_id { get; set; }

        public string phone { get; set; }*/

        public string first_name { get; set; }

        public string last_name { get; set; }

        [BsonElement("last_location_log")]
        public LocationLogDto last_location_log { get; set; }

        public UserStatus status { get; set; }

        [BsonDefaultValue(0)]
        public int total_logs { get; set; }

        [BsonElement("settings")]
        public SettingDto settings { get; set; }

        public double last_time_update_status { get; set; }
    }

    public class SettingDto
    {
        public string language { get; set; }
    }
}
