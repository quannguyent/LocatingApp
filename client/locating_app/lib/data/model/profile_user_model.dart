import 'package:json_annotation/json_annotation.dart';
part 'profile_user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProfileUserModel {
  @JsonKey(name: "id", defaultValue: "")
  String id;

  @JsonKey(name: "uuid", defaultValue: "")
  String uuid;

  @JsonKey(name: "username", defaultValue: "")
  String userName;

  @JsonKey(name: "first_name", defaultValue: "")
  String firstName;

  @JsonKey(name: "last_name", defaultValue: "")
  String lastName;

  @JsonKey(name: "email", defaultValue: "")
  String email;

  @JsonKey(name: "phone", defaultValue: "")
  String phone;

  @JsonKey(name: "status", defaultValue: "")
  String status;

  @JsonKey(name: "avatar_url", defaultValue: null)
  String avatar_url;

  @JsonKey(name:"friendship", defaultValue: 0)
  int friendship;

  @JsonKey(name: "active_status", defaultValue: null)
  int activeStatus;

  @JsonKey(name: "last_time_update_status", defaultValue: null)
  double lastTimeUpdateStatus;

  ProfileUserModel({
    this.id,
    this.userName,
    this.firstName,
    this.lastName,
    this.email,
    this.status,
    this.avatar_url,
    this.phone,
    this.uuid,
    this.friendship,
    this.activeStatus,
    this.lastTimeUpdateStatus,
  });

  static ProfileUserModel fromJson(Map<String, dynamic> json) =>
      _$ProfileUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileUserModelToJson(this);
}
