using System;
using System.Collections.Generic;
using System.Text;
using Volo.Abp.Application.Dtos;

namespace locating_app.ConnectionHubs
{
    public class ConnectionHubDto : AuditedEntityDto<Guid>
    {
        public Guid user_id { get; set; }

        public string connection_id { get; set; }

        public string hub_name { get; set; }

        public double create_at { get; set; }

        public double update_at { get; set; }
    }
}
