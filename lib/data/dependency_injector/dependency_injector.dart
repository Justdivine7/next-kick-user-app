import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:next_kick/data/api_services/app_api_services.dart';
import 'package:next_kick/data/local_storage/app_local_storage_service.dart';
import 'package:next_kick/data/notification_service.dart';
import 'package:next_kick/data/repositories/auth_repository.dart';
import 'package:next_kick/data/repositories/drill_repository.dart';
import 'package:next_kick/data/repositories/notification_repository.dart';
import 'package:next_kick/data/repositories/player_repository.dart';
import 'package:next_kick/data/repositories/team_repository.dart';
import 'package:next_kick/data/repositories/user_repository.dart';
import 'package:next_kick/features/auth/bloc/auth_bloc.dart';
import 'package:next_kick/features/player/drills/bloc/drill_bloc.dart';
import 'package:next_kick/features/notification/bloc/notification_bloc.dart';
import 'package:next_kick/features/team/fixtures_and_standings/bloc/fixtures_bloc.dart';
import 'package:next_kick/features/team/standings/bloc/standings_bloc.dart';
import 'package:next_kick/features/team/tournament/bloc/tournament_bloc.dart';
import 'package:next_kick/features/user/bloc/user_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // CORE DATA

  getIt.registerLazySingleton<Dio>(() => Dio());
  await GetStorage.init();
  getIt.registerLazySingleton<GetStorage>(() => GetStorage());
  getIt.registerLazySingleton<AppLocalStorageService>(
    () => AppLocalStorageService(getIt<GetStorage>()),
  );

  // API CLIENTS
  getIt.registerLazySingleton<AppApiClient>(
    () => AppApiClient(getIt<Dio>(), getIt<AppLocalStorageService>()),
  );
  getIt.registerLazySingleton<NotificationService>(
    () => NotificationService(
      apiClient: getIt<AppApiClient>(),
      localStorage: getIt<AppLocalStorageService>(),
    ),
  );
  // REPOSITORIES

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      apiClient: getIt<AppApiClient>(),
      localStorage: getIt<AppLocalStorageService>(),
    ),
  );
  getIt.registerLazySingleton<PlayerRepository>(
    () => PlayerRepository(
      apiClient: getIt<AppApiClient>(),
      localStorage: getIt<AppLocalStorageService>(),
    ),
  );
  getIt.registerLazySingleton<DrillRepository>(
    () => DrillRepository(getIt<AppApiClient>()),
  );
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepository(getIt<AppApiClient>()),
  );
  getIt.registerLazySingleton<TeamRepository>(
    () => TeamRepository(getIt<AppApiClient>()),
  );
  getIt.registerLazySingleton<StandingRepository>(
    () => StandingRepository(getIt<AppApiClient>()),
  );
  // BLOCS

  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthRepository>()));
  getIt.registerFactory<DrillBloc>(() => DrillBloc(getIt<DrillRepository>()));
  getIt.registerFactory<NotificationBloc>(
    () => NotificationBloc(getIt<NotificationRepository>()),
  );
  getIt.registerFactory<UserBloc>(
    () => UserBloc(userRepository: getIt<PlayerRepository>()),
  );
  getIt.registerFactory<TournamentBloc>(
    () => TournamentBloc(getIt<TeamRepository>()),
  );
  getIt.registerFactory<FixturesBloc>(
    () => FixturesBloc(getIt<TeamRepository>()),
  );
  getIt.registerFactory<StandingsBloc>(() => StandingsBloc());
}
