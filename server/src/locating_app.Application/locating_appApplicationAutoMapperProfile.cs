using AutoMapper;
using locating_app.Users;
using locating_app.Reports;
using locating_app.LocationLogs;
using locating_app.Places;
using locating_app.PlaceTrackings;
using locating_app.UserRelationships;
using locating_app.UserAnnotations;
using locating_app.Conversations;
using locating_app.ConnectionHubs;
using locating_app.UserDevices;
using locating_app.Messages;

namespace locating_app
{
    public class locating_appApplicationAutoMapperProfile : Profile
    {
        public locating_appApplicationAutoMapperProfile()
        {
            /* You can configure your AutoMapper mapping configuration here.
             * Alternatively, you can split your mapping configurations
             * into multiple profile classes for a better organization. */

            CreateMap<User, UserDto>();

            CreateMap<Report, ReportDto>();

            CreateMap<Conversation, ConversationDto>();

            CreateMap<LocationLog, LocationLogDto>();

            CreateMap<Place, PlaceDto>();

            CreateMap<PlaceTracking, PlaceTrackingDto>();

            CreateMap<UserRelationship, UserRelationshipDto>();

            CreateMap<UserAnnotation, UserAnnotationDto>();

            CreateMap<UserAnnotationDto, UserAnnotation>();

            CreateMap<ConnectionHubDto, ConnectionHub>();

            CreateMap<UserDevice, UserDeviceDto>();

            CreateMap<Message, MessageDto>();

        }
    }
}
