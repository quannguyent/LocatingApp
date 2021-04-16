import 'package:json_annotation/json_annotation.dart';
part 'log_location_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ListLogLocationModel{
  @JsonKey(name: "last_location_log", defaultValue: null)
  LogLocationModel lastLocationLog;
  @JsonKey(name: "place_id", defaultValue: "")
  String placeId;
  @JsonKey(name: "status", defaultValue: 0)
  int status;

  ListLogLocationModel({
    this.lastLocationLog,
    this.placeId,
    this.status,
  });

  static ListLogLocationModel fromJson(Map<String, dynamic> json) => _$ListLogLocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListLogLocationModelToJson(this);
}
@JsonSerializable(explicitToJson: true)
class LogLocationModel {
  @JsonKey(name: "user_id", defaultValue: '')
  String userId;

  @JsonKey(name: "content", defaultValue: '')
  String content;

  @JsonKey(name: "lat", defaultValue: null)
  double lat;

  @JsonKey(name: "lng", defaultValue: null)
  double lng;

  @JsonKey(name: "hash_share_code", defaultValue: '')
  String hashShareCode;

  @JsonKey(name: "created_at", defaultValue: null)
  double createdAt;

  LogLocationModel({
    this.userId,
    this.content,
    this.lat,
    this.lng,
    this.hashShareCode,
    this.createdAt,
  });

  static LogLocationModel fromJson(Map<String, dynamic> json) => _$LogLocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LogLocationModelToJson(this);
}