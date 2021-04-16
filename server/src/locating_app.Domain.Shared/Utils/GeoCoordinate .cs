using System;
using System.Collections.Generic;
using System.Text;

namespace locating_app.Utils
{
    public class GeoCoordinate
    {
        public static double Calculate(double sLatitude, double sLongitude, double eLatitude,
                               double eLongitude)
        {
            var radiansOverDegrees = (Math.PI / 180.0);

            var sLatitudeRadians = sLatitude * radiansOverDegrees;
            var sLongitudeRadians = sLongitude * radiansOverDegrees;
            var eLatitudeRadians = eLatitude * radiansOverDegrees;
            var eLongitudeRadians = eLongitude * radiansOverDegrees;

            var dLongitude = eLongitudeRadians - sLongitudeRadians;
            var dLatitude = eLatitudeRadians - sLatitudeRadians;

            var result1 = Math.Pow(Math.Sin(dLatitude / 2.0), 2.0) +
                          Math.Cos(sLatitudeRadians) * Math.Cos(eLatitudeRadians) *
                          Math.Pow(Math.Sin(dLongitude / 2.0), 2.0);

            // Using 6371 as the number of km around the earth
            var result2 = 6371 * 2.0 *
                          Math.Atan2(Math.Sqrt(result1), Math.Sqrt(1.0 - result1));

            //meter
            return result2 * 1000;
        }

        public static bool filterLogInsideScreen(double locationLat, double locationLng, double topRightPointLat, double topRightPointLng, double bottomLeftPointLat, double bottomLeftPointLng)
        {
            if (locationLat < topRightPointLat
                && locationLat > bottomLeftPointLat
                && locationLng < topRightPointLng
                && locationLng > bottomLeftPointLng
            )
                return true;

            return false;
        }
    }
}
