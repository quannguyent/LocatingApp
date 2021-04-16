// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingModel _$SettingModelFromJson(Map<String, dynamic> json) {
  return SettingModel(
    mapType: json['map_type'] as String ?? 'Normal',
    language: json['language'] as String ?? 'vi',
    unit: json['unit'] as String ?? 'Km',
    range: json['range'] as int,
    notificationSettingModel: json['notification_settings'] == null
        ? null
        : NotificationSettingModel.fromJson(
            json['notification_settings'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SettingModelToJson(SettingModel instance) =>
    <String, dynamic>{
      'map_type': instance.mapType,
      'language': instance.language,
      'unit': instance.unit,
      'range': instance.range,
      'notification_settings': instance.notificationSettingModel?.toJson(),
    };

NotificationSettingModel _$NotificationSettingModelFromJson(
    Map<String, dynamic> json) {
  return NotificationSettingModel(
    lat: (json['lat'] as num)?.toDouble(),
    lng: (json['lng'] as num)?.toDouble(),
    permissionNotification: json['permission_notification'] as bool ?? true,
  );
}

Map<String, dynamic> _$NotificationSettingModelToJson(
        NotificationSettingModel instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'permission_notification': instance.permissionNotification,
    };
