import 'package:dio/dio.dart';
import 'package:geocoder/geocoder.dart';
import 'package:locaing_app/data/model/model.dart';
import 'package:locaing_app/data/network/network.dart';
import 'package:locaing_app/utils/common.dart';

class LogLocationRepository {
  Future<ApiResponse> updateLocation({LogLocationModel log}) async {
    String accessToken = await Common.getToken();

    Response<ApiResponse> response = await Network.instance.post(
      url: ApiConstant.APIHOST + ApiConstant.LOG_LOCATION,
      body: log.toJson(),
      token: accessToken,
    );
    return response.data;
  }

  Future<LogLocationModel> getLastLogLocation(String userId) async {
    String accessToken = await Common.getToken();
    LogLocationModel logLocationModel;
    try {
      Response<ApiResponse> response = await Network.instance.get(
        url: ApiConstant.APIHOST + ApiConstant.LAST_LOG + userId,
        token: accessToken,
      );
      ApiResponse data = response.data;
      if (data.resultCode == 1) {
        if (data.data == null) {
          return null;
        } else {
          logLocationModel = LogLocationModel.fromJson(data.data);
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return logLocationModel;
  }

  Future<List<LogLocationModel>> getLogLocations({
    String userId,
    double startTime,
    double endTime,
    double topRightLat,
    double topRightLng,
    double bottomLeftLat,
    double bottomLeftLng,
  }) async {
    String accessToken = await Common.getToken();
    List<LogLocationModel> listLogs;
    var param = {
      's_time': startTime,
      'e_time': endTime,
      'topRightPointLat': topRightLat,
      'topRightPointLng': topRightLng,
      'bottomLeftPointLat': bottomLeftLat,
      'bottomLeftPointLng': bottomLeftLng,
    };
    try {
      Response<ApiResponse> response = await Network.instance.get(
        url: ApiConstant.APIHOST + ApiConstant.LOG_LOCATION + '/' + userId,
        token: accessToken,
        params: param,
      );
      ApiResponse data = response.data;
      if (data.resultCode == 1) {
        if (data.data != null) {
          listLogs = (data.data as List)
              .map((json) => LogLocationModel.fromJson(json))
              .toList();
        } else {
          listLogs = null;
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return listLogs;
  }

  Future<List<String>> getLocations(List<LogLocationModel> listLogs) async {
    List<String> locations = [];
    for (int i = 0; i < listLogs.length; i++) {
      var coordinates = new Coordinates(listLogs[i].lat, listLogs[i].lng);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      locations.add("${first.addressLine}");
    }
    return locations;
  }
}
