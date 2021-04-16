import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locaing_app/blocs/blocs.dart';
import 'package:locaing_app/data/model/model.dart';
import 'package:locaing_app/res/colors.dart';
import 'package:locaing_app/res/resources.dart';
import 'package:locaing_app/ui/widgets/widgets.dart';
import 'package:locaing_app/utils/common.dart';
import 'package:locaing_app/utils/utils.dart';
import '../../localizations.dart';

class RegisterPlaceDetailScreen extends StatefulWidget {
  const RegisterPlaceDetailScreen({Key key, @required this.arguments})
      : super(key: key);
  final Arguments arguments;
  @override
  _RegisterPlaceDetailScreenState createState() =>
      _RegisterPlaceDetailScreenState();
}

class _RegisterPlaceDetailScreenState extends State<RegisterPlaceDetailScreen> {
  final double initZoom = 15.5;
  double sliderMin = 100;
  double sliderMax = 3000;
  double _zoomLevel;
  Completer<GoogleMapController> _controller = Completer();
  LatLng _myLocation;
  String _address = '';
  Set<Circle> _circles = HashSet<Circle>();
  Set<Marker> _markers = HashSet<Marker>();

  double _radius;
  final double initRadius = 200;
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  LatLng centerPosition;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _setCircle(LatLng position) {
    int circleIdCounter = 1;
    final String circleId = 'circle_id_$circleIdCounter';
    _circles.add(Circle(
      circleId: CircleId(circleId),
      center: position,
      radius: _radius ?? initRadius,
      fillColor: AppTheme.nearlyBlue.withOpacity(0.3),
      strokeWidth: 0,
    ));
  }

  void _setMarker(LatLng position) {
    int markerIdCounter = 1;
    final String markerId = 'circle_id_$markerIdCounter';
    _markers.add(Marker(
      markerId: MarkerId(markerId),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ));
  }

  void _setMap(LatLng position) {
    _myLocation = position;
    _setMarker(position);
    _setCircle(position);
    _getLocation(position);
  }

  void _onCameraMove(CameraPosition position) {
    centerPosition = position.target;
  }

  void _onCameraIdle() {
    if (centerPosition == null) {
      _setMap(_myLocation);
    } else {
      _circles.clear();
      _markers.clear();
      _setMap(centerPosition);
    }
  }

  Future<String> _getLocation(LatLng position) async {
    String location = "";
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    location = first.addressLine;
    setState(() {
      _address = location;
    });
    return location;
  }

  double getZoomLevel(double radius) {
    double zoomLevel;
    if (radius >= 100 && radius < 250) {
      zoomLevel = 17;
    } else if (radius >= 250 && radius < 300) {
      zoomLevel = 15.5;
    } else if (radius >= 300 && radius < 800) {
      zoomLevel = 15;
    } else if (radius >= 800 && radius < 1200) {
      zoomLevel = 14;
    } else {
      zoomLevel = 13;
    }

    return zoomLevel;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.arguments.place != null) {
      _radius = widget.arguments.place.rad;
      _zoomLevel = getZoomLevel(_radius);
      _myLocation =
          LatLng(widget.arguments.place.lat, widget.arguments.place.lng);
      _setMap(_myLocation);
    } else {
      _radius = initRadius;
      _zoomLevel = initZoom;
      Common.getCoordinates().then((value) {
        _myLocation = value;
        _setMap(_myLocation);
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.arguments.place != null) {
      if (_textController.text == "")
        _textController.text = widget.arguments.place.name;
    } else {
      if (_textController.text == "")
        _textController.text =
            Language.of(context).getText('register_place.default_place');
    }

    return BlocConsumer<PlaceBloc, PlaceState>(
      listener: (context, state) {
        if (state.messageSuccess == 'failure') {
          if (widget.arguments.place != null) {
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text(Language.of(context)
                    .getText('register_place.update_failure')),
                duration: Duration(seconds: 1),
              ),
            );
          } else {
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text(
                    Language.of(context).getText('register_place.add_failure')),
                duration: Duration(seconds: 1),
              ),
            );
          }
        }

