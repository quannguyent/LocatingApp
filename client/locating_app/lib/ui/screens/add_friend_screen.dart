import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locaing_app/blocs/blocs.dart';
import 'package:locaing_app/data/model/model.dart';
import 'package:locaing_app/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../localizations.dart';
import '../../res/resources.dart';
import '../widgets/widgets.dart';

class AddFriendScreen extends StatefulWidget {
  @override
  _AddFriendScreenState createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  List<ProfileUserModel> users;
  List<String> _phones;
  List<Widget> listViews = <Widget>[];
  final List<PhoneNumber> _displayName = [];
  ScrollController controller;
  int divisions;
  int index;
  final int maxLength = 10;

  Future<List<String>> getContacts() async {
    List<String> phones = [];
    // Load without thumbnails initially.
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      contacts.forEach((contact) {
        if (contact.displayName != null) {
          contact.phones.forEach((phone) {
            _displayName.add(new PhoneNumber(
                name: contact.displayName,
                phone: phone.value.replaceAll(new RegExp('\\s'), '')));
            phones.add(phone.value.replaceAll(new RegExp('\\s'), ''));
          });
        }
      });
      return phones;
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.restricted) {
      Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.contacts]);
      return permissionStatus[PermissionGroup.contacts] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  void _scrollListener() {
    if (index < divisions) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        index++;
        List<String> phones = [];
        int length;
        if (index == divisions) {
          length = _phones.length;
        } else {
          length = maxLength * index;
        }
        for (int i = maxLength * (index - 1); i < length; i++) {
          phones.add(_phones[i]);
        }
        BlocProvider.of<FriendBloc>(context).add(PhoneExistMoreRequested(
          phones: phones,
          uuidMe: BlocProvider.of<ProfileBloc>(context).state.profileUser.uuid,
        ));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContacts().then((value) {
      _phones = value;
      index = 1;
      divisions = _phones.length ~/ maxLength;
      int length;
      if (_phones.length <= maxLength) {
        length = _phones.length;
      } else {
        length = maxLength * index;
      }
      List<String> phones = [];
      for (int i = 0; i < length; i++) {
        phones.add(_phones[i]);
      }
      BlocProvider.of<FriendBloc>(context).add(GetListFriend());
      BlocProvider.of<FriendBloc>(context).add(PhoneExistRequested(
        phones: phones,
        uuidMe: BlocProvider.of<ProfileBloc>(context).state.profileUser.uuid,
        isSearch: false,
      ));
    });
    controller = new ScrollController()..addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreenMethod(
      iconBack: true,
      title: 'home.add_friend',
      body: Container(
        child: BlocConsumer<FriendBloc, FriendState>(
          listener: (context, state) {
            if (state is PhoneLoadSuccess) {
              state.users.forEach((user) {
                final phoneNumber =
                    _displayName.where((phone) => phone.phone == user.phone);
                if (phoneNumber.isNotEmpty) {
                  listViews.add(
                    itemListView(
                      displayName: phoneNumber.first.name,
                      profile: user,
                    ),
                  );
                }
              });

              if (_phones != null) {
                final List<PhoneNumber> phoneNumbers = [];
                state.phones.forEach((phone) {
                  final phoneNumber =
                      _displayName.where((name) => name.phone == phone);
                  phoneNumbers.add(PhoneNumber(
                    phone: phoneNumber.first.phone,
                    name: phoneNumber.first.name,
                  ));
                });
                state.users.forEach((user) {
                  phoneNumbers.removeWhere((item) => item.phone == user.phone);
                });
                phoneNumbers.forEach((name) {
                  listViews.add(itemListView(displayName: name.name));
                });
              }
            }
            if (state is Refresh) {
              listViews.clear();
            }
          },
          builder: (context, state) {
            return Container(
              child: Column(
                children: [
                  searchUI(),
                  (state is LoadingFriend)
                      ? Center(
                          child: LoadingApp.loading1(),
                        )
                      : Expanded(
                          child: listFriendUI(users: state.users),
                        ),
                  (state is LoadingMoreFriend)
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: LoadingApp.loading1(),
                          ),
                        )
                      : Container(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget searchUI() {
    return Container(
      margin: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 10),
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
              maxLines: 1,
              controller: _controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: Language.of(context).getText("add_friend.search"),
              ),
              onChanged: (value) {
                _phones.clear();
                for (PhoneNumber phoneNumber in _displayName) {
                  if (phoneNumber.name.toLowerCase().contains(value.toLowerCase()) ||
                      phoneNumber.phone.toLowerCase().contains(value.toLowerCase())) {
                    _phones.add(phoneNumber.phone);
                  }
                }
                index = 1;
                divisions = _phones.length ~/ maxLength + 1;
                List<String> phones = [];
                int length;
                if (_phones.length <= maxLength) {
                  length = _phones.length;
                  divisions = 0;
                } else {
                  length = maxLength * index;
                }

                for (int i = 0; i < length; i++) {
                  phones.add(_phones[i]);
                }
                BlocProvider.of<FriendBloc>(context).add(PhoneExistRequested(
                  phones: phones,
                  uuidMe: BlocProvider.of<ProfileBloc>(context)
                      .state
                      .profileUser
                      .uuid,
                  isSearch: true,
                ));
                // BlocProvider.of<FriendBloc>(context).add((FindFriendByPhone(search: value)));
              },
            ),
          )
        ],
      ),
    );
  }

  Widget listFriendUI({List<ProfileUserModel> users}) {
    return ListView.builder(
      itemCount: listViews.length,
      controller: controller,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return listViews[index];
      },
    );
  }

  ImageProvider avatar;
  Widget itemListView(
      {String displayName, String usernanameme, ProfileUserModel profile}) {
    if (profile != null) {
      if (profile.avatar != null) {
        avatar = NetworkImage(profile.avatar);
      } else {
        avatar = AssetImage(AppImages.DEFAULT_AVATAR);
      }
    } else {
      avatar = AssetImage(AppImages.DEFAULT_AVATAR);
    }
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
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
                              displayName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            profile != null
                                ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: Text(
                                  profile.username,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              ),
                            )
                                : SizedBox(height: 8.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                  flex: 5,
                ),
                Flexible(
                  flex: 2,
                  child: InkWell(
                    onTap: () {
                      String uuidMe = BlocProvider.of<ProfileBloc>(context)
                          .state
                          .profileUser
                          .uuid;
                      BlocProvider.of<FriendBloc>(context).add(
                        RequireAddFriend(
                          idMe: uuidMe,
                          idFriend: profile.uuid,
                        ),
                      );
                      BlocProvider.of<FriendBloc>(context).add(GetListFriend());
                      BlocProvider.of<FriendBloc>(context).add(
                        PhoneExistRequested(phones: _phones),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.center,
                          colors: <Color>[
                            profile == null
                                ? AppTheme.darkBlue.withOpacity(0.7)
                                : Colors.red.withOpacity(0.7),
                            profile == null ? AppTheme.darkBlue : Colors.red,
                          ],
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            30,
                          ),
                        ),
                        border: Border.all(
                          width: 0.5,
                          color:
                              profile == null ? AppTheme.darkBlue : Colors.red,
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                      child: Container(
                        width: DeviceUtil.getDeviceWidth(context) / 9,
                        child: Text(
                          Language.of(context).getText(profile != null
                              ? 'add_friend.add'
                              : "add_friend.invite"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            letterSpacing: 0.18,
                            color: AppTheme.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
