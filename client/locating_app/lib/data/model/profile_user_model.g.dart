// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileUserModel _$ProfileUserModelFromJson(Map<String, dynamic> json) {
  return ProfileUserModel(
    id: json['id'] as String ?? '',
    userName: json['username'] as String ?? '',
    firstName: json['first_name'] as String ?? '',
    lastName: json['last_name'] as String ?? '',
    email: json['email'] as String ?? '',
    status: json['status'] as String ?? '',
    avatar_url: json['avatar_url'] as String,
    phone: json['phone'] as String ?? '',
    uuid: json['uuid'] as String ?? '',
    friendship: json['friendship'] as int ?? 0,
    activeStatus: json['active_status'] as int,
    lastTimeUpdateStatus: (json['last_time_update_status'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ProfileUserModelToJson(ProfileUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'username': instance.userName,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'status': instance.status,
      'avatar_url': instance.avatar_url,
      'friendship': instance.friendship,
      'active_status': instance.activeStatus,
      'last_time_update_status': instance.lastTimeUpdateStatus,
    };
