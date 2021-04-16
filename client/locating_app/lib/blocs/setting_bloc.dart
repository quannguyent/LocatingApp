import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants.dart';
import '../data/model/model.dart';
import '../data/network/network.dart';
import '../data/repository/repository.dart';
import '../localizations.dart';
import '../utils/common.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  PushSettingRepository pushSettingRepository = new PushSettingRepository();

  SettingBloc() : super(InitialState());

  @override
  Stream<SettingState> mapEventToState(SettingEvent event) async* {
    // TODO: implement mapEventToState
    if (event is RequireLoadSetting) {
      //get setting from server
      ApiResponse response = await pushSettingRepository.getSetting();
      if (response.resultCode == 1) {
        SettingModel settingModel =
            SettingModel.fromJson(response.data[Constants.APP_NAME]);

        await Common.setRange(
          settingModel.range,
        );
        await Common.setEnableNotification(
          settingModel.notificationSettingModel.permissionNotification,
        );
        await Common.setUnit(settingModel.unit);
        await Common.setTypeMap(settingModel.mapType);
        await Common.setLanguage(settingModel.language);
        await LanguageDelegate().load(Locale(settingModel.language));

        yield PushSettingSuccess(
          state,
          permission:
              settingModel.notificationSettingModel.permissionNotification,
          range: settingModel.range,
          unit: settingModel.unit,
          mapType: settingModel.mapType,
          language: settingModel.language,
        );
      }
    }

    if (event is ChangeSettingNotification) {
      await Common.setEnableNotification(event.permission);
      yield PushSettingSuccess(
        state,
        permission: event.permission,
      );
      ApiResponse response = await pushSettingRepository.setting(
        permission: event.permission,
        range: state.range,
        unit: state.unit,
        mapType: state.mapType,
        language: state.language,
      );
    }

    if (event is ChangeRange) {
      await Common.setRange(event.range);
      yield PushSettingSuccess(
        state,
        range: event.range,
      );
      ApiResponse response = await pushSettingRepository.setting(
        permission: state.permission,
        range: event.range,
        unit: state.unit,
        mapType: state.mapType,
        language: state.language,
      );
    }

    if (event is ChangeUnit) {
      await Common.setUnit(event.unit);
      yield PushSettingSuccess(
        state,
        unit: event.unit,
      );
      ApiResponse response = await pushSettingRepository.setting(
        permission: state.permission,
        range: state.range,
        unit: event.unit,
        mapType: state.mapType,
        language: state.language,
      );
    }

    if (event is ChangeMapType) {
      await Common.setTypeMap(event.mapType);
      yield PushSettingSuccess(state, mapType: event.mapType);
      ApiResponse response = await pushSettingRepository.setting(
        permission: state.permission,
        range: state.range,
        unit: state.unit,
        mapType: event.mapType,
        language: state.language,
      );
    }

    if (event is ChangeLanguageSetting) {
      await Common.setLanguage(event.language);
      await LanguageDelegate().load(Locale(event.language));
      yield PushSettingSuccess(state, language: event.language);
      ApiResponse response = await pushSettingRepository.setting(
        permission: state.permission,
        range: state.range,
        unit: state.unit,
        mapType: state.mapType,
        language: event.language,
      );
    }
  }
}

abstract class SettingEvent extends Equatable {
  const SettingEvent();
}

class RequireLoadSetting extends SettingEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ChangeSettingNotification extends SettingEvent {
  final bool permission;
  ChangeSettingNotification({this.permission});

  @override
  // TODO: implement props
  List<Object> get props => [permission];
}

class ChangeRange extends SettingEvent {
  final int range;

  ChangeRange({this.range});

  @override
  // TODO: implement props
  List<Object> get props => [range];
}

class ChangeUnit extends SettingEvent {
  final String unit;

  ChangeUnit({this.unit});

  @override
  // TODO: implement props
  List<Object> get props => [unit];
}

class ChangeMapType extends SettingEvent {
  final String mapType;

  ChangeMapType(this.mapType);

  @override
  // TODO: implement props
  List<Object> get props => [mapType];
}

class ChangeLanguageSetting extends SettingEvent {
  final String language;

  ChangeLanguageSetting(this.language);

  @override
  // TODO: implement props
  List<Object> get props => [language];
}

abstract class SettingState extends Equatable {
  final bool permission;
  final int range;
  final String unit;
  final String mapType;
  final String language;

  SettingState({
    this.permission,
    this.range,
    this.unit,
    this.mapType,
    this.language,
  });

  @override
  // TODO: implement props
  List<Object> get props => [permission, range, unit, mapType, language];
}

class InitialState extends SettingState {
  InitialState() : super();
}

class PushSettingSuccess extends SettingState {
  PushSettingSuccess(
    SettingState oldState, {
    permission,
    range,
    unit,    
    mapType,
    language,
  }) : super(
          permission: permission ?? oldState.permission,
          range: range ?? oldState.range,
          unit: unit ?? oldState.unit,
          mapType: mapType ?? oldState.mapType,
          language: language ?? oldState.language,
        );
  @override
  // TODO: implement props
  List<Object> get props => [permission, range, unit, mapType, language];
}
