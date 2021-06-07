import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
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
  WeMapController mapController;
  static double initZoom = 15.5;
  double _direction;
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
  final String _defaultAvatarUrl = "assets/images/default_avatar.png";
  bool _satelliteEnabled = false;
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
    String token = await Common.getToken();
    print("xxxxxxxxxxxxxxxx token : ${token}");
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

  Future<void> addImageFromAsset(
      String name, String assetName, double lat, double long) async {
    print("xxxxxxx 12331231231232 iamge");

    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list =
        await _drawMap.getBytesFromAsset(_defaultAvatarUrl, 150, 150);
    await mapController.addImage(name, list);
    mapController.addSymbol(
      SymbolOptions(
        geometry: LatLng(lat, long),
        iconImage: name,
      ),
    );
  }

  Future<void> addImageFromNetWork(
      String name, double lat, double long, String url) async {
    print("xxxxxxx 12331231231232 iamge $url");
    final Uint8List list = await _drawMap.getBytesFromNetwork(url, 150, 150);
    await mapController.addImage(name, list);
    mapController.addSymbol(
      SymbolOptions(
        geometry: LatLng(lat, long),
        iconImage: name,
      ),
    );
  }

  void _onStyleLoaded(LatLng myLoc) {
    final List<ProfileUserModel> profile =
        BlocProvider.of<FriendBloc>(context).state.listFriend;
    profile.forEach((element) {
      print("xxxxx 123123123123312312 id ${element.id} ${element.email}");
    });
    String username =
        BlocProvider.of<ProfileBloc>(context).state.profileUser.username;
    String imageUrl =
        BlocProvider.of<ProfileBloc>(context).state.profileUser.avatar;
    if (imageUrl == null) {
      addImageFromAsset(
          "assetImage", _defaultAvatarUrl, myLoc.latitude, myLoc.longitude);
    } else {
      addImageFromNetWork(username, myLoc.latitude, myLoc.longitude,
          Common.getAvatarUrl(imageUrl));
    }
    addImageFromNetWork(
        "admin",
        20.98622634635928,
        105.79820509950514,
        Common.getAvatarUrl(
            "https://raw.githubusercontent.com/quannguyent/LocatingApp.BE/master/Avatar/Screenshot_20210213-014516.png"));
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
      setState(() {
        _myLocation = LatLng(value.latitude, value.longitude);
      });
      // _drawMap.drawTriangle(100, 100).then((value) => markerRectangle = value);
      String username =
          BlocProvider.of<ProfileBloc>(context).state.profileUser.username;
      print("xxxxxx username in map_widget $username");
      String imageUrl =
          BlocProvider.of<ProfileBloc>(context).state.profileUser.avatar;
      if (imageUrl != null) {
        _drawMap.loadAvatarUser(imageUrl, 200).then((value) {
          setState(() {
            markerIcon = value;
          });
          _realTimeTracking();
        });
      } else {
        _drawMap.drawCircle(200, 200, username).then((value) {
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
            nameUser: state.profileUser.username,
            linkImage: state.profileUser.avatar != null
                ? state.profileUser.avatar
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
    print("xxxx user in map ${user.id}");
    showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (builder) {
        return BlocConsumer<PlaceBloc, PlaceState>(
          builder: (context, state) {
            return CustomBottomSheetFriend(
              nameUser: user.username,
              linkImage: user.avatar != null ? user.avatar : null,
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
        // body: markerIcon != null
        body: BlocBuilder<SettingBloc, SettingState>(
          builder: (context, state) {
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
                    return Container(
                      child: WeMap(
                        onMapClick: (point, latlng, _place) async {
                          place = await _place;
                        },
                        onPlaceCardClose: () {
                          // print("Place Card closed");
                        },
                        onStyleLoadedCallback: () {
                          if (_myLocation != null) {
                            mapController.moveCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: _myLocation,
                                  zoom: 16.0,
                                ),
                              ),
                            );
                            _onStyleLoaded(_myLocation);
                          }
                        },
                        gestureRecognizers:
                            <Factory<OneSequenceGestureRecognizer>>[
                          new Factory<OneSequenceGestureRecognizer>(
                            () => new EagerGestureRecognizer(),
                          ),
                        ].toSet(),
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
                    iconColor: _satelliteEnabled != true
                        ? Colors.white
                        : AppTheme.yellowRed,
                    onTap: () {
                      setState(() {
                        if (_satelliteEnabled == false) {
                          _satelliteEnabled = true;
                          mapController.addSatelliteLayer();
                        } else {
                          _satelliteEnabled = false;
                          mapController.removeSatelliteLayer();
                        }
                      });
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
        // : Center(
        //     child: LoadingApp.loading1(),
        //   ),
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
    // print("xxxxx ${BlocProvider.of<FriendBloc>(context).state.listFriend}");
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
          child: BlocProvider.of<FriendBloc>(context).state.listFriend != null
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: BlocProvider.of<FriendBloc>(context)
                      .state
                      .listFriend
                      .length,
                  itemBuilder: (BuildContext context, int i) {
                    return Container(
                      padding: EdgeInsets.only(right: 8),
                      child: itemFriend(
                        color: Colors.white,
                        isFriend: true,
                        status: BlocProvider.of<FriendBloc>(context)
                            .state
                            .listFriend[i]
                            .activeStatus,
                        onTap: () {
                          showBottomSheetFriend(
                              BlocProvider.of<FriendBloc>(context)
                                  .state
                                  .listFriend[i]);
                        },
                        icon: CircleAvatar(
                          radius: 25,
                          backgroundImage: BlocProvider.of<FriendBloc>(context)
                                      .state
                                      .listFriend[i]
                                      .avatar !=
                                  null
                              ? NetworkImage(Common.getAvatarUrl(
                                  BlocProvider.of<FriendBloc>(context)
                                      .state
                                      .listFriend[i]
                                      .avatar))
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
