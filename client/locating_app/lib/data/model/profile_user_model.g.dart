part of 'profile_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileUserModel _$ProfileUserModelFromJson(Map<String, dynamic> json) {
  return ProfileUserModel(
    id: json['id'] as int ?? 0,
    username: json['username'] as String ?? '',
    displayName: json['displayName'] as String ?? '',
    email: json['email'] as String ?? '',
    status: json['status'] as String ?? '',
    avatar: json['avatar'] as String,
    phone: json['phone'] as String ?? '',
    sexId: json['sexId'] as int ?? 0,
    friendship: json['friendship'] as int ?? 0,
    activeStatus: json['active_status'] as int,
    updatedAt: (json['last_time_update_status'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ProfileUserModelToJson(ProfileUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'displayName': instance.displayName,
      'email': instance.email,
      'phone': instance.phone,
      'status': instance.status,
      'avatar': instance.avatar,
      'friendship': instance.friendship,
      'active_status': instance.activeStatus,
      'last_time_update_status': instance.updatedAt,
    };
