import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locaing_app/blocs/blocs.dart';
import 'package:locaing_app/data/model/model.dart';
import 'package:locaing_app/localizations.dart';
import 'package:locaing_app/res/colors.dart';
import 'package:locaing_app/res/images.dart';
import 'package:locaing_app/ui/widgets/widgets.dart';
import 'package:locaing_app/utils/device.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ListFriendsScreen extends StatefulWidget {
  bool iconBack;

  ListFriendsScreen({this.iconBack});

  @override
  _ListFriendsScreenState createState() => _ListFriendsScreenState();
}

class _ListFriendsScreenState extends State<ListFriendsScreen> {
  TextEditingController _textEditingController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<FriendBloc>(context).add(GetListFriend());
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BaseScreenMethod(
      iconBack: widget.iconBack == null ? true : false,
      title: 'list_friend.friends',
      body: BlocConsumer<FriendBloc, FriendState>(
        listener: (context, state) {
          if (state is RequestSuccessFriend) {
            // if(state.success!=null){
            //  // _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(state.success),),);
            // }

          }
        },
        builder: (context, state) {
          return Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        Divider(
                          height: 1,
                        ),
                        searchUI(),
                        listFriendUI(state.listFriend)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget searchUI() {
    return BlocConsumer<FriendBloc, FriendState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 0),
          padding: EdgeInsets.only(left: 8, right: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: AppTheme.dark_grey.withOpacity(0.1),
          ),
          child: Row(
            children: [
              Container(
                child: Icon(
                  Icons.search,
                  color: AppTheme.dark_grey.withOpacity(0.5),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: DeviceUtil.getDeviceWidth(context) - 100,
                height: 40,
                child: TextFormField(
                  maxLines: null,
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: Language.of(context)
                        .getText("list_friend.search_friend"),
                  ),
                  onChanged: (value) {
                    BlocProvider.of<FriendBloc>(context).add((FindFriend(value)));
                  },
                ),
              )
            ],
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget listFriendUI(List<ProfileUserModel> listFriend) {
    return Container(
      width: DeviceUtil.getDeviceWidth(context),
      margin: EdgeInsets.only(top: 16, left: 16, right: 0, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 16),
            child: Text(
              listFriend != null
                  ? listFriend.length.toString() +
                      " " +
                      Language.of(context)
                          .getText("list_friend.friends")
                          .toLowerCase()
                  : "",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: DeviceUtil.getDeviceHeight(context) - 170,
              minHeight: 70,
            ),
            //height:double.infinity,
            child: listFriend != null
                ? ListView.builder(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    itemCount: listFriend.length,
                    itemBuilder: (context, i) {
                      return (Column(
                        children: [
                          itemFriend(
                            listFriend[i],
                          ),
                        ],
                      ));
                    },
                  )
                : Container(
                    child: Text(
                      Language.of(context).getText("list_friend.empty_friend"),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget itemFriend(ProfileUserModel user) {
    print('Avatar: ${user.avatar_url}');
    return Container(
      // color: Colors.yellow,
      width: DeviceUtil.getDeviceWidth(context) - 16,
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                // color: Colors.blue,
                margin: EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: user.avatar_url != null
                      ? NetworkImage(user.avatar_url)
                      : AssetImage(
                    AppImages.DEFAULT_AVATAR,
                  ),
                ),
              ),
              (user.activeStatus == 1) ? Positioned(
                right: 32,
                bottom: 12,
                child: CustomPaint(
                  painter: DotPainter(color: AppTheme.statusOn, width: 14,),
                ),
              ) : Container(),
            ],
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Text(
                user.userName,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              FocusScope.of(context).unfocus();
              showBottomSheet(user);
            },
            padding: EdgeInsets.zero,
          )
        ],
      ),
    );
  }

  void showBottomSheet(ProfileUserModel user) {
    showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (builder) {
        return BottomOptionFriend(user);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }
}

class BottomOptionFriend extends StatelessWidget {
  final ProfileUserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
      ),
      child: Wrap(
        children: [
          Container(
            padding: EdgeInsets.only(top: 12, bottom: 4, left: 16, right: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(AppImages.INTRO_2),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        user.userName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
              child: Divider(
            thickness: 1,
          )),
          Container(
            padding: EdgeInsets.only(left: 16, right: 18),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: item(context,
                      icon: Icons.person_remove_outlined,
                      title: "list_friend.un_friend",
                      description: "list_friend.des_unfriend", function: () {
                    String uuidMe = BlocProvider.of<ProfileBloc>(context)
                        .state
                        .profileUser
                        .uuid;
                    BlocProvider.of<FriendBloc>(context).add(
                      DeleteFriend(uuidMe, user.uuid),
                    );
                    BlocProvider.of<FriendBloc>(context).add(GetListFriend());
                    Navigator.pop(context);
                  }),
                ),
                item(context,
                    icon: Icons.star,
                    title: "list_friend.remove_best_friend",
                    description: "list_friend.des_remove_best_friend",
                    color: user.friendship == 0 ? null : AppTheme.yellowRed,
                    function: () {
                  String uuidMe = BlocProvider.of<ProfileBloc>(context)
                      .state
                      .profileUser
                      .uuid;
                  BlocProvider.of<FriendBloc>(context).add(
                    SetCloseFriend(uuidMe, user.uuid),
                  );
                  BlocProvider.of<FriendBloc>(context).add(GetListFriend());
                  Navigator.pop(context);
                })
              ],
            ),
          )
        ],
      ),
    );
  }

  BottomOptionFriend(this.user);
  Widget item(BuildContext context,
      {String title,
      String description,
      IconData icon,
      Color color,
      Function function}) {
    return InkWell(
      onTap: () {
        function();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 8),
              child: Icon(
                icon,
                size: 25,
                color: color == null ? null : color,
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 4),
                    child: Text(
                      Language.of(context).getText(title),
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    child: Text(
                      Language.of(context).getText(description),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.grey_500,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
