import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locaing_app/utils/common.dart';
import '../data/model/model.dart';
import '../data/network/network.dart';
import '../data/repository/repository.dart';

class ProfileEvent {}

class GetProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  String email;
  String firstName;
  String lastName;
  String status;
  String oldPassword;
  String newPassword;
  String retypeNewPassword;
  String id;
  String phoneNumber;
  File image;

  UpdateProfileEvent(
    this.email,
    this.firstName,
    this.lastName,
    this.status,
    this.oldPassword,
    this.newPassword,
    this.retypeNewPassword,
    this.id,
    this.phoneNumber, {
    this.image,
  });
}

class ProfileState {
  ProfileUserModel profileUser = new ProfileUserModel();
  String error = "1111";
  String success;
  ProfileState({this.profileUser, this.error, this.success});
}

class UpdateSuccess extends ProfileState {}

class UpdateError extends ProfileState {
  UpdateError.fromOldState(
    ProfileState oldState, {
    ProfileUserModel profile,
    String error,
    String success,
  }) : super(
          profileUser: profile ?? oldState.profileUser,
          error: error ?? oldState.error,
          success: success ?? oldState.success,
        );
}

class InitProFileUser extends ProfileState {
  InitProFileUser()
      : super(
          profileUser: new ProfileUserModel(
            id: "",
            userName: "",
            firstName: "",
            lastName: "",
            email: "",
            status: "",
            avatar_url: null,
            phone: "",
            uuid: "",
          ),
          error: null,
          success: null,
        );
}

class LoadingProfile extends ProfileState {
  LoadingProfile.fromOldState(
    ProfileState oldState, {
    ProfileUserModel profile,
    String error,
    String success,
  }) : super(
          profileUser: profile ?? oldState.profileUser,
          error: error ?? oldState.error,
          success: success ?? oldState.success,
        );
}

class GetProfileState extends ProfileState {
  GetProfileState.fromOldState(
    ProfileState oldState, {
    ProfileUserModel profile,
    String error,
    String success,
  }) : super(
          profileUser: profile ?? oldState.profileUser,
          error: error ?? oldState.error,
          success: success ?? oldState.success,
        );
}

class UpdateProfile extends ProfileState {
  UpdateProfile.fromOldState(
    ProfileState oldState, {
    ProfileUserModel profile,
    String error,
    String success,
  }) : super(
          profileUser: profile ?? oldState.profileUser,
          error: error ?? oldState.error,
          success: success ?? oldState.success,
        );
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ServiceRepository serviceRepository = new ServiceRepository();

  ProfileBloc(ProfileState initialState) : super(InitProFileUser());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is GetProfileEvent) {
      yield LoadingProfile.fromOldState(state);
      try {
        String token = await Common.getToken();
        ApiResponse response =
            await serviceRepository.getProfileUser(token: token);
        print("xxxxxx response in profile_bloc $response");
        if (response.resultCode == 1) {
          ProfileUserModel profileUserModel =
              ProfileUserModel.fromJson(response.data);
          Common.setUserId(profileUserModel.uuid);
          yield GetProfileState.fromOldState(state, profile: profileUserModel);
        } else {
          //error
          yield GetProfileState.fromOldState(state,
              error: response.message.toString());
        }
      } catch (e) {
        print(e.toString());
      }
    }
    if (event is UpdateProfileEvent) {
      print('update');
      yield LoadingProfile.fromOldState(state);
      try {
        var response = await serviceRepository.updateProfile(
          event.email,
          event.firstName,
          event.lastName,
          event.status,
          event.oldPassword,
          event.newPassword,
          event.retypeNewPassword,
          event.id,
          event.phoneNumber,
          image: event.image != null ? event.image : null,
        );
        if (response['code'] == 1) {
          ProfileUserModel profileUserModel =
              ProfileUserModel.fromJson(response['data']);
          yield UpdateProfile.fromOldState(state,
              profile: profileUserModel,
              success: response['message'].toString());
        } else {
          print(response['message'].toString());
          yield UpdateError.fromOldState(state,
              error: response['message'].toString());
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
