import 'package:json_annotation/json_annotation.dart';
part 'profile_user_model.g.dart';

@JsonSerializable(explicitToJson: true)

class Sex {
  @JsonKey(name: "id", defaultValue: 0)
  int id;

  @JsonKey(name: "code", defaultValue: '')
  String code;
}
class ProfileUserModel {
  @JsonKey(name: "id", defaultValue: 0)
  int id;

  @JsonKey(name: "uuid", defaultValue: "")
  String uuid;

  @JsonKey(name: "username", defaultValue: "")
  String username;

  @JsonKey(name: "display_name", defaultValue: "")
  String displayName;

  @JsonKey(name: "email", defaultValue: "")
  String email;

  @JsonKey(name: "phone", defaultValue: "")
  String phone;

  @JsonKey(name: "status", defaultValue: "")
  String status;

  @JsonKey(name: "avatar", defaultValue: null)
  String avatar;

  @JsonKey(name:"friendship", defaultValue: 0)
  int friendship;

  @JsonKey(name:"sexId", defaultValue: 0)
  int sexId;

  @JsonKey(name: "active_status", defaultValue: null)
  int activeStatus;

  @JsonKey(name: "updated_at", defaultValue: null)
  double updatedAt;

  ProfileUserModel({
    this.id,
    this.username,
    this.displayName,
    this.email,
    this.status,
    this.avatar,
    this.phone,
    this.sexId,
    this.uuid,
    this.friendship,
    this.activeStatus,
    this.updatedAt,
  });

  static ProfileUserModel fromJson(Map<dynamic, dynamic> json) => _$ProfileUserModelFromJson(json);


  Map<String, dynamic> toJson() => _$ProfileUserModelToJson(this);
}
