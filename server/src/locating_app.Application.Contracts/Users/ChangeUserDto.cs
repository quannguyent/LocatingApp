using System;
using System.Collections.Generic;
using System.Text;
using Volo.Abp.EventBus;

namespace locating_app.Users
{
    [EventName("locating-app.create-user")]
    public class ChangeUserDto
    {
        public Guid user_id { get; set; }

        public string first_name { get; set; }

        public string last_name { get; set; }

        public string language { get; set; }

    }
}
