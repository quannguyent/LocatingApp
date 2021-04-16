using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.Application.Dtos;
using Volo.Abp.Domain.Entities.Auditing;

namespace locating_app.Reports
{
    public class ReportDto : AuditedEntityDto<Guid>
    {
        public Guid user_id { get; set; }

        public ReportStatus status { get; set; }

        public double created_at { get; set; }

        public double updated_at { get; set; }
    }
}
