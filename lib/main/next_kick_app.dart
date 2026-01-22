import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/data/dependency_injector/dependency_injector.dart';
import 'package:next_kick/data/notification_service.dart';
import 'package:next_kick/features/player/drills/bloc/drill_bloc.dart';
import 'package:next_kick/features/notification/bloc/notification_bloc.dart';
import 'package:next_kick/features/team/fixtures_and_standings/bloc/fixtures_bloc.dart';
import 'package:next_kick/features/team/standings/bloc/standings_bloc.dart';
import 'package:next_kick/features/team/tournament/bloc/tournament_bloc.dart';
import 'package:next_kick/main/app_splash_screen.dart';
import 'package:next_kick/data/routes/route.dart';
import 'package:next_kick/features/auth/bloc/auth_bloc.dart';
import 'package:next_kick/features/user/bloc/user_bloc.dart';
import 'package:next_kick/utilities/theme/app_theme_service.dart';

class NextKickApp extends StatefulWidget {
  const NextKickApp({super.key});

  @override
  State<NextKickApp> createState() => _NextKickAppState();
}

class _NextKickAppState extends State<NextKickApp> {
  late final NotificationService _notificationService;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _notificationService = getIt<NotificationService>();

    await _initNotifications();
    await _loadDeviceId();
    await _loadFCMToken();
  }

  Future<void> _loadDeviceId() async {
    await getIt<NotificationService>().getDeviceId();
  }

  Future<void> _loadFCMToken() async {
    await FirebaseMessaging.instance.getToken();
  }

  Future<void> _initNotifications() async {
    await _notificationService.initFCM(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthBloc>()),
        BlocProvider(create: (context) => getIt<UserBloc>()),
        BlocProvider(create: (context) => getIt<DrillBloc>()),
        BlocProvider(create: (context) => getIt<NotificationBloc>()),
        BlocProvider(create: (context) => getIt<TournamentBloc>()),
        BlocProvider(create: (context) => getIt<FixturesBloc>()),
        BlocProvider(create: (context) => getIt<StandingsBloc>()),
      ],
      child: AppWithProviders(),
    );
  }
}

class AppWithProviders extends StatelessWidget {
  const AppWithProviders({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: NotificationService.navigatorKey,
          title: 'Next Kick',
          theme: AppThemeService().lighttheme,
          darkTheme: AppThemeService().darkTheme,
          initialRoute: AppSplashScreen.routeName,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: (settings) => generateRoute(settings),
        );
      },
    );
  }
}
