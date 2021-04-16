import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locaing_app/data/network/api_response.dart';
import 'package:locaing_app/data/repository/repository.dart';

class CallHelpEvent {}
class CallForHelp extends CallHelpEvent{}
class CallHelpState{
  String success,error;
  CallHelpState({this.success, this.error});
}
class InitCallHelpState extends CallHelpState{
  InitCallHelpState():super(
    success: null,
    error: null,
  );
}
class PostCallHelpState extends CallHelpState{
  PostCallHelpState.fromOldState(CallHelpState oldState,{String success,String error}):super(
    success: success ?? oldState.success,
    error: error ?? oldState.error,
  );
}
class CallHelpBloc extends Bloc<CallHelpEvent,CallHelpState>{
  CallHelpBloc() : super(InitCallHelpState());


  @override
  Stream<CallHelpState> mapEventToState(CallHelpEvent event) async*{
    if(event is CallHelpEvent){
      ApiResponse response = await ServiceRepository().callForHelp();
      if(response.resultCode==1){
        yield PostCallHelpState.fromOldState(state,success: "call_for_help.success");
      }else{
        yield PostCallHelpState.fromOldState(state,success: response.message);
      }
    }
  }

}