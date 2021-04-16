import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locaing_app/blocs/blocs.dart';
import 'package:locaing_app/res/images.dart';
import 'package:locaing_app/ui/widgets/widgets.dart';
import '../../localizations.dart';

class LanguageSettingScreen extends StatefulWidget {
  @override
  _LanguageSettingScreenState createState() => _LanguageSettingScreenState();
}

class _LanguageSettingScreenState extends State<LanguageSettingScreen> {
  bool _isShowSelection = false;
  List<Item> listLanguage = [];
  Future getLanguage1(String language) async {
    listLanguage = [
      new Item(
          "Vietnam",
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(AppImages.ICON_LOGO_VIETNAM),
          ),
          "vi",
          language == "vi" ? true : false),
      new Item(
          "English",
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/england.png"),
          ),
          "en",
          language == "en" ? true : false),
    ];
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
        getLanguage1(state.language);
        return BaseScreenMethod(
          iconBack: true,
          title: "settings.change_language",
          body: Column(
            children: <Widget>[
              CustomCard(
                margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                padding:
                EdgeInsets.only(left: 18, right: 18, top: 18, bottom: 18),
                child: _isShowSelection == false
                    ? titleLanguage()
                    : Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: titleLanguage(),
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Column(
                      children:
                      List.generate(listLanguage.length, (index) {
                        return dropDownItem(listLanguage[index]);
                      }),
                    ),
                  ],
                ),
              ),
              Container(),
            ],
          ),
        );
      },
    );
  }

  Widget dropDownItem(Item item) {
    return InkWell(
      onTap: () async {
        BlocProvider.of<SettingBloc>(context)
            .add(ChangeLanguageSetting(item.shortName));
      },
      child: Container(
        margin: EdgeInsets.only(top: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 24,
                      height: 24,
                      margin: EdgeInsets.only(
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: item.icon,
                      ),
                    ),
                    Container(
                      child: Center(
                        //margin: EdgeInsets.only(right: 10,bottom: 10),
                        child: Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: item.isCheck ? Icon(Icons.check) : Container(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget titleLanguage() {
    return InkWell(
      onTap: () {
        setState(() {
          _isShowSelection = !_isShowSelection;
        });
      },
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Container(
              child: Text(
                Language.of(context).getText("settings.select_language"),
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Icon(Icons.keyboard_arrow_down),
          ),
        ],
      ),
    );
  }
}

class Item {
  final String name;
  final CircleAvatar icon;
  bool isCheck;
  String shortName;
  Item(this.name, this.icon, this.shortName, this.isCheck);
}
