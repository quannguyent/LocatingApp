import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/ios_settings.dart';
import 'package:background_locator/settings/locator_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locaing_app/blocs/blocs.dart';
import 'package:locaing_app/data/model/model.dart';
import 'package:locaing_app/data/repository/repository.dart';
import 'package:locaing_app/localizations.dart';
import 'package:locaing_app/res/resources.dart';
import 'package:locaing_app/ui/screens/home_screen.dart';
import 'package:locaing_app/ui/screens/screens.dart';
import 'package:locaing_app/ui/widgets/widgets.dart';
import 'package:locaing_app/utils/common.dart';
import 'dart:math' as math;

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget screenView;
  DrawerIndex drawerIndex;
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>(debugLabel: "MainNavigator");
  static const String _isolateName = "LocatorIsolate";
  ReceivePort port = ReceivePort();
  static LogLocationRepository _logLocationRepository =
      new LogLocationRepository();
  static double distance = 10;

  static _updateLocation(LatLng location) async {
    await Common.setCurrentLocation(
        '${location.latitude}, ${location.longitude}');
    String userId = await Common.getUserId();
    if (userId != null) {
      final LogLocationModel logLocationModel = new LogLocationModel(
        userId: userId,
        lat: location.latitude,
        lng: location.longitude,
        content: '',
        hashShareCode: '',
      );
      try {
        final LogLocationModel lastLog =
            await _logLocationRepository.getLastLogLocation(userId);
        if (lastLog != null) {
          if (calculateDistance(location.latitude, location.longitude,
                  lastLog.lat, lastLog.lng) >=
              distance) {
            await Common.setCurrentLocation(
                '${location.latitude}, ${location.longitude}');
            await _logLocationRepository.updateLocation(
              log: logLocationModel,
            );
          }
        } else {
          await Common.setCurrentLocation(
              '${location.latitude}, ${location.longitude}');
          await _logLocationRepository.updateLocation(
            log: logLocationModel,
          );
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  static double calculateDistance(double sLatitude, double sLongitude,
      double eLatitude, double eLongitude) {
    var radiansOverDegrees = (math.pi / 180.0);

    var sLatitudeRadians = sLatitude * radiansOverDegrees;
    var sLongitudeRadians = sLongitude * radiansOverDegrees;
    var eLatitudeRadians = eLatitude * radiansOverDegrees;
    var eLongitudeRadians = eLongitude * radiansOverDegrees;

    var dLongitude = eLongitudeRadians - sLongitudeRadians;
    var dLatitude = eLatitudeRadians - sLatitudeRadians;

    var result1 = math.pow(math.sin(dLatitude / 2.0), 2.0) +
        math.cos(sLatitudeRadians) *
            math.cos(eLatitudeRadians) *
            math.pow(math.sin(dLongitude / 2.0), 2.0);

    // Using 6371 as the number of km around the earth
    var result2 =
        6371 * 2.0 * math.atan2(math.sqrt(result1), math.sqrt(1.0 - result1));

    //meter
    return result2 * 1000;
  }

  Future<void> initPlatformState() async {
    await BackgroundLocator.initialize();
  }

  static void callback(LocationDto locationDto) async {
    final SendPort send = IsolateNameServer.lookupPortByName(_isolateName);
    send?.send(locationDto);
    Future.delayed(const Duration(milliseconds: 5000), () async {
      await _updateLocation(
          new LatLng(locationDto.latitude, locationDto.longitude));
    });
  }

  void startLocationService() {
    BackgroundLocator.registerLocationUpdate(callback,
        iosSettings: IOSSettings(accuracy: LocationAccuracy.HIGH),
        androidSettings: AndroidSettings(
          accuracy: LocationAccuracy.NAVIGATION,
          interval: 10,
        ));
  }

  @override
  void initState() {
    super.initState();
    FCM fcm = FCM();
    fcm.setNotification(context);
    BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        drawerIndex = DrawerIndex.HOME;
        screenView = HomeScreen();
      });
      // IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
      // initPlatformState();
      // startLocationService();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: navigatorKey,
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
            },
            screenView: screenView ?? LoadingApp.loading1(),
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = HomeScreen();
        });
      } else if (drawerIndex == DrawerIndex.SETUP_ALERT) {
        setState(() {
          screenView = PlaceScreen();
        });
      } else if (drawerIndex == DrawerIndex.SETTING) {
        setState(() {
          screenView = SettingScreen();
        });
      } else if (drawerIndex == DrawerIndex.PRIVACY_FRIENDS) {
        setState(() {
          screenView = ListFriendsScreen(
            iconBack: false,
          );
        });
      }
    }
  }
}
