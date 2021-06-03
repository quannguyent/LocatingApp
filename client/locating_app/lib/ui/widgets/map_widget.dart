import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as locationLib;
import 'package:http/http.dart' as http;
import 'package:wemapgl/wemapgl.dart';
import 'package:locaing_app/blocs/blocs.dart';
import 'package:locaing_app/data/model/model.dart';
import 'package:locaing_app/data/network/network.dart';
import 'package:locaing_app/localizations.dart';
import 'package:locaing_app/res/resources.dart';
import 'package:locaing_app/routes.dart';
import 'package:locaing_app/ui/widgets/custom_bottom_sheet.dart';
import 'package:locaing_app/ui/widgets/widgets.dart';
import 'package:locaing_app/utils/common.dart';
import 'package:locaing_app/utils/utils.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:signalr_core/signalr_core.dart';

class MapWidget extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MapWidget> {
  @override
  // bool get wantKeepAlive => true;
  WeMapController mapController;

  // Completer<GoogleMapController> _controller = Completer();
  // MapType mapType;
  // Set<Marker> _markers = Set();
  static double initZoom = 15.5;
  double _direction;
  // BitmapDescriptor userIcon;
  final DrawMap _drawMap = DrawMap();
  CameraTargetBounds _cameraTargetBounds = CameraTargetBounds.unbounded;
  final double sides = 3.0;
  Uint8List markerIcon;
  Uint8List markerRectangle;
  Uint8List markerImage;
  LatLng _myLocation;
  WeMapPlace place;
  locationLib.Location location;
  locationLib.LocationData currentLocation;
  Timer timer;
  void _onMapCreated(WeMapController controller) {
    mapController = controller;
  }

  final connection = HubConnectionBuilder()
      .withUrl(
          ApiConstant.HUB + ApiConstant.LOCATION,
          HttpConnectionOptions(
            logging: (level, message) => {},
          ))
      .build();
  void sendCurrentLocationLoop() async {
    final uri = Uri.parse(
        "http://112.213.88.49:8088/rpc/locating-app/location-log/create");
  }

  _realTimeTracking() async {
    String userId = await Common.getUserId();

    await connection.start();

    connection.invoke("RegisterFriendLocation", args: [userId]);

    connection.on('ReceiveFriendLocation', (message) {
      //print(message);
      final List<ListLogLocationModel> locations = (message[0]['data'] as List)
          .map((json) => ListLogLocationModel.fromJson(json))
          .toList();
      List<LogLocationModel> locationsLogs = [];
      for (ListLogLocationModel i in locations) {
        locationsLogs.add(i.lastLocationLog);
      }
      final List<ProfileUserModel> profile =
          BlocProvider.of<FriendBloc>(context).state.listFriend;
      BlocProvider.of<TrackingBloc>(context)
          .add(GetTrackingFriend(logs: locationsLogs, profiles: profile));
    });
  }

  cameraFocus() async {
    LatLng currentLocation;
    currentLocation = await Common.getCoordinates();
    mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 270.0,
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          tilt: 30.0,
          zoom: 17.0,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    connection.stop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<SettingBloc>(context).add(RequireLoadSetting());
    location = new locationLib.Location();
    location.onLocationChanged().listen((locationLib.LocationData currentLoc) {
      currentLocation = currentLoc;
    });
    FlutterCompass.events.listen((event) {
      if (mounted) {
        setState(() {
          _direction = event;
        });
      }
    });
    Common.getCoordinates().then((value) {
      // _myLocation = LatLng(value.latitude, value.longitude);
      // _drawMap.drawTriangle(100, 100).then((value) => markerRectangle = value);
      String userName =
          BlocProvider.of<ProfileBloc>(context).state.profileUser.userName;
      String imageUrl =
          BlocProvider.of<ProfileBloc>(context).state.profileUser.avatar_url;
      if (imageUrl != null) {
        _drawMap.loadAvatarUser(imageUrl, 200).then((value) {
          setState(() {
            markerIcon = value;
          });
          _realTimeTracking();
        });
      } else {
        _drawMap.drawCircle(200, 200, userName).then((value) {
          setState(() {
            markerIcon = value;
          });
          _realTimeTracking();
        });
      }
    });
  }

