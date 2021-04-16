import 'dart:convert';
import 'package:dio/dio.dart';
import '../../constants.dart';
import '../../utils/common.dart';
import '../model/model.dart';
import '../network/network.dart';

class PushSettingRepository {
  PushSettingRepository();

  Future<ApiResponse> setting({
    bool permission,
    int range,
    String unit,
    String mapType,
    String language,
  }) async {
    String appName = Constants.APP_NAME;
    //LocationData location = await Common.getCoordinates();
    NotificationSettingModel notificationSetting = new NotificationSettingModel(
      lat: null,
      lng: null,
      permissionNotification: permission,
    );
    SettingModel pushSetting = new SettingModel(
      mapType: mapType,
      language: language,
      range: range,
      unit: unit,
      notificationSettingModel: notificationSetting,
    );
    var body = {
      'setting_name': appName,
      'setting_data': pushSetting.toJson(),
    };
    String accessToken = await Common.getToken();
    Response<ApiResponse> response = await Network.instance.put(
      url: ApiConstant.SETTING,
      body: body,
      token: accessToken,
    );
    return response.data;
  }

  Future<ApiResponse> getSetting() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String accessToken = await Common.getToken();
    Response<ApiResponse> response = await Network.instance.get(
      url: ApiConstant.SETTING,
      token: accessToken,
    );
    return response.data;
  }

  Future<ApiResponse> updateLocation(double lat, double lng) async {
    var body = {"lat": "$lat", "lng": "$lng", "app_name": Constants.APP_NAME};
    Response<ApiResponse> response = await Network.instance.put(
      url: ApiConstant.APIHOST + ApiConstant.UPDATE_LOCATION,
      body: jsonEncode(body),
    );
    return response.data;
  }
}
