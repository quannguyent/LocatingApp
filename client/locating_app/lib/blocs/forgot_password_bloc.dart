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
        ApiResponse response =
            await serviceRepository.forgotPassword(event.email);
        if (response.resultCode == 1) {
          yield LoadedState(data: event.email);
        } else {
          yield ErrorState(data: response.message.toString());
        }
      } catch (e) {
        print(e.toString());
      }
    }
    if (event is UpdatePassword) {
      yield LoadingState();
      try {
        // ServiceRepository serviceRepository = new ServiceRepository();
        // ApiResponse response = await serviceRepository.updatePassword(
        //     event.email, event.code, event.passWord, event.retypePassword);
        // if (response.resultCode == 1) {
        //   yield UpdatePasswordSuccess(response.message.toString());
        // } else {
        //   yield ErrorState(data: response.message.toString());
        // }
      } catch (e) {
        print(e.toString());
      }
    }
  }
}

class TypeEmailEvent extends BaseEvent {
  String email;
  TypeEmailEvent(this.email);
}

class UpdatePasswordSuccess extends BaseState {
  String messgae;

  UpdatePasswordSuccess(this.messgae);
}

class UpdatePassword extends BaseEvent {
  String email, passWord, retypePassword, code;

  UpdatePassword(this.email, this.passWord, this.retypePassword, this.code);
}
