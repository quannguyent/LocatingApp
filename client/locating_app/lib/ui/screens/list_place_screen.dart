import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/io_client.dart';
import 'package:locaing_app/blocs/blocs.dart';
import 'package:locaing_app/data/model/model.dart';
import 'package:locaing_app/data/network/api_constant.dart';
import 'package:locaing_app/data/repository/repository.dart';
import 'package:locaing_app/ui/widgets/base_screen_method.dart';
import 'package:locaing_app/utils/common.dart';
import 'package:locaing_app/utils/utils.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:wemapgl/wemapgl.dart';

class ListPlaceScreen extends StatefulWidget {
  @override
  _ListPlaceScreenState createState() => _ListPlaceScreenState();
}

class _ListPlaceScreenState extends State<ListPlaceScreen>
    with AutomaticKeepAliveClientMixin<ListPlaceScreen> {
  @override
  bool get wantKeepAlive => true;
  ProfileUserModel user;
  LatLng cameraTarget = LatLng(0, 0);
  WeMapController mapController;
  WeMapPlace place;

  // Completer<GoogleMapController> _controller = Completer();

  // MapType mapType;
  // Set<Marker> listMarkers = Set();
  double zoom = 14;
  // BitmapDescriptor userIcon;
  final DrawMap _drawMap = DrawMap();
  var dataBytes;
  final double sides = 3.0;
  Uint8List markerIcon;
  Uint8List markerRectangle;
  Uint8List markerImage;

  final connection = HubConnectionBuilder()
      .withUrl(
        ApiConstant.HUB + ApiConstant.LOCATION,
        HttpConnectionOptions(
          client: IOClient(
              HttpClient()..badCertificateCallback = (x, y, z) => true),
        ),
      )
      .build();

  // _realTimeTracking(ProfileUserModel u) async {
  //   LogLocationModel log =
  //       await LogLocationRepository().getLastLogLocation(u.uuid);
  //   // GoogleMapController controller = await _controller.future;
  //   // await controller.moveCamera(CameraUpdate.newCameraPosition(
  //   //   CameraPosition(
  //   //     bearing: 0,
  //   //     zoom: 14,
  //   //     target: LatLng(log.lat, log.lng),
  //   //   ),
  //   // ));
  //   _drawMap.drawTriangle(100, 100).then((value) => markerRectangle = value);
  //   String userId = await Common.getUserId();
  //   await connection.start();
  //   connection.invoke("RegisterFriendLocation", args: [userId]);
  //   connection.on('ReceiveFriendLocation', (message) {
  //     // print("Message: $message");
  //     List<ListLogLocationModel> listLog = (message[0]['data'] as List)
  //         .map((json) => ListLogLocationModel.fromJson(json))
  //         .toList();
  //     for (ListLogLocationModel i in listLog) {
  //       if (i.lastLocationLog.userId ==
  //           BlocProvider.of<HomeBloc>(context).state.user.uuid) {
  //         Marker m1 = Marker(
  //           markerId: MarkerId("id_friend"),
  //           position: LatLng(i.lastLocationLog.lat, i.lastLocationLog.lng),
  //           icon: BitmapDescriptor.fromBytes(markerIcon),
  //         );

  //         BlocProvider.of<PlaceBloc>(context)
  //             .add(GetTracking(locationLog: i, marker: m1));
  //       }
  //     }
  //   });
  // }
  void _onMapCreated(WeMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = BlocProvider.of<HomeBloc>(context).state.user;
    print(user.username);
    BlocProvider.of<PlaceBloc>(context)
        .add(PlaceRequested(friendId: user.uuid));
    setState(() {
      if (user.avatar != null) {
        _drawMap.loadAvatarUser(user.avatar, 150).then((value) {
          markerIcon = value;
        });
      } else {
        _drawMap.drawCircle(150, 150, user.avatar).then((value) {
          markerIcon = value;
        });
      }
    });
    // _realTimeTracking(user);
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    BlocProvider.of<PlaceBloc>(context).add(ClearMarkerCircle());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    connection.stop();
  }

  @override
  Widget build(BuildContext context) {
    print("this is list_place_screen");

    return BaseScreenMethod(
      title: "home.follow",
      iconBack: true,
      body: Container(
        child: BlocConsumer<PlaceBloc, PlaceState>(
          builder: (context, state) {
            return WeMap(
              onMapClick: (point, latlng, _place) async {
                place = await _place;
              },
              onPlaceCardClose: () {
                // print("Place Card closed");
              },
              reverse: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(21.036029, 105.782950),
                zoom: 16.0,
              ),
              destinationIcon: "assets/symbols/destination.png",
            );
          },
          listener: (context, state) {},
        ),
      ),
    );
  }
}
