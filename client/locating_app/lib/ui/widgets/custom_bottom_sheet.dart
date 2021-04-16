import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locaing_app/blocs/blocs.dart';
import 'package:locaing_app/data/model/model.dart';
import 'package:locaing_app/data/network/network.dart';
import 'package:locaing_app/data/repository/repository.dart';
import 'package:locaing_app/localizations.dart';
import 'package:locaing_app/res/colors.dart';
import 'package:locaing_app/res/images.dart';
import 'package:locaing_app/routes.dart';
import 'package:locaing_app/utils/common.dart';
import 'package:locaing_app/utils/device.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart';

class CustomBottomSheet extends StatefulWidget {
  String nameUser, location, linkLocation, linkImage;
  bool isMe;
  Function copyText;
  CustomBottomSheet(
      {this.nameUser,
      this.location,
      this.linkLocation,
      this.linkImage,
      this.isMe,
      this.copyText});

  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  String addressCurrent;

  Future<String> getAddressMeCurrent() async {
    LatLng myLocation;
    myLocation = await Common.getCoordinates();
    final coordinates =
        new Coordinates(myLocation.latitude, myLocation.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      addressCurrent = first.addressLine;
    });
    return addressCurrent;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddressMeCurrent();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: Wrap(
            children: [
              Container(
                padding:
                    EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppTheme.white,
                                  backgroundImage: widget.linkImage == null
                                      ? AssetImage(AppImages.DEFAULT_AVATAR)
                                      : NetworkImage(widget.linkImage),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5, top: 5),
                                  child: Text(
                                    widget.nameUser,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      letterSpacing: 0.18,
                                      color: AppTheme.darkText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Wrap(
                              direction: Axis.horizontal,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(
                                      left: 6, top: 4, bottom: 4, right: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.yellowRed,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      bottomLeft: Radius.circular(30),
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.historyUserScreen,
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.history,
                                          color: AppTheme.white,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 2),
                                          child: Text(
                                            Language.of(context).getText(
                                                "profile_user.history"),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              letterSpacing: 0.2,
                                              color: AppTheme.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 4),
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(
                                      left: 4, top: 4, bottom: 4, right: 6),
                                  decoration: BoxDecoration(
                                    color: AppTheme.green,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      bottomRight: Radius.circular(30),
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, Routes.profileScreen);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.account_circle_outlined,
                                          color: AppTheme.white,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 2),
                                          child: Text(
                                            Language.of(context).getText(
                                                "profile_user.profile"),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              letterSpacing: 0.2,
                                              color: AppTheme.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      width: DeviceUtil.getDeviceWidth(context),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 7, top: 15),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              child: Icon(
                                Icons.location_on_outlined,
                                color: AppTheme.nearlyBlue,
                              ),
                              margin: EdgeInsets.only(right: 10),
                            ),
                            Text(
                              widget.isMe == null
                                  ? widget.location
                                  : addressCurrent == null
                                      ? " "
                                      : addressCurrent,
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 12,
                                letterSpacing: 0.2,
                                color: AppTheme.darkText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 7, top: 10),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Container(
                                child: Icon(
                                  Icons.link,
                                  color: AppTheme.nearlyBlue,
                                ),
                                margin: EdgeInsets.only(right: 10),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 10),
                                width: DeviceUtil.getDeviceWidth(context) - 110,
                                child: Text(
                                  state.hashLinkLocation != null
                                      ? "http://" + state.hashLinkLocation
                                      : "",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontSize: 12,
                                    letterSpacing: 0.2,
                                    color: AppTheme.darkText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              widget.copyText();
                            },
                            child: Container(
                              child: Icon(
                                Icons.file_copy_outlined,
                                size: 20,
                                color: AppTheme.nearlyBlue,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}

class CustomBottomSheetFriend extends StatelessWidget {
  String nameUser, location, linkLocation, linkImage;
  ProfileUserModel user;
  int isCloseFriend;
  CustomBottomSheetFriend({
    this.nameUser,
    this.location,
    this.linkLocation,
    this.linkImage,
    this.isCloseFriend,
    this.user,
  });

  Widget itemIcon(
      String title, IconData icon, BuildContext context, Function onPress,
      {bool border}) {
    return InkWell(
      onTap: () {
        onPress();
      },
      child: Container(
        margin: EdgeInsets.only(right: 2),
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
            border: border == null
                ? Border(
                    right: BorderSide(
                        color: Colors.black, width: border == null ? 0.1 : 0),
                  )
                : null),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          direction: Axis.vertical,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 2),
              child: Icon(
                icon,
                color: Colors.blue,
                size: 20,
              ),
            ),
            Container(
              child: Text(Language.of(context).getText(title),
                  style: TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 10,
                    letterSpacing: 0.2,
                    color: AppTheme.darkText,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void directFriend(ProfileUserModel friend) async {
    LogLocationModel log =
        await LogLocationRepository().getLastLogLocation(user.uuid);
    if (log != null) {
      final availableMaps = await MapLauncher.installedMaps;
      await availableMaps.first.showMarker(
        coords: Coords(log.lat, log.lng),
        title: "Go to friend",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        alignment: WrapAlignment.end,
        children: [
          Container(
            // padding: EdgeInsets.all(4),
            margin: EdgeInsets.only(bottom: 18, right: 18),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Wrap(
              direction: Axis.horizontal,
              children: [
                itemIcon("home.chat", Icons.chat, context, () {
                  Navigator.pushNamed(
                    context,
                    Routes.chatScreen,
                    arguments: user,
                  );
                }),
                itemIcon(
                    "home.follow", Icons.follow_the_signs_outlined, context,
                    () {
                  Navigator.pushNamed(
                    context,
                    Routes.listPlaceScreen,
                    arguments: user,
                  );
                }),
                itemIcon("profile_user.history", Icons.history, context, () {
                  Navigator.pushNamed(
                    context,
                    Routes.historyUserScreen,
                    arguments: user.uuid,
                  );
                }),
                itemIcon("home.address", Icons.location_on_outlined, context,
                    () {
                  Navigator.pushNamed(
                    context,
                    Routes.registerPlaceScreen,
                    arguments: user.uuid,
                  );
                }),
                itemIcon(
                  "home.direction",
                  Icons.directions,
                  context,
                  () {
                    directFriend(user);
                  },
                  border: false,
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: AppTheme.white,
                              backgroundImage: linkImage == null
                                  ? AssetImage(AppImages.DEFAULT_AVATAR)
                                  : NetworkImage(linkImage),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5, top: 5),
                              child: Text(
                                nameUser,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  letterSpacing: 0.18,
                                  color: AppTheme.darkText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  width: DeviceUtil.getDeviceWidth(context),
                ),
                Container(
                  margin: EdgeInsets.only(left: 7, top: 15),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.location_on_outlined,
                            color: AppTheme.nearlyBlue,
                          ),
                          margin: EdgeInsets.only(right: 10),
                        ),
                        Text(
                          "30 Trieu Khuc Ha Dong Ha Noi",
                          style: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 12,
                            letterSpacing: 0.2,
                            color: AppTheme.darkText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 7, top: 15),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.star,
                            color:
                                isCloseFriend == 1 ? AppTheme.yellowRed : null,
                          ),
                          margin: EdgeInsets.only(right: 10),
                        ),
                        Text(
                          Language.of(context).getText("home.close_friend"),
                          style: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 12,
                            letterSpacing: 0.2,
                            color: AppTheme.darkText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
