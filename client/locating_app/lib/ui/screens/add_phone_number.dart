import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locaing_app/blocs/blocs.dart';
import 'package:locaing_app/res/resources.dart';
import 'package:locaing_app/ui/widgets/widgets.dart';
import 'package:locaing_app/utils/common.dart';
import 'package:locaing_app/utils/utils.dart';

import '../../localizations.dart';

class AddEmailPhoneScreen extends StatefulWidget {
  @override
  _AddEmailPhoneScreenState createState() => _AddEmailPhoneScreenState();
}

class _AddEmailPhoneScreenState extends State<AddEmailPhoneScreen> {
  TextEditingController _email = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  bool hasError = false;String phoneCode;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String errorEmail;  String errorPhoneNumber;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();



  @override
  Widget build(BuildContext context) {
     List<dynamic> argument=ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: BlocConsumer<LoginBloc, BaseState>(
        listener: (context, state) {
          if (state is LoadedState<String>) {}
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
                                      .getText("login_user.add_email"),
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
                                .getText("login_user.des_add_email"),
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
                       argument[1] =="account_does_not_contain_email_and_phone" || argument[1]=="account_does_not_contain_email"?Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: ItemTextField(
                            Icons.mail_outline,
                            "reset_password.email_address",
                            _email,
                            errorText: errorEmail,
                            hideText: false,
                          ),
                        ):Container(),
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: ItemTextField(
                            Icons.mail_outline,
                            "register.phone_number",
                            _phoneNumber,
                            errorText: errorPhoneNumber,
                            hideText: false,
                            isPhoneCode: true,
                            inputType: TextInputType.number,
                            getPhoneCode: (CountryCode code){
                              setState(() {
                                phoneCode=code.dialCode;
                                print(phoneCode);
                              });
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: ItemButton(
                            title: "home.login",
                            onPress: () {
                              String email,phone;int checkNull=0;
                              setState(() {//
                               if(argument[1] =="account_does_not_contain_email_and_phone" || argument[1]=="account_does_not_contain_email"){
                                 if (_email.text.isEmpty) {
                                   errorEmail = "error.not_null";
                                   checkNull=1;
                                 } else {
                                   errorEmail =
                                       Common.validateEmail(_email.text);
                                   email = _email.text;
                                 }
                               }
                                if (_phoneNumber.text.isEmpty) {
                                  errorPhoneNumber = "error.not_null";
                                  checkNull=1;
                                } else {
                                  phone = phoneCode!=null ?phoneCode+_phoneNumber.text :"+84"+_phoneNumber.text;
                                  errorPhoneNumber = null;
                                }
                              });
                          if(checkNull==0){
                            if(argument[0]==true){
                              //login FB
                              if( argument[1] =="account_does_not_contain_email_and_phone" || argument[1]=="account_does_not_contain_email"){
                                BlocProvider.of<LoginBloc>(context).add(LoginFaceBookEvent(isAddEmailOrPhone: true,phone: phone,email: email,token: argument[2]));
                              }
                              else{
                                BlocProvider.of<LoginBloc>(context).add(LoginFaceBookEvent(isAddEmailOrPhone: true,phone: phone,token: argument[2]));
                              }
                            }else{
                              //login GG
                              BlocProvider.of<LoginBloc>(context).add(LoginGoogleEvent(isAddEmailOrPhone: true,phone: phone,token: argument[2]));
                            }
                          }

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
