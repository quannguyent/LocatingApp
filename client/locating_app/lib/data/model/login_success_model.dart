import 'package:json_annotation/json_annotation.dart';
part 'login_success_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LoginSuccessModel {
  @JsonKey(name: "access_token", defaultValue: "")
  String accessToken;

  @JsonKey(name: "token_type", defaultValue: "")
  String tokenType;

  LoginSuccessModel(this.accessToken, this.tokenType);

  static LoginSuccessModel fromJson(Map<String, dynamic> json) =>
      _$LoginSuccessModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginSuccessModelToJson(this);
}
