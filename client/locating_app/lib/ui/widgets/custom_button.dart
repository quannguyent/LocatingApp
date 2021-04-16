import 'package:flutter/material.dart';
import '../../localizations.dart';
import '../../res/resources.dart';
import '../../utils/utils.dart';

class ItemButton extends StatefulWidget {
  String title;
  Function onPress;
  Color color;
  Color colorText;
  bool boldText;

  ItemButton({this.title, this.onPress, this.color, this.colorText,this.boldText});

  @override
  _ItemButtonState createState() => _ItemButtonState();
}

class _ItemButtonState extends State<ItemButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: DeviceUtil.getDeviceWidth(context),
      margin: EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: widget.onPress,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              // end: Alignment.bottomCenter,
              colors: <Color>[
                widget.color == null
                    ? AppTheme.darkBlue.withOpacity(0.7)
                    : widget.color,
                widget.color == null ? AppTheme.darkBlue : widget.color,
              ],
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(
                30,
              ),
            ),
            border: Border.all(width: 0.5, color: AppTheme.darkBlue),
          ),
          padding: EdgeInsets.all(12),
          width: DeviceUtil.getDeviceWidth(context),
          child: Text(
            Language.of(context).getText(widget.title),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight:widget.boldText!=null ?FontWeight.w600: FontWeight.w500,
              fontSize: 16,
              letterSpacing: 0.18,
              color: widget.colorText == null ? Colors.white : widget.colorText,
            ),
          ),
        ),
      ),
    );
  }
}
