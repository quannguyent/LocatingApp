import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locaing_app/data/model/model.dart';
import 'package:locaing_app/data/repository/repository.dart';
import 'package:locaing_app/res/resources.dart';
import 'package:locaing_app/utils/common.dart';

class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
  final PlaceRepository placeRepository = new PlaceRepository();
  PlaceBloc() : super(PlaceInitial());
  @override
  Stream<PlaceState> mapEventToState(event) async* {
    if (event is PlaceRequested) {
      yield PlaceLoadInProgress.fromOldState(state);
      try {
        String userId = await Common.getUserId();
        final List<PlaceModel> listPlaces = await placeRepository.getPlaces(
          userId: userId,
          friendId: event.friendId,
        );
        yield PlaceLoadSuccess.fromOldState(
          state,
          listPlaces: listPlaces,
          messageSuccess: 'get',
        );
      } catch (err) {
        yield PlaceLoadFailure.fromOldState(state, messageSuccess: null);
      }
    }

    if (event is AddPlace) {
      yield PlaceLoadInProgress.fromOldState(state);
      try {
        String userId = await Common.getUserId();
        final bool check = await placeRepository.addPlace(
            userId: userId,
            friendId: event.friendId,
            name: event.name,
            address: event.address,
            lat: event.lat,
            lng: event.lng,
            rad: event.rad);
        if (check) {
          final List<PlaceModel> listPlaces = await placeRepository.getPlaces(
              userId: userId, friendId: event.friendId);
          yield PlaceLoadSuccess.fromOldState(state,
              listPlaces: listPlaces, messageSuccess: 'add');
        }
      } catch (err) {
        yield PlaceLoadFailure.fromOldState(state, messageSuccess: 'failure');
      }
    }

    if (event is UpdatePlace) {
      yield PlaceLoadInProgress.fromOldState(state);
      try {
        String userId = await Common.getUserId();
        final bool check = await placeRepository.updatePlace(
            userId: userId,
            friendId: event.friendId,
            placeId: event.placeId,
            name: event.name,
            address: event.address,
            lat: event.lat,
            lng: event.lng,
            rad: event.rad);
        if (check) {
          final List<PlaceModel> listPlaces = await placeRepository.getPlaces(
              userId: userId, friendId: event.friendId);
          yield PlaceLoadSuccess.fromOldState(state,
              listPlaces: listPlaces, messageSuccess: 'update');
        }
      } catch (err) {
        yield PlaceLoadFailure.fromOldState(state, messageSuccess: 'failure');
      }
    }

    if (event is DeletePlace) {
      final List<PlaceModel> listPlaces = state.listPlaces;
      yield PlaceLoadInProgress.fromOldState(state);
      try {
        String userId = await Common.getUserId();
        final bool check = await placeRepository.deletePlace(
          userId: userId,
          friendId: event.friendId,
          placeId: event.placeId,
        );
        if (check) {
          listPlaces.remove(listPlaces[event.index]);
          yield PlaceLoadSuccess.fromOldState(state,
              listPlaces: listPlaces, messageSuccess: 'delete');
        }
      } catch (err) {
        yield PlaceLoadFailure.fromOldState(state, messageSuccess: null);
      }
    }
    if (event is GetTracking) {
      for (PlaceModel j in state.listPlaces) {
        if (event.locationLog.status != null) {
          if (event.locationLog.status == 1 &&
              event.locationLog.placeId == j.id) {
            yield PlaceLoadSuccess.fromOldState(
              state,
              marker: _setCircle(id: j.id)[0],
              circles: _setCircle(id: j.id)[1],
            );
            break;
          } else {
            yield PlaceLoadSuccess.fromOldState(
              state,
              marker: _setCircle()[0],
              circles: _setCircle()[1],
            );
          }
        }
      }

      if (event.marker != null) {
        Map<MarkerId, Marker> marker;
        marker = state.marker;
        marker[MarkerId("id_friend")] = event.marker;
        yield PlaceLoadSuccess.fromOldState(
          state,
          marker: marker,
          targetMap: event.marker.position,
        );
      }
    }
    if (event is ClearMarkerCircle) {
      yield PlaceInitial();
    }
  }

  _setCircle({String id}) {
    int _markerIdCounter = 1;
    Map<MarkerId, Marker> marker = state.marker;
    Map<CircleId, Circle> circles = state.circles;
    if (state.listPlaces.isNotEmpty) {
      for (PlaceModel i in state.listPlaces) {
        String circleId = 'circle_id_$_markerIdCounter';
        final String markerIdVal = 'marker_id_$_markerIdCounter';
        _markerIdCounter++;
        MarkerId markerId = MarkerId(markerIdVal);
        marker[markerId] = Marker(
          markerId: markerId,
          position: LatLng(i.lat, i.lng),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        );
        circles[CircleId(circleId)] = Circle(
          circleId: CircleId(circleId),
          center: LatLng(i.lat, i.lng),
          radius: i.rad,
          fillColor: id != i.id
              ? AppTheme.nearlyBlue.withOpacity(0.3)
              : AppTheme.nearlyYellow.withOpacity(0.7),
          strokeWidth: 0,
        );
        _markerIdCounter++;
      }
    }
    return [marker, circles];
  }
}

