
import 'blocs.dart';

class LogoutBloc extends BaseBloc{
  LogoutBloc(BaseState initialState) : super(null);

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) {
    // TODO: implement mapEventToState
    if(state is SignOut){
      print("logout app");
    }
  }

}
class SignOut extends BaseEvent{}