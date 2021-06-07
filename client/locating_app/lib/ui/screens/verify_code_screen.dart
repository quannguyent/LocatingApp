import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../blocs/blocs.dart';
import '../../data/network/repuest/user_register.dart';
import '../../localizations.dart';
import '../../res/resources.dart';
import '../../routes.dart';
import '../../utils/utils.dart';
import '../widgets/widgets.dart';
class VerifyCodeScreen extends StatefulWidget {
  @override
  _VerifyCodeScreenState createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  TextEditingController textEditingController = TextEditingController();
  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    //   errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserRegister userRegister = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.white,
      body: BlocConsumer<RegisterBloc, BaseState>(
        listener: (context, state) {
          if (state is LoadedState<String>) {
            _scaffoldKey.currentState.showSnackBar(
              new SnackBar(
                content: new Text(
                  Language.of(context).getText("register." + state.data),
                ),
              ),
            );
            Navigator.pushNamed(context, Routes.login);
          }
        },
        builder: (context, state) {
          return Container(
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
                  padding: EdgeInsets.only(left: 45, right: 45, bottom: 40),
                  alignment: Alignment.center,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        new TextSpan(
                          text:
                          Language.of(context).getText("register.verify") +
                              "\n",
                          style: TextStyle(
                            // h5 -> headline
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: 0.27,
                            height: 1.2,
                            color: AppTheme.darkerText,
                          ),
                        ),
                        new TextSpan(
                          text: Language.of(context)
                              .getText("register.des_verify"),
                          style: TextStyle(
                            // h5 -> headline
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            letterSpacing: 0.27,
                            height: 1.8,
                            color: AppTheme.darkerText.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  // color: Colors.blue,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: PinCodeTextField(
                    autoFocus: true,
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 6,
                    obscureText: false,
                    obscuringCharacter: '*',
                    animationType: AnimationType.fade,
                    validator: (v) {},
                    pinTheme: PinTheme(
                      selectedColor: AppTheme.deactivatedText
                          .withOpacity(0.5), // mau border
                      disabledColor: Colors.white,
                      selectedFillColor:
                      AppTheme.whiteBlack, // mau khi dang chon
                      activeFillColor: Color(0xffedf3f7), // mau khi da nhap
                      activeColor: Color(0xffedf3f7), // border khi da nhap
                      inactiveColor: AppTheme.deactivatedText
                          .withOpacity(0.5), // mau border khi chua dc chon
                      inactiveFillColor: Colors.white, // mau khi chua dc chon
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10),
                      fieldHeight: 50,
                      fieldWidth: 50,
                    ),
                    cursorColor: Colors.black,
                    animationDuration: Duration(milliseconds: 300),
                    textStyle: TextStyle(fontSize: 20, height: 1.6),
                    backgroundColor: AppTheme.white,
                    enableActiveFill: true,
                    //   errorAnimationController: errorController,
                    controller: textEditingController,
                    keyboardType: TextInputType.number,
                    onCompleted: (v) {
                      print("Completed");
                    },
                    // onTap: () {
                    //   print("Pressed");
                    // },
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      return true;
                    },
                  ),
                ),
                Container(
                  width: DeviceUtil.getDeviceWidth(context),
                  padding: EdgeInsets.only(left: 45, right: 45, top: 40),
                  alignment: Alignment.center,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        new TextSpan(
                          text: Language.of(context)
                              .getText("register.have_not_code") +
                              "\n",
                          style: TextStyle(
                            // h5 -> headline
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            letterSpacing: 0.27,
                            height: 1.4,
                            color: AppTheme.darkerText.withOpacity(0.7),
                          ),
                        ),
                        new TextSpan(
                          text: Language.of(context).getText("register.resend"),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            letterSpacing: 0.27,
                            height: 1.2,
                            color: AppTheme.darkBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: ItemButton(
                    title: "register.verify_button",
                    onPress: () {
                      BlocProvider.of<RegisterBloc>(context).add(VerifyCode(
                          userRegister.email,
                          userRegister.username,
                          currentText));
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}