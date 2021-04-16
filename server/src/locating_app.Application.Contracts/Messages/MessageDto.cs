using System;
using System.Collections.Generic;
using System.Text;
using Volo.Abp.Application.Dtos;

namespace locating_app.Messages
{
    public class MessageDto : AuditedEntityDto<Guid>
    {
        public Guid conversation_id { get; set; }

        public Guid sender_id { get; set; }

        public int count { get; set; }

        public double created_at { get; set; }

        public string reply { get; set; }
    }
}
