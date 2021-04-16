import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locaing_app/blocs/call_for_help_bloc.dart';
import 'package:shake/shake.dart';
import 'package:flutter/material.dart';
import '../../localizations.dart';
import '../../res/resources.dart';
import '../widgets/widgets.dart';

class AlertScreen extends StatefulWidget {
  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  int countDown = 10;
  Timer _timer;
  void startCountDownTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (countDown == 0) {
          BlocProvider.of<CallHelpBloc>(context).add(CallForHelp());
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            countDown--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startCountDownTimer();
    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
      // Do stuff on phone shake
      BlocProvider.of<CallHelpBloc>(context).add(CallForHelp());
      _timer.cancel();
      print("lac");
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CallHelpBloc,CallHelpState>(
      listener: (context, state) {
        if(state is PostCallHelpState){
          if(state.success!=null){
            showDialog(
                barrierDismissible: true,
                context: context,
                builder: (context) {
                  return DialogWidget(
                    title:state.success,
                    success: true,
                  );
                });
          }
          if(state.error!=null){
            showDialog(
                barrierDismissible: true,
                context: context,
                builder: (context) {
                  return DialogWidget(
                    title: state.error,
                  );
                });
          }
        }
      },
      builder: (context, state) {
        return BaseScreenMethod(
          title: "alert.alert",
          iconBack: true,
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      Language.of(context).getText("alert.send_alert"),
                      style: TextStyle(
                        // h6 -> title
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 0.18,
                        color: AppTheme.darkText,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      Language.of(context).getText("alert.des_alert"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        // h6 -> title
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        letterSpacing: 0.18,
                        color: AppTheme.darkText,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      countDown.toString(),
                      style: TextStyle(
                        // h6 -> title
                        fontWeight: FontWeight.normal,
                        fontSize: 100,
                        letterSpacing: 0.18,
                        color: AppTheme.nealyRed,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(left: 40, right: 40, bottom: 20),
                    child: ItemButton(
                      title: "alert.close",
                      onPress: () {
                        _timer.cancel();
                        Navigator.pop(context);
                      },
                      color: Color(0xfff0f0f5).withOpacity(0.9),
                      colorText: AppTheme.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

