import 'package:dio/dio.dart';
import 'package:locaing_app/utils/common.dart';
import 'package:quiver/collection.dart';
import 'dart:convert';
import 'api_response.dart';
import 'network.dart';

class Network {
  static int _timeOut = 10000; //10s
  static BaseOptions options = BaseOptions(
      connectTimeout: _timeOut,
      receiveTimeout: _timeOut,
      baseUrl: ApiConstant.APIHOST);
  static Dio _dio = Dio(options);

  Network._internal() {
    _dio.interceptors.add(LogInterceptor(
        responseBody: true, requestBody: true, requestHeader: true));
  }

  static final Network instance = Network._internal();

  //get array
  Future<Response<ApiResponse>> get(
      {String url, Map<String, dynamic> params, String token}) async {
    try {
      String accessToken = await Common.getToken();
      Response response = await _dio.get(
        url,
        queryParameters: params,
        options: Options(responseType: ResponseType.json, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        }),
      );
      return getApiResponse(response);
    } on DioError catch (e) {
      //handle error
      print("DioError: ${e.toString()}");
      return getError(e);
    }
  }

  Future<Response<ApiResponse>> post(
      {String url,
      Object body = const {},
      Map<String, dynamic> params = const {},
      String token,
      String contentType = Headers.jsonContentType}) async {
    try {
      String accessToken = await Common.getToken();
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (accessToken != '') {
        headers['Authorization'] = 'Bearer $accessToken';
      }

      Response response = await _dio.post(
        url,
        data: body,
        queryParameters: params,
        options: Options(responseType: ResponseType.json, headers: headers),
      );
      return getApiResponse(response);
    } on DioError catch (e) {
      print("DioError: ${e.toString()}");
      return getError(e);
    }
  }

  Future<Response<ApiResponse>> put({
    String url,
    Object body = const {},
    Map<String, dynamic> params = const {},
    String token,
    bool multipartFormData,
    String contentType = Headers.jsonContentType,
  }) async {
    try {
      String accessToken = await Common.getToken();
      Response response = await _dio.put(
        url,
        data: body,
        queryParameters: params,
        options: Options(responseType: ResponseType.json, headers: {
          'Content-Type': multipartFormData == null
              ? 'application/json'
              : "multipart/form-data",
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        }),
      );
      return getApiResponse(response);
    } on DioError catch (e) {
      //handle error
      print("DioError: ${e.toString()}");
      return getError(e);
    }
  }

  Future<Response<ApiResponse>> delete({
    String url,
    Object body = const {},
    Map<String, dynamic> params = const {},
    String token,
    bool multipartFormData,
    String contentType = Headers.jsonContentType,
  }) async {
    try {
      String accessToken = await Common.getToken();
      Response response = await _dio.delete(
        url,
        data: body,
        queryParameters: params,
        options: Options(responseType: ResponseType.json, headers: {
          'Content-Type': multipartFormData == null
              ? 'application/json'
              : "multipart/form-data",
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        }),
      );
      return getApiResponse(response);
    } on DioError catch (e) {
      //handle error
      print("DioError: ${e.toString()}");
      return getError(e);
    }
  }

  Response<ApiResponse> getError(DioError e) {
    switch (e.type) {
      case DioErrorType.CANCEL:
      case DioErrorType.CONNECT_TIMEOUT:
      case DioErrorType.RECEIVE_TIMEOUT:
      case DioErrorType.SEND_TIMEOUT:
      case DioErrorType.DEFAULT:
        return Response<ApiResponse>(
          data: ApiResponse.errorLocal("error_api.connect"),
        );
      default:
        return Response<ApiResponse>(data: ApiResponse.error(e.message));
    }
  }

  Response<ApiResponse> getApiResponse(Response response) {
    var result = response;
    if (result == null) {
      return Response<ApiResponse>(
          data: ApiResponse.success(resultCode: 1, data: response.data));
    }

    return Response<ApiResponse>(
      data: ApiResponse.success(
        resultCode: result.statusCode == 200 ? 1 : 0,
        message: result.statusMessage,
        data: result.data,
      ),
    );
  }
}
