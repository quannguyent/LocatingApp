using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace locating_app.LocationLogs
{
    public class CreateLocationLogDto
    {
        [Required]
        public Guid user_id { get; set; }

        [Required]
        [JsonInclude]
        public string content { get; set; }

        [Required]
        public double created_at { get; set; }

        [Required]
        public string lat { get; set; }

        [Required]
        public string lng { get; set; }

        [Required]
        public string hash_share_code { get; set; }
    }
}
