import 'dart:ui';
import 'package:flutter/material.dart';
import '../../localizations.dart';
import '../../res/resources.dart';
import '../../routes.dart';
import '../../utils/utils.dart';
import '../widgets/widgets.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  String title = "app_name",
      description = "intro.intro_1",
      assetImage = AppImages.INTRO_1;
  int index = 0;

  void nextPage() {
    setState(() {
      index <= 2 ? index++ : () {
      };
      if (index == 1) {
        title = "intro.title_2";
        description = "intro.intro_2";
        assetImage = AppImages.INTRO_2;
      }
      if (index == 2) {
        title = "intro.title_3";
        description = "intro.intro_3";
        assetImage = AppImages.INTRO_3;
      }
      if(index==3)  Navigator.pushNamed(context, Routes.login);
    });
  }

  void backPage() {
    setState(() {
      index > 0 ? index-- : () {};
      if (index == 0) {
        title = "app_name";
        description = "intro.intro_1";
        assetImage = AppImages.INTRO_1;
      }
      if (index == 1) {
        title = "intro.title_2";
        description = "intro.intro_2";
        assetImage = AppImages.INTRO_2;
      }
      if (index == 2) {
        title = "intro.title_3";
        description = "intro.intro_3";
        assetImage = AppImages.INTRO_3;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (end) {
          if (end.primaryVelocity < 0) {
            nextPage();
            //next
          } else if (end.primaryVelocity > 0) {
            backPage();
            // back
          }
        },
        child: Container(
          child: ItemIntroScreen(
            title: title,
            description: description,
            assetImage: assetImage,
            index: index,
            onpress: () {
              nextPage();
            //  if(index==3)  Navigator.pushNamed(context, Routes.login);
            },
          ),
        ),
      ),
    );
  }
}

class ItemIntroScreen extends StatefulWidget {
  String title, description;
  Function onpress;
  int index = 0;
  String assetImage;
  ItemIntroScreen(
      {this.title,
      this.description,
      this.onpress,
      this.index,
      this.assetImage});

  @override
  _ItemIntroScreenState createState() => _ItemIntroScreenState();
}

class _ItemIntroScreenState extends State<ItemIntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ClipRRect(
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, AppTheme.deactivatedText])
                .createShader(bounds);
          },
          blendMode: BlendMode.darken,
          child: Container(
            width: DeviceUtil.getDeviceWidth(context),
            height: DeviceUtil.getDeviceHeight(context),
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage(widget.assetImage),
              fit: BoxFit.cover,
            )),
          ),
        ),
      ),
      Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(bottom: 50, left: 40, right: 40),
              width: DeviceUtil.getDeviceWidth(context),
              height: DeviceUtil.getDeviceHeight(context) / 3.2,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      Language.of(context).getText(widget.title),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        letterSpacing: 0.27,
                        color: AppTheme.white,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      Language.of(context).getText(widget.description),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        letterSpacing: 0.27,
                        color: AppTheme.white,
                      ),
                    ),
                  ),
                  ItemButton(
                    color: AppTheme.white,
                    colorText: AppTheme.nearlyBlue,
                    title: "intro.next",
                    onPress: widget.onpress,
                  ),
                  Container(
                    width: 60,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: widget.index == 0
                                ? AppTheme.nearlyBlue
                                : AppTheme.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: widget.index == 1
                                ? AppTheme.nearlyBlue
                                : AppTheme.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: widget.index == 2
                                ? AppTheme.nearlyBlue
                                : AppTheme.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ]);
  }
}
