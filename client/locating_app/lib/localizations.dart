import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:locaing_app/blocs/blocs.dart';
import 'package:locaing_app/data/network/api_response.dart';
import 'package:locaing_app/routes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'data/model/model.dart';
import 'data/repository/repository.dart';

Map<String, dynamic> languages;

class Language {
  final Locale _locale;

  Language(this._locale);

  static Language of(BuildContext context) {
    return Localizations.of<Language>(context, Language);
  }

  /// func get value of json with nest string key
  String getText(String key) {
    List<String> listKey = key.split(".");
    if (listKey.length == 1) {
      return languages[key] ?? "";
    }
    dynamic valueNest;
    for (int i = 0; i < listKey.length - 1; i++) {
      valueNest = languages[listKey[i]];
    }
    String keyResult = listKey[listKey.length - 1];
    return valueNest[keyResult] ?? "";
  }

  String get currentLanguage => _locale.languageCode;
}

class LanguageDelegate extends LocalizationsDelegate<Language> {
  const LanguageDelegate();

  @override
  bool isSupported(Locale locale) =>
      [Constants.VI, Constants.EN].contains(locale.languageCode);

  @override
  Future<Language> load(Locale locale) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(
        SPrefCache.PREF_KEY_LANGUAGE, locale.languageCode);
    String string = await rootBundle
        .loadString("assets/strings/${locale.languageCode}.json");
    languages = json.decode(string);
    return SynchronousFuture<Language>(Language(locale));
  }

  @override
  bool shouldReload(LanguageDelegate old) => false;
}

class PermissionsService {
  final PermissionHandler _permissionHandler = PermissionHandler();
  Future<bool> _requestPermission(PermissionGroup permission) async {
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  //kiem tra quyen co hya chua
  Future<bool> hasPermission(PermissionGroup permission) async {
    var permissionStatus =
        await _permissionHandler.checkPermissionStatus(permission);
    return permissionStatus == PermissionStatus.granted;
  }

  //cap quyen
  Future<bool> requestLocationPermission() async {
    return _requestPermission(PermissionGroup.locationAlways);
  }

  Future<bool> requestNotificationPermission() async {
    return _requestPermission(PermissionGroup.notification);
  }

  Future<bool> openSetting() async {
    bool a = await _permissionHandler.openAppSettings();
    return a;
  }
}

class FCM {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String uuid;
  bool isChat;
  getProfileUser(String uuid, BuildContext context) async {
    ApiResponse data = await ServiceRepository().getProfileUuId(uuid);
    if (data.resultCode == 1) {
      ProfileUserModel profileUser = ProfileUserModel.fromJson(data.data);
      print(profileUser.username);
      BlocProvider.of<HomeBloc>(context).add(SelectFriend(user: profileUser));
      Navigator.pushNamed(context, Routes.listPlaceScreen);
    }
  }

  getDataChat(String uuid, BuildContext context) async {
    ApiResponse data = await ServiceRepository().getProfileUuId(uuid);
    if (data.resultCode == 1) {
      ProfileUserModel profileUser = ProfileUserModel.fromJson(data.data);
      Navigator.pushNamed(context, Routes.chatScreen, arguments: profileUser);
    }
  }

  setNotification(BuildContext context) {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (value) async {
      isChat ? getDataChat(uuid, context) : getProfileUser(uuid, context);
    });
    _firebaseMessaging.configure(
      onMessage: (message) async {
        print("onMessage: $message");
        String title = message["notification"]["title"];
        String body = message["notification"]["body"];
        uuid = message['data']['user_id'];
        String typeNotification = message['data']['notification_type'];
        if (typeNotification == 'CHAT') {
          isChat = true;
          notificationLocalChat(title, body);
        } else {
          isChat = false;
          notificationLocal(title, body);
        }
      },
      onLaunch: (message) async {
        print("onLaunch: $message");
        String uuid = message['data']['user_id'];
        String typeNotification = message['data']['notification_type'];
        if (typeNotification == 'CHAT') {
          isChat = true;
          getDataChat(uuid, context);
        } else {
          isChat = false;
          getProfileUser(uuid, context);
        }
      },
      onResume: (message) async {
        print("onResume: $message");
        String uuid = message['data']['user_id'];
        getProfileUser(uuid, context);
        String typeNotification = message['data']['notification_type'];
        if (typeNotification == 'CHAT') {
          isChat = true;
          getDataChat(uuid, context);
        } else {
          isChat = false;
          getProfileUser(uuid, context);
        }
      },
    );
  }

  notificationLocalChat(String title, String body) async {
    var vibrationPattern = new Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'notification_chat',
      'notification chat',
      'chat',
      importance: Importance.max,
      priority: Priority.high,
      vibrationPattern: vibrationPattern,
      enableVibration: true,
      playSound: true,
    );
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Custom_Sound',
    );
  }

  notificationLocal(String title, String body) async {
    var vibrationPattern = new Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'location_sound',
      'notification in app',
      'your channel description',
      sound: RawResourceAndroidNotificationSound("alert"),
      importance: Importance.max,
      priority: Priority.high,
      vibrationPattern: vibrationPattern,
      enableVibration: true,
      playSound: true,
    );
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Custom_Sound',
    );
  }
}
