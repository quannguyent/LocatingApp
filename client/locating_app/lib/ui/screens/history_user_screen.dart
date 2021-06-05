import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:locaing_app/data/network/api_constant.dart';
import 'package:wemapgl/wemapgl.dart';
import 'package:intl/intl.dart';
import 'package:locaing_app/blocs/blocs.dart';
import 'package:locaing_app/data/model/model.dart';
import 'package:locaing_app/localizations.dart';
import 'package:locaing_app/res/colors.dart';
import 'package:locaing_app/res/resources.dart';
import 'package:locaing_app/ui/widgets/widgets.dart';
import 'package:locaing_app/utils/common.dart';
import 'package:locaing_app/utils/device.dart';
import 'package:http/http.dart' as http;

class HistoryUserScreen extends StatefulWidget {
  @override
  _HistoryUserScreenState createState() => _HistoryUserScreenState();
}

class _HistoryUserScreenState extends State<HistoryUserScreen> {
  // Completer<GoogleMapController> _controller = Completer();
  // Set<Marker> listMarkers = Set();
  double zoom = 16;
  WeMapController mapController;
  LatLng cameraTarget = LatLng(21.066933, 105.789319);
  // Set<Polyline> _polyLines = {};
  List<LatLng> _listPolyLines = [];
  List<String> _location = [];
  double heightBottomSheet;
  Uint8List markerIcon;
  String userId;
  WeMapPlace place;
  List<List<double>> coordinates = [];
  // Set<Circle> _circles = HashSet<Circle>();
  dynamic geometries = {
    "type": "GeometryCollection",
    "geometries": [
      {
        "type": "LineString",
        "coordinates": [
          [106.8310546875, 13.004557745339769],
          [107.061767578125, 11.40464884161848],
          [105.93017578125, 10.17437402751379],
        ]
      }
    ]
  };
  Future<LatLngBounds> _getVisibleRegion() async {
    final LatLngBounds bounds = await mapController.getVisibleRegion();
    print("xxxx bounds $bounds");
    return bounds;
  }

  void _addPolyline(dynamic a) {
    mapController.addGeoJSON(GeoJSONOptions(
      geojson: jsonEncode(a),
      type: GeoJSONOptions.POLYLINE,
      lineColor: "#ff0000",
      lineWidth: 2,
      lineOpacity: 1,
    ));
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  // void loadData(List<LogLocationModel> listLogs) async {
  //   LatLng start = new LatLng(listLogs[0].lat, listLogs[0].lng);
  //   LatLng end = new LatLng(
  //       listLogs[listLogs.length - 1].lat, listLogs[listLogs.length - 1].lng);
  //   // listMarkers.clear();
  //   _listPolyLines.clear();
  //   _polyLines.clear();
  //   listMarkers.add(Marker(
  //     anchor: Offset(0.5, 0.5),
  //     markerId: MarkerId("marker_id_start"),
  //     position: start,
  //     icon: BitmapDescriptor.defaultMarker,
  //   ));
  //   listMarkers.add(Marker(
  //     anchor: Offset(0.5, 0.5),
  //     markerId: MarkerId("marker_id_end"),
  //     position: end,
  //     icon: BitmapDescriptor.fromBytes(markerIcon),
  //   ));
  //   listLogs.forEach((element) {
  //     _listPolyLines.add(LatLng(element.lat, element.lng));
  //   });

  //   _polyLines.add(
  //     // ve duong di
  //     Polyline(
  //         polylineId: PolylineId('polylineId'),
  //         color: AppTheme.green.withOpacity(0.5),
  //         width: 5,
  //         points: _listPolyLines),
  //   );
  // }

  void _getLogLocation(DateTime dateTime) async {
    print("xxxx this id userId $userId");
    if (userId == null) {
      userId = await Common.getUserId();
    }
    String token = await Common.getToken();
    // final LatLngBounds bounds = await _getVisibleRegion();

    double endTime = 0;
    double startTime = 0;
    if (dateTime == DateTime.now()) {
      endTime = dateTime.millisecondsSinceEpoch / 1000;
      DateTime temp = new DateTime(
          dateTime.year, dateTime.month, dateTime.day, 0, 0, 0, 0, 0);
      startTime = temp.millisecondsSinceEpoch / 1000;
    } else {
      endTime = dateTime.millisecondsSinceEpoch / 1000 + 3600 * 24;
      startTime = dateTime.millisecondsSinceEpoch / 1000;
    }
    var response = await http.post(
      ApiConstant.APIHOST + ApiConstant.GET_HISTORY_LOCATION,
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        {
          "appUserId": {
            "equal": userId,
          },
        },
      ),
    );
    List resBody = jsonDecode(response.body);

    resBody.forEach((element) {
      List<double> b = [];
      b.add(element["latitude"]);
      b.add(element["longtitude"]);
      print("xxxxx b ${element["latitude"]}");
      coordinates.add(b);
    });
    geometries["geometries"]["coordinates"] = [...coordinates];
    // BlocProvider.of<LogLocationBloc>(context).add(GetLogRequested(
    //   userId: uuidFiend,
    //   // startTime: startTime,
    //   // endTime: endTime,
    //   topRightLat: bounds.northeast.latitude,
    //   topRightLng: bounds.northeast.longitude,
    //   bottomLeftLat: bounds.southwest.latitude,
    //   bottomLeftLng: bounds.southwest.longitude,
    // ));
  }

