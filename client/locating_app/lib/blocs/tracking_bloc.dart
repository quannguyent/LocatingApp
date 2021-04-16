import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locaing_app/data/model/model.dart';
import 'package:locaing_app/data/repository/repository.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  TrackingRepository trackingRepository = new TrackingRepository();
  TrackingBloc() : super(TrackingInitial());

  @override
  Stream<TrackingState> mapEventToState(event) async* {
    if (event is GetTrackingFriend) {
      yield TrackingInProgress(state);
      final Set<Marker> markers = await trackingRepository.getMarKerFriend(
          logs: event.logs, profiles: event.profiles);
      yield TrackingSuccess(state, markers: markers);
    }
  }
}

abstract class TrackingEvent extends Equatable {
  const TrackingEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetTrackingFriend extends TrackingEvent {
  final List<LogLocationModel> logs;
  final List<ProfileUserModel> profiles;
  const GetTrackingFriend({this.logs, this.profiles});

  @override
  // TODO: implement props
  List<Object> get props => [logs, profiles];
}

abstract class TrackingState extends Equatable {
  final Set<Marker> markers;

  const TrackingState({this.markers});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class TrackingInitial extends TrackingState {
  TrackingInitial() : super(markers: Set());
}

class TrackingInProgress extends TrackingState {
  TrackingInProgress(TrackingState oldState, {markers})
      : super(markers: markers ?? oldState.markers);
}

class TrackingSuccess extends TrackingState {
  TrackingSuccess(TrackingState oldState, {markers})
      : super(markers: markers ?? oldState.markers);
  @override
  // TODO: implement props
  List<Object> get props => [markers];
}

class TrackingFailure extends TrackingState {}
