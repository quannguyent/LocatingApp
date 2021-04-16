import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/io_client.dart';
import 'package:locaing_app/blocs/blocs.dart';
import 'package:locaing_app/data/model/model.dart';
import 'package:locaing_app/data/network/api_constant.dart';
import 'package:locaing_app/data/repository/repository.dart';
import 'package:locaing_app/ui/widgets/base_screen_method.dart';
import 'package:locaing_app/utils/common.dart';
import 'package:locaing_app/utils/utils.dart';
import 'package:signalr_core/signalr_core.dart';

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
  Completer<GoogleMapController> _controller = Completer();

  MapType mapType;
  Set<Marker> listMarkers = Set();
  double zoom = 14;
  BitmapDescriptor userIcon;
  final DrawMap _drawMap = DrawMap();
  var dataBytes;
  final double sides = 3.0;
  Uint8List markerIcon;
  Uint8List markerRectangle;
  Uint8List markerImage;
  final connection = HubConnectionBuilder()
      .withUrl(
          ApiConstant.HUB+ApiConstant.LOCATION,
          HttpConnectionOptions(
            client: IOClient(
                HttpClient()..badCertificateCallback = (x, y, z) => true),
          ),
  ).build();

  _realTimeTracking(ProfileUserModel u) async {
    LogLocationModel log=await LogLocationRepository().getLastLogLocation(u.uuid);
    GoogleMapController controller = await _controller.future;
    await controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
      bearing: 0,zoom: 14,
      target: LatLng(log.lat, log.lng),
    ),));
    _drawMap.drawTriangle(100, 100).then((value) => markerRectangle = value);
    String userId = await Common.getUserId();
    await connection.start();
    connection.invoke("RegisterFriendLocation", args: [userId]);
    connection.on('ReceiveFriendLocation', (message) {
      // print("Message: $message");
       List<ListLogLocationModel> listLog =
      (message[0]['data'] as List)
          .map((json) => ListLogLocationModel.fromJson(json))
          .toList();
      for (ListLogLocationModel i in listLog) {
        if (i.lastLocationLog.userId == BlocProvider.of<HomeBloc>(context).state.user.uuid) {
          Marker m1=  Marker(
            markerId: MarkerId("id_friend"),
            position:LatLng(i.lastLocationLog.lat, i.lastLocationLog.lng),
            icon: BitmapDescriptor.fromBytes(markerIcon),
          );

        BlocProvider.of<PlaceBloc>(context).add(GetTracking(locationLog: i,marker: m1));
        }
      }
    }
    );

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = BlocProvider.of<HomeBloc>(context).state.user;
    print(user.userName);
    BlocProvider.of<PlaceBloc>(context).add(PlaceRequested(friendId: user.uuid));
    setState(() {
      if (user.avatar_url != null) {
        _drawMap.loadAvatarUser(user.avatar_url, 150).then((value) {
          markerIcon = value;
        });
      } else {
        _drawMap.drawCircle(150, 150, user.avatar_url).then((value) {
          markerIcon = value;
        });
      }

    });
    _realTimeTracking(user);
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
    return BaseScreenMethod(
      title: "home.follow",
      iconBack: true,
      body: Container(
        child: BlocConsumer<PlaceBloc, PlaceState>(
          builder: (context, state) {
            return  GoogleMap(
              circles:  Set<Circle>.of(state.circles.values),
              markers: Set<Marker>.of(state.marker.values),
              initialCameraPosition: CameraPosition(
                target: cameraTarget,
                zoom: zoom,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },

              onCameraMove: (CameraPosition position) {},
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                new Factory<OneSequenceGestureRecognizer>(
                  () => new EagerGestureRecognizer(),
                ),
              ].toSet(),
            );
          },
          listener: (context, state) {
          },
        ),
      ),
    );
  }
}
