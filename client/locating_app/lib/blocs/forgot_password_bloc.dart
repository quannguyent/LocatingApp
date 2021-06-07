import 'package:locaing_app/utils/common.dart';

import '../data/network/network.dart';
import '../data/repository/repository.dart';
import 'blocs.dart';
class ForgotPasswordBloc extends BaseBloc {
  ForgotPasswordBloc(BaseState initialState) : super(null);

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is TypeEmailEvent) {
      yield LoadingState();
      try {
        ServiceRepository serviceRepository = new ServiceRepository();
        ApiResponse response = await serviceRepository.forgotPassword(event.email);

        if (response.resultCode == 1) {
          if (event.isResend) {
            yield LoadedState(data: 'resend_success');
          } else yield LoadedState(data: event.email);
        } else {
          yield ErrorState(data: 'forgot_password');
        }
      } catch (e) {
        print(e.toString());
      }
    }
    if (event is VerifyOtpCode) {
      yield LoadingState();

      try {
        ServiceRepository serviceRepository = new ServiceRepository();
        ApiResponse response = await serviceRepository.verifyOtpCode(event.email, event.code);

        if (response.resultCode == 1) {
          Common.saveToken(response.data.token);
          yield LoadedState(data: 'verify_otp_success');
        } else {
          print('error');
          yield ErrorState(data: 'verify_otp');
        }
      } catch (e) {
        print(e.toString());
      }
    }
    if (event is RecoverPassword) {
      yield LoadingState();   
      try {
        ServiceRepository serviceRepository = new ServiceRepository();
        ApiResponse response = await serviceRepository.recoverPassword(event.passWord);

        if (response.resultCode == 1) {
          yield RecoverPasswordSuccess('reset_password_success');
        } else {
          yield ErrorState(data: response.message.toString());
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }
}

class TypeEmailEvent extends BaseEvent {
  String email;
  bool isResend;

  TypeEmailEvent(
    this.email,
    {
      this.isResend = false
    }
  );
}

class RecoverPasswordSuccess extends BaseState {
  String messgae;

  RecoverPasswordSuccess(this.messgae);
}

class RecoverPassword extends BaseEvent {
  String passWord;

  RecoverPassword(this.passWord);
}

class VerifyOtpCode extends BaseEvent {
  String email, code;

  VerifyOtpCode(this.email, this.code);
}
