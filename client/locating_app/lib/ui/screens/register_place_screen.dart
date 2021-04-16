import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:locaing_app/blocs/blocs.dart';
import 'package:locaing_app/data/model/model.dart';
import 'package:locaing_app/localizations.dart';
import 'package:locaing_app/res/resources.dart';
import 'package:locaing_app/ui/widgets/widgets.dart';
import 'package:locaing_app/utils/utils.dart';

import '../../routes.dart';

class RegisterPlaceScreen extends StatefulWidget {
  final String friendId;
  const RegisterPlaceScreen({Key key, @required this.friendId})
      : super(key: key);
  @override
  _RegisterPlaceScreenState createState() => _RegisterPlaceScreenState();
}

class _RegisterPlaceScreenState extends State<RegisterPlaceScreen> {
  List<Widget> listViews = <Widget>[];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PlaceBloc>(context)
        .add(PlaceRequested(friendId: widget.friendId));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreenMethod(
      title: "home.register_place",
      iconBack: true,
      body: BlocBuilder<PlaceBloc, PlaceState>(
        builder: (context, state) {
          // if (state is PlaceInitial || state is PlaceLoadInProgress) {
          //   return Container();
          // }
          // if (state is PlaceLoadSuccess) {
          //
          // }
          // return Center();

          listViews.clear();
          if (state.listPlaces != null) {
            for (int i = 0; i < state.listPlaces.length; i++) {
              listViews.add(itemAddPlace(
                  friendId: widget.friendId,
                  placeId: state.listPlaces[i].id,
                  place: state.listPlaces[i].name,
                  icon: Icons.home,
                  index: i,
                  onTap: () {
                    Navigator.pushNamed(
                        context, Routes.registerPlaceDetailScreen,
                        arguments: Arguments(
                            friendId: widget.friendId,
                            place: state.listPlaces[i]));
                  }));
            }
          }
          listViews.add(addPlace(widget.friendId));

          return Container(
            color: AppTheme.white,
            height: DeviceUtil.getDeviceHeight(context),
            width: DeviceUtil.getDeviceWidth(context),
            child: Column(
              children: [
                Divider(
                  height: 2,
                  color: AppTheme.darkBlue.withOpacity(0.5),
                ),
                new Container(
                  width: DeviceUtil.getDeviceWidth(context),
                  height: DeviceUtil.getDeviceHeight(context) / 4,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: AssetImage(AppImages.MAP),
                      colorFilter: new ColorFilter.mode(
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
                      Language.of(context)
                          .getText('register_place.description'),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: ListView.builder(
                      itemCount: listViews.length,
                      itemBuilder: (context, index) => listViews[index],
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

  Widget itemAddPlace({
    int index,
    String friendId,
    String place,
    String placeId,
    IconData icon,
    Function onTap,
  }) {
    Color color = AppTheme.grey_500;
    return Column(
      children: [
        Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: Row(
                      children: [
                        Icon(icon, color: color, size: 20),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          place == "add_place"
                              ? Language.of(context)
                                  .getText('register_place.$place')
                              : place,
                          style: TextStyle(
                              fontSize: 16,
                              color:
                                  place == "add_place" ? Colors.black : color),
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
          secondaryActions: [
            IconSlideAction(
              caption: Language.of(context).getText('register_place.delete'),
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => BlocProvider.of<PlaceBloc>(context).add(DeletePlace(
                  friendId: friendId, placeId: placeId, index: index)),
            ),
          ],
        ),
        Divider(
          height: 1,
        ),
      ],
    );
  }

  Widget addPlace(String friendId) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, Routes.registerPlaceDetailScreen,
                arguments: Arguments(friendId: widget.friendId, place: null));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 9,
                  child: Row(
                    children: [
                      Icon(Icons.add, color: AppTheme.nearlyBlue, size: 20),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        Language.of(context)
                            .getText('register_place.add_place'),
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
