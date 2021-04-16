import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locaing_app/routes.dart';
import '../../blocs/blocs.dart';
import '../../localizations.dart';
import '../../res/resources.dart';
import '../../utils/utils.dart';
import '../widgets/widgets.dart';

import 'screens.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  @override
  _CreateNewPasswordState createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPasswordScreen> {
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String errorPassWord;
  String errorConfirmPassword;

  @override
  Widget build(BuildContext context) {
    ArgumentVerify argumentVerify = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.white,
      body: BlocConsumer<ForgotPasswordBloc, BaseState>(
        listener: (context, state) {
          if (state is UpdatePasswordSuccess) {
            showDialog(barrierDismissible: false,
                context: context,
                builder: (context) {
                  return DialogWidget(
                    title: "reset_password.update_success",
                    button: "home.login",
                    success: true,
                    ontap: (){
                      Navigator.pushReplacementNamed(context, Routes.login);
                    },
                  );
                });
            // _scaffoldKey.currentState.showSnackBar(
            //   new SnackBar(
            //     content: new Text(
            //       "cap nhat mat khau thanh cong",
            //     ),
            //   ),
            // );
          }
          if (state is ErrorState<String>) {
            showDialog(
                context: context,
                builder: (context) {
                  return DialogWidget(
                    title: "error."+state.data,
                    button: "oK",
                  );
                });
            // _scaffoldKey.currentState.showSnackBar(
            //   new SnackBar(
            //     content: new Text(
            //       Language.of(context).getText("error." + state.data),
            //     ),
            //   ),
            // );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Container(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            Language.of(context).getText("register.back"),
                            style: TextStyle(
                              // h5 -> headline
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              letterSpacing: 0.27,
                              color: AppTheme.darkerText.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: DeviceUtil.getDeviceWidth(context),
                    margin: EdgeInsets.only(top: 25),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: RichText(
                      // textAlign: TextAlign.center,
                      text: TextSpan(
                        children: <TextSpan>[
                          new TextSpan(
                            text: Language.of(context)
                                .getText("reset_password.create_new_pass"),
                            style: TextStyle(
                              // h5 -> headline
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              letterSpacing: 0.27,
                              // height: 1.8,
                              color: AppTheme.darkerText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    // color: Colors.blue,
                    // margin: EdgeInsets.only(right: 20),
                    padding: EdgeInsets.only(
                        left: 20, right: 60, top: 10, bottom: 40),
                    child: Text(
                      Language.of(context)
                          .getText("reset_password.des_create_new_pass"),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        // h5 -> headline
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        letterSpacing: 0.27,
                        height: 1.4,
                        color: AppTheme.darkerText.withOpacity(0.7),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: ItemTextField(
                      Icons.lock_outline,
                      "register.password",
                      password,
                      errorText: errorPassWord,
                      hideText: true,
                      onChange: () {
                        setState(() {
                          errorPassWord = null;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: ItemTextField(
                      Icons.lock_outline,
                      "register.confirm_password",
                      confirmPassword,
                      errorText: errorConfirmPassword,
                      hideText: true,
                      onChange: () {
                        setState(() {
                          errorPassWord = null;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: ItemButton(
                      title: "reset_password.reset_password",
                      onPress: () {
                        setState(() {
                          if (password.text.isEmpty) {
                            errorPassWord = "error.not_null";
                          } else {
                            errorPassWord = null;
                          }
                          if (confirmPassword.text.isEmpty) {
                            errorConfirmPassword = "error.not_null";
                          } else {
                            errorConfirmPassword = null;
                          }

                          if (password.text != confirmPassword.text) {
                            errorConfirmPassword = "error.password_error";
                          }
                          if (password.text == confirmPassword.text) {
                            BlocProvider.of<ForgotPasswordBloc>(context).add(
                              UpdatePassword(
                                argumentVerify.email,
                                password.text,
                                confirmPassword.text,
                                argumentVerify.code,
                              ),
                            );
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}