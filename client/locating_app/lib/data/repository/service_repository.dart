import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../utils/common.dart';
import '../network/network.dart';

class ServiceRepository {
  ServiceRepository();

  Future<ApiResponse> getProfileUser({String token}) async {
    Response<ApiResponse> response = await Network.instance.post(
        url: ApiConstant.APIHOST + ApiConstant.PROFILE_USER, token: token);
    return response.data;
  }

  Future<ApiResponse> forgotPassword(String email) async {
    var body = {"email": "$email", "app_name": "${Constants.APP_NAME}"};
    Response<ApiResponse> response = await Network.instance.post(
      url: ApiConstant.APIHOST + ApiConstant.FORGOT_PASSWORD,
      body: jsonEncode(body),
    );
    return response.data;
  }

  Future<ApiResponse> updatePassword(
      String oldPassword, String newPassword) async {
    var body = {
      "oldPassword": "$oldPassword",
      "newPassword": "$newPassword",
    };
    Response<ApiResponse> response = await Network.instance.post(
      url: ApiConstant.APIHOST + ApiConstant.RESET_PASSWORD,
      body: jsonEncode(body),
    );
    return response.data;
  }

  Future<Map<String, dynamic>> updateProfile(
    String email,
    String firstName,
    String lastName,
    String status,
    String phoneNumber,
    String oldPassword,
    String newPassword,
    String retypeNewPassword,
    String id, {
    File image,
  }) async {
    var streamReponse;
    String accessToken = await Common.getToken();
    var response = await http.MultipartRequest(
        "PUT", Uri.parse(ApiConstant.APIHOST + ApiConstant.UPDATE_USER + id));
    response.headers['Authorization'] = "Bearer $accessToken";
    response.headers['Content-Type'] = 'multipart/form-data';
    response.fields["email"] = "$email";
    response.fields["first_name"] = "$firstName";
    response.fields["last_name"] = "$lastName";
    response.fields["status"] = "$status";
    response.fields["phone"] = "$phoneNumber";
    response.fields["old_password"] = "$oldPassword";
    response.fields["new_password"] = "$newPassword";
    response.fields["retype_password"] = "$retypeNewPassword";
    if (image != null) {
      var multipartFile = await http.MultipartFile.fromPath(
        "avatar_image",
        image.path,
      );
      response.files.add(multipartFile);
    }
    try {
      streamReponse = await response.send();

      final responseRequest = await http.Response.fromStream(streamReponse);
      if (responseRequest.statusCode != 200) {
        return null;
      }
      final Map<String, dynamic> responseData =
          jsonDecode(responseRequest.body);
      return responseData;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<ApiResponse> shareLocation(String id) async {
    Response<ApiResponse> response = await Network.instance.put(
      url: ApiConstant.SHARE_LOCATION + id,
    );
    return response.data;
  }

  Future<ApiResponse> addFriend(String idMe, String idFriend) async {
    var body = {"user_id_1": "$idMe", "user_id_2": "$idFriend"};
    Response<ApiResponse> response = await Network.instance.post(
      url: ApiConstant.ADD_FRIEND,
      body: jsonEncode(body),
    );
    return response.data;
  }

  Future<ApiResponse> getListFriend() async {
    String userId = await Common.getUserId();
    String token = await Common.getToken();
    Response<ApiResponse> response = await Network.instance.post(
        url: ApiConstant.APIHOST + ApiConstant.GET_LIST_FRIEND,
        token: token,
        body: jsonEncode({"appUserId": userId}));
    return response.data;
  }

  Future<ApiResponse> setCloseFriend(String uuidMe, String uuidFriend) async {
    var body = {"user_id_1": "$uuidMe", "user_id_2": "$uuidFriend"};
    Response<ApiResponse> response = await Network.instance.put(
      url: ApiConstant.SET_CLOSE_FRIEND,
      body: body,
    );
    return response.data;
  }

  Future<ApiResponse> deleteFriend(String uuidMe, String uuidFriend) async {
    var body = {"user_id_1": "$uuidMe", "user_id_2": "$uuidFriend"};
    Response<ApiResponse> response = await Network.instance.delete(
      url: ApiConstant.DELETE_FRIEND,
      body: body,
    );
    return response.data;
  }

  Future<ApiResponse> sendChat(
      String uuidMe, String uuidFriend, String reply) async {
    Response<ApiResponse> response =
        await Network.instance.post(url: ApiConstant.SEND_CHAT, params: {
      "sender_id": "$uuidMe",
      "receiver_id": "$uuidFriend",
      "reply": "$reply",
    });
    return response.data;
  }

  Future<ApiResponse> getProfileUuId(String uuid) async {
    Response<ApiResponse> response = await Network.instance.get(
      url: ApiConstant.GET_PROFILE_UUID + uuid,
    );
    return response.data;
  }

  Future<ApiResponse> callForHelp() async {
    Response<ApiResponse> response = await Network.instance.get(
      url: ApiConstant.APIHOST + ApiConstant.CALL_FOR_HELP,
    );
    return response.data;
  }
}