class PlaceEvent {}

class PlaceRequested extends PlaceEvent {
  String friendId;

  PlaceRequested({this.friendId});
}

class ClearMarkerCircle extends PlaceEvent {}

class AddPlace extends PlaceEvent {
  final String name;
  final String address;
  final double rad;
  final double lat;
  final double lng;
  final String friendId;

  AddPlace({
    @required this.friendId,
    this.name,
    this.address,
    this.rad,
    this.lat,
    this.lng,
  });
}

class GetTracking extends PlaceEvent {
  Marker marker;
  Set<Circle> circles;
  List<PlaceModel> listPlace;
  ListLogLocationModel locationLog;
  GetTracking({this.marker, this.circles, this.listPlace, this.locationLog});
}

class DeletePlace extends PlaceEvent {
  final String friendId;
  final String placeId;
  final int index;

  DeletePlace({this.friendId, this.placeId, this.index});

  @override
  // TODO: implement props
  List<Object> get props => [friendId, placeId, index];
}

class UpdatePlace extends PlaceEvent {
  final String placeId;
  final String name;
  final String address;
  final double rad;
  final double lat;
  final double lng;
  final String friendId;

  UpdatePlace({
    @required this.friendId,
    this.placeId,
    this.name,
    this.address,
    this.rad,
    this.lat,
    this.lng,
  });

  @override
  // TODO: implement props
  List<Object> get props => [
        friendId,
        placeId,
        name,
        address,
        rad,
        lat,
        lng,
      ];
}

class PlaceState {
  List<PlaceModel> listPlaces;
  Map<MarkerId, Marker> marker;
  Map<CircleId, Circle> circles;
  String messageSuccess;
  LatLng targetMap;
  PlaceState(
      {this.listPlaces,
      this.messageSuccess,
      this.marker,
      this.circles,
      this.targetMap});
}

class PlaceInitial extends PlaceState {
  PlaceInitial()
      : super(
          listPlaces: [],
          messageSuccess: null,
          marker: <MarkerId, Marker>{},
          circles: <CircleId, Circle>{},
          targetMap: null,
        );
}

class PlaceLoadInProgress extends PlaceState {
  PlaceLoadInProgress.fromOldState(
    PlaceState oldStare, {
    List<PlaceModel> listPlaces,
    Map<MarkerId, Marker> marker,
    Map<CircleId, Circle> circles,
    LatLng targetMap,
  }) : super(
          listPlaces: listPlaces ?? oldStare.listPlaces,
          messageSuccess: null,
          marker: marker ?? oldStare.marker,
          circles: circles ?? oldStare.circles,
          targetMap: targetMap ?? oldStare.targetMap,
        );
}

class PlaceLoadSuccess extends PlaceState {
  PlaceLoadSuccess.fromOldState(
    PlaceState oldStare, {
    List<PlaceModel> listPlaces,
    String messageSuccess,
    Map<MarkerId, Marker> marker,
    Map<CircleId, Circle> circles,
    LatLng targetMap,
  }) : super(
          listPlaces: listPlaces ?? oldStare.listPlaces,
          messageSuccess: messageSuccess,
          marker: marker ?? oldStare.marker,
          circles: circles ?? oldStare.circles,
          targetMap: targetMap ?? oldStare.targetMap,
        );
}

class PlaceLoadFailure extends PlaceState {
  PlaceLoadFailure.fromOldState(
    PlaceState oldState, {
    List<PlaceModel> listPlaces,
    String messageSuccess,
    Map<MarkerId, Marker> marker,
    Map<CircleId, Circle> circles,
    LatLng targetMap,
  }) : super(
          listPlaces: listPlaces ?? oldState.listPlaces,
          messageSuccess: messageSuccess,
          marker: marker ?? oldState.marker,
          circles: circles ?? oldState.circles,
          targetMap: targetMap ?? oldState.targetMap,
        );
}
