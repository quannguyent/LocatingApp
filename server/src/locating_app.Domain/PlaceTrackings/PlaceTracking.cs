using locating_app.Placetrackings;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.Domain.Entities.Auditing;

namespace locating_app.PlaceTrackings
{
    public class PlaceTracking : AuditedAggregateRoot<Guid>
    {
        public Guid user_id { get; set; }

        public Guid following_id { get; set; } 

        public Guid place_id { get; set; }

        public PlaceStatus status { get; set; }
    }
}