  void showBottomSheetMe() {
    showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (builder) => BlocConsumer<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return CustomBottomSheet(
            cameraFocus: cameraFocus,
            nameUser: state.profileUser.userName,
            linkImage: state.profileUser.avatar_url != null
                ? state.profileUser.avatar_url
                : null,
            isMe: true,
            copyText: () {
              copyText(BlocProvider.of<HomeBloc>(context)
                  .state
                  .hashLinkLocation
                  .toString());
            },
          );
        },
        listener: (context, state) {},
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  void showBottomSheetFriend(ProfileUserModel user) {
    BlocProvider.of<HomeBloc>(context).add(SelectFriend(user: user));
    showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (builder) {
        return BlocConsumer<PlaceBloc, PlaceState>(
          builder: (context, state) {
            return CustomBottomSheetFriend(
              nameUser: user.userName,
              linkImage: user.avatar_url != null ? user.avatar_url : null,
              isCloseFriend: user.friendship,
              user: user,
            );
          },
          listener: (context, state) {},
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: markerIcon != null
          ? BlocBuilder<SettingBloc, SettingState>(
              builder: (context, state) {
                // switch (state.mapType) {
                //   case "Normal":
                //     {
                //       mapType = MapType.normal;
                //       break;
                //     }
                //   case "Satellite":
                //     {
                //       mapType = MapType.satellite;
                //       break;
                //     }
                //   case "Terrain":
                //     {
                //       mapType = MapType.terrain;
                //       break;
                //     }
                // }
                return Stack(
                  children: [
                    BlocConsumer<TrackingBloc, TrackingState>(
                      listener: (context, state) {
                        if (state is TrackingSuccess) {
                          // setState(() {
                          //   _markers.clear();
                          //   _markers = Set.from(state.markers);
                          //   _markers.addAll([
                          //     Marker(
                          //       markerId: MarkerId('marker_user'),
                          //       icon: BitmapDescriptor.fromBytes(markerIcon),
                          //       anchor: Offset(0.5, 0.5),
                          //       position: _myLocation,
                          //     ),
                          //     Marker(
                          //       markerId: MarkerId('marker_rotation'),
                          //       icon:
                          //           BitmapDescriptor.fromBytes(markerRectangle),
                          //       anchor: Offset(0.5, 1.75),
                          //       rotation: _direction,
                          //       position: _myLocation,
                          //     ),
                          //   ]);
                          // });
                        }
                      },
                      builder: (context, trackingState) {
                        // return Container(
                        //   child: GoogleMap(
                        //     markers: _markers,
                        //     mapType: mapType,
                        //     zoomControlsEnabled: false,
                        //     initialCameraPosition: CameraPosition(
                        //       target: _myLocation,
                        //       zoom: initZoom,
                        //     ),
                        //     onMapCreated: (GoogleMapController controller) {
                        //       _controller.complete(controller);
                        //     },
                        //     gestureRecognizers:
                        //         <Factory<OneSequenceGestureRecognizer>>[
                        //       new Factory<OneSequenceGestureRecognizer>(
                        //         () => new EagerGestureRecognizer(),
                        //       ),
                        //     ].toSet(),
                        //   ),
                        // );
                        return Container(
                          child: WeMap(
                            onMapClick: (point, latlng, _place) async {
                              place = await _place;
                            },
                            onPlaceCardClose: () {
                              // print("Place Card closed");
                            },
                            myLocationTrackingMode:
                                MyLocationTrackingMode.Tracking,
                            reverse: true,
                            myLocationEnabled: true,
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: const CameraPosition(
                              target: LatLng(21.036029, 105.782950),
                              zoom: 16.0,
                            ),
                            destinationIcon: "assets/symbols/destination.png",
                          ),
                        );
                      },
                    ),
                    itemMap(
                        top: 60,
                        left: 10,
                        color: Colors.grey[500].withOpacity(0.6),
                        icon: Icons.map_outlined,
                        padding: 8,
                        // iconColor: mapType != MapType.satellite
                        //     ? Colors.white
                        //     : AppTheme.yellowRed,
                        onTap: () {
                          // if (mapType != MapType.satellite)
                          //   BlocProvider.of<SettingBloc>(context).add(
                          //     ChangeMapType("Satellite"),
                          //   );
                          // if (mapType == MapType.satellite)
                          //   BlocProvider.of<SettingBloc>(context).add(
                          //     ChangeMapType("Normal"),
                          //   );
                        }),
                    itemMap(
                      top: 110,
                      left: 10,
                      color: Colors.redAccent[100].withOpacity(0.6),
                      icon: Icons.notifications_none_outlined,
                      iconColor: Colors.white,
                      padding: 8,
                      onTap: () {
                        Navigator.pushNamed(context, Routes.alertScreen);
                      },
                    ),
                    itemMap(
                      top: 160,
                      left: 10,
                      color: AppTheme.yellowRed.withOpacity(0.8),
                      icon: Icons.people_alt,
                      iconColor: Colors.white,
                      padding: 8,
                      onTap: () {
                        Navigator.pushNamed(context, Routes.listFriendsScreen);
                      },
                    ),
                    Positioned(
                      bottom: 90,
                      child: Container(
                        width: DeviceUtil.getDeviceWidth(context),
                        height: 60,
                        padding: EdgeInsets.only(left: 10),
                        child: bottomListFriend(),
                      ),
                    ),
                  ],
                );
              },
            )
          : Center(
              child: LoadingApp.loading1(),
            ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void copyText(String content) async {
    Clipboard.setData(new ClipboardData(text: content)).then((_) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(Language.of(context).getText("profile_user.copied"))));
      Navigator.pop(context);
    });
  }

  Widget itemMap({
    IconData icon,
    Color iconColor,
    Color color,
    double padding,
    double top,
    double bottom,
    double left,
    Function onTap,
  }) {
    return Positioned(
      top: top ?? null,
      left: left ?? null,
      bottom: bottom ?? null,
      child: InkWell(
        onTap: onTap ?? null,
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
      ),
    );
  }

  Widget itemFriend({
    Widget icon,
    Color color,
    double padding,
    Function onTap,
    bool isFriend,
    int status,
  }) {
    return InkWell(
      onTap: onTap ?? null,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(padding ?? 0),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: icon,
          ),
          (isFriend != null)
              ? (status == 1)
                  ? Positioned(
                      right: 18,
                      bottom: 21,
                      child: CustomPaint(
                        painter: DotPainter(
                          color: AppTheme.statusOn,
                          width: 14,
                        ),
                      ),
                    )
                  : Container()
              : Container(),
        ],
      ),
    );
  }

  Widget bottomListFriend() {
    return Row(
      children: [
        itemFriend(
          color: Colors.white,
          icon: Icon(
            Icons.person_add,
            color: Colors.blue,
          ),
          isFriend: false,
          status: 0,
          padding: 14,
          onTap: () {
            Navigator.pushNamed(context, Routes.addFriendScreen);
          },
        ),
        itemFriend(
          color: Colors.white,
          padding: 18,
          isFriend: false,
          status: 0,
          onTap: () {
            BlocProvider.of<HomeBloc>(context).add(
              ShowBottomPerson(
                BlocProvider.of<ProfileBloc>(context).state.profileUser.uuid,
              ),
            );
            showBottomSheetMe();
          },
          icon: Text('User'),
        ),
        Expanded(
          child: BlocProvider.of<FriendBloc>(context).state.listCloseFriend !=
                  null
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: BlocProvider.of<FriendBloc>(context)
                      .state
                      .listCloseFriend
                      .length,
                  itemBuilder: (BuildContext context, int i) {
                    return Container(
                      padding: EdgeInsets.only(right: 8),
                      child: itemFriend(
                        color: Colors.white,
                        isFriend: true,
                        status: BlocProvider.of<FriendBloc>(context)
                            .state
                            .listCloseFriend[i]
                            .activeStatus,
                        onTap: () {
                          showBottomSheetFriend(
                              BlocProvider.of<FriendBloc>(context)
                                  .state
                                  .listCloseFriend[i]);
                        },
                        icon: CircleAvatar(
                          radius: 25,
                          backgroundImage: BlocProvider.of<FriendBloc>(context)
                                      .state
                                      .listCloseFriend[i]
                                      .avatar_url !=
                                  null
                              ? NetworkImage(
                                  BlocProvider.of<FriendBloc>(context)
                                      .state
                                      .listCloseFriend[i]
                                      .avatar_url)
                              : AssetImage(AppImages.DEFAULT_AVATAR),
                        ),
                      ),
                    );
                  },
                )
              : Container(),
        ),
      ],
    );
  }
}
