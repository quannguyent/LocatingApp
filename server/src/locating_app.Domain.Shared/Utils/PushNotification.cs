using locating_app.Localization;
using Microsoft.Extensions.Localization;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.DependencyInjection;

namespace locating_app.Utils
{
    public class PushNotification : ITransientDependency
    {

        public static async Task pushNotification(string body, string title, object data, string token)
        {
            var client = new HttpClient();
            var payload = JsonConvert.SerializeObject(new
            {
                to = token,
                notification = new
                {
                    title = title,
                    body = body,
                    click_action = "FLUTTER_NOTIFICATION_CLICK"
                },
                priority = "high",
                data = data
            });

            client.DefaultRequestHeaders.TryAddWithoutValidation("Content-Type", "application/json");
            client.DefaultRequestHeaders.TryAddWithoutValidation("Authorization", "key=AAAAkuXzNa4:APA91bEOPZErx9KG2SmG3kLZ63WpvZW9dZbr0jv-IbjaAdecvixVg7siLI2JQIZtDrsxZ6hpA89359zksLpR7PoJVbsxumU9HdQZ89Qs-0CSKdZaWzSqZDYLxsf6aZHS4UaET8BJXNs2");

            var res = await client.PostAsync("https://fcm.googleapis.com/fcm/send", new StringContent(payload, Encoding.UTF8, "application/json"));

            return;
        }
    }
}
