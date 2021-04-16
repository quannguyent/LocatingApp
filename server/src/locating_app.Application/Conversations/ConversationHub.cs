using locating_app.ConnectionHubs;
using locating_app.DataResponse;
using locating_app.Messages;
using locating_app.Models.DataResponse;
using locating_app.Users;
using locating_app.Utils;
using Microsoft.AspNetCore.SignalR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Volo.Abp.AspNetCore.SignalR;
using Volo.Abp.Domain.Repositories;

namespace locating_app.Conversations
{
    [HubRoute("/conversation-hub")]
    public class ConversationHub : AbpHub
    {
        private readonly IRepository<User, Guid> _userRepository;

        private readonly IRepository<Conversation, Guid> _conversationRepository;

        private readonly IRepository<ConnectionHub, Guid> _connectionHubRepository;

        private readonly IRepository<Message, Guid> _messageRepository;

        public ConversationHub(
            IRepository<User, Guid> userRepository,
            IRepository<Conversation, Guid> conversationRepository,
            IRepository<ConnectionHub, Guid> connectionHubRepository,
            IRepository<Message, Guid> messageRepository)
        {
            _userRepository = userRepository;
            _conversationRepository = conversationRepository;
            _connectionHubRepository = connectionHubRepository;
            _messageRepository = messageRepository;
        }

        public async Task ReceiveMessage(Guid senderId, Guid receiverId, int count, string connectionId)
        {
            try
            {
                var conversation = await ConversationData.getConversationData(
                    senderId, 
                    receiverId, 
                    count,
                    _userRepository, 
                    _conversationRepository,
                    _messageRepository);

                await Clients.Client(connectionId).SendAsync(
                    "ReceiveMessage",
                    conversation
                );
            }
            catch(Exception e)
            {
                Console.WriteLine(e);
            }
        }

        public async Task SetConnectionId(Guid userId, string connectionId)
        {
            var connectionHub = new ConnectionHub
            {
                user_id = userId,
                connection_id = connectionId,
                hub_name = "conversation-hub",
                create_at = DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1)).TotalSeconds,
                update_at = DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1)).TotalSeconds,
            };

            var existedConnectionHub = await _connectionHubRepository.FirstOrDefaultAsync(
                m => m.user_id == userId && m.hub_name == connectionHub.hub_name);

            if (existedConnectionHub is null)
            {
                await _connectionHubRepository.InsertAsync(connectionHub);
            }
            else
            {
                existedConnectionHub.connection_id = connectionId;
                existedConnectionHub.update_at = DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1)).TotalSeconds;

                await _connectionHubRepository.UpdateAsync(existedConnectionHub);
            }
        }

        public class ConversationData
        {
            public static async Task<DataResponse<List<Message>>> getConversationData(
                Guid senderId,
                Guid receiverId,
                int count,
                IRepository<User, Guid> _userRepository,
                IRepository<Conversation, Guid> _conversationRepository,
                IRepository<Message, Guid> _messageRepository)
            {
                var sender = await _userRepository.FirstOrDefaultAsync(m => m.user_id == senderId);

                var receiver = await _userRepository.FirstOrDefaultAsync(m => m.user_id == receiverId);

                if (sender is null || receiver is null)
                {
                    return new DataResponse<List<Message>> (
                        code: StatusCode.FAILURE,
                        message: "incorrect_sender_or_receiver",
                        data: null
                    );
                }

                var conversation = await _conversationRepository.FirstOrDefaultAsync(
                    m => (m.user_id_1 == senderId
                    && m.user_id_2 == receiverId)
                    || (m.user_id_1 == receiverId
                    && m.user_id_2 == senderId));

                var listMessage = _messageRepository.Where(
                    m => m.conversation_id == conversation.Id
                    && m.count <= conversation.total - count
                    && m.count > conversation.total - count - 20
                ).OrderByDescending(m => m.count).ToList();

                return new DataResponse<List<Message>> (
                    code: StatusCode.SUCCESS,
                    message: "success",
                    data: listMessage
                );
            }
        }
    }
}
