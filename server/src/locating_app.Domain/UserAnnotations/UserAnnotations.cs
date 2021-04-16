using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.Domain.Entities.Auditing;

namespace locating_app.UserAnnotations
{
    public class UserAnnotation : AuditedAggregateRoot<Guid>
    {
        public Guid create_id { get; set; }
        public Guid annotated_user_id { get; set; }
        public string avatar_path { get; set; }
        public string alias_name { get; set; }
    }
}
