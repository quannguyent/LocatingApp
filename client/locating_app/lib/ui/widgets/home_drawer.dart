import 'dart:ui';

import 'package:background_locator/background_locator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locaing_app/blocs/blocs.dart';
import 'package:locaing_app/data/repository/repository.dart';
import 'package:locaing_app/localizations.dart';
import 'package:locaing_app/res/resources.dart';
import 'package:locaing_app/routes.dart';
import 'package:locaing_app/utils/common.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({
    Key key,
    this.screenIndex,
    this.iconAnimationController,
    this.callBackIndex,
  }) : super(key: key);

  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList> drawerList;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FriendBloc>(context).add(GetListFriend());
  }

  void setDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: Language.of(context).getText('home.home'),
        icon: Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.SETUP_ALERT,
        labelName: Language.of(context).getText('home.setup_notification'),
        icon: Icon(Icons.location_on_outlined),
      ),
      DrawerList(
        index: DrawerIndex.SETTING,
        labelName: Language.of(context).getText('home.setting'),
        icon: Icon(Icons.settings),
      ),
      DrawerList(
        index: DrawerIndex.PRIVACY_FRIENDS,
        labelName: Language.of(context).getText('home.security_friend'),
        icon: Icon(Icons.attribution_outlined),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // setDrawerListArray();
    return Scaffold(
      backgroundColor: AppTheme.notWhite.withOpacity(0.5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Center(
//            width: double.infinity,
//            padding: const EdgeInsets.only(top: 40.0),
            child: Container(
              margin: EdgeInsets.only(top: 40),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return ScaleTransition(
                        scale: AlwaysStoppedAnimation<double>(
                          1.0 - (widget.iconAnimationController.value) * 0.2,
                        ),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation<double>(Tween<double>(
                                begin: 0.0,
                                end: 24.0,
                              )
                                  .animate(
                                    CurvedAnimation(
                                      parent: widget.iconAnimationController,
                                      curve: Curves.fastOutSlowIn,
                                    ),
                                  )
                                  .value /
                              360),
                          // child: Container(
                          //   height: 120,
                          //   width: 120,
                          //   decoration: BoxDecoration(
                          //     shape: BoxShape.circle,
                          //     boxShadow: <BoxShadow>[
                          //       BoxShadow(
                          //         color: AppTheme.grey.withOpacity(0.6),
                          //         //   offset: const Offset(2.0, 4.0),
                          //         blurRadius: 8,
                          //       ),
                          //     ],
                          //   ),
                          //   child: BlocConsumer<ProfileBloc, ProfileState>(
                          //     listener: (context, state) {},
                          //     builder: (context, state) {
                          //       return CircleAvatar(
                          //         backgroundColor: Colors.white,
                          //         backgroundImage:
                          //             state.profileUser.avatar_url == null
                          //                 ? AssetImage(AppImages.LOGO_VIETNAM)
                          //                 : NetworkImage(
                          //                     state.profileUser.avatar_url),
                          //       );
                          //     },
                          //   ),
                          // ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // const SizedBox(
          //   height: 4,
          // ),
          // Divider(
          //   height: 1,
          //   color: AppTheme.grey.withOpacity(0.6),
          // ),
          // Expanded(
          //   flex: 9,
          //   child: ListView.builder(
          //     physics: const BouncingScrollPhysics(),
          //     padding: const EdgeInsets.all(0.0),
          //     itemCount: drawerList.length,
          //     itemBuilder: (BuildContext context, int index) {
          //       return inkwell(drawerList[index]);
          //     },
          //   ),
          // ),
          // Expanded(
          //   flex: 2,
          //   child: Container(
          //     padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          //     child: InkWell(
          //       onTap: () async {
          //         onStop();
          //         Login a = new Login();
          //         a.signOutFacebook();
          //         a.signOutGoogle();
          //         IsolateNameServer.removePortNameMapping("LocatorIsolate");
          //         await BackgroundLocator.updateNotificationText();
          //         await BackgroundLocator.unRegisterLocationUpdate()
          //             .then((value) {
          //           Common.removeToken();
          //           FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
          //           _firebaseMessaging.deleteInstanceID();
          //           Navigator.popUntil(
          //               context, ModalRoute.withName(Routes.login));
          //         });
          //       },
          //       child: Row(
          //         children: <Widget>[
          //           Container(
          //             width: 6.0,
          //             height: 46.0,
          //           ),
          //           const Padding(
          //             padding: EdgeInsets.all(4.0),
          //           ),
          //           Icon(
          //             Icons.wifi_tethering,
          //             color: AppTheme.nearlyBlack,
          //           ),
          //           const Padding(
          //             padding: EdgeInsets.all(4.0),
          //           ),
          //           Text(
          //             Language.of(context).getText("home.logout"),
          //             style: TextStyle(
          //               fontWeight: FontWeight.w500,
          //               fontSize: 16,
          //               color: AppTheme.nearlyBlack,
          //             ),
          //             textAlign: TextAlign.left,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  void onStop() async {
    BackgroundLocator.unRegisterLocationUpdate();
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(
                            listData.imageName,
                            color: widget.screenIndex == listData.index
                                ? Colors.blue
                                : AppTheme.nearlyBlack,
                          ),
                        )
                      : Icon(
                          listData.icon.icon,
                          color: widget.screenIndex == listData.index
                              ? Colors.blue
                              : AppTheme.nearlyBlack,
                        ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? Colors.blue
                          : AppTheme.nearlyBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                          (MediaQuery.of(context).size.width * 0.75 - 64) *
                              (1.0 -
                                  widget.iconAnimationController.value -
                                  1.0),
                          0.0,
                          0.0,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex(indexScreen);
  }
}

enum DrawerIndex {
  HOME,
  SETUP_ALERT,
  SETTING,
  PRIVACY_FRIENDS,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;
}
