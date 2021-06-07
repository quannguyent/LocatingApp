import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locaing_app/blocs/blocs.dart';
import 'package:locaing_app/data/model/model.dart';
import 'package:locaing_app/localizations.dart';
import 'package:locaing_app/res/resources.dart';
import 'package:locaing_app/routes.dart';
import 'package:locaing_app/ui/widgets/widgets.dart';
import 'package:locaing_app/utils/common.dart';
import 'package:locaing_app/utils/utils.dart';

class PlaceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<ProfileUserModel> friends =
        BlocProvider.of<FriendBloc>(context).state.listFriend;
    return BaseScreenMethod(
      title: "home.register_place",
      body: Container(
        color: AppTheme.white,
        height: DeviceUtil.getDeviceHeight(context),
        width: DeviceUtil.getDeviceWidth(context),
        child: Column(
          children: [
            Divider(
              height: 2,
              color: AppTheme.darkBlue.withOpacity(0.5),
            ),
            Container(
              width: DeviceUtil.getDeviceWidth(context),
              height: DeviceUtil.getDeviceHeight(context) / 4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages.MAP),
                  colorFilter: ColorFilter.mode(
                    Colors.red.withOpacity(0.5),
                    BlendMode.dst,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 20,
                bottom: 20,
              ),
              child: Center(
                child: Text(
                  Language.of(context).getText('register_place.description'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            friends == null
                ? Container()
                : Expanded(
                    child: Container(
                      child: ListView.builder(
                        itemCount: friends.length,
                        itemBuilder: (context, index) =>
                            itemFriend(context, friends[index]),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget itemFriend(BuildContext context, ProfileUserModel friend) {
    Color color = AppTheme.grey_500;
    ImageProvider avatar;
    if (friend != null) {
      if (friend.avatar != null) {
        avatar = NetworkImage(Common.getAvatarUrl(friend.avatar));
      } else {
        avatar = AssetImage(AppImages.DEFAULT_AVATAR);
      }
    } else {
      avatar = AssetImage(AppImages.DEFAULT_AVATAR);
    }
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.registerPlaceScreen,
              arguments: friend.uuid,
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              children: [
                Flexible(
                  flex: 9,
                  child: Row(
                    children: [
                      Container(
                          child: CircleAvatar(
                        radius: 24,
                        backgroundImage: avatar,
                        backgroundColor: Colors.white,
                      )),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        padding: EdgeInsets.all(4.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              friend.username,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.add,
                    color: color,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
        ),
      ],
    );
  }
}
