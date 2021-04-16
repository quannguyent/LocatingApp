import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/blocs.dart';
import '../../localizations.dart';
import '../../res/resources.dart';
import '../../routes.dart';
import '../../utils/utils.dart';
import '../widgets/widgets.dart';

class RequireLocationScreen extends StatefulWidget {
  @override
  _RequireLocationScreenState createState() => _RequireLocationScreenState();
}

class _RequireLocationScreenState extends State<RequireLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: DeviceUtil.getDeviceWidth(context),
        height: DeviceUtil.getDeviceHeight(context),
        child: Stack(
          children: [
            ClipRRect(
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppTheme.deactivatedText
                      ]).createShader(bounds);
                },
                blendMode: BlendMode.darken,
                child: Container(
                  width: DeviceUtil.getDeviceWidth(context),
                  height: DeviceUtil.getDeviceHeight(context),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(AppImages.REQUIRE_LOCATION),
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
                    padding: EdgeInsets.only(bottom: 80, left: 40, right: 40),
                    width: DeviceUtil.getDeviceWidth(context),
                    height: DeviceUtil.getDeviceHeight(context) / 3.2 + 30,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            Language.of(context)
                                .getText("require_location.title"),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              letterSpacing: 0.27,
                              color: AppTheme.white,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            Language.of(context)
                                .getText("require_location.des_title"),
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
                          title: "require_location.set_always",
                          onPress: () {
                            PermissionsService()
                                .requestLocationPermission()
                                .then((value) {
                              if (value == true) {
                                print(value.toString());
                                Navigator.pushNamed(context, Routes.home);
                              }
                            });
                          },
                          boldText: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                Positioned(
                  top: 80,
                  child: Container(
                    width: DeviceUtil.getDeviceWidth(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 0.6 * DeviceUtil.getDeviceWidth(context),
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppTheme.nearlyWhite.withOpacity(0.4),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                          ),
                          child: Text(
                            Language.of(context)
                                .getText("require_location.use_app"),
                            style: TextStyle(
                              color: AppTheme.darkText.withOpacity(0.16),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            PermissionsService().requestLocationPermission().then((value){
                              print(value.toString());
                              Navigator.pushNamed(context, Routes.home);
                            });
                          },
                          child: Container(
                            width:
                                0.6 * DeviceUtil.getDeviceWidth(context) + 24,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppTheme.nearlyWhite,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              Language.of(context)
                                  .getText("require_location.always"),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 0.6 * DeviceUtil.getDeviceWidth(context),
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppTheme.nearlyWhite.withOpacity(0.4),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                          ),
                          child: Text(
                            Language.of(context)
                                .getText("require_location.deny"),
                            style: TextStyle(
                              color: AppTheme.darkText.withOpacity(0.16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
