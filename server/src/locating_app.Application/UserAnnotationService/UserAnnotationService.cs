using locating_app.DataResponse;
using locating_app.Models.DataResponse;
using locating_app.UserAnnotations;
using locating_app.Users;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.Application.Services;
using Volo.Abp.DependencyInjection;
using Volo.Abp.Domain.Repositories;

namespace locating_app.UserRelationships
{
    [Route("api/user-annotation")]
    public class UserAnnotationService : ApplicationService, ITransientDependency
    {
        private readonly IRepository<UserRelationship, Guid> _userRelationshipRepository;
        private readonly IRepository<UserAnnotation, Guid> _userAnnotationRepository;

        public UserAnnotationService(
            IRepository<UserRelationship, Guid> userRelationshipRepository,
            IRepository<UserAnnotation, Guid> userAnnotationRepository
        )
        {
            _userRelationshipRepository = userRelationshipRepository;
            _userAnnotationRepository = userAnnotationRepository;
        }

        [HttpPost]
        public async Task<DataResponse<UserAnnotationDto>> create(UserAnnotationDto payload)
        {
            try
            {
                var check_exist_relation = await _userRelationshipRepository
                .CountAsync(
                    x => (x.user_id_1 == payload.creator_id && x.user_id_2 == payload.annotated_user_id) ||
                    (x.user_id_1 == payload.annotated_user_id && x.user_id_2 == payload.creator_id)
                );

                if (check_exist_relation > 0)
                {
                    var userAnnotation = ObjectMapper.Map<UserAnnotationDto, UserAnnotation>(payload);

                    userAnnotation = await _userAnnotationRepository.InsertAsync(userAnnotation);

                    return new DataResponse<UserAnnotationDto>(
                        code: StatusCode.SUCCESS,
                        message: "success",
                        data: ObjectMapper.Map<UserAnnotation, UserAnnotationDto>(userAnnotation)
                    );
                }
                else
                {
                    return new DataResponse<UserAnnotationDto>(
                        code: StatusCode.FAILURE,
                        message: "two_user_not_related",
                        data: null
                    );
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e);

                return new DataResponse<UserAnnotationDto>(
                    code: StatusCode.FAILURE,
                    message: "error",
                    data: null
                );
            }
        }
    }
}
