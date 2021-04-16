import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/model/model.dart';
import '../data/network/network.dart';
import '../data/repository/repository.dart';

class HomeEvent {}

class ShowBottomPerson extends HomeEvent {
  String idUser;

  ShowBottomPerson(this.idUser);
}

class SelectFriend extends HomeEvent {
  ProfileUserModel user;

  SelectFriend({this.user});
}

class HomeState {
  String hashLinkLocation;
  ProfileUserModel user;
  HomeState({this.hashLinkLocation, this.user});
}

class InitHomeState extends HomeState {
  InitHomeState() : super(hashLinkLocation: null, user: null);
}

class GetPersonSuccess extends HomeState {
  GetPersonSuccess.fromOldState(
    HomeState oldState, {
    String hashLinkLocation,
    ProfileUserModel user,
  }) : super(
          hashLinkLocation: hashLinkLocation ?? oldState.hashLinkLocation,
          user: user ?? oldState.user,
        );
}

class LoadingHome extends HomeState {
  LoadingHome.fromOldState(
    HomeState oldState, {
    String hashLinkLocation,
    ProfileUserModel user,
  }) : super(
          hashLinkLocation: hashLinkLocation ?? oldState.hashLinkLocation,
          user: user ?? oldState.user,
        );
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(HomeState initialState) : super(InitHomeState());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is SelectFriend) {
      yield GetPersonSuccess.fromOldState(state, user: event.user);
    }
    if (event is ShowBottomPerson) {
      print("load user");
      yield LoadingHome.fromOldState(state);
      try {
        ApiResponse response =
            await ServiceRepository().shareLocation(event.idUser);
        if (response.resultCode == 1) {
          String hashCode = response.data["hash_code"];
          print(hashCode);
          yield GetPersonSuccess.fromOldState(state,
              hashLinkLocation: hashCode);
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
