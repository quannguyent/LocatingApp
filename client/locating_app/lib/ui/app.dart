import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:locaing_app/data/model/model.dart';
import 'package:locaing_app/ui/screens/screens.dart';
import 'package:locaing_app/utils/common.dart';
import '../constants.dart';
import '../localizations.dart';
import '../res/resources.dart';
import '../routes.dart';
import '../utils/utils.dart';

class MyApp extends StatelessWidget {
  final String language;
  MyApp.language({this.language});

  @override
  Widget build(BuildContext context) {
   // SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.light : Brightness.light,
      statusBarColor: Colors.transparent,
      systemNavigationBarDividerColor:  Colors.transparent,
      systemNavigationBarColor:  Colors.transparent,
    ));
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: AppTheme.textTheme,
        platform: TargetPlatform.iOS,
      ),
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.instance.navigatorKey,
      localizationsDelegates: [
        const LanguageDelegate(),
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      locale: this.language == null
          ? Constants.SUPPORT_LOCALE[0]
          : Locale(this.language),
      supportedLocales: Constants.SUPPORT_LOCALE,
      localeResolutionCallback: (locale, supportedLocales) =>
          _localeCallback(locale, supportedLocales),
      initialRoute: Routes.initScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == Routes.registerPlaceDetailScreen) {
          final Arguments arg = settings.arguments;
          return MaterialPageRoute(
            builder: (_) => RegisterPlaceDetailScreen(
              arguments: arg,
            ),
          );
        }
        if (settings.name == Routes.registerPlaceScreen) {
          String arg = settings.arguments;
          return MaterialPageRoute(
            builder: (_) => RegisterPlaceScreen(
             friendId: arg,
            )
          );
        }
        return null;
      },
      routes: Routes.routes,
    );
  }

  Locale _localeCallback(Locale locale, Iterable<Locale> supportedLocales) {
    if (locale == null) {
      return supportedLocales.first;
    }
    // Check if the current device locale is supported
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return supportedLocale;
      }
    }
    // If the locale of the device is not supported, use the first one
    // from the list (japanese, in this case).
    return supportedLocales.first;
  }

  MyApp({this.language});
}
