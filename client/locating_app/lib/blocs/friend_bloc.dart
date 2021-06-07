import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locaing_app/data/model/model.dart';
import 'package:locaing_app/data/network/api_response.dart';
import 'package:locaing_app/data/repository/repository.dart';
import 'package:locaing_app/utils/common.dart';
import 'dart:developer' as dev;

class FriendEvent {}

class GetListFriend extends FriendEvent {
  String idMe;
}

class FindFriend extends FriendEvent {
  String name;

  FindFriend(this.name);
}

class SetCloseFriend extends FriendEvent {
  String uuidMe, uuidFriend;
  SetCloseFriend(this.uuidMe, this.uuidFriend);
}

class DeleteFriend extends FriendEvent {
  String uuidMe, uuidFriend;
  DeleteFriend(this.uuidMe, this.uuidFriend);
}

class DeleteCloseFriend extends FriendEvent {}

class PhoneExistRequested extends FriendEvent {
  String uuidMe;
  List<String> phones;
  bool isSearch;
  PhoneExistRequested({this.phones, this.uuidMe, this.isSearch});
}

class PhoneExistMoreRequested extends FriendEvent {
  String uuidMe;
  List<String> phones;
  PhoneExistMoreRequested({this.phones, this.uuidMe});
}

class RequireAddFriend extends FriendEvent {
  int idFriend;
  RequireAddFriend({this.idFriend});
}

class FindFriendByPhone extends FriendEvent {
  String search;
  FindFriendByPhone({this.search});
}

class FriendState {
  List<ProfileUserModel> listFriend;
  List<ProfileUserModel> listCloseFriend;
  String success;
  String error;
  List<ProfileUserModel> users;
  List<String> phones;

  FriendState({
    this.success,
    this.error,
    this.listCloseFriend,
    this.listFriend,
    this.users,
    this.phones,
  });
}

class InitFriendState extends FriendState {
  InitFriendState()
      : super(
          success: null,
          error: null,
          listFriend: null,
          listCloseFriend: null,
          users: [],
          phones: null,
        );
}

class RequestSuccessFriend extends FriendState {
  RequestSuccessFriend.fromOldState(
    FriendState oldStare, {
    List<ProfileUserModel> listFriend,
    List<ProfileUserModel> listCloseFriend,
    String success,
    String error,
    List<ProfileUserModel> users,
    List<String> phones,
  }) : super(
          listFriend: listFriend ?? oldStare.listFriend,
          listCloseFriend: listCloseFriend ?? oldStare.listCloseFriend,
          success: success ?? oldStare.success,
          error: error ?? oldStare.error,
          users: users ?? oldStare.users,
          phones: phones ?? oldStare.phones,
        );
}

class PhoneLoadSuccess extends FriendState {
  PhoneLoadSuccess.fromOldState(
    FriendState oldStare, {
    List<ProfileUserModel> listFriend,
    List<ProfileUserModel> listCloseFriend,
    String success,
    String error,
    List<ProfileUserModel> users,
    List<String> phones,
  }) : super(
          listFriend: listFriend ?? oldStare.listFriend,
          listCloseFriend: listCloseFriend ?? oldStare.listCloseFriend,
          success: success ?? oldStare.success,
          error: error ?? oldStare.error,
          users: users ?? oldStare.users,
          phones: phones ?? oldStare.phones,
        );
}

class LoadingFriend extends FriendState {
  LoadingFriend.fromOldState(
    FriendState oldStare, {
    List<ProfileUserModel> listFriend,
    List<ProfileUserModel> listCloseFriend,
    String success,
    String error,
    List<ProfileUserModel> users,
    List<String> phones,
  }) : super(
          listFriend: listFriend ?? oldStare.listFriend,
          listCloseFriend: listCloseFriend ?? oldStare.listCloseFriend,
          success: success ?? oldStare.success,
          error: error ?? oldStare.error,
          users: users ?? oldStare.users,
          phones: phones ?? oldStare.phones,
        );
}

class LoadingMoreFriend extends FriendState {
  LoadingMoreFriend.fromOldState(
    FriendState oldStare, {
    List<ProfileUserModel> listFriend,
    List<ProfileUserModel> listCloseFriend,
    String success,
    String error,
    List<ProfileUserModel> users,
    List<String> phones,
  }) : super(
          listFriend: listFriend ?? oldStare.listFriend,
          listCloseFriend: listCloseFriend ?? oldStare.listCloseFriend,
          success: success ?? oldStare.success,
          error: error ?? oldStare.error,
          users: users ?? oldStare.users,
          phones: phones ?? oldStare.phones,
        );
}

