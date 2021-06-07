import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locaing_app/data/model/model.dart';
import 'package:locaing_app/data/repository/repository.dart';

class LogLocationBloc extends Bloc<LogLocationEvent, LogLocationState> {
  final LogLocationRepository logLocationRepository =
      new LogLocationRepository();
  LogLocationBloc() : super(LogLocationInitial());

  @override
  Stream<LogLocationState> mapEventToState(event) async* {
    if (event is GetLogRequested) {
      print("xxx location log 1");
      yield LogLocationLoadInProgress();
      try {
        final List<LogLocationModel> listLogs =
            await logLocationRepository.getLogLocations(
          userId: event.userId,
          startTime: event.startTime,
          endTime: event.endTime,
          topRightLat: event.topRightLat,
          topRightLng: event.topRightLng,
          bottomLeftLat: event.bottomLeftLat,
          bottomLeftLng: event.bottomLeftLng,
        );
        if (listLogs != null) {
          final List<String> locations =
              await logLocationRepository.getLocations(listLogs);
          yield LogLocationLoadSuccess(
              listLogs: listLogs, locations: locations);
        } else {
          yield LogLocationLoadSuccess(listLogs: null, locations: null);
        }
      } catch (e) {
        yield LogLocationLoadFailure();
      }
    }
  }
}

abstract class LogLocationEvent extends Equatable {
  const LogLocationEvent();
}

class GetLogRequested extends LogLocationEvent {
  final String userId;
  final double startTime;
  final double endTime;
  final double topRightLat;
  final double topRightLng;
  final double bottomLeftLat;
  final double bottomLeftLng;

  const GetLogRequested({
    this.userId,
    this.startTime,
    this.endTime,
    this.topRightLat,
    this.topRightLng,
    this.bottomLeftLat,
    this.bottomLeftLng,
  });

  @override
  // TODO: implement props
  List<Object> get props => [
        userId,
        startTime,
        endTime,
        topRightLat,
        topRightLng,
        bottomLeftLat,
        bottomLeftLng,
      ];
}

abstract class LogLocationState extends Equatable {
  const LogLocationState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LogLocationInitial extends LogLocationState {}

class LogLocationLoadInProgress extends LogLocationState {}

class LogLocationLoadSuccess extends LogLocationState {
  final List<LogLocationModel> listLogs;
  final List<String> locations;

  const LogLocationLoadSuccess({this.listLogs, this.locations});

  @override
  // TODO: implement props
  List<Object> get props => [listLogs, locations];
}

class LogLocationLoadFailure extends LogLocationState {}
