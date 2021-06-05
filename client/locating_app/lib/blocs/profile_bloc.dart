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
  String username;
  String email;
  String displayname;
  String status;
  String phoneNumber;
  String oldPassword;
  String newPassword;
  int sexId;
  File image;

  UpdateProfileEvent(
    this.username,
    this.email,
    this.displayname,
    this.status,
    this.phoneNumber,
    this.oldPassword,
    this.newPassword,
    this.sexId,
    {
      this.image,
    }
  );
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
            id: 0,
            username: "",
            displayName: "",
            email: "",
            status: "",
            avatar: null,
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
        ApiResponse response = await serviceRepository.getProfileUser();
        if (response.resultCode == 1) {
          ProfileUserModel profileUserModel = ProfileUserModel.fromJson(response.data);
          Common.setUserId(profileUserModel.id.toString());
          yield GetProfileState.fromOldState(state, profile: profileUserModel);
        } else {
          //error
          yield GetProfileState.fromOldState(
            state,
            error: response.message.toString()
          );
        }
      } catch (e) {
        print(e.toString());
      }
    }
    if (event is UpdateProfileEvent) {
      yield LoadingProfile.fromOldState(state);
      try {
        var isError = false;
        var message = '';

        if (event.oldPassword.isNotEmpty
        && event.newPassword.isNotEmpty) {
          ApiResponse passwordResponse = await serviceRepository.updatePassword(
            event.oldPassword,
            event.newPassword,
          );

          if (passwordResponse.resultCode != 1) {
            isError = true;
            message = 'update_password';
          }
        }

        if (!isError && event.username.isNotEmpty) {
          ApiResponse response = await serviceRepository.updateProfile(
            event.username,
            event.email,
            event.displayname,
            event.status,
            event.phoneNumber,
            event.sexId,
            image: event.image != null ? event.image : null,
          );

          if (response.resultCode == 1) {
            ProfileUserModel profileUserModel =
                ProfileUserModel.fromJson(response.data);
            yield UpdateProfile.fromOldState(state,
                profile: profileUserModel,
                success: response.message.toString());
          } else {
            isError = true;
            message = 'update_profile';
          }
        }

        if (isError) {
          yield UpdateError.fromOldState(state,
            error: message
          );
        }
        
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
