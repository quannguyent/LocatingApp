// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceModel _$PlaceModelFromJson(Map<String, dynamic> json) {
  return PlaceModel(
    id: json['id'] as String ?? '',
    name: json['name'] as String ?? '',
    address: json['address'] as String ?? '',
    rad: (json['rad'] as num)?.toDouble(),
    lat: (json['lat'] as num)?.toDouble(),
    lng: (json['lng'] as num)?.toDouble(),
    createdAt: (json['created_at'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$PlaceModelToJson(PlaceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'rad': instance.rad,
      'lat': instance.lat,
      'lng': instance.lng,
      'created_at': instance.createdAt,
    };
