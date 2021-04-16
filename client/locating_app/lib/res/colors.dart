import 'dart:ui';

import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFEFEFE);
  static const Color white = Color(0xFFFFFFFF);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color grey_500 = Color(0xFF9E9E9E);
  static const Color dark_grey = Color(0xFF313A44);
  static const Color whiteBlack = Color(0xfff5f6fa);
  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color spacer = Color(0xFFF2F2F2);
  static const String fontName = 'WorkSans';
  static const Color nearlyDarkBlue = Color(0xFF2633C5);
  static const Color nearlyDarkBrown = Color(0xFF990033);

  static const Color nearlyYellow = Color(0xFFffff66);
  static const Color nealyRed = Color(0xffff7979);
  static const Color nearlyBlue = Color(0xFF00B6F0);
  static const Color blue = Color(0xff708eeb);
  static const Color darkBlue = Color(0xff546de5);
  static const Color background = Color(0xFFF2F3F8);
  static const Color nearlyRed = Color(0xffff7979);
  static const Color green = Color(0xff00cec9);
  static const Color yellowRed = Color(0xfffdcb6e);
  static const Color red = Color(0xFFF44336);
  static const Color statusOn = Color(0xFF33d9b2);
  static const Color statusOff = Color(0xFFd1ccc0);

  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText2: body2,
    bodyText1: body1,
    caption: caption,
  );

  static const TextStyle display1 = TextStyle(
    // h4 -> display1
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle(
    // h5 -> headline
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle(
    // h6 -> title
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    // subtitle2 -> subtitle
    fontFamily: fontName,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    letterSpacing: -0.04,
    color: nearlyDarkBrown,
  );

  static const TextStyle body2 = TextStyle(
    // body1 -> body2
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle(
    // body2 -> body1
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    // Caption -> caption
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );

  static TextTheme _buildTextTheme(TextTheme base) {
    const String fontName = 'WorkSans';
    return base.copyWith(
      headline1: base.headline1.copyWith(fontFamily: fontName),
      headline2: base.headline2.copyWith(fontFamily: fontName),
      headline3: base.headline3.copyWith(fontFamily: fontName),
      headline4: base.headline4.copyWith(fontFamily: fontName),
      headline5: base.headline5.copyWith(fontFamily: fontName),
      headline6: base.headline6.copyWith(fontFamily: fontName),
      button: base.button.copyWith(fontFamily: fontName),
      caption: base.caption.copyWith(fontFamily: fontName),
      bodyText1: base.bodyText1.copyWith(fontFamily: fontName),
      bodyText2: base.bodyText2.copyWith(fontFamily: fontName),
      subtitle1: base.subtitle1.copyWith(fontFamily: fontName),
      subtitle2: base.subtitle2.copyWith(fontFamily: fontName),
      overline: base.overline.copyWith(fontFamily: fontName),
    );
  }

  static ThemeData buildLightTheme() {
    final Color primaryColor = Color(0xFF54D3C2); //HexColor('#54D3C2');
    final Color secondaryColor = Color(0xFF54D3C2); //HexColor('#54D3C2');
    final ColorScheme colorScheme = const ColorScheme.light().copyWith(
      primary: primaryColor,
      secondary: secondaryColor,
    );
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      colorScheme: colorScheme,
      primaryColor: primaryColor,
      buttonColor: primaryColor,
      indicatorColor: Colors.white,
      splashColor: Colors.white24,
      splashFactory: InkRipple.splashFactory,
      accentColor: secondaryColor,
      canvasColor: Colors.white,
      backgroundColor: const Color(0xFFFFFFFF),
      scaffoldBackgroundColor: const Color(0xFFF6F6F6),
      errorColor: const Color(0xFFB00020),
      buttonTheme: ButtonThemeData(
        colorScheme: colorScheme,
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
      accentTextTheme: _buildTextTheme(base.accentTextTheme),
      platform: TargetPlatform.iOS,
    );
  }
}
