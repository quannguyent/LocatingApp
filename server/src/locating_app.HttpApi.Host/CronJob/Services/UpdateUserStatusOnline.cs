using System;
using System.Threading;
using System.Threading.Tasks;
using locating_app.LocationLogs;
using locating_app.Users;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json.Linq;
using Volo.Abp.Domain.Repositories;

namespace locating_app.CronJob
{
    public class UpdateUserStatusOnline : CronJobService
    {
        private readonly ILogger<UpdateUserStatusOnline> _logger;

        private readonly IRepository<User, Guid> _userRepository;


        public UpdateUserStatusOnline(
            IScheduleConfig<UpdateUserStatusOnline> config,
            ILogger<UpdateUserStatusOnline> logger,
            IRepository<User, Guid> userRepository
        ) : base(config.CronExpression, config.TimeZoneInfo)
        {
            _logger = logger;
            _userRepository = userRepository;
        }

        public override Task StartAsync(CancellationToken cancellationToken)
        {
            _logger.LogInformation("CronJob UpdateUserStatusOnline starts.");
            return base.StartAsync(cancellationToken);
        }

        public override async Task<Task> DoWork(CancellationToken cancellationToken)
        {
            _logger.LogInformation($"{DateTime.Now:hh:mm:ss} CronJob UpdateUserStatusOnline is working.");

            var listUser = await _userRepository.GetListAsync();

            foreach (var user in listUser)
            {
                var userLastLog = user.last_location_log;

                if (userLastLog is null)
                {
                    return Task.CompletedTask;
                }

                var last_log_time = userLastLog.created_at;

                var time_between = DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1)).TotalSeconds - last_log_time;

                if (time_between > 60 && user.status == UserStatus.ONLINE)
                {
                    user.status = UserStatus.OFFLINE;
                    user.last_time_update_status = DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1)).TotalSeconds;
                }
                else if (time_between <= 60 && user.status == UserStatus.OFFLINE)
                {
                    user.status = UserStatus.ONLINE;
                    user.last_time_update_status = DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1)).TotalSeconds;
                }

                await _userRepository.UpdateAsync(user);
            }

            return Task.CompletedTask;
        }

        public override Task StopAsync(CancellationToken cancellationToken)
        {
            _logger.LogInformation("CronJob UpdateUserStatusOnline is stopping.");
            return base.StopAsync(cancellationToken);
        }
    }
}