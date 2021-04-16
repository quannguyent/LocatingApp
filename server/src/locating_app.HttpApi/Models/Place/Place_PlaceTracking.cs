using locating_app.Placetrackings;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace locating_app.Models.Place
{
    public class Place_PlaceTracking
    {
        public Guid user_id { get; set; }

        public Guid following_id { get; set; }

        public string name { get; set; }

        public string address { get; set; }

        public double rad { get; set; }

        public double lat { get; set; }

        public double lng { get; set; }

    }
}
