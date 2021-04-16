using System;
using System.Collections.Generic;
using System.Text;
using Volo.Abp.EventBus;

namespace locating_app.UserDevices
{
    [EventName("locating-app.get-user-device")]
    public class GetUserDeviceEto
    {
        public Guid user_id { get; set; }

        public string device_id { get; set; }

        public string app_name { get; set; }

        public string status { get; set; }

        public MetadataDto metadata { get; set; }
    }
}
