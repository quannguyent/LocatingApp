import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../blocs/blocs.dart';
import '../../data/model/model.dart';
import '../../localizations.dart';
import '../../res/resources.dart';
import '../../utils/utils.dart';
import '../widgets/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../routes.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  String errorUser;
  String errorPassword;
  double radius = 30;
  bool isLoginFb = true;

  Widget logoWidget() {
    return Container(
      width: DeviceUtil.getDeviceWidth(context),
      height: DeviceUtil.getDeviceHeight(context) / 4,
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.only(left: 24, bottom: 24),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.blue.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              Language.of(context).getText("app_name"),
              style: TextStyle(
                // h5 -> headline
                fontWeight: FontWeight.bold,
                fontSize: 32,
                letterSpacing: 0.27,
                color: AppTheme.blue,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 12),
            child: Text(
              Language.of(context).getText("home.welcome_back"),
              style: TextStyle(
                // h5 -> headline
                fontWeight: FontWeight.w500,
                fontSize: 14,
                letterSpacing: 0.27,
                color: AppTheme.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bodyWidget() {
    return Container(
      margin: EdgeInsets.only(top: 60),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40),
                    child: ItemTextField(
                      Icons.perm_identity,
                      "home.username",
                      _username,
                      errorText: errorUser,
                      hideText: false,
                      onChange: () {
                        setState(() {
                          errorUser = null;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40),
                    child: ItemTextField(
                      Icons.lock_outline,
                      "home.password",
                      _password,
                      errorText: errorPassword,
                      hideText: true,
                      onChange: () {
                        setState(() {
                          errorPassword = null;
                        });
                      },
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

  Widget bottomWidget() {
    return Container(
      width: DeviceUtil.getDeviceWidth(context),
      margin: EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 15),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isLoginFb = true;
                      });
                      BlocProvider.of<LoginBloc>(context)
                          .add(LoginFaceBookEvent());
                    },
                    child: Container(
                      child: itemLogin(
                        FontAwesomeIcons.facebook,
                        "Facebook",
                        Color(0xff0984e3),
                      ),
                      margin: EdgeInsets.only(right: 20),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isLoginFb = false;
                    });
                    BlocProvider.of<LoginBloc>(context).add(LoginGoogleEvent());
                  },
                  child: itemLogin(
                    FontAwesomeIcons.google,
                    "Google",
                    Colors.redAccent,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, BaseState>(
      listener: (context, state) {
        if (state is LoadedState<String>) {
          PermissionsService()
              .hasPermission(PermissionGroup.locationAlways)
              .then((value) {
            if (value == true) {
              Navigator.pushNamed(context, Routes.home);
            } else
              Navigator.pushNamed(context, Routes.requireLocationScreen);
          });
        }
        if (state is ErrorState<String>) {
          if (state.data == "account_does_not_contain_phone" ||
              state.data == "account_does_not_contain_email_and_phone") {
            //fb :true, gg:false
            Navigator.pushNamed(context, Routes.addPhoneNumber,
                arguments: [isLoginFb, state.data, state.dataTrash]);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
                color: AppTheme.whiteBlack.withOpacity(0.5),
                width: DeviceUtil.getDeviceWidth(context),
                height: DeviceUtil.getDeviceHeight(context),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: logoWidget(),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 30),
                        child: bodyWidget(),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40, right: 40),
                        child: ItemButton(
                          title: "home.login",
                          onPress: () {
                            String userName = _username.text;
                            String passWord = _password.text;
                            setState(() {
                              if (_username.text.isEmpty) {
                                errorUser = "error.not_null";
                              } else {
                                errorUser = null;
                                //  userName = _username.text;
                              }
                              if (_password.text.isEmpty) {
                                errorPassword = "error.not_null";
                              } else {
                                errorPassword = null;
                                //password = _password.text;
                              }
                            });
                            if (userName.isNotEmpty && passWord.isNotEmpty) {
                              print(_username.text.toString());

                              Navigator.pushNamed(context, Routes.home);

                              BlocProvider.of<LoginBloc>(context).add(
                                LoginPressedEvent(
                                  user: User(
                                    _username.text,
                                    _password.text,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, Routes.resetPasswordScreen);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 0.85 * DeviceUtil.getDeviceWidth(context),
                          child: Text(
                            Language.of(context)
                                .getText("home.forgot_password"),
                            style: TextStyle(
                              // h5 -> headline
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              letterSpacing: 0.27,
                              color: AppTheme.blue,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 0, bottom: 30),
                        child: bottomWidget(),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40, right: 40),
                        child: ItemButton(
                          title: "home.sign_up",
                          onPress: () {
                            Navigator.pushNamed(context, Routes.registerScreen);
                          },
                          color: Color(0xfff0f0f5).withOpacity(0.9),
                          colorText: AppTheme.blue,
                        ),
                      ),
                      BlocConsumer<LoginBloc, BaseState>(
                        listener: (context, state) {
                          if (state is ErrorState<String>) {
                            if (state.data ==
                                    "account_does_not_contain_phone" ||
                                state.data ==
                                    "account_does_not_contain_email_and_phone") {
                            } else {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text(
                                  Language.of(context)
                                      .getText("error." + state.data),
                                ),
                              ));
                            }
                          }
                        },
                        builder: (context, state) {
                          return Container();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              state is LoadingState ? LoadingApp.loading1() : Container(),
            ],
          ),
        );
      },
    );
  }

  Widget itemLogin(IconData image, String title, Color color) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.blue.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          FaIcon(
            image,
            color: color,
            size: 20,
          ),
        ],
      ),
    );
  }
}
