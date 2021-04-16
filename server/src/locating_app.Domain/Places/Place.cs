using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.Domain.Entities.Auditing;

namespace locating_app.Places
{
    public class Place : AuditedAggregateRoot<Guid>
    {
        public string name { get; set; }

        public string address { get; set; }

        public double rad { get; set; }

        public double lat { get; set; }

        public double lng { get; set; }

        public double created_at { get; set; }
    }
}
