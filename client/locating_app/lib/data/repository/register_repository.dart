import 'dart:convert';
import 'package:dio/dio.dart';
import '../network/network.dart';
import '../network/repuest/user_register.dart';

class RegisterRepository {
  RegisterRepository();
  Future<ApiResponse> registerUser(UserRegister user) async {
    Response<ApiResponse> response = await Network.instance.post(
      url: ApiConstant.APIHOST + ApiConstant.REGISTER,
      body: user.toMap(),
    );
    return response.data;
  }

  Future<ApiResponse> verifyCode(
      String email, String userName, String code) async {
    var body = {"email": "$email", "verify_code": "$code"};
    Response<ApiResponse> response = await Network.instance.post(
      url: ApiConstant.APIHOST + ApiConstant.VERIFY_CODE,
      body: jsonEncode(body),
    );
    return response.data;
  }
}