class Refresh extends FriendState {
  Refresh.fromOldState(
    FriendState oldStare, {
    List<ProfileUserModel> listFriend,
    List<ProfileUserModel> listCloseFriend,
    String success,
    String error,
    List<ProfileUserModel> users,
    List<String> phones,
  }) : super(
          listFriend: listFriend ?? oldStare.listFriend,
          listCloseFriend: listCloseFriend ?? oldStare.listCloseFriend,
          success: success ?? oldStare.success,
          error: error ?? oldStare.error,
          users: users ?? oldStare.users,
          phones: phones ?? oldStare.phones,
        );
}

class FriendBloc extends Bloc<FriendEvent, FriendState> {
  FriendBloc(FriendBloc initialState) : super(InitFriendState());
  List<ProfileUserModel> listFriendAll;
  @override
  Stream<FriendState> mapEventToState(FriendEvent event) async* {
    if (event is GetListFriend) {
      yield LoadingFriend.fromOldState(state);
      try {
        ApiResponse response = await ServiceRepository().getListFriendRequest();
        if (response.resultCode == 1) {
          List<ProfileUserModel> listFriend = (response.data as List)
              .map((e) => ProfileUserModel.fromJson(e))
              .toList();
          listFriendAll = listFriend;
          List<ProfileUserModel> listCloseFriend = (response.data as List)
              .map((e) => ProfileUserModel.fromJson(e))
              .toList();
          listCloseFriend.removeWhere((item) => item.friendship == 0);
          yield RequestSuccessFriend.fromOldState(state,
              listFriend: listFriend, listCloseFriend: listCloseFriend);
        }
      } catch (e) {}
    }
    if (event is FindFriend) {
      yield LoadingFriend.fromOldState(state);
      List<ProfileUserModel> listFriend = state.listFriend;
      List<ProfileUserModel> filterUser = listFriend
          .where((item) => item.username.contains(event.name))
          .toList();
      yield RequestSuccessFriend.fromOldState(state, listFriend: filterUser);
      if (event.name.isEmpty) {
        yield RequestSuccessFriend.fromOldState(
          state,
          listFriend: listFriendAll,
        );
      }
    }
    if (event is SetCloseFriend) {
      yield LoadingFriend.fromOldState(state);
      try {
        ApiResponse response = await ServiceRepository()
            .setCloseFriend(event.uuidMe, event.uuidFriend);
        if (response.resultCode == 1) {
          String success = response.message;
          yield RequestSuccessFriend.fromOldState(state, success: success);
        } else {
          String error = response.message;
          yield RequestSuccessFriend.fromOldState(state, error: error);
        }
      } catch (e) {
        print(e.toString());
      }
    }
    if (event is DeleteFriend) {
      yield LoadingFriend.fromOldState(state);
      try {
        ApiResponse response = await ServiceRepository()
            .deleteFriend(event.uuidMe, event.uuidFriend);
        if (response.resultCode == 1) {
          List<ProfileUserModel> listFriend = (response.data as List)
              .map((e) => ProfileUserModel.fromJson(e))
              .toList();
          List<ProfileUserModel> listCloseFriends = listFriend;

          listFriendAll = listFriend;
          yield RequestSuccessFriend.fromOldState(
            state,
            listFriend: listFriend,
          );
        }
      } catch (e) {
        print(e.toString());
      }
    }
    if (event is PhoneExistRequested) {
      yield LoadingFriend.fromOldState(state);
      if (event.isSearch != null) {
        if (event.isSearch) {
          yield Refresh.fromOldState(state);
        }
      }

      try {
        // final List<ProfileUserModel> users =
        //     await AddFriendRepository().getPhoneUserExist(event.phones);
        var response = await ServiceRepository().getUsers(event.phones);

        // final Map mapResponse = json.decode(response);
        final List<ProfileUserModel> users = (response.data as List)
            .map((e) => ProfileUserModel.fromJson(e))
            .toList();

        // for (ProfileUserModel i in state.listFriend) {
        //   users.removeWhere((item) => item.id == i.id);
        // }
        // users.removeWhere((item) => item.id == int.parse(event.uuidMe));

        yield PhoneLoadSuccess.fromOldState(state, users: users, phones: event.phones);

      } catch (e) {
        print(e.toString());
      }
    }
    if (event is PhoneExistMoreRequested) {
      yield LoadingMoreFriend.fromOldState(state);
      try {
        final List<ProfileUserModel> users =
            await AddFriendRepository().getPhoneUserExist(event.phones);

        for (ProfileUserModel i in state.listFriend) {
          users.removeWhere((item) => item.uuid == i.uuid);
        }
        users.removeWhere((item) => item.uuid == event.uuidMe);
        yield PhoneLoadSuccess.fromOldState(state,
            users: users, phones: event.phones);
      } catch (e) {
        print(e.toString());
      }
    }
    if (event is RequireAddFriend) {
      yield LoadingFriend.fromOldState(state);
      try {
        ApiResponse response =
            await ServiceRepository().addFriend(event.idFriend);
        if (response.resultCode == 1) {
          yield RequestSuccessFriend.fromOldState(state,
              success: "add_friend_success");
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
