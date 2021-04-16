import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locaing_app/blocs/blocs.dart';
import 'package:locaing_app/res/resources.dart';
import 'package:locaing_app/ui/widgets/widgets.dart';
import 'package:locaing_app/utils/utils.dart';
import '../../localizations.dart';

class MapSettingScreen extends StatelessWidget {
  Widget itemSetting(String title, String description, BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: <Widget>[
          Container(
            width: DeviceUtil.getDeviceWidth(context),
            child: Padding(
              padding: const EdgeInsets.only(
                top: AppDimens.SIZE_15,
                left: AppDimens.SIZE_15,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Language.of(context).getText(title),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimens.SIZE_20,
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
    return Scaffold(
      body: BaseScreenMethod(
        iconBack: true,
        title: "settings.maps",
        body: Container(
          margin: EdgeInsets.only(top: 8, left: 8, bottom: 8),
          width: DeviceUtil.getDeviceWidth(context),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8),
                child: itemSetting(
                  "settings.map_type",
                  "settings.map_type_description",
                  context,
                ),
              ),
              ChangeMapTypeWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeMapTypeWidget extends StatefulWidget {
  final List<String> ds = ['normal', 'satellite', 'terrain'];

  ChangeMapTypeWidget();

  @override
  _ChangeMapTypeWidgetState createState() => _ChangeMapTypeWidgetState();
}

class _ChangeMapTypeWidgetState extends State<ChangeMapTypeWidget> {
  String value1 = "";
  getType(String mapType, String language) async {
    value1 = language == "vi"
        ? mapType.toLowerCase()
        : Language.of(context)
        .getText("settings." + mapType.toLowerCase().toString())
        .toLowerCase();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
        String mapType = state.mapType;
        String language = state.language;
        getType(mapType, language);
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min, // dua coloum ve min height
            children: List.generate(widget.ds.length, (index) {
              return Container(
                child: Row(
                  children: <Widget>[
                    Radio(
                      activeColor: AppTheme.nearlyRed,
                      value: widget.ds[index].toString(),
                      groupValue: value1,
                      onChanged: (String value) {
                        if (value != value1) {
                          String type = value.replaceRange(
                              0, 1, widget.ds[index][0].toUpperCase());
                          BlocProvider.of<SettingBloc>(context)
                              .add(ChangeMapType(type));
                        }
                      },
                    ),
                    Text(
                      Language.of(context).getText("settings." + widget.ds[index]),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        letterSpacing: 0.27,
                        color: AppTheme.grey,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }
}