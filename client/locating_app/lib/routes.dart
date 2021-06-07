import 'package:flutter/material.dart';
import 'package:locaing_app/ui/widgets/widgets.dart';

import 'ui/screens/screens.dart';

class Routes {
  Routes._();
  static const String splashScreen = "/splash_screen";
  static const String home = "/home_screen";
  static const String login = "/login_screen";
  static const String registerScreen = "/register_screen";
  static const String verifyCodeScreen = "/verify_code_screen";
  static const String resetPasswordScreen = "/reset_password_screen";
  static const String verifyCodeResetPasswordScreen =
      "/verify_code_reset_password_screen";
  static const String createNewPasswordScreen = "/create_new_password_screen";
  static const String introScreen = "/intro_screen";
  static const String addFriendScreen = "/add_friend_screen";
  static const String alertScreen = "/alert_screen";
  static const String requireLocationScreen = "/require_location_screen";
  static const String pricingScreen = "/pricing_screen";
  static const String settingScreen = "/setting_screen";
  static const String notificationSettingScreen =
      "/notification_setting_screen";
  static const String languageSettingScreen = "/language_setting_screen";
  static const String mapSettingScreen = "/map_setting_screen";
  static const String alertSettingScreen = "/alert_setting_screen";
  static const String placeScreen = "/place_screen";
  static const String registerPlaceScreen = "/register_place_screen";
  static const String registerPlaceDetailScreen =
      "/register_place_detail_screen";
  static const String chatScreen = "/chat_screen";
  static const String historyUserScreen = "/history_user_screen";
  static const String listFriendsScreen = "/list_friend_screen";
  static const String profileScreen = "/profile_screen";
  static const String addPhoneNumber = "/add_phone_number";
  static const String listPlaceScreen = "/list_place_screen";
  static const String listFriendRequestScreen = "/list_friend_request_screen";


  static String initScreen() => splashScreen;

  static final routes = <String, WidgetBuilder>{
    splashScreen: (context) => SplashScreen(),
    home: (context) => NavigationHomeScreen(), //Home(),
    registerScreen: (context) => RegisterScreen(),
    login: (context) => LoginScreen(),
    verifyCodeScreen: (context) => VerifyCodeScreen(),
    resetPasswordScreen: (context) => ResetPasswordScreen(),
    verifyCodeResetPasswordScreen: (context) => VerifyCodeResetPasswordScreen(),
    createNewPasswordScreen: (context) => CreateNewPasswordScreen(),
    introScreen: (context) => IntroScreen(),
    addFriendScreen: (context) => AddFriendScreen(),
    alertScreen: (context) => AlertScreen(),
    requireLocationScreen: (context) => RequireLocationScreen(),
    pricingScreen: (context) => PricingScreen(),
    settingScreen: (context) => SettingScreen(),
    notificationSettingScreen: (context) => NotificationSettingScreen(),
    mapSettingScreen: (context) => MapSettingScreen(),
    languageSettingScreen: (context) => LanguageSettingScreen(),
    alertSettingScreen: (context) => AlertSettingScreen(),
    // registerPlaceScreen: (context) => RegisterPlaceScreen(),
    chatScreen: (context) => ChatScreen(),
    historyUserScreen: (context) => HistoryUserScreen(),
    listFriendsScreen: (context) => ListFriendsScreen(),
    profileScreen: (context) => ProfileScreen(0),
    addPhoneNumber: (context) => AddEmailPhoneScreen(),
    placeScreen: (context) => PlaceScreen(),
    listPlaceScreen: (context) => ListPlaceScreen(),
    listFriendRequestScreen: (context) => ListFriendRequestScreen(),

  };
}
