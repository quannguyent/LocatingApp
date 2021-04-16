import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../constants.dart';
import '../localizations.dart';
import '../utils/common.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(InitialAppState());

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is ChangeLanguage) {
      String language = await Common.getLanguage();
      await LanguageDelegate().load(Locale(language));
      yield ChangeAppState(language: language, map: state.map);
    }
    if (event is ChangeTypeMap) {
      String typeMap = await Common.getTypeMap();
      yield ChangeAppState(language: state.language, map: typeMap);
    }
  }
}

abstract class AppState extends Equatable {
  final String language;
  final String map;

  const AppState({this.language, this.map});
  @override
  // TODO: implement props
  List<Object> get props => [language, map];
}

class InitialAppState extends AppState {
  InitialAppState() : super(language: Constants.VI, map: "Terrain");
}

class ChangeAppState extends AppState {
  final String language;
  final String map;

  const ChangeAppState({this.language, this.map})
      : super(language: language, map: map);

  @override
  // TODO: implement props
  List<Object> get props => [language, map];
}

abstract class AppEvent extends Equatable {}

class ChangeTypeMap extends AppEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ChangeLanguage extends AppEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
