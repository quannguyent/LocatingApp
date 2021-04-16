import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/io_client.dart';
import 'package:locaing_app/data/model/message_model.dart';
import 'package:locaing_app/data/network/api_response.dart';
import 'package:locaing_app/data/repository/service_repository.dart';
import 'package:signalr_core/signalr_core.dart';

class ChatEvent {}

class GetListChatEvent extends ChatEvent {
  String uuidMe, uuidFriend;
  List<MessageModel> data;
  GetListChatEvent(this.data);
}

class EventLoadMore extends ChatEvent {
  String uuidMe, uuidFriend;
  HubConnection hubConnection;
  List<MessageModel> data;
  EventLoadMore(
    this.uuidMe,
    this.uuidFriend,
    this.hubConnection,
    this.data,
  );
}

class SendChatEvent extends ChatEvent {
  String uuidMe, uuidFriend, content;
  SendChatEvent(this.uuidMe, this.uuidFriend, this.content);
}

class ChatState {
  List<MessageModel> listChat;
  String error;
  int index;
  bool isRefresh;
  ChatState({this.listChat, this.error, this.index, this.isRefresh});
}

class InitChatState extends ChatState {
  InitChatState()
      : super(
          listChat: [],
          error: null,
          index: 1,
          isRefresh: false,
        );
}

class LoadingChat extends ChatState {
  LoadingChat.fromOldState(
    ChatState oldState, {
    List<MessageModel> listChat,
    String error,
    int index,
    bool isRefresh,
  }) : super(
          listChat: listChat ?? oldState.listChat,
          error: error ?? oldState.error,
          index: index ?? oldState.index,
          isRefresh: isRefresh ?? oldState.isRefresh,
        );
}

class GetChat extends ChatState {
  GetChat.fromOldState(
    ChatState oldState, {
    List<MessageModel> listChat,
    String error,
    int index,
    bool isRefresh,
  }) : super(
          listChat: listChat ?? oldState.listChat,
          error: error ?? oldState.error,
          index: index ?? oldState.index,
          isRefresh: isRefresh ?? oldState.isRefresh,
        );
}

class SendSuccess extends ChatState {
  SendSuccess.fromOldState(
    ChatState oldState, {
    List<MessageModel> listChat,
    String error,
    int index,
    bool isRefresh,
  }) : super(
          listChat: listChat ?? oldState.listChat,
          error: error ?? oldState.error,
          index: index ?? oldState.index,
          isRefresh: isRefresh ?? oldState.isRefresh,
        );
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(ChatState initialState) : super(InitChatState());

  Future<void> connectHubChat(
      String uuidMe, String uuidFriend, HubConnection connectionBuilder) async {
    await connectionBuilder.invoke('ReceiveMessage', args: [
      uuidMe,
      uuidFriend,
      state.listChat.length,
      connectionBuilder.connectionId,
    ]);
  }

  bool more = false;
  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is GetListChatEvent) {
      print('get chat');
      List<MessageModel> a = state.listChat;
      List<MessageModel> oldListChat = state.listChat;
      if (more == true) {
        a.reversed;
        oldListChat.insertAll(0, event.data);
      } else {
        oldListChat.addAll(event.data);
      }
      yield GetChat.fromOldState(
        state,
        listChat: oldListChat,
        isRefresh: false,
      );
      more = false;
    }
    if (event is EventLoadMore) {
      print('load more');
      yield GetChat.fromOldState(state, isRefresh: true);
      await connectHubChat(
        event.uuidMe,
        event.uuidFriend,
        event.hubConnection,
      );
      more = true;
    }
    if (event is SendChatEvent) {
      ApiResponse response = await ServiceRepository().sendChat(
        event.uuidMe,
        event.uuidFriend,
        event.content,
      );
      if (response.resultCode == 1) {
        yield SendSuccess.fromOldState(state);
      }
      if (response.resultCode != 1) {
        yield GetChat.fromOldState(state, error: response.message.toString());
      }
    }
  }
}
