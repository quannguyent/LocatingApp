import 'package:dio/dio.dart';
import 'package:locaing_app/data/model/model.dart';
import 'package:locaing_app/data/network/network.dart';
import 'package:locaing_app/data/network/network_impl.dart';
import 'package:locaing_app/utils/common.dart';

class PlaceRepository {
  Future<List<PlaceModel>> getPlaces({String userId, String friendId}) async {
    List<PlaceModel> listPlaces;
    String accessToken = await Common.getToken();
    Map<String, dynamic> params = {
      "user_id": userId,
      "following_id": friendId,
    };
    try {
      Response<ApiResponse> response = await Network.instance.get(
        url: ApiConstant.APIHOST + ApiConstant.PLACE,
        params: params,
        token: accessToken,
      );
      ApiResponse data = response.data;
      if (data.resultCode == 1) {
        if (data.data != null) {
          listPlaces = (data.data as List)
              .map((json) => PlaceModel.fromJson(json))
              .toList();
        } else {
          listPlaces = null;
        }
      }
    } catch (e) {
      print(e.toString());
    }

    return listPlaces;
  }

  Future<bool> addPlace({
    String userId,
    String friendId,
    String name,
    String address,
    double rad,
    double lat,
    double lng,
  }) async {
    String accessToken = await Common.getToken();
    var body = {
      "user_id": userId,
      "following_id": friendId,
      "name": name,
      "address": address,
      "rad": rad,
      "lat": lat,
      "lng": lng,
    };
    try {
      Response<ApiResponse> response = await Network.instance.post(
        url: ApiConstant.APIHOST + ApiConstant.PLACE,
        body: body,
        token: accessToken,
      );

      ApiResponse data = response.data;
      if (data.resultCode == 1) {
        return true;
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> updatePlace({
    String userId,
    String friendId,
    String placeId,
    String name,
    String address,
    double rad,
    double lat,
    double lng,
  }) async {
    String accessToken = await Common.getToken();
    var body = {
      "place_id": placeId,
      "user_id": userId,
      "following_id": friendId,
      "name": name,
      "address": address,
      "rad": rad,
      "lat": lat,
      "lng": lng,
    };

    try {
      Response<ApiResponse> response = await Network.instance.put(
        url: ApiConstant.APIHOST + ApiConstant.PLACE,
        body: body,
        token: accessToken,
      );
      ApiResponse data = response.data;
      if (data.resultCode == 1) {
        return true;
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> deletePlace(
      {String placeId, String userId, String friendId}) async {
    String accessToken = await Common.getToken();
    var params = {
      "place_id": placeId,
      "user_id": userId,
      "following_id": friendId,
    };

    try {
      Response<ApiResponse> response = await Network.instance.delete(
        url: ApiConstant.APIHOST + ApiConstant.PLACE,
        params: params,
        token: accessToken,
      );
      ApiResponse data = response.data;
      if (data.resultCode == 1) {
        return true;
      }
    } catch (e) {
      print(e.toString());
    }

    return false;
  }
}
