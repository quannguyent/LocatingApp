import 'package:flutter/material.dart';
import '../../localizations.dart';
import '../../utils/utils.dart';

class BaseScreenMethod extends StatelessWidget {
  final String title;
  final String titleCity;
  final bool iconMoreMenu;
  final bool iconShare;
  final bool iconSearch;
  final bool iconBack;
  final Widget body;
  bool isShowRefresh=true;
  bool location;
  Function  shareImage;

  BaseScreenMethod({
    Key key,
    this.title,
    this.titleCity,
    this.iconMoreMenu,
    this.iconShare,
    this.iconBack,
    this.body,
    this.iconSearch,
    this.shareImage,
    this.location,
    this.isShowRefresh
  }) : super(key: key);

  Widget getAppBarUI(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            offset: const Offset(0, 1),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(
            //top: MediaQuery.of(context).padding.top,
            left: 8,
            right: 8,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: DeviceUtil.getDeviceWidth(context),
                alignment: Alignment.centerLeft,
                height: AppBar().preferredSize.height,
                child: Container(
                  color: Colors.transparent,
                  child: iconBack != null && iconBack
                      ? InkWell(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_back),
                    ),
                  )
                      : Container(),
                ),
              ),
              Container(
                width: 0.75*DeviceUtil.getDeviceWidth(context),
                alignment: Alignment.center,
                child: Text(
                  title != null
                      ? Language.of(context).getText(title)
                      : titleCity != null
                      ? titleCity
                      : "",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize:  location==null?22:18,
                  ),
                  maxLines: 1,
                ),
              ),
              Container(
                width: DeviceUtil.getDeviceWidth(context),
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    iconSearch != null
                        ? Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(32.0),
                        ),
                        onTap: () {
                          // Navigator.pushNamed(
                          //   context,
                          //   Routes.searchScreen,
                          // );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Icon(Icons.search),
                        ),
                      ),
                    )
                        : Container(),
                    iconShare != null
                        ? Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(32.0),
                        ),
                        onTap: () {
                          shareImage();
                        },
                        child: Container(
                          child: Icon(Icons.share),
                        ),
                      ),
                    )
                        : Container(),
                    iconMoreMenu != null
                        ? Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(32.0),
                        ),
                        onTap: () {},
                        // child: Container(
                        //   child: PopMenu(
                        //     isRefresh: isShowRefresh,
                        //   ),
                        // ),
                      ),
                    )
                        : Container(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
// Widget Text("sds");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          getAppBarUI(context),
          Expanded(
            child: body != null ? Container(
             // padding: const EdgeInsets.only(bottom:30.0),
              child: body,
            ) : Container(),
          ),
        ],
      ),
    );
  }
}
