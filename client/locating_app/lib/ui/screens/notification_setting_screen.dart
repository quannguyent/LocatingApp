import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locaing_app/blocs/blocs.dart';
import 'package:locaing_app/res/resources.dart';
import 'package:locaing_app/ui/widgets/widgets.dart';
import 'package:locaing_app/utils/device.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:system_setting/system_setting.dart';
import '../../localizations.dart';

class NotificationSettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScreenMethod(
      title: "settings.notifications",
      iconBack: true,
      body: SingleChildScrollView(child: NotificationSetting()),
    );
  }
}

class NotificationSetting extends StatefulWidget {
  @override
  _NotificationSettingState createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  final GlobalKey _globalKey = GlobalKey<FormState>();
  TextEditingController _controller = new TextEditingController();
  bool _permission = true;
  bool notification = true, vibration = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
        _permission = state.permission;
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: DeviceUtil.getDeviceWidth(context),
                margin: EdgeInsets.only(bottom: 10),
                color: AppTheme.white,
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16,
                          ),
                          child: Text(
                            Language.of(context)
                                .getText('settings.notifications'),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width > 360
                                  ? 16
                                  : 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 16, left: 16),
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: InkWell(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                              onTap: () async {
                                context.read<SettingBloc>().add(
                                      ChangeSettingNotification(
                                        permission: !_permission,
                                      ),
                                    );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 0, bottom: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        Language.of(context).getText(
                                            'settings.show_notification'),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    CupertinoSwitch(
                                      activeColor: state.permission
                                          ? AppTheme.buildLightTheme()
                                              .primaryColor
                                          : Colors.grey.withOpacity(0.6),
                                      onChanged: (bool value) async {
                                        context
                                            .read<SettingBloc>()
                                            .add(ChangeSettingNotification(
                                              permission: value,
                                            ));
                                      },
                                      value: state.permission,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _permission
                  ? SingleChildScrollView(
                      child: InkWell(
                        onTap: () async {
                          await PermissionHandler().openAppSettings();
                          //SystemSetting.goto(SettingTarget.NOTIFICATION);
                        },
                        child: Container(
                          width: DeviceUtil.getDeviceWidth(context),
                          height: DeviceUtil.getDeviceHeight(context),
                          color: Colors.white,
                          padding: EdgeInsets.all(16),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    Language.of(context)
                                        .getText("settings.setting"),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                  padding: EdgeInsets.only(bottom: 8),
                                ),
                                Container(
                                  child: Text(
                                    Language.of(context)
                                        .getText("settings.des_setting"),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w100,
                                        color: Colors.black),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }
}
