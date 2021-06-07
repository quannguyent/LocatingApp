import 'package:email_validator/email_validator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:locaing_app/data/model/history_location.dart';
import 'package:wemapgl/wemapgl.dart';

import 'package:intl/intl.dart';
import 'package:location/location.dart' as GPSService;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class Common {
  static Future setLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SPrefCache.PREF_KEY_LANGUAGE, language);
  }

  static Future<String> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String typeLanguage = prefs.getString(SPrefCache.PREF_KEY_LANGUAGE);
    return typeLanguage;
  }

  static Future setTypeMap(String typeMap) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SPrefCache.TYPE_MAP, typeMap);
  }

  static Future<String> getTypeMap() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String typeMap = prefs.getString(SPrefCache.TYPE_MAP);
    print(typeMap);
    return typeMap;
  }

  static Future<bool> getEnableNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSelected = prefs.getBool(SPrefCache.ENABLE_NOTIFICATION);
    return isSelected;
  }

  static Future<void> setEnableNotification(bool isSelected) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SPrefCache.ENABLE_NOTIFICATION, isSelected);
  }

  static Future<void> setUnit(String unit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SPrefCache.UNIT, unit);
  }

  static Future<String> getUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String unit = prefs.getString(SPrefCache.UNIT);
    return unit;
  }

  static Future<void> setRange(int range) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(SPrefCache.RANGE, range);
  }

  static Future removeToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(SPrefCache.TOKEN_SIGN_IN);
  }

  static Future<int> getRange() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int range = prefs.getInt(SPrefCache.RANGE);
    return range;
  }

  static Future saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SPrefCache.TOKEN_SIGN_IN, token);
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SPrefCache.TOKEN_SIGN_IN) ?? '';
  }

  static Future setUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SPrefCache.USER_ID, userId);
  }

  static Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SPrefCache.USER_ID);
  }

  static Future setBounds(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SPrefCache.BOUNDS_MAP, userId);
  }

  static Future<String> getBounds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SPrefCache.BOUNDS_MAP);
  }

  static Future setCurrentLocation(String location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SPrefCache.CURRENT_LOCATION, location);
  }

  static Future<String> getCurrentLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SPrefCache.CURRENT_LOCATION);
  }

  static Future<LatLng> getCoordinates() async {
    bool serviceEnabled;
    GPSService.LocationData myLocation;
    GPSService.Location location = new GPSService.Location();
    bool enable = true;
    GPSService.PermissionStatus _permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      try {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          enable = false;
        }
      } catch (e) {
        print("Exception: $e");
        enable = false;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == GPSService.PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != GPSService.PermissionStatus.GRANTED) {
        enable = false;
      }
    }

    if (enable) {
      // myLocation = await location.getLocation();
      // return LatLng(myLocation.latitude, myLocation.longitude);
      geolocator.Position position =
          await geolocator.Geolocator.getCurrentPosition(
              desiredAccuracy: geolocator.LocationAccuracy.best);
      return LatLng(position.latitude, position.longitude);
    } else {
      String currentLocation = await Common.getCurrentLocation();
      List<String> str = currentLocation.split(',');
      return LatLng(double.parse(str[0]), double.parse(str[1]));
    }
    // return myLocation;
  }

  static Future<String> getUserLocation() async {
    String locate = "";
    String latlng = "";
    GPSService.LocationData myLocation;
    GPSService.Location location = new GPSService.Location();
    bool _serviceEnabled;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }
    if (_serviceEnabled) {
      try {
        myLocation = await location.getLocation();
        final coordinates =
            new Coordinates(myLocation.latitude, myLocation.longitude);
        var addresses =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        var first = addresses.first;
        locate = first.addressLine;
        latlng = "Latitude :" +
            first.coordinates.latitude.toString() +
            "\nLongitude :" +
            first.coordinates.longitude.toString();
        print(locate + latlng);
      } catch (e) {
        if (e.code == 'PERMISSION_DENIED') {
          // error = 'please grant permission';
        }
        if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
          //error = 'permission denied- please enable it from app settings';print("sai2");
        }
        myLocation = null;
      }
    }
    return locate + "\n" + latlng;
  }

  static Future<List<String>> getRawDataDevice() async {
    List<String> infoDevice = [];
    return infoDevice;
  }

  static Future saveTokenFirebase(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SPrefCache.TOKEN_FIREBASE, token);
  }

  static Future<String> getTokenFirebase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SPrefCache.TOKEN_FIREBASE) ?? '';
  }

  static int readTimestampToMonth(int timestamp) {
    var now = DateTime.now();
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    return diff.inHours;
  }

  static String readTime(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm:ss | dd-MM-yyyy');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';
    time = format.format(date);
    return time;
  }

  static Future<List<String>> getLocations(
      List<HistoryLocation> listLogs) async {
    print("xxxxx 123123123 ${listLogs[0].lat}");
    List<String> locations = [];
    for (int i = 0; i < listLogs.length; i++) {
      var coordinates = new Coordinates(listLogs[i].lat, listLogs[i].lng);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      locations.add("${first.addressLine}");
    }
    print("xxxx locations ${locations[0]}");
    return locations;
  }

  static String validateEmail(value) {
    return EmailValidator.validate(value) ? null : "error.error_email";
  }
}
