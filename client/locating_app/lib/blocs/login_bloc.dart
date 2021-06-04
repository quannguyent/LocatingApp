import 'package:flutter/material.dart';
import '../data/model/model.dart';
import '../data/network/network.dart';
import '../data/repository/repository.dart';
import '../utils/common.dart';
import 'blocs.dart';

class LoginBloc extends BaseBloc {
  LoginBloc(BaseState initialState) : super(null);

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is LoginFaceBookEvent) {
      yield LoadingState();
      String token;
      Login login = new Login();
      if (event.token == null) {
        String tokenFB = await login.loginFacebook();
        token = tokenFB;
      } else {
        token = event.token;
      }
      if (token != null) {
        ApiResponse response;
        if (event.isAddEmailOrPhone != null) {
          response = await login.logInToServer(
            token,
            isFacebook: true,
            isAddEmailOrPhone: true,
            phone: event.phone,
            email: event.email,
          );
        } else {
          response = await login.logInToServer(token, isFacebook: true);
        }
        if (response.resultCode == 1) {
          LoginSuccessModel loginSuccessModel =
              LoginSuccessModel.fromJson(response.data);
          // print("token from server" + loginSuccessModel.accessToken);
          await Common.saveToken(loginSuccessModel.accessToken);
          yield LoadedState(data: loginSuccessModel.accessToken);
        } else {
          yield ErrorState(data: response.message, dataTrash: token);
        }
      } else {
        yield InitState();
      }
    }

    if (event is LoginGoogleEvent) {
      String token;
      Login login = new Login();
      yield LoadingState();
      if (event.token == null) {
        String tokenGG = await login.loginGoogle();
        token = tokenGG;
        //print(tokenGG + " access token");
      } else {
        token = event.token;
      }
      if (token != null) {
        ApiResponse response;
        if (event.isAddEmailOrPhone != null) {
          response = await login.logInToServer(token,
              isGoogle: true, isAddEmailOrPhone: true, phone: event.phone,);
        } else {
          response = await login.logInToServer(token, isGoogle: true);
        }
        if (response.resultCode == 1) {
          LoginSuccessModel loginSuccessModel =
              LoginSuccessModel.fromJson(response.data);
          await Common.saveToken(loginSuccessModel.accessToken);
          yield LoadedState(data: loginSuccessModel.accessToken);
        } else {
          yield ErrorState(data: response.message, dataTrash: token);
        }
      } else {
        yield InitState();
      }
    }

    if (event is LoginPressedEvent) {
      yield LoadingState();
      try {
        Login login = new Login();
        User user = event.user;
        ApiResponse response = await login.login(user.username, user.password);

        if (response.resultCode == 1) {
          Map<String, dynamic> data = response.data;

          String token = data['token'];

          if (token != null) {
            await Common.saveToken(token);
            yield LoadedState(data: token);
          } else {
            yield ErrorState(data: "error");
          }
        } else {
          yield ErrorState(data: 'login');
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }
}

class LoginFaceBookEvent extends BaseEvent {
  bool isAddEmailOrPhone;
  String phone;
  String email;
  String token;
  LoginFaceBookEvent(
      {this.isAddEmailOrPhone, this.phone, this.email, this.token});
}

class LoginGoogleEvent extends BaseEvent {
  bool isAddEmailOrPhone;
  String phone;
  String token;
  LoginGoogleEvent({this.isAddEmailOrPhone, this.phone, this.token});
}

class LoginPressedEvent extends BaseEvent {
  final User user;
  LoginPressedEvent({@required this.user});
}
