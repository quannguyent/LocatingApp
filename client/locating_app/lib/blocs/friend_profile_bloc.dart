import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locaing_app/data/model/model.dart';
import 'package:locaing_app/data/network/network.dart';
import 'package:locaing_app/data/repository/repository.dart';

class FriendProfileBloc extends Bloc<FriendProfileEvent, FriendProfileState> {
  ServiceRepository serviceRepository = ServiceRepository();
  FriendProfileBloc() : super(FriendProfileInitial());

  @override
  Stream<FriendProfileState> mapEventToState(event) async* {
    if (event is FriendProfileRequired) {
      yield FriendProfileLoadInProgress.fromOldState(state);
      try {
        final ApiResponse data =
            await serviceRepository.getProfileUuId(event.userId);
        if (data.resultCode == 1) {
          ProfileUserModel profileUser = ProfileUserModel.fromJson(data.data);
          print(profileUser.userName);
          yield FriendProfileLoadSuccess.fromOldState(state,
              friendProfile: profileUser);
        }
      } catch (err) {
        yield FriendProfileLoadFailure();
      }
    }
  }
}

abstract class FriendProfileEvent extends Equatable {
  const FriendProfileEvent();
}

class FriendProfileRequired extends FriendProfileEvent {
  final String userId;
  FriendProfileRequired(this.userId);

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

abstract class FriendProfileState extends Equatable {
  final ProfileUserModel friendProfile;
  const FriendProfileState({this.friendProfile});

  @override
  // TODO: implement props
  List<Object> get props => [friendProfile];
}

class FriendProfileInitial extends FriendProfileState {
  FriendProfileInitial() : super(friendProfile: null);
}

class FriendProfileLoadInProgress extends FriendProfileState {
  FriendProfileLoadInProgress.fromOldState(
    FriendProfileState oldState, {
    ProfileUserModel friendProfile,
  }) : super(
          friendProfile: friendProfile ?? oldState.friendProfile,
        );
}

class FriendProfileLoadSuccess extends FriendProfileState {
  FriendProfileLoadSuccess.fromOldState(
    FriendProfileState oldState, {
    ProfileUserModel friendProfile,
  }) : super(
          friendProfile: friendProfile ?? oldState.friendProfile,
        );
}

class FriendProfileLoadFailure extends FriendProfileState {}
