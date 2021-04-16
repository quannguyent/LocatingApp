import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/blocs.dart';
import '../../localizations.dart';
import '../../res/resources.dart';
import '../../routes.dart';
import '../../utils/utils.dart';
import '../widgets/widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController textEditingController = TextEditingController();
  bool hasError = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String errorEmail;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: BlocConsumer<ForgotPasswordBloc, BaseState>(
        listener: (context, state) {
          if (state is LoadedState<String>) {
            Navigator.pushNamed(
              context,
              Routes.verifyCodeResetPasswordScreen,
              arguments: state.data,
            );
          }
          if (state is ErrorState<String>) {
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
            key: _scaffoldKey,
            body: Stack(
              children: [
                SingleChildScrollView(
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
                                      .getText("reset_password.reset_password"),
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
                                .getText("reset_password.des_reset_password"),
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
                            Icons.mail_outline,
                            "reset_password.email_address",
                            textEditingController,
                            errorText: errorEmail,
                            checkInvalid: (value) {
                              return EmailValidator.validate(value)
                                  ? null
                                  : "example@gmail.com";
                            },
                            hideText: false,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 0),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: ItemButton(
                            title: "reset_password.send_code",
                            onPress: () {
                              BlocProvider.of<ForgotPasswordBloc>(context).add(
                                  TypeEmailEvent(textEditingController.text));
                            },
                          ),
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
}