using System;
using System.Text;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using Serilog;
using Serilog.Events;

namespace locating_app
{
    public class Program
    {
        public static int Main(string[] args)
        {
            /*SendMessage();*/
            /*TestMessage();*/
            Log.Logger = new LoggerConfiguration()
#if DEBUG
                .MinimumLevel.Debug()
#else
                .MinimumLevel.Information()
#endif
                .MinimumLevel.Override("Microsoft", LogEventLevel.Information)
                .MinimumLevel.Override("Microsoft.EntityFrameworkCore", LogEventLevel.Warning)
                .Enrich.FromLogContext()
                .WriteTo.Async(c => c.File("Logs/logs.txt"))
#if DEBUG
                .WriteTo.Async(c => c.Console())
#endif
                .CreateLogger();

            try
            {
                Log.Information("Starting locating_app.HttpApi.Host.");
                CreateHostBuilder(args).Build().Run();
                return 0;
            }
            catch (Exception ex)
            {
                Log.Fatal(ex, "Host terminated unexpectedly!");
                return 1;
            }
            finally
            {
                Log.CloseAndFlush();
            }
        }

        internal static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                })
                .UseAutofac()
                .UseSerilog();

        internal static void TestMessage()
        {
            var factory = new ConnectionFactory
            {
                Uri = new Uri("amqp://guest:guest@localhost:5672")
            };
            /*var factory = new ConnectionFactory() { HostName = "localhost" };*/

            using (var connection = factory.CreateConnection())
            using (var channel = connection.CreateModel())
            {
                channel.QueueDeclare("locating-app", true, false, false, null);
                var consumer = new EventingBasicConsumer(channel);
                consumer.Received += (model, ea) =>
                {
                    var messagebody = ea.Body.ToArray();
                    var message = Encoding.UTF8.GetString(messagebody);
                    Console.WriteLine("Recieved message:{0}", message);
                };

                channel.BasicConsume("locating-app", true, consumer);

                Console.ReadLine();
            }
        }

        internal static void SendMessage()
        {
            var factory = new ConnectionFactory() { HostName = "localhost" };
            using (var getconnection = factory.CreateConnection())
            using (var passage = getconnection.CreateModel())
            {
                passage.QueueDeclare("Test", false, false, false, null);
                string message = "creating a message using asp.net core rabbitmq";
                var body = Encoding.UTF8.GetBytes(message);
                passage.BasicPublish("", "Test", null, body);
                Console.WriteLine("sent message:{0}", message);
            }

            Console.ReadLine();
        }
    }
}
