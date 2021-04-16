import 'package:json_annotation/json_annotation.dart';
part 'setting_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SettingModel {
  @JsonKey(name: "map_type", defaultValue: "Normal")
  String mapType;

  @JsonKey(name: "language", defaultValue: "vi")
  String language;

  @JsonKey(name: "unit", defaultValue: "Km")
  String unit;

  @JsonKey(name: "range", defaultValue: null)
  int range;

  @JsonKey(name: "notification_settings", defaultValue: null)
  NotificationSettingModel notificationSettingModel;

  SettingModel({
    this.mapType,
    this.language,
    this.unit,
    this.range,
    this.notificationSettingModel,
  });

  static SettingModel fromJson(Map<String, dynamic> json) =>
      _$SettingModelFromJson(json);

  Map<String, dynamic> toJson() => _$SettingModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NotificationSettingModel {
  @JsonKey(name: "lat", defaultValue: null)
  double lat;

  @JsonKey(name: "lng", defaultValue: null)
  double lng;

  // @JsonKey(name: "radius", defaultValue: 10)
  // int radius;

  @JsonKey(name: "permission_notification", defaultValue: true)
  bool permissionNotification;

  NotificationSettingModel({
    this.lat,
    this.lng,
    //this.radius,
    this.permissionNotification,
  });

  static NotificationSettingModel fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationSettingModelToJson(this);
}
