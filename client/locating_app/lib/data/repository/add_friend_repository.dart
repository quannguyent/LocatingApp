import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:locaing_app/data/model/model.dart';
import 'package:locaing_app/data/network/network.dart';
import 'package:locaing_app/utils/common.dart';

class AddFriendRepository {
  Future<List<ProfileUserModel>> getPhoneUserExist(List<String> phones) async {
    final _uri = Uri(
        scheme: ApiConstant.SCHEME,
        host: ApiConstant.HOST_PHONE,
        port: 8000,
        path: ApiConstant.URL_PHONE,
        queryParameters: {
          'phones': phones,
        });
    String accessToken = await Common.getToken();
    var response = await http.get(_uri, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    final Map mapResponse = json.decode(response.body);
    final List<ProfileUserModel> users = (mapResponse['data'] as List)
        .map((e) => ProfileUserModel.fromJson(e))
        .toList();

    return users;
  }
}
