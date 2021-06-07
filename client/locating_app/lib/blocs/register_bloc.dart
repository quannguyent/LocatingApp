import '../data/network/network.dart';
import '../data/network/repuest/user_register.dart';
import '../data/repository/repository.dart';
import 'base_bloc/base_bloc.dart';
import 'blocs.dart';

class RegisterBloc extends BaseBloc {
  RegisterBloc(BaseState initialState) : super(null);

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is RegisterEvent) {
      yield LoadingState();
      try {
        RegisterRepository registerRepository = new RegisterRepository();
        ApiResponse response = await registerRepository.registerUser(event.user);

        if (response.resultCode == 1) {
          yield LoadedState(data: event.user);
        } else {
          yield ErrorState(data: 'register');
        }
      } catch (e) {
        print(e.toString());
      }
    }
    if (event is VerifyCode) {
      print("xac minh code");
      yield LoadingState();
      try {
        RegisterRepository registerRepository = new RegisterRepository();
        ApiResponse response = await registerRepository.verifyCode(
            event.email, event.username, event.code);
        if (response.resultCode == 1) {
          yield LoadedState(data: response.message.toString());
        } else {
          yield ErrorState(data: response.message.toString());
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }
}

class RegisterEvent extends BaseEvent {
  UserRegister user;
  RegisterEvent(this.user);
}
class VerifyCode extends BaseEvent {
  String email, username, code;

  VerifyCode(this.email, this.username, this.code);
}
