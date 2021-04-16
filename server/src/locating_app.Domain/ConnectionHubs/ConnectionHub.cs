using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.Domain.Entities.Auditing;

namespace locating_app.ConnectionHubs
{
    public class ConnectionHub : AuditedAggregateRoot<Guid>
    {
        public Guid user_id { get; set; }

        public string connection_id { get; set; }

        public string hub_name { get; set; }

        public double create_at { get; set; }

        public double update_at { get; set; }
    }
}
