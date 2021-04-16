using locating_app.ConnectionHubs;
using locating_app.DataResponse;
using locating_app.Localization;
using locating_app.Messages;
using locating_app.Models.DataResponse;
using locating_app.UserDevices;
using locating_app.UserRelationships;
using locating_app.Users;
using locating_app.Utils;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Localization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.Application.Services;
using Volo.Abp.DependencyInjection;
using Volo.Abp.Domain.Repositories;

namespace locating_app.Conversations
{
    [Route("api/conversation")]
    public class ConversationService : 
        ApplicationService,
        ITransientDependency
    {
        private readonly IRepository<Conversation, Guid> _conversationRepository;

        private readonly IRepository<UserRelationship, Guid> _userRelationshipRepository;

        private readonly IRepository<User, Guid> _userRepository;

        private readonly IRepository<ConnectionHub, Guid> _connectionHubRepository;

        private readonly IHubContext<ConversationHub> _hubContext;

        private readonly IRepository<Message, Guid> _messageRepository;

        private readonly IRepository<UserDevice, Guid> _userDeviceRepository;

        private readonly IStringLocalizer<locating_appResource> _localizer;

        public ConversationService(
            IRepository<Conversation, Guid> conversationRepository,
            IRepository<User, Guid> userRepository,
            IHubContext<ConversationHub> hubContext,
            IRepository<UserRelationship, Guid> userRelationshipRepository,
            IRepository<ConnectionHub, Guid> connectionHubRepository,
            IRepository<Message, Guid> messageRepository,
            IRepository<UserDevice, Guid> userDeviceRepository)
        {
            _conversationRepository = conversationRepository;
            _userRepository = userRepository;
            _userRelationshipRepository = userRelationshipRepository;
            _connectionHubRepository = connectionHubRepository;
            _hubContext = hubContext;
            _messageRepository = messageRepository;
            _userDeviceRepository = userDeviceRepository;
        }

        [HttpPost("send-message")]
        public async Task<DataResponse<Message>> sendMessage(Guid senderId, Guid receiverId, string reply)
        {
            try
            {
                var sender = await _userRepository.FirstOrDefaultAsync(m => m.user_id == senderId);

                var receiver = await _userRepository.FirstOrDefaultAsync(m => m.user_id == receiverId);

                if (sender is null || receiver is null)
                {
                    return new DataResponse<Message>(
                        code: StatusCode.FAILURE,
                        message: "incorrect_sender_or_receiver",
                        data: null
                    );
                }

                var relationship = await _userRelationshipRepository.FirstOrDefaultAsync(
                    m => (m.user_id_1 == senderId
                    && m.user_id_2 == receiverId)
                    || (m.user_id_1 == receiverId
                    && m.user_id_2 == senderId));

                if (relationship is null)
                {
                    return new DataResponse<Message>(
                        code: StatusCode.FAILURE,
                        message: "two_user_have_no_relationship",
                        data: null
                    );
                }

                var conversation = await _conversationRepository.FirstOrDefaultAsync(
                    m => (m.user_id_1 == sender.user_id
                    && m.user_id_2 == receiver.user_id)
                    || (m.user_id_1 == receiver.user_id
                    && m.user_id_2 == sender.user_id));

                var newMessage = new Message();

                if (conversation is null)
                {
                    var newConversation = new Conversation
                    {
                        user_id_1 = senderId,
                        user_id_2 = receiverId,
                        created_at = DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1)).TotalSeconds,
                        total = 1
                    };

                    await _conversationRepository.InsertAsync(newConversation);

                    newMessage = new Message
                    {
                        conversation_id = newConversation.Id,
                        sender_id = senderId,
                        created_at = DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1)).TotalSeconds,
                        count = newConversation.total,
                        reply = reply
                    };

                    await _messageRepository.InsertAsync(newMessage);
                }
                else
                {
                    newMessage = new Message
                    {
                        conversation_id = conversation.Id,
                        sender_id = senderId,
                        created_at = DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1)).TotalSeconds,
                        count = conversation.total + 1,
                        reply = reply
                    };

                    await _messageRepository.InsertAsync(newMessage);

                    conversation.total += 1;

                    await _conversationRepository.UpdateAsync(conversation);
                }

                //push notification
                var receiverDevice = _userDeviceRepository.Where(
                    m => m.user_id == receiver.user_id
                    && m.app_name == "locating");

                var message = $"{newMessage.reply}";

                var title = $"{sender.first_name} {sender.last_name}";

                var data = new
                {
                    user_id = receiver.user_id,
                    notification_type = "CHAT"
                };

                foreach (var device in receiverDevice)
                {
                    await PushNotification.pushNotification(message, title, data, device.metadata.firebase.token);
                }

                //send to client hub message
                var senderConnectionHub = await _connectionHubRepository.FirstOrDefaultAsync(
                    m => m.user_id == sender.user_id && m.hub_name == "conversation-hub");

                var connectionIds = new List<string> { senderConnectionHub.connection_id };

                var receiverConnectionHub = await _connectionHubRepository.FirstOrDefaultAsync(
                    m => m.user_id == receiver.user_id && m.hub_name == "conversation-hub");

                if (receiverConnectionHub != null)
                {
                    connectionIds.Add(receiverConnectionHub.connection_id);
                }

                await _hubContext.Clients.Clients(connectionIds)
                    .SendAsync("ReceiveMessage", new DataResponse<List<Message>>(
                        code: StatusCode.SUCCESS,
                        message: "success",
                        data: new List<Message> { newMessage }
                    ));

                return new DataResponse<Message>(
                    code: StatusCode.SUCCESS,
                    message: "success",
                    data: newMessage
                );
            }
            catch (Exception e)
            {
                Console.WriteLine(e);

                return new DataResponse<Message>(
                    code: StatusCode.FAILURE,
                    message: "failure",
                    data: null
                );
            }
        }

        [HttpGet]
        public async Task<DataResponse<List<Message>>> getConversationData(
            Guid senderId,
            Guid receiverId,
            int pageSize,
            int? pageIndex)
        {
            var sender = await _userRepository.FirstOrDefaultAsync(m => m.user_id == senderId);

            var receiver = await _userRepository.FirstOrDefaultAsync(m => m.user_id == receiverId);

            if (sender is null || receiver is null)
            {
                return null;
            }

            var conversation = await _conversationRepository.FirstOrDefaultAsync(
                m => (m.user_id_1 == senderId
                && m.user_id_2 == receiverId)
                || (m.user_id_1 == receiverId
                && m.user_id_2 == senderId));

            var listMessage = _messageRepository.Where(
                m => m.conversation_id == conversation.Id
            ).OrderByDescending(m => m.count);

            var list = await PaginatedList<Message>.CreateAsync(listMessage, pageIndex ?? 1, pageSize);

            return new DataResponse<List<Message>>(
                code: StatusCode.SUCCESS,
                message: "success",
                data: list
            );
        }
    }
}
