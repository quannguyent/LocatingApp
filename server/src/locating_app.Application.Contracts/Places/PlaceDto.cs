using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.Application.Dtos;
using Volo.Abp.Domain.Entities.Auditing;

namespace locating_app.Places
{
    public class PlaceDto : AuditedEntityDto<Guid>
    {
        public string name { get; set; }

        public string address { get; set; }

        public double rad { get; set; }

        public string lat { get; set; }

        public string lng { get; set; }

        public double created_at { get; set; }
    }
}
