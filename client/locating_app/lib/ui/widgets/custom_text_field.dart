import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import '../../localizations.dart';
import '../../res/resources.dart';
import '../../utils/utils.dart';

class ItemTextField extends StatefulWidget {
  IconData icon;
  String labelText;
  TextEditingController controller;
  TextInputType inputType;
  String errorText;
  Function checkInvalid;
  bool hideText;
  double width;
  double widthTextInput;
  bool enableTap = true;
  Function onChange;
  bool isPhoneCode;
  Function getPhoneCode;
  ItemTextField(
    this.icon,
    this.labelText,
    this.controller, {
    this.inputType,
    this.errorText,
    this.checkInvalid,
    this.hideText,
    this.width,
    this.widthTextInput,
    this.enableTap,
    this.onChange,
    this.isPhoneCode,
        this.getPhoneCode,
  });

  @override
  _ItemTextFieldState createState() => _ItemTextFieldState();
}

class _ItemTextFieldState extends State<ItemTextField> {
  // String errorText=widget.errorText;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width == null
          ? DeviceUtil.getDeviceWidth(context)
          : widget.width,
      // margin: EdgeInsets.only(bottom: 10),
      child: Form(
        autovalidate: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 8, left: 22),
              child: Text(
                Language.of(context).getText(widget.labelText),
                style: TextStyle(
                  // subtitle2 -> subtitle
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  letterSpacing: -0.04,
                  color: AppTheme.deactivatedText,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              padding: EdgeInsets.only(left: 22),
              height: 55,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppTheme.buildLightTheme().backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                // border: Border.all(color: Colors.blue.withOpacity(0.8), width: 1),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppTheme.blue.withOpacity(0.5),
                    blurRadius: 2,
                    offset: Offset(1, 1),
                  )
                ],
              ),
              child: Row(
                children: <Widget>[
                  Container(
                      child: widget.isPhoneCode == null
                          ? Icon(
                              widget.icon,
                              color: AppTheme.blue,
                              size: 20,
                            )
                          : Container(
                              margin: EdgeInsets.only(left: 2),
                              width: 50,
                              child: CountryListPick(
                                pickerBuilder:
                                    (context, CountryCode countryCode) {
                                  return Column(
                                    children: [
                                      Flexible(
                                        fit: FlexFit.tight,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                countryCode.flagUri,
                                                package: 'country_list_pick',
                                                width: 20,
                                                height: 20,
                                              ),
                                              Container(
                                                child: Text(countryCode.dialCode),
                                                margin: EdgeInsets.only(left: 6),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                // To disable option set to false
                                theme: CountryTheme(
                                  isShowFlag: true,
                                  isShowCode: true,
                                  isDownIcon: true,
                                ),
                                // Set default value
                                initialSelection: '+84',
                                onChanged: widget.getPhoneCode,
                                // onChanged: (CountryCode code) {
                                //
                                // },
                              ),
                            )),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: widget.widthTextInput == null
                          ? 250
                          : widget.widthTextInput,
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: TextFormField(
                        enabled:
                            widget.enableTap == null ? true : widget.enableTap,
                        keyboardType: widget.inputType,
                        controller: widget.controller,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        maxLines: 1,
                        cursorColor: AppTheme.buildLightTheme().primaryColor,
                        decoration: InputDecoration(
                          hintText: widget.controller.text.isEmpty
                              ? Language.of(context).getText(
                                  widget.labelText,
                                )
                              : null,
                          hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: AppTheme.deactivatedText.withOpacity(0.6)),
                          border: InputBorder.none,
                          errorText: widget.errorText != null
                              ? Language.of(context).getText(widget.errorText)
                              : null,
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              widget.errorText = null;
                            });
                            widget.onChange();
                          }
                        },
                        validator: widget.checkInvalid,
                        obscureText: widget.hideText,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
