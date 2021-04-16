import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../blocs/blocs.dart';
import '../../localizations.dart';
import '../../res/resources.dart';
import '../../utils/utils.dart';
import '../widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  double paddingBottom;

  ProfileScreen(this.paddingBottom);

  @override
  Widget build(BuildContext context) {
    return ProfileWidget(paddingBottom);
  }
}

class ProfileWidget extends StatefulWidget {
  double paddingBottom;

  ProfileWidget(this.paddingBottom);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _username = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _firstName = new TextEditingController();
  TextEditingController _lastName = new TextEditingController();
  TextEditingController _confirmPassword = new TextEditingController();
  TextEditingController _newPassword = new TextEditingController();
  TextEditingController _phoneNumber = new TextEditingController();
  String errorUserName;
  String errorEmail;
  String errorFirstName;
  String errorLastName;
  String errorPassWord;
  String errorConfirmPassword;
  String errorNewPassword;  String errorPhoneNumber;

  double radius = 30;
  File _image;
  ImageProvider avatar;
  Widget logoWidget() {
    return Container(
      width: DeviceUtil.getDeviceWidth(context),
      height: DeviceUtil.getDeviceHeight(context) / 4,
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.only(left: 24, bottom: 24),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.blue.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              Language.of(context).getText("profile"),
              style: TextStyle(
                // h5 -> headline
                fontWeight: FontWeight.bold,
                fontSize: 30,
                letterSpacing: 0.27,
                color: AppTheme.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bodyWidget() {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is GetProfileState) {
          if (state.profileUser.avatar_url != null) {
            setState(() {
              _image = null;
              avatar = NetworkImage(state.profileUser.avatar_url);
            });
          } else {
            setState(() {
              _image = null;
              avatar = AssetImage(AppImages.INTRO_1);
            });
          }
        }
      },
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(top: 60),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    CircleAvatar(radius: 60, backgroundImage: avatar),
                    InkWell(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 5),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(40)),
                        child: Icon(
                          Icons.edit_outlined,
                          color: AppTheme.white,
                          size: 15,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                alignment: Alignment.center,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 40, right: 40),
                        child: ItemTextField(
                          Icons.mail_outline,
                          "register.email",
                          _email,
                          errorText: errorEmail,
                          checkInvalid: (value) {},
                          hideText: false,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40, right: 40),
                        //color: Colors.red,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: ItemTextField(
                                Icons.perm_contact_calendar_outlined,
                                "register.first_name",
                                _firstName,
                                errorText: errorFirstName,
                                hideText: false,
                                width:
                                    DeviceUtil.getDeviceWidth(context) / 2 - 50,
                                widthTextInput: 110,
                              ),
                              // margin: EdgeInsets.only(right: 10),
                            ),
                            Container(
                              //margin: EdgeInsets.only(right: 30),
                              child: ItemTextField(
                                Icons.perm_contact_calendar_outlined,
                                "register.last_name",
                                _lastName,
                                errorText: errorLastName,
                                hideText: false,
                                width:
                                    DeviceUtil.getDeviceWidth(context) / 2 - 50,
                                widthTextInput: 110,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40, right: 40),
                        child: ItemTextField(
                          Icons.phone,
                          "register.phone",
                          _phoneNumber,
                          errorText: errorPhoneNumber,
                          hideText: false,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40, right: 40),
                        child: ItemTextField(
                          Icons.lock_outline,
                          "profile_user.old_password",
                          _password,
                          errorText: errorPassWord,
                          hideText: true,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40, right: 40),
                        child: ItemTextField(
                          Icons.lock_outline,
                          "profile_user.new_password",
                          _newPassword,
                          errorText: errorConfirmPassword,
                          hideText: true,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40, right: 40),
                        child: ItemTextField(
                          Icons.lock_outline,
                          "register.confirm_password",
                          _confirmPassword,
                          errorText: errorConfirmPassword,
                          hideText: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is GetProfileState) {
          _email.text =
              BlocProvider.of<ProfileBloc>(context).state.profileUser.email ??
                  "";
          _lastName.text = BlocProvider.of<ProfileBloc>(context)
                  .state
                  .profileUser
                  .lastName ??
              "";
          _firstName.text = BlocProvider.of<ProfileBloc>(context)
                  .state
                  .profileUser
                  .firstName ??
              "";
          _username.text = BlocProvider.of<ProfileBloc>(context)
                  .state
                  .profileUser
                  .userName ??
              "";

          _phoneNumber.text = BlocProvider.of<ProfileBloc>(context)
              .state
              .profileUser
              .phone ??
              "";
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: widget.paddingBottom),
                color: AppTheme.whiteBlack,
                width: DeviceUtil.getDeviceWidth(context),
                height: DeviceUtil.getDeviceHeight(context),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: logoWidget(),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: bodyWidget(),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40, right: 40),
                        child: ItemButton(
                          title: "profile_user.update",
                          onPress: () async {
                            String userName = "",
                                email = "",
                                password = "",
                                newPassword = "",
                                confirmPassword = "",
                                lastName = "",phoneNumber="",
                                firstName = "";
                            setState(() {
                              if (_email.text.isEmpty) {
                                errorEmail = "error.not_null";
                              } else {
                                errorEmail = null;
                                email = _email.text;
                              }
                              if (_lastName.text.isEmpty) {
                                errorLastName = "error.not_null";
                              } else {
                                errorLastName = null;
                                lastName = _lastName.text;
                              }
                              if (_phoneNumber.text.isEmpty) {
                                errorPhoneNumber = "error.not_null";
                              } else {
                                errorPhoneNumber = null;
                                phoneNumber = _phoneNumber.text;
                              }
                              if (_firstName.text.isEmpty) {
                                errorFirstName = "error.not_null";
                              } else {
                                errorFirstName = null;
                                firstName = _firstName.text;
                              }
                              if (firstName.isNotEmpty &&
                                  lastName.isNotEmpty &&
                                  email.isNotEmpty &&phoneNumber.isNotEmpty&&
                                  EmailValidator.validate(email) == true) {
                                BlocProvider.of<ProfileBloc>(context)
                                    .add(UpdateProfileEvent(
                                  _email.text,
                                  _firstName.text,
                                  _lastName.text,
                                  state.profileUser.status,
                                  _phoneNumber.text,
                                  _password.text ?? _password.text,
                                  _newPassword.text ?? _newPassword.text,
                                  _confirmPassword.text ??
                                      _confirmPassword.text,
                                  state.profileUser.id,
                                  image: _image != null ? _image : null,
                                ));
                              }
                            });
                          },
                        ),
                      ),
                      BlocConsumer<ProfileBloc, ProfileState>(
                        listener: (context, state) {
                          if (state is UpdateError) {
                            state.error != null
                                ? showDialog(
                                    context: context,
                                    builder: (context) {
                                      return DialogWidget(
                                        title: "error." + state.error,
                                      );
                                    })
                                : print("done");
                          }
                        },
                        builder: (context, state) {
                          return Container();
                        },
                      ),
                      BlocConsumer<ProfileBloc, ProfileState>(
                        listener: (context, state) {
                          if (state is UpdateProfile) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            state.success != null
                                ? showDialog(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (context) {
                                      return DialogWidget(
                                        title: "profile_user.update_success",
                                        success: true,
                                      );
                                    })
                                : print("done");
                          }
                        },
                        builder: (context, state) {
                          return Container();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              state is LoadingProfile ? LoadingApp.loading1() : Container(),
            ],
          ),
        );
      },
    );
  }

  Widget itemLogin(IconData image, String title, Color color) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.blue.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          FaIcon(
            image,
            color: color,
            size: 20,
          ),
        ],
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text(
                        Language.of(context).getText("profile_user.gallery"),
                      ),
                      onTap: () {
                        imageFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text(
                        Language.of(context).getText("profile_user.camera")),
                    onTap: () {
                      imageFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future imageFromCamera() async {
    final pickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 100);
    setState(() {
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    });
  }

  Future imageFromGallery() async {
    final pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 100);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        setState(() {
          avatar = FileImage(_image);
        });
      } else {
        print('No image selected.');
      }
    });
  }
}
