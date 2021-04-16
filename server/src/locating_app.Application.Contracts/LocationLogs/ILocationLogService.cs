using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.Application.Services;

namespace locating_app.LocationLogs
{
    public interface ILocationLogService :
/*        ICrudAppService<
            LocationLogDto,
            Guid>,*/
        IApplicationService
    {
        Task<List<LocationLogDto>> GetListAsync();
    }
}
