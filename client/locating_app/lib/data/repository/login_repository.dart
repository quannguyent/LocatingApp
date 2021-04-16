import 'package:dio/dio.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:platform_device_id/platform_device_id.dart';

import '../../constants.dart';
import '../../utils/common.dart';
import '../model/model.dart' as model;
import '../network/network.dart';

class Login {
  Login();

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var facebookLogin = FacebookLogin();

  void signOutGoogle() async {
    await _googleSignIn.signOut();
    print("User Sign Out");
  }

  Future<String> loginGoogle() async {
    String token;
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    if(googleSignInAccount==null)return null;
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    token = googleSignInAuthentication.accessToken;
    print(googleSignInAuthentication.idToken.toString() + " id token");
    UserCredential authResult = await _auth.signInWithCredential(credential);
    User _user = authResult.user;
    assert(!_user.isAnonymous);
    assert(await _user.getIdToken() != null);
    User currentUser = await _auth.currentUser;
    assert(_user.uid == currentUser.uid);
    return token;
  }

  Future<void> signOutFacebook() async {
    print("logout facebook");
    await facebookLogin.logOut();
    await _auth.signOut();
  }

  Future<String> loginFacebook() async {
    String token;
    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    var facebookLoginResult = await facebookLogin.logIn(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        {
          print("login false");
          token = null;
          break;
        }
      case FacebookLoginStatus.cancelledByUser:
        {
          print("CancelledByUser");
          token = null;
          break;
        }
      case FacebookLoginStatus.loggedIn:
        {
          print("login success");
          final tokenLogin = facebookLoginResult.accessToken.token; // gettoken
          // token = tokenLogin.accessToken.token;
          final graphResponse = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${tokenLogin}');
          final profile = json.decode(graphResponse.body);
          token = tokenLogin;
          break;
        }
    }
    return token;
  }

  Future<ApiResponse> login(String username, password) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    model.User user = new model.User(username, password);
    String tokenFirebase = await Common.getTokenFirebase();
    String idDevice = await PlatformDeviceId.getDeviceId;
    String appName = Constants.APP_NAME;
    Response<ApiResponse> response = await Network.instance.post(
      url: ApiConstant.APIHOST + ApiConstant.AUTHENTICATION,
      body: {
        "username": user.username,
        "password": user.password,
        "app_name": appName,
        "token_firebase": tokenFirebase,
        "device_id": idDevice,
      },
    );
    return response.data;
  }

  Future<ApiResponse> logInToServer(String token,
      {bool isFacebook, bool isGoogle, bool isAddEmailOrPhone,String phone,String email}) async {
    String method;
    String tokenFirebase = await Common.getTokenFirebase();
    String idDevice = await PlatformDeviceId.getDeviceId;
    String appName = Constants.APP_NAME;
    var body;
    var body1 ={
      "credentials": {
        "token_auth": "$token",
        "app_name": "$appName",
        "token_firebase": "$tokenFirebase",
        "device_id": "$idDevice",
      }
    };
    var bodyFB ={
      "credentials": {
        "token_auth": "$token",
        "app_name": "$appName",
        "token_firebase": "$tokenFirebase",
        "device_id": "$idDevice",
      },
      "email": "$email",
      "phone": "$phone"
    };
    var bodyG ={
      "credentials": {
        "token_auth": "$token",
        "app_name": "$appName",
        "token_firebase": "$tokenFirebase",
        "device_id": "$idDevice",
      },
      "phone": "$phone"
    };
    if(isAddEmailOrPhone==null) body=body1;
    if (isFacebook != null) {
      method = ApiConstant.FACEBOOK;
      if(isAddEmailOrPhone!=null){
        body= bodyFB;
      }
    }
    else {
      if (isGoogle != null) method = ApiConstant.GOOGLE;
      if(isAddEmailOrPhone!=null){
        body= bodyG;
      }
    }
    Response<ApiResponse> response = await Network.instance.post(
      url: ApiConstant.APIHOST + ApiConstant.apiHostLogin + method,
      body: body,
    );
    return response.data;
  }
}
