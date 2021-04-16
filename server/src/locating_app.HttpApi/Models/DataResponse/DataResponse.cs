using locating_app.DataResponse;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace locating_app.Models.DataResponse
{
    public class DataResponse<T>
    {

        public DataResponse(StatusCode code, string message, T data)
        {
            this.code = code;
            this.message = message;
            this.data = data;
        }

        public StatusCode code { get; set; }

        public string message { get; set; }

        public T data { get; set; }
    }
}
