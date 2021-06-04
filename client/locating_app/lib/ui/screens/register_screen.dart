import 'package:email_validator/email_validator.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:locaing_app/utils/common.dart';
import '../../blocs/blocs.dart';
import '../../data/network/repuest/user_register.dart';
import '../../localizations.dart';
import '../../res/resources.dart';
import '../../utils/utils.dart';
import '../widgets/widgets.dart';
import '../../routes.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RegisterWidget();
  }
}

class RegisterWidget extends StatefulWidget {
  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _username = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _displayName = new TextEditingController();
  TextEditingController _confirmPassword = new TextEditingController();
  String errorUserName;
  String errorEmail;
  String errorDisplayName;
  String errorPhone;
  String errorPassWord;
  String errorConfirmPassword;
  double radius = 30;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget logoWidget() {
    return Container(
      width: DeviceUtil.getDeviceWidth(context),
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.all(24),
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
      margin: EdgeInsets.only(top: 20),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                //   Container(
                //     margin: EdgeInsets.only(left: 24, right: 24, bottom: 20),
                //     child: 
                //       TextFormField(
                //         style: TextStyle(
                //           fontSize: 18,
                //         ),
                //         cursorColor: AppTheme.buildLightTheme().primaryColor,
                //         decoration: InputDecoration(
                //           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                //           prefixIcon: Padding(
                //             child: Icon(Icons.mail_outline, size: 24, color: errorEmail == null ? AppTheme.blue : AppTheme.red),
                //             padding: const EdgeInsetsDirectional.only(start: 16, end: 12)
                //           ),
                //           hintText: _email.text.isEmpty
                //              Language.of(context).getText(
                //                 "register.email"
                //               )
                //             : null,
                //           hintStyle: TextStyle(
                //             fontSize: 16,
                //             fontWeight: FontWeight.w300,
                //             color: AppTheme.deactivatedText.withOpacity(0.6)),
                //           errorText: errorEmail != null ? Language.of(context).getText(errorEmail) : null,
                //           border: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(30),
                //             borderSide: BorderSide(
                //                 width: 0, 
                //                 style: BorderStyle.none,
                //             ),
                //           ),
                //           filled: true,
                //           fillColor: AppTheme.white,
                //         ),
                //         controller: _email,
                //         onChanged: (value) {
                //           if (value.isNotEmpty) {
                //             setState(() {
                //               errorEmail = null;
                //             });
                //           }
                //         },
                //       ),
                //     ),
                  Container(
                    margin: EdgeInsets.only(left: 24, right: 24),
                    child: ItemTextField(
                      Icons.mail_outline,
                      "register.email",
                      _email,
                      errorText: errorEmail,
                      hideText: false,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 24, right: 24),
                    child: ItemTextField(
                      Icons.perm_identity,
                      "register.display_name",
                      _displayName,
                      errorText: errorDisplayName,
                      hideText: false,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 24, right: 24),
                    child: ItemTextField(
                      Icons.perm_identity,
                      "register.user_name",
                      _username,
                      errorText: errorUserName,
                      hideText: false,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 24, right: 24),
                    child: ItemTextField(
                      Icons.call,
                      "register.phone_number",
                      _phone,
                      errorText: errorPhone,
                      hideText: false,
                      inputType: TextInputType.number,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 24, right: 24),
                    child: ItemTextField(
                      Icons.lock_outline,
                      "register.password",
                      _password,
                      errorText: errorPassWord,
                      hideText: true,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 24, right: 24),
                    child: ItemTextField(
                      Icons.lock_outline,
                      "register.confirm_password",
                      _confirmPassword,
                      errorText: errorConfirmPassword,
                      hideText: true,
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
      margin: EdgeInsets.only(bottom: 10, top: 24),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(Language.of(context).getText("register.have_an_account")),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              Language.of(context).getText("home.login"),
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: BlocConsumer<RegisterBloc, BaseState>(
      listener: (context, state) {
        if (state is LoadedState<UserRegister>) {
          _scaffoldKey.currentState.showSnackBar(
            new SnackBar(
              content: new Text(
                Language.of(context).getText("success.register"),
              ),
            ),
          );

          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushNamed(context, Routes.login);
          });
        } else if (state is ErrorState<String>) {
            _scaffoldKey.currentState.showSnackBar(
              new SnackBar(
                content: new Text(
                  Language.of(context).getText("error." + state.data),
                ),
              ),
            );
          }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
                color: AppTheme.whiteBlack,
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
                        margin: EdgeInsets.only(bottom: 8),
                        child: bodyWidget(),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 24, right: 24),
                        child: ItemButton(
                          title: "register.create",
                          onPress: () {
                            String userName = "",
                              email = "",
                              password = "",
                              confirmPassword = "",
                              displayName = "",
                              phone="";

                            setState(() {
                              if (_username.text.isEmpty) {
                                errorUserName = "error.not_null";
                              } else {
                                errorUserName = null;
                                userName = _username.text;
                              }
                              if (_password.text.isEmpty) {
                                errorPassWord = "error.not_null";
                              } else {
                                errorPassWord = null;
                                password = _password.text;
                              }
                              if (_phone.text.isEmpty) {
                                errorPhone = "error.not_null";
                              } else {
                                errorPassWord = null;
                                phone = _phone.text;
                              }
                              if (_confirmPassword.text.isEmpty) {
                                errorConfirmPassword = "error.not_null";
                              } else {
                                errorConfirmPassword = null;
                                confirmPassword = _confirmPassword.text;
                              }
                              if (_email.text.isEmpty) {
                                errorEmail = "error.not_null";
                              } else {
                                errorEmail = Common.validateEmail(_email.text);
                                email = _email.text;
                              }
                              if (_displayName.text.isEmpty) {
                                errorDisplayName = "error.not_null";
                              } else {
                                errorDisplayName = null;
                                displayName = _displayName.text;
                              }

                              if (_password.text != _confirmPassword.text) {
                                errorConfirmPassword = "error.password_error";
                              }
                              if (userName.isNotEmpty &&
                                  displayName.isNotEmpty &&
                                  email.isNotEmpty &&
                                  EmailValidator.validate(email) == true &&
                                  password.isNotEmpty &&
                                  password == confirmPassword &&
                                  confirmPassword.isNotEmpty) {
                                UserRegister user = new UserRegister(
                                  userName,
                                  email,
                                  password,
                                  displayName,
                                  phone,
                                );
                                BlocProvider.of<RegisterBloc>(context).add(
                                  RegisterEvent(user),
                                );
                              }
                            });
                          },
                        ),
                      ),
                      Container(
                        child: bottomWidget(),
                      ),
                      BlocConsumer<RegisterBloc, BaseState>(
                        listener: (context, state) {
                          if (state is ErrorState<String>) {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(Language.of(context)
                                    .getText("error." + state.data)),
                              ),
                            );
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
      ),
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
