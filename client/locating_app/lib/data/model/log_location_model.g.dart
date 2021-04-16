// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListLogLocationModel _$ListLogLocationModelFromJson(Map<String, dynamic> json) {
  return ListLogLocationModel(
    lastLocationLog: json['last_location_log'] == null
        ? null
        : LogLocationModel.fromJson(
            json['last_location_log'] as Map<String, dynamic>),
    placeId: json['place_id'] as String ?? '',
    status: json['status'] as int ?? 0,
  );
}

Map<String, dynamic> _$ListLogLocationModelToJson(
        ListLogLocationModel instance) =>
    <String, dynamic>{
      'last_location_log': instance.lastLocationLog?.toJson(),
      'place_id': instance.placeId,
      'status': instance.status,
    };

LogLocationModel _$LogLocationModelFromJson(Map<String, dynamic> json) {
  return LogLocationModel(
    userId: json['user_id'] as String ?? '',
    content: json['content'] as String ?? '',
    lat: (json['lat'] as num)?.toDouble(),
    lng: (json['lng'] as num)?.toDouble(),
    hashShareCode: json['hash_share_code'] as String ?? '',
    createdAt: (json['created_at'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$LogLocationModelToJson(LogLocationModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'content': instance.content,
      'lat': instance.lat,
      'lng': instance.lng,
      'hash_share_code': instance.hashShareCode,
      'created_at': instance.createdAt,
    };
