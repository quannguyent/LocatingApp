using System;
using locating_app.CronJob;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace locating_app
{
    public class Startup
    {
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddApplication<locating_appHttpApiHostModule>();

            services.AddScoped<IMyScopedService, MyScopedService>();

            services.AddCronJob<UpdateUserStatusOnline>(c =>
            {
                c.TimeZoneInfo = TimeZoneInfo.Local;
                //c.CronExpression = @"*/1 * * * *"; //run every 2 min
                c.CronExpression = @"* * * * *"; //run every 1 min
                //c.CronExpression = @"50 12 * * *"; //run every 12h50
            });
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, ILoggerFactory loggerFactory)
        {
            app.InitializeApplication();
        }
    }
}
