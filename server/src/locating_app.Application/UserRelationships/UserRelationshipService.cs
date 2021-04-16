using locating_app.DataResponse;
using locating_app.Models.DataResponse;
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
    [Route("api/user-relationship")]
    public class UserRelationshipService : ApplicationService, ITransientDependency
    {
        private readonly IRepository<UserRelationship, Guid> _userRelationshipRepository;

        private readonly IRepository<User, Guid> _userRepository;

        public UserRelationshipService(
            IRepository<UserRelationship, Guid> userRelationshipRepository,
            IRepository<User, Guid> userRepository)
        {
            _userRelationshipRepository = userRelationshipRepository;
            _userRepository = userRepository;
        }

        [HttpPost]
        public async Task<DataResponse<UserRelationshipDto>> create(UserRelationshipDto input)
        {
            try
            {
                var firstUser = await _userRepository.FirstOrDefaultAsync(m => m.user_id == input.user_id_1);

                var secondUser = await _userRepository.FirstOrDefaultAsync(m => m.user_id == input.user_id_2);

                if (firstUser is null || secondUser is null || input.user_id_1 == input.user_id_2)
                {
                    return new DataResponse<UserRelationshipDto>(
                        code: StatusCode.FAILURE,
                        message: "first_or_second_user_is_incorrect",
                        data: null
                    );
                }

                var checkRelated = await _userRelationshipRepository.FirstOrDefaultAsync(
                    m => (m.user_id_1 == input.user_id_1
                    && m.user_id_2 == input.user_id_2)
                    || (m.user_id_1 == input.user_id_2
                    && m.user_id_2 == input.user_id_1)
                );

                if (!(checkRelated is null))
                {
                    return new DataResponse<UserRelationshipDto>(
                        code: StatusCode.FAILURE,
                        message: "two_user_related",
                        data: null
                    );
                }

                var relationship = new UserRelationship
                {
                    user_id_1 = input.user_id_1,
                    user_id_2 = input.user_id_2,
                    user_1_metadata = new Metadata { friendship = Friendship.NORMAL},
                    user_2_metadata = new Metadata { friendship = Friendship.NORMAL }
                };

                var userRelationship = await _userRelationshipRepository.InsertAsync(relationship);

                var relationShipDto = ObjectMapper.Map<UserRelationship, UserRelationshipDto>(userRelationship);

                return new DataResponse<UserRelationshipDto>(
                    code: StatusCode.SUCCESS,
                    message: "success",
                    data: relationShipDto
                );
            }
            catch (Exception e)
            {
                Console.WriteLine(e);

                return new DataResponse<UserRelationshipDto>(
                    code: StatusCode.FAILURE,
                    message: "error",
                    data: null
                );
            }
        }

        [HttpPut("close")]
        public async Task<DataResponse<UserRelationshipDto>> setCloseFriendship(Guid sUserId, Guid eUserId)
        {
            try
            {
                var userFriendship = await _userRelationshipRepository.FirstOrDefaultAsync(
                m => (m.user_id_1 == sUserId && m.user_id_2 == eUserId)
                || m.user_id_1 == eUserId && m.user_id_2 == sUserId);

                if (userFriendship is null)
                {
                    return new DataResponse<UserRelationshipDto>(
                        code: StatusCode.FAILURE,
                        message: "two_user_have_no_relationship",
                        data: null
                    );
                }

                if (sUserId == userFriendship.user_id_1)
                {
                    if (userFriendship.user_1_metadata.friendship == Friendship.CLOSE)
                        userFriendship.user_1_metadata.friendship = Friendship.NORMAL;
                    else
                        userFriendship.user_1_metadata.friendship = Friendship.CLOSE;
                }
                else if (sUserId == userFriendship.user_id_2)
                {
                    if (userFriendship.user_2_metadata.friendship == Friendship.CLOSE)
                        userFriendship.user_2_metadata.friendship = Friendship.NORMAL;
                    else
                        userFriendship.user_2_metadata.friendship = Friendship.CLOSE;
                }

                await _userRelationshipRepository.UpdateAsync(userFriendship);

                var userFriendshipDto = ObjectMapper.Map<UserRelationship, UserRelationshipDto>(userFriendship);

                return new DataResponse<UserRelationshipDto>(
                    code: StatusCode.SUCCESS,
                    message: "success",
                    data: userFriendshipDto
                );
            }
            catch (Exception e)
            {
                return new DataResponse<UserRelationshipDto>(
                    code: StatusCode.FAILURE,
                    message: "error",
                    data: null
                );
            }
        }

        [HttpGet]
        public async Task<DataResponse<List<UserRelationshipDto>>> get([FromQuery] Guid id)
        {
            try
            {
                var queryable = await _userRelationshipRepository.GetQueryableAsync();

                var listRelationShip = queryable.Where(x => id == x.user_id_1 || id == x.user_id_2).ToList();

                return new DataResponse<List<UserRelationshipDto>>(
                    code: StatusCode.SUCCESS,
                    message: "success",
                    data: ObjectMapper.Map<List<UserRelationship>, List<UserRelationshipDto>>(listRelationShip)
                );
            }
            catch (Exception e)
            {
                Console.WriteLine(e);

                return new DataResponse<List<UserRelationshipDto>>(
                    code: StatusCode.FAILURE,
                    message: "error",
                    data: null
                );
            }
        }

        [HttpDelete]
        public async Task<DataResponse<string>> delete(Guid sUserId, Guid eUserId)
        {
            try
            {
                var userFriendship = await _userRelationshipRepository.FirstOrDefaultAsync(
                m => (m.user_id_1 == sUserId && m.user_id_2 == eUserId)
                || m.user_id_1 == eUserId && m.user_id_2 == sUserId);

                if (userFriendship is null)
                {
                    return new DataResponse<string>(
                        code: StatusCode.FAILURE,
                        message: "two_user_have_no_relationship",
                        data: null
                    );
                }

                await _userRelationshipRepository.DeleteAsync(userFriendship);

                return new DataResponse<string>(
                    code: StatusCode.SUCCESS,
                    message: "success",
                    data: null
                );
            }
            catch (Exception e)
            {
                Console.WriteLine(e);

                return new DataResponse<string>(
                    code: StatusCode.FAILURE,
                    message: "error",
                    data: null
                );
            }
        }
    }
}