        if (state.messageSuccess == 'add') {
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(
                  Language.of(context).getText('register_place.add_success')),
              duration: Duration(seconds: 1),
            ),
          );
          Future.delayed(
              const Duration(seconds: 1), () => Navigator.pop(context));
        }

        if (state.messageSuccess == 'update') {
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(Language.of(context)
                  .getText('register_place.update_success')),
              duration: Duration(seconds: 1),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          body: Container(
            child: Stack(
              children: [
                Container(
                  child: _myLocation != null
                      ? GoogleMap(
                          markers: _markers,
                          circles: _circles,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: _myLocation, // song gianh
                            zoom: _zoomLevel,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                          onCameraMove: _onCameraMove,
                          onCameraIdle: _onCameraIdle,
                          gestureRecognizers:
                              <Factory<OneSequenceGestureRecognizer>>[
                            new Factory<OneSequenceGestureRecognizer>(
                              () => new EagerGestureRecognizer(),
                            ),
                          ].toSet(),
                        )
                      : Container(
                          child: Center(
                            child: LoadingApp.loading1(),
                          ),
                        ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  right: 16,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              color: Colors.transparent,
                              child: InkWell(
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
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      searchUI(),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: bottomBar(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget searchUI() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.2),
            offset: Offset(1.1, 1.1),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: TextFormField(
          style: TextStyle(color: AppTheme.grey_500),
          controller: _searchController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            suffixIcon: Icon(
              Icons.search_outlined,
              color: AppTheme.grey_500,
            ),
            suffixIconConstraints: BoxConstraints(
              minWidth: 2,
              minHeight: 2,
            ),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: Language.of(context).getText('register_place.search'),
          ),
        ),
      ),
    );
  }

  Widget bottomBar() {
    return Container(
      height: DeviceUtil.getDeviceHeight(context) / 2.8,
      width: DeviceUtil.getDeviceWidth(context),
      child: contentBottomBar(),
      decoration: ShapeDecoration(
        color: AppTheme.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
      ),
    );
  }

  Widget contentBottomBar() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Icon(
                          widget.arguments.friendId == "home"
                              ? Icons.home
                              : (widget.arguments.friendId == "school"
                                  ? Icons.school
                                  : Icons.work),
                          color: AppTheme.darkBlue,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: TextField(
                      controller: _textController,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.edit_outlined,
                          color: AppTheme.grey_500,
                        ),
                        suffixIconConstraints: BoxConstraints(
                          minWidth: 2,
                          minHeight: 2,
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        isCollapsed: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                _address,
                maxLines: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 1.5,
                  trackShape: RoundedRectSliderTrackShape(),
                  thumbColor: AppTheme.darkBlue,
                  activeTrackColor: AppTheme.darkBlue,
                  inactiveTrackColor: AppTheme.deactivatedText,
                ),
                child: Slider(
                  min: sliderMin,
                  max: sliderMax,
                  value: _radius,
                  onChanged: (value) async {
                    _circles.clear();
                    _markers.clear();
                    if (value >= 100 && value < 250) {
                      _zoomLevel = 17;
                    } else if (value >= 250 && value < 300) {
                      _zoomLevel = 15.5;
                    } else if (value >= 300 && value < 800) {
                      _zoomLevel = 15;
                    } else if (value >= 800 && value < 1200) {
                      _zoomLevel = 14;
                    } else {
                      _zoomLevel = 13;
                    }

                    final complete = await _controller.future;
                    complete.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: _myLocation,
                          zoom: _zoomLevel,
                        ),
                      ),
                    );
                    setState(() {
                      _radius = value;
                      _setMap(_myLocation);
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Center(
                child: Text('${_radius.round()} m'),
              ),
            ),
            ItemButton(
              title: "register_place.save",
              boldText: true,
              onPress: () {
                if (widget.arguments.place != null) {
                  BlocProvider.of<PlaceBloc>(context).add(UpdatePlace(
                    friendId: widget.arguments.friendId,
                    placeId: widget.arguments.place.id,
                    name: _textController.text,
                    address: _address,
                    lat: _myLocation.latitude,
                    lng: _myLocation.longitude,
                    rad: _radius,
                  ));
                } else {
                  BlocProvider.of<PlaceBloc>(context).add(AddPlace(
                    friendId: widget.arguments.friendId,
                    name: _textController.text,
                    address: _address,
                    lat: _myLocation.latitude,
                    lng: _myLocation.longitude,
                    rad: _radius,
                  ));
                }
              },
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
