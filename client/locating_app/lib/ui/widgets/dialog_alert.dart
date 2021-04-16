import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:locaing_app/localizations.dart';

class DialogWidget extends StatelessWidget {
  final String title, content, button;
  bool success;
  final GestureTapCallback positiveBtnPressed;
  Function ontap;
  DialogWidget({
    @required this.title,
    @required this.content,
    @required this.button,
    @required this.positiveBtnPressed,
    this.success,
    this.ontap,
  });

  Widget _buildDialogContent(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          // Bottom rectangular box
          margin:
              EdgeInsets.only(top: 40), // to push the box half way below circle
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: button != null ? 20 : 40), // spacing inside the box
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                Language.of(context).getText(title),
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: 16,
              ),
              content != null
                  ? Text(
                      Language.of(context).getText(content),
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.center,
                    )
                  : Container(),
              button != null
                  ? InkWell(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10,top: 20),
                        child: Text(
                          Language.of(context).getText(button),
                          style: TextStyle(fontSize: 16, color: Colors.blue,fontWeight: FontWeight.w500),
                        ),
                      ),
                      onTap: ontap,
                    )
                  : Container(),
            ],
          ),
        ),
        CircleAvatar(
          backgroundColor: success != null ? Colors.green : Colors.redAccent,
          maxRadius: 35.0,
          child: FaIcon(
            success != null
                ? FontAwesomeIcons.checkCircle
                : FontAwesomeIcons.exclamation,
            color: Colors.white,
            size: 40,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }
}
