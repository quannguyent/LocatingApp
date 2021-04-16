import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locaing_app/blocs/blocs.dart';
import 'package:locaing_app/ui/widgets/widgets.dart';
import '../../localizations.dart';

class AlertSettingScreen extends StatefulWidget {
  @override
  _AlertSettingScreenState createState() => _AlertSettingScreenState();
}

class _AlertSettingScreenState extends State<AlertSettingScreen> {
  String rangeValue;
  String unitValue;
  String language;
  List<String> listRanges = ["0", "1", "5", "10", "20", "30", "50"];
  List<String> listUnits = ["Miles", "Km"];
  bool _isShowSelection = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreenMethod(
      title: "settings.range",
      iconBack: true,
      body: BlocBuilder<SettingBloc, SettingState>(
        builder: (context, state) {
          rangeValue = state.range.toString();
          unitValue = state.unit;
          language = state.language;
          return Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 24,
                    ),
                    child: Text(
                      Language.of(context).getText('settings.change_range'),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.width > 360 ? 18 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16, left: 16),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 4, left: 16, right: 16),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          icon: Icon(Icons.arrow_drop_down_outlined),
                          value: rangeValue,
                          iconSize: 24,
                          elevation: 16,
                          onChanged: (String value) {
                            BlocProvider.of<SettingBloc>(context)
                                .add(ChangeRange(range: int.parse(value)));
                          },
                          isExpanded: true,
                          items: listRanges
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value == "0"
                                  ? (language == 'vi' ? "Tắt" : "Disable")
                                  : value + " Km"),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 24,
                    ),
                    child: Text(
                      Language.of(context).getText('settings.change_unit'),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.width > 360 ? 18 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16, left: 16),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 4, left: 16, right: 16),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          icon: Icon(Icons.arrow_drop_down_outlined),
                          value: unitValue,
                          iconSize: 24,
                          elevation: 16,
                          isExpanded: true,
                          onChanged: (String value) {
                            BlocProvider.of<SettingBloc>(context)
                                .add(ChangeUnit(unit: value));
                          },
                          items: listUnits
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

}
