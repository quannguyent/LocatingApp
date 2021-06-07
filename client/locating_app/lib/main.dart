import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locaing_app/blocs/friend_bloc.dart';
import 'package:locaing_app/blocs/friend_profile_bloc.dart';
import 'blocs/blocs.dart';
import 'ui/app.dart';
import 'package:wemapgl/wemapgl.dart' as WEMAP;

void main() async {
  WEMAP.Configuration.setWeMapKey('GqfwrZUEfxbwbnQUhtBMFivEysYIxelQ');
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then(
    (_) => runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(
            create: (_) => AppBloc(),
          ),
          BlocProvider<LoginBloc>(
            create: (_) => LoginBloc(null),
          ),
          BlocProvider<ProfileBloc>(
            create: (_) => ProfileBloc(InitProFileUser()),
          ),
          BlocProvider<RegisterBloc>(
            create: (_) => RegisterBloc(null),
          ),
          BlocProvider<ForgotPasswordBloc>(
            create: (_) => ForgotPasswordBloc(null),
          ),
          BlocProvider<SettingBloc>(
            create: (_) => SettingBloc(),
          ),
          BlocProvider<HomeBloc>(
            create: (_) => HomeBloc(null),
          ),
          BlocProvider<FriendBloc>(
            create: (_) => FriendBloc(null),
          ),
          BlocProvider<LogLocationBloc>(
            create: (_) => LogLocationBloc(),
          ),
          BlocProvider<TrackingBloc>(
            create: (_) => TrackingBloc(),
          ),
          BlocProvider<PlaceBloc>(
            create: (_) => PlaceBloc(),
          ),
          BlocProvider<FriendProfileBloc>(
            create: (_) => FriendProfileBloc(),
          ),
          BlocProvider<CallHelpBloc>(
            create: (_) => CallHelpBloc(),
          ),
        ],
        child: MyApp.language(),
      ),
    ),
  );
}
