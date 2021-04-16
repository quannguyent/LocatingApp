import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locaing_app/blocs/blocs.dart';
import 'package:locaing_app/res/resources.dart';
import 'package:locaing_app/ui/widgets/widgets.dart';
import 'package:locaing_app/utils/utils.dart';
import '../../localizations.dart';
import '../../routes.dart';

class SettingScreen extends StatelessWidget {
  bool fromMenu;

  SettingScreen({this.fromMenu});

  Widget itemSetting(String title, String description, BuildContext context,
      String jumpScreen) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, jumpScreen);
      },
      child: Column(
        children: <Widget>[
          Container(
            width: DeviceUtil.getDeviceWidth(context),
            child: Padding(
              padding: const EdgeInsets.only(
                top: AppDimens.SIZE_15,
                left: AppDimens.SIZE_15,
                bottom: AppDimens.SIZE_15,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      Language.of(context).getText(title),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppDimens.SIZE_20,
                      ),
                    ),
                    margin: EdgeInsets.only(bottom: 5),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    description != null
                        ? Language.of(context).getText(description)
                        : "",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: AppDimens.SIZE_15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    fromMenu = ModalRoute.of(context).settings.arguments;
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
    return BaseScreenMethod(
      iconBack: fromMenu,
      title: "home.settings",
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: AppDimens.SIZE_10),
          child: Column(
            children: <Widget>[
              Container(
                child: itemSetting(
                  "settings.notifications",
                  "settings.descriptionNoti",
                  context,
                  Routes.notificationSettingScreen,
                ),
              ),
              Container(
                child: itemSetting(
                  "settings.range",
                  "settings.descriptionRange",
                  context,
                  Routes.alertSettingScreen,
                ),
              ),
              Container(
                child: itemSetting(
                  "settings.maps",
                  "settings.descriptionMap",
                  context,
                  Routes.mapSettingScreen,
                ),
              ),
              Container(
                child: itemSetting(
                  "settings.change_language",
                  "settings.des_change_language",
                  context,
                  Routes.languageSettingScreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
      },
    );
  }
}
