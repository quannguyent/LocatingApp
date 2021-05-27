import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/io_client.dart';
import 'package:locaing_app/blocs/blocs.dart';
import 'package:locaing_app/blocs/chat_bloc.dart';
import 'package:locaing_app/blocs/profile_bloc.dart';
import 'package:locaing_app/data/model/model.dart';
import 'package:locaing_app/localizations.dart';
import 'package:locaing_app/res/colors.dart';
import 'package:locaing_app/res/images.dart';
import 'package:locaing_app/ui/widgets/widgets.dart';
import 'package:locaing_app/utils/device.dart';
import 'package:signalr_core/signalr_core.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    ProfileUserModel user;
    user = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        // resizeToAvoidBottomPadding: false,
        body: BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(null),
          child: Container(
            width: DeviceUtil.getDeviceWidth(context),
            height: DeviceUtil.getDeviceHeight(context),
            child: Column(
              children: [
                AppbarWidget(user),
                BodyWidget(user),
              ],
            ),
          ),
        ));
  }
}

class AppbarWidget extends StatefulWidget {
  ProfileUserModel user;

  @override
  _AppbarWidgetState createState() => _AppbarWidgetState();

  AppbarWidget(this.user);
}

class _AppbarWidgetState extends State<AppbarWidget> {
  String time = '';
  int activeStatus;
  Timer timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String getTime(double lastUpdate) {
    double now = DateTime.now().millisecondsSinceEpoch / 1000;
    double second = now - lastUpdate;
    String online = Language.of(context).getText('chat.online');
    String hourUnit = Language.of(context).getText('chat.hour');
    String minuteUnit = Language.of(context).getText('chat.minute');
    String ago = Language.of(context).getText('chat.ago');

    String time;
    if (second < 60) {
      time = "$online 1 $minuteUnit $ago";
    } else if (second >= 60 && second < 60 * 60) {
      int minute = second ~/ 60;
      time = "$online $minute $minuteUnit $ago";
    } else if (second >= 60 * 60 && second < 24 * 60 * 60) {
      int hour = second ~/ (60 * 60);
      int minute = (second % (60 * 60)) ~/ 60;
      time = "$online $hour $hourUnit $minute $minuteUnit $ago";
    } else {
      time = '';
    }
    return time;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendProfileBloc, FriendProfileState>(
      builder: (context, state) {
        if (state.friendProfile == null) {
          activeStatus = widget.user.activeStatus;
        } else {
          activeStatus = state.friendProfile.activeStatus;
          double lastUpdate = state.friendProfile.lastTimeUpdateStatus;
          time = getTime(lastUpdate);
        }
        return Container(
          width: DeviceUtil.getDeviceWidth(context),
          height: 0.1 * DeviceUtil.getDeviceHeight(context),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                offset: const Offset(0, 2),
                blurRadius: 4.0,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 45,
                child: Container(
                    width: DeviceUtil.getDeviceWidth(context),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 8),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    NetworkImage(widget.user.avatar_url),
                              ),
                            ),
                            (activeStatus == 1)
                                ? Positioned(
                                    right: 22,
                                    bottom: 12,
                                    child: CustomPaint(
                                      painter: DotPainter(
                                        color: AppTheme.statusOn,
                                        width: 14,
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                widget.user.userName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              margin: EdgeInsets.only(bottom: 5),
                            ),
                            (activeStatus == 0)
                                ? Text(
                                    time.toString(),
                                    style: TextStyle(
                                      color: AppTheme.darkText.withOpacity(0.5),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ],
                    )),
              ),
              Positioned(
                left: 20,
                child: Container(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: AppTheme.deactivatedText,
                      size: 20,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class BodyWidget extends StatefulWidget {
  final ProfileUserModel user;

  BodyWidget(this.user);

  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  ScrollController _listViewController = ScrollController();
  TextEditingController textEditingController = new TextEditingController();
  final connection = HubConnectionBuilder()
      .withUrl(
        'http://192.168.1.140:44323/conversation-hub',
        HttpConnectionOptions(
          client: IOClient(
              HttpClient()..badCertificateCallback = (x, y, z) => true),
          logging: (level, message) => print(message),
        ),
      )
      .build();
  Future<List<MessageModel>> connectHubChat(
      String uuidMe, String uuidFriend) async {
    List<MessageModel> data;
    await connection.start();
    connection.on(
      'ReceiveMessage',
      (message) {
        print(message.toString());
        data = (message[0]['data'] as List)
            .map((e) => MessageModel.fromJson(e))
            .toList();
        List<MessageModel> dataReversed = data.reversed.toList();
        BlocProvider.of<ChatBloc>(context).add(GetListChatEvent(dataReversed));
      },
    );
    await connection.invoke(
      'ReceiveMessage',
      args: [
        uuidMe,
        uuidFriend,
        BlocProvider.of<ChatBloc>(context).state.listChat.length,
        connection.connectionId,
      ],
    );

    await connection.invoke(
      'SetConnectionId',
      args: [
        uuidMe,
        connection.connectionId,
      ],
    );

    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String uuidMe =
        BlocProvider.of<ProfileBloc>(context).state.profileUser.uuid;
    connectHubChat(uuidMe, widget.user.uuid);
    Timer(
      Duration(milliseconds: 500),
      () => jumpBottomChat(),
    );
  }

  void jumpBottomChat() {
    if (BlocProvider.of<ChatBloc>(context).state.listChat.length >= 20) {
      _listViewController.animateTo(
          _listViewController.position.maxScrollExtent + 40,
          duration: Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    connection.stop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is SendSuccess) {
          jumpBottomChat();
        }
      },
      builder: (context, state) {
        return GestureDetector(
            onVerticalDragUpdate: (details) {
              int sensitivity = 8;
              if (details.delta.dy > sensitivity) {
                // Down Swipe
                FocusScope.of(context).unfocus();
              }
            },
            child: Container(
              height: 0.9 * DeviceUtil.getDeviceHeight(context),
              child: Scaffold(
                // resizeToAvoidBottomPadding: false, // this avoids the overflow error
                body: Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  width: DeviceUtil.getDeviceWidth(context),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                  ),
                  child: SingleChildScrollView(
                    child: Stack(
                      alignment: Alignment.center,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.only(bottom: 60),
                          width: DeviceUtil.getDeviceWidth(context),
                          height: 0.9 * DeviceUtil.getDeviceHeight(context),
                          // decoration: BoxDecoration(color: Colors.yellow),
                          child: RefreshIndicator(
                            onRefresh: () async {
                              String uuidMe =
                                  BlocProvider.of<ProfileBloc>(context)
                                      .state
                                      .profileUser
                                      .uuid;
                              BlocProvider.of<ChatBloc>(context).add(
                                EventLoadMore(
                                  uuidMe,
                                  widget.user.uuid,
                                  connection,
                                  state.listChat,
                                ),
                              );
                            },
                            child: ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.only(bottom: 10),
                              controller: _listViewController,
                              //reverse: true,
                              shrinkWrap: true,
                              itemCount: state.listChat.length,
                              itemBuilder: (context, index) {
                                bool showAvatar = true;
                                if (index < state.listChat.length - 1) {
                                  showAvatar = checkShowAvatar(
                                      state.listChat[index].senderId,
                                      state.listChat[index + 1].senderId);
                                }
                                return ItemChat(
                                  state.listChat[index].senderId,
                                  widget.user,
                                  content: state.listChat[index].reply,
                                  isShowAvatar: showAvatar,
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          child: Wrap(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(left: 20),
                                width: DeviceUtil.getDeviceWidth(context) * 0.9,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width:
                                          DeviceUtil.getDeviceWidth(context) *
                                              0.7,
                                      child: TextFormField(
                                        controller: textEditingController,
                                        onTap: () {},
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                        maxLines: 3,
                                        minLines: 1,
                                        cursorColor: AppTheme.buildLightTheme()
                                            .primaryColor,
                                        decoration: InputDecoration(
                                          hintText: Language.of(context)
                                              .getText('chat.hint_message'),
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppTheme.deactivatedText
                                                .withOpacity(0.6),
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        onChanged: (value) {},
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(),
                                      alignment: Alignment.center,
                                      width:
                                          DeviceUtil.getDeviceWidth(context) *
                                                  0.2 -
                                              20,
                                      child: InkWell(
                                        onTap: () {
                                          // FocusScope.of(context).unfocus();
                                          if (textEditingController
                                              .text.isNotEmpty) {
                                            String uuidMe =
                                                BlocProvider.of<ProfileBloc>(
                                                        context)
                                                    .state
                                                    .profileUser
                                                    .uuid;
                                            BlocProvider.of<ChatBloc>(context)
                                                .add(
                                              SendChatEvent(
                                                uuidMe,
                                                widget.user.uuid,
                                                textEditingController.text
                                                    .toString()
                                                    .trim(),
                                              ),
                                            );
                                            textEditingController.text = "";
                                          }
                                        },
                                        child: FaIcon(
                                          FontAwesomeIcons.paperPlane,
                                          size: 20,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
      },
    );
  }
}

bool checkShowAvatar(String id1, String id2) {
  if (id1 == id2)
    return false;
  else
    return true;
}

class ItemChat extends StatefulWidget {
  String senderId;
  String imageAvatar;
  String content;
  ProfileUserModel user;
  bool isShowAvatar;

  ItemChat(this.senderId, this.user,
      {this.imageAvatar, this.content, this.isShowAvatar});

  @override
  _ItemchatState createState() => _ItemchatState();
}

class _ItemchatState extends State<ItemChat> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 14, top: 2, bottom: 2),
      alignment: widget.senderId ==
              BlocProvider.of<ProfileBloc>(context).state.profileUser.uuid
          ? Alignment.centerRight
          : Alignment.bottomLeft,
      width: DeviceUtil.getDeviceWidth(context),
      child: widget.senderId ==
              BlocProvider.of<ProfileBloc>(context).state.profileUser.uuid
          ? Wrap(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(2),
                    ),
                  ),
                  child: Text(
                    widget.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    // margin: EdgeInsets.only(right: 14),
                    child: widget.isShowAvatar == true
                        ? CircleAvatar(
                            radius: 15.0,
                            backgroundImage: widget.user.avatar_url != null
                                ? NetworkImage(widget.user.avatar_url)
                                : AssetImage(AppImages.DEFAULT_AVATAR),
                          )
                        : Container(
                            //child: Text(""),
                            //  margin: EdgeInsets.only(left: 19),
                            ),
                  ),
                ),
                Expanded(
                    flex: 7,
                    child: Wrap(
                      children: [
                        Container(
                          width: DeviceUtil.getDeviceWidth(context) / 2,
                          // not me
                          //  margin: EdgeInsets.only(bottom: 4),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(14),
                              topRight: Radius.circular(14),
                              bottomRight: Radius.circular(14),
                              bottomLeft: Radius.circular(2),
                            ),
                          ),
                          child: Text(
                            widget.content,
                            style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.deactivatedText,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
    );
  }
}