  DateTime selectedDate = DateTime.now();
  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isBefore(DateTime.now().add(Duration(days: 0))) &&
        day.isAfter(DateTime.now().subtract(Duration(days: 30))))) {
      return true;
    }
    return false;
  }

  _selectDate() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(20230),
      selectableDayPredicate: _decideWhichDayToEnable,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _getLogLocation(picked);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    heightBottomSheet = 300;
    _getLogLocation(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    userId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Container(
        width: DeviceUtil.getDeviceHeight(context),
        height: DeviceUtil.getDeviceHeight(context),
        child: BlocBuilder<LogLocationBloc, LogLocationState>(
          builder: (context, state) {
            if (state is LogLocationLoadSuccess) {
              if (state.listLogs != null) {
                // loadData(state.listLogs);
              } else {
                // listMarkers.clear();
                _listPolyLines.clear();
                // _polyLines.clear();
              }
            }
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                BlocConsumer<PlaceBloc, PlaceState>(
                  builder: (context, state) {
                    return WeMap(
                      onMapClick: (point, latlng, _place) async {
                        place = await _place;
                      },
                      onPlaceCardClose: () {
                        // print("Place Card closed");
                      },
                      onStyleLoadedCallback: () async {
                        await _addPolyline(geometries);
                      },
                      reverse: true,
                      onMapCreated: (WeMapController controller) {
                        mapController = controller;
                      },
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(21.036029, 105.782950),
                        zoom: 16.0,
                      ),
                      destinationIcon: "assets/symbols/destination.png",
                    );
                  },
                  listener: (context, state) {
                    if (state is PlaceLoadSuccess) {}
                  },
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.blue,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                // state is LogLocationLoadSuccess
                //     ? bottomSheetHistory(
                //         listLogs: state.listLogs,
                //         locations: state.locations,
                //         isLoad: false)
                //     : bottomSheetHistory(isLoad: true),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget bottomSheetHistory(
      {List<LogLocationModel> listLogs, List<String> locations, bool isLoad}) {
    String dateOfWeek = Language.of(context)
        .getText("history_location.${DateFormat('EEEE').format(selectedDate)}");
    String dateOfMonth = DateFormat('d').format(selectedDate);
    String month = Language.of(context)
        .getText("history_location.${DateFormat('MMM').format(selectedDate)}");
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        bottom: 20,
      ),
      width: DeviceUtil.getDeviceWidth(context),
      height: heightBottomSheet,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 1,
            offset: Offset(1, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 60,
              child: Column(
                children: [
                  Center(
                    child: GestureDetector(
                      onVerticalDragUpdate: (details) {
                        if (details.delta.dy > 0) {
                          setState(() {
                            print("down");
                            if (heightBottomSheet ==
                                DeviceUtil.getDeviceHeight(context) / 1.5)
                              heightBottomSheet = 300;
                          });
                        }
                        if (details.delta.dy < 0) {
                          print("up");
                          setState(() {
                            if (heightBottomSheet == 300)
                              heightBottomSheet =
                                  DeviceUtil.getDeviceHeight(context) / 1.5;
                          });
                        }
                      },
                      child: Container(
                        //  color: Colors.deepOrange,
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 10,
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                _selectDate();
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 30),
                                child: FaIcon(
                                  FontAwesomeIcons.calendarAlt,
                                  color: AppTheme.nearlyBlue,
                                  size: 30,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                '$dateOfWeek, $dateOfMonth $month',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: AppTheme.deactivatedText,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1.5,
                  )
                ],
              )),
          isLoad
              ? Expanded(child: Center(child: LoadingApp.loading1()))
              : listLogs != null
                  ? Expanded(
                      child: Container(
                        child: ListView.builder(
                          itemCount: listLogs.length,
                          itemBuilder: (context, index) {
                            return itemCardHistory(
                              listLogs[index],
                              locations[index],
                            );
                          },
                        ),
                      ),
                    )
                  : Expanded(
                      child: Center(
                        child: Text(Language.of(context)
                            .getText('history_location.no_log_message')),
                      ),
                    )
        ],
      ),
    );
  }

  Widget itemCardHistory(LogLocationModel logLocationModel, String location) {
    String time = Common.readTime(logLocationModel.createdAt.round());
    String distance = location;
    return Container(
      width: DeviceUtil.getDeviceWidth(context),
      padding: EdgeInsets.only(left: 20, bottom: 10, top: 10, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 4),
            child: Text(
              time,
              style: TextStyle(
                color: AppTheme.deactivatedText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            child: Text(
              distance,
              style: TextStyle(
                color: AppTheme.nearlyBlack,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Divider(
            thickness: 1.5,
          )
        ],
      ),
    );
  }
}
