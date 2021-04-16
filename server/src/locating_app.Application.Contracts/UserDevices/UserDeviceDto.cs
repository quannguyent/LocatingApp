using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Text;
using Volo.Abp.Application.Dtos;
using Volo.Abp.Domain.Entities.Auditing;

namespace locating_app.UserDevices
{
    [BsonIgnoreExtraElements]
    public class UserDeviceDto : AuditedEntityDto<Guid>
    {
        public Guid user_id { get; set; }

        public string device_id { get; set; }

        public string app_name { get; set; }

        public string status { get; set; }

        public MetadataDto metadata { get; set; }
    }

    public class MetadataDto
    {
        public FirebaseDto firebase { get; set; }
    }

    public class FirebaseDto
    {
        public string token { get; set; }
    }
}
