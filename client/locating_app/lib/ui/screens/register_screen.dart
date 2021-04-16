import 'package:email_validator/email_validator.dart';
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
  TextEditingController _firstName = new TextEditingController();
  TextEditingController _lastName = new TextEditingController();
  TextEditingController _confirmPassword = new TextEditingController();
  String errorUserName;
  String errorEmail;
  String errorFirstName;
  String errorLastName;
  String errorPhone;
  String errorPassWord;
  String errorConfirmPassword;
  double radius = 30;

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
              Language.of(context).getText("register.let_start"),
              style: TextStyle(
                // h5 -> headline
                fontWeight: FontWeight.bold,
                fontSize: 30,
                letterSpacing: 0.27,
                color: AppTheme.blue,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 12),
            child: Text(
              Language.of(context).getText("register.create_account"),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40),
                    child: ItemTextField(
                      Icons.mail_outline,
                      "register.email",
                      _email,
                      errorText: errorEmail,
                      hideText: false,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40),
                    //color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: ItemTextField(
                            Icons.perm_contact_calendar_outlined,
                            "register.first_name",
                            _firstName,
                            errorText: errorFirstName,
                            hideText: false,
                            width: DeviceUtil.getDeviceWidth(context) / 2 - 50,
                            widthTextInput: 110,
                          ),
                          // margin: EdgeInsets.only(right: 10),
                        ),
                        Container(
                          //margin: EdgeInsets.only(right: 30),
                          child: ItemTextField(
                            Icons.perm_contact_calendar_outlined,
                            "register.last_name",
                            _lastName,
                            errorText: errorLastName,
                            hideText: false,
                            width: DeviceUtil.getDeviceWidth(context) / 2 - 50,
                            widthTextInput: 110,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40),
                    child: ItemTextField(
                      Icons.perm_identity,
                      "register.user_name",
                      _username,
                      errorText: errorUserName,
                      hideText: false,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40),
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
                    margin: EdgeInsets.only(left: 40, right: 40),
                    child: ItemTextField(
                      Icons.lock_outline,
                      "register.password",
                      _password,
                      errorText: errorPassWord,
                      hideText: true,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40),
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
      margin: EdgeInsets.only(bottom: 10),
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
                      BlocProvider.of<LoginBloc>(context).add(LoginFaceBookEvent());
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
          Container(
            margin: EdgeInsets.only(top: 40),
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
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, BaseState>(
      listener: (context, state) {
        if (state is LoadedState<UserRegister>) {
          Navigator.pushNamed(context, Routes.verifyCodeScreen,
              arguments: state.data,);
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
                        margin: EdgeInsets.only(bottom: 20),
                        child: bodyWidget(),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40, right: 40),
                        child: ItemButton(
                          title: "register.create",
                          onPress: () {
                            String userName = "",
                                email = "",
                                password = "",
                                confirmPassword = "",
                                lastName = "",
                                firstName = "",phone="";
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
                              if (_lastName.text.isEmpty) {
                                errorLastName = "error.not_null";
                              } else {
                                errorLastName = null;
                                lastName = _lastName.text;
                              }
                              if (_firstName.text.isEmpty) {
                                errorFirstName = "error.not_null";
                              } else {
                                errorFirstName = null;
                                firstName = _firstName.text;
                              }

                              if (_password.text != _confirmPassword.text) {
                                errorConfirmPassword = "error.password_error";
                              }
                              if (userName.isNotEmpty &&
                                  firstName.isNotEmpty &&
                                  lastName.isNotEmpty &&
                                  email.isNotEmpty &&
                                  EmailValidator.validate(email) == true &&
                                  password.isNotEmpty &&
                                  password == confirmPassword &&
                                  confirmPassword.isNotEmpty) {
                                UserRegister user = new UserRegister(
                                  userName,
                                  email,
                                  password,
                                  firstName,
                                  lastName,
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
                        margin: EdgeInsets.only(top: 20),
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
