// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_success_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginSuccessModel _$LoginSuccessModelFromJson(Map<String, dynamic> json) {
  return LoginSuccessModel(
    json['access_token'] as String ?? '',
    json['token_type'] as String ?? '',
  );
}

Map<String, dynamic> _$LoginSuccessModelToJson(LoginSuccessModel instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
    };
