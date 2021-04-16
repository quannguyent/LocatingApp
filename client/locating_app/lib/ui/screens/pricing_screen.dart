import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:locaing_app/localizations.dart';
import 'package:locaing_app/res/colors.dart';
import 'package:locaing_app/res/images.dart';
import 'package:locaing_app/ui/widgets/custom_button.dart';
import 'package:locaing_app/utils/device.dart';

class PricingScreen extends StatefulWidget {
  @override
  _PricingScreenState createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen> {
  bool month = true;
  String moneyPricing = "186.000";
  Widget itemContent(String content) {
    return Container(
      // width: DeviceUtil.getDeviceWidth(context),
      padding: EdgeInsets.only(left: 30, bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: FaIcon(
              FontAwesomeIcons.check,
              size: 14,
              color: AppTheme.white,
            ),
          ),
          Container(
            width: DeviceUtil.getDeviceWidth(context) * 0.8,
            child: Text(
              Language.of(context).getText(content),
              maxLines: 2,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                letterSpacing: 0.18,
                color: AppTheme.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget itemMoney(String money, String time, bool tick) {
    return InkWell(
      onTap: () {
        if (money == "186.000") {
          setState(() {
            month = true;
            moneyPricing = money;
          });
        } else {
          setState(() {
            month = false;
            moneyPricing = money;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: tick == true ? Colors.blue : null,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          money + " đ / " + Language.of(context).getText("pricing.$time"),
          style: TextStyle(
            fontSize: 13,
            color: AppTheme.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //width: DeviceUtil.getDeviceWidth(context),
        height: DeviceUtil.getDeviceHeight(context),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppTheme.deactivatedText
                      ]).createShader(bounds);
                },
                blendMode: BlendMode.darken,
                child: Container(
                  width: DeviceUtil.getDeviceWidth(context),
                  height: DeviceUtil.getDeviceHeight(context),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppImages.INTRO_1),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 10,
              child: Icon(
                Icons.close,
                color: AppTheme.white,
                size: 30,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      Language.of(context).getText("pricing.service_vip"),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                        letterSpacing: 0.4,
                        height: 0.9,
                        color: AppTheme.white,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      itemContent("pricing.add_friend"),
                      itemContent("pricing.alert"),
                      itemContent("pricing.history"),
                      itemContent("pricing.map_3d"),
                      itemContent("pricing.no_ads"),
                    ],
                  ),
                  Column(
                    children: [
                      Divider(
                        color: AppTheme.white,
                        indent: 60,
                        endIndent: 60,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 5),
                        width: DeviceUtil.getDeviceWidth(context) * 0.6,
                        child: Text(
                          Language.of(context).getText("pricing.title") +
                              "$moneyPricing đ / " +
                              Language.of(context).getText("pricing.month"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            // letterSpacing: 0.18,
                            color: AppTheme.white,
                          ),
                        ),
                      ),
                      Divider(
                        color: AppTheme.white,
                        indent: 60,
                        endIndent: 60,
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppTheme.white),
                    ),
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 10,
                      children: [
                        itemMoney("186.000", "month", month),
                        itemMoney("1.600.000", "year", !month),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40),
                    child: ItemButton(
                      title: "pricing.register",
                      color: AppTheme.white,
                      colorText: Colors.blue,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
