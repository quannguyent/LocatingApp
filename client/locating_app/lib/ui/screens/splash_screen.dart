import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:locaing_app/localizations.dart';
import '../../res/resources.dart';
import '../../routes.dart';
import '../../utils/common.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    _firebaseMessaging.getToken().then((token) {
      Common.saveTokenFirebase(token);
      print("Token Firebase: $token");
    });

    SchedulerBinding.instance.addPostFrameCallback((_) => openScreen(context));
    // run app first
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.all(30),
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.LOGO_APP),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                padding: EdgeInsets.only(),
                child: Text(
                  "Locating",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  openScreen(BuildContext context) async {
    String token = await Common.getToken();
    await Future.delayed(Duration(seconds: 2));
    if (token.isEmpty) {
      Navigator.pushReplacementNamed(context, Routes.introScreen);
    } else {
      Navigator.pushReplacementNamed(context, Routes.login);
      Navigator.pushNamed(context, Routes.home);
    }
  }
}
