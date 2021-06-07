import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:locaing_app/data/model/profile_user_model.dart';
import '../../constants.dart';
import '../../utils/common.dart';
import '../network/network.dart';
import '../model/model.dart' as model;

class ServiceRepository {
  ServiceRepository();

  Future<ApiResponse> getProfileUser() async {
    Response<ApiResponse> response = await Network.instance
        .post(url: ApiConstant.APIHOST + ApiConstant.PROFILE_USER);
    return response.data;
  }

  Future<ApiResponse> forgotPassword(String email) async {
    var body = {'email': '$email'};

    Response<ApiResponse> response = await Network.instance.post(
      url: ApiConstant.APIHOST + ApiConstant.FORGOT_PASSWORD,
      body: body,
    );
    return response.data;
  }

  Future<ApiResponse> verifyOtpCode(String email, String code) async {
    var body = {
      'email': '$email',
      'code': '$code',
    };

    Response<ApiResponse> response = await Network.instance.post(
      url: ApiConstant.APIHOST + ApiConstant.VERIFY_OTP_CODE,
      body: body,
    );
    return response.data;
  }

  Future<ApiResponse> recoverPassword(String newPassword) async {
    var body = {
      "new_password": "$newPassword",
    };

    Response<ApiResponse> response = await Network.instance.post(
      url: ApiConstant.APIHOST + ApiConstant.RESET_PASSWORD,
      body: body,
    );
    return response.data;
  }

  Future<ApiResponse> updatePassword(
    String oldPassword,
    String newPassword
  ) async {
    var body = {
      "oldPassword": "$oldPassword",
      "newPassword": "$newPassword",
    };
    Response<ApiResponse> response = await Network.instance.post(
      url: ApiConstant.APIHOST + ApiConstant.CHANGE_PASSWORD,
      body: body,
    );
    return response.data;
  }

  Future<ApiResponse> updateProfile(
    String username,
    String email,
    String displayname,
    String status,
    String phoneNumber,
    int sexId,
    {
      File image,
    }
  ) async {
    var body = {
      'username': '$username',
      'email': '$email',
      'displayName': '$displayname',
      'phone': '$phoneNumber',
      'sexId': sexId
    };

    var response = await Network.instance.post(
      url: ApiConstant.APIHOST + ApiConstant.UPDATE_PROFILE,
      body: body,
    );

    return response.data;

    if (image != null) {
      var multipartFile = await http.MultipartFile.fromPath(
        "avatar",
        image.path,
      );

      print(multipartFile);
    }
    // try {
    //   streamReponse = await response.send();

    //   final responseRequest = await http.Response.fromStream(streamReponse);
    //   if (responseRequest.statusCode != 200) {
    //     return null;
    //   }
    //   final Map<String, dynamic> responseData =
    //       jsonDecode(responseRequest.body);
    //   return responseData;
    // } catch (e) {
    //   print(e.toString());
    // }
  }

  Future<ApiResponse> shareLocation(String id) async {
    Response<ApiResponse> response = await Network.instance.put(
      url: ApiConstant.SHARE_LOCATION + id,
    );
    return response.data;
  }

  Future<ApiResponse> addFriend(int idFriend) async {
    String idMe = await Common.getUserId();
    var myID = int.parse("$idMe");
    // var friendID = int.parse("$idFriend") is int;
    var body = {"appUserId": "$myID", "friendId": "$idFriend"};
    Response<ApiResponse> response = await Network.instance.post(
      url: ApiConstant.APIHOST + ApiConstant.ADD_FRIEND,
      body: jsonEncode(body),
    );
    return response.data;
  }

  Future<ApiResponse> getListFriend() async {
    Response<ApiResponse> response = await Network.instance.post(
      url: ApiConstant.APIHOST + ApiConstant.GET_LIST_FRIEND,
      body: {}
    );
    return response.data;
  }

  Future<ApiResponse> getListFriendRequest() async {
    Response<ApiResponse> response = await Network.instance.post(
        url: ApiConstant.APIHOST + ApiConstant.GET_LIST_FRIEND_REQUEST,
        body: {}
    );
    return response.data;
  }

  Future<ApiResponse> getUsers(List<String> phones) async {
    var body = phones.map((phone) => {
      'phone': '$phone'
    }).toList();
    var response = await Network.instance.post(
      url: ApiConstant.APIHOST + ApiConstant.GET_USER_BY_PHONE,
      body: body,
    );
    return response.data;
  }

  Future<List<ProfileUserModel>> getUsersByPhones(List<String> phones) async {
    String url = ApiConstant.APIHOST + ApiConstant.GET_USER_BY_PHONE;
    var body = phones.map((phone) => {
      'phone': '$phone'
    }).toList();
    String accessToken = await Common.getToken();
    var headers = {
      'Content-Type': 'application/json; charset=utf-8',
    };

    if (accessToken != '') {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    final response = await http.post(
        '$url',
        headers: headers,
        body: jsonEncode(body)
    );
    if (response.statusCode == 200) {
      var list = json.decode(response.body) as List<dynamic>;
      List<ProfileUserModel> listUsers = list.map((model) => ProfileUserModel.fromJson(model)).toList();
      return listUsers;
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      throw Exception('Cannot get user by phone');
    }
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
