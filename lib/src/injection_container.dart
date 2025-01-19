import 'package:boilerplate_flutter/src/features/splash/bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'core/data/http_helper.dart';
import 'core/data/network_info.dart';
import 'core/data/prefs_helper.dart';
import 'core/navigation/app_router.dart';
import 'core/utils/global_config.dart';
import 'features/auth/data/dataSources/authentication_data_source.dart';
import 'features/auth/data/repositories/authentication_repository_impl.dart';
import 'features/auth/presentation/forget_password/bloc/bloc.dart';
import 'features/auth/presentation/login/bloc/bloc.dart';
import 'features/auth/presentation/reset_password/bloc/bloc.dart';
import 'features/auth/presentation/signup/bloc/bloc.dart';
import 'features/auth/presentation/verification/bloc/bloc.dart';
import 'features/auth/presentation/verify_forget_password/bloc/bloc.dart';
import 'features/calendar/data/dataSources/calendar_data_source.dart';
import 'features/calendar/data/repositories/calendar_repository_impl.dart';
import 'features/calendar/presentation/calendar/bloc/bloc.dart';
import 'features/home/presentation/bloc/bloc.dart';
import 'features/library/data/dataSources/library_data_source.dart';
import 'features/library/data/repositories/library_repository_impl.dart';
import 'features/library/presentation/library/bloc/bloc.dart';
import 'features/profile/data/dataSources/profile_data_source.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/presentation/profile/bloc/bloc.dart';
import 'features/todo/data/dataSources/todo_data_source.dart';
import 'features/todo/data/repositories/todo_repository_impl.dart';
import 'features/todo/presentation/todo/bloc/bloc.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton(Dio(
    BaseOptions(
      connectTimeout: const Duration(milliseconds: 180000),
      receiveTimeout: const Duration(milliseconds: 180000),
      responseType: ResponseType.plain,
      receiveDataWhenStatusError: true,
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json'
      },
    ),
  ));

  getIt.registerSingleton<AppRouter>(AppRouter());

  getIt.registerLazySingleton<HttpHelper>(
    () => HttpHelper(getIt<Dio>(), getIt<PrefsHelper>()),
  );

  getIt.registerLazySingleton<PrefsHelper>(
    () => PrefsHelper(),
  );

  getIt.registerFactory<GlobalConfig>(
    () => GlobalConfig(),
  );

  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  /// Repositories
  getIt.registerLazySingleton<AuthRepositoryImpl>(
    () => AuthRepositoryImpl(
      getIt<AuthenticationDataSourceImpl>(),
      getIt<PrefsHelper>(),
    ),
  );

  getIt.registerLazySingleton<CalendarRepositoryImpl>(
    () => CalendarRepositoryImpl(
      getIt<CalendarDataSourceImpl>(),
    ),
  );

  getIt.registerLazySingleton<LibraryRepositoryImpl>(
    () => LibraryRepositoryImpl(
      getIt<LibraryDataSourceImpl>(),
    ),
  );

  getIt.registerLazySingleton<ProfileRepositoryImpl>(
    () => ProfileRepositoryImpl(
      getIt<ProfileDataSourceImpl>(),
    ),
  );

  getIt.registerLazySingleton<TodoRepositoryImpl>(
    () => TodoRepositoryImpl(
      getIt<TodoDataSourceImpl>(),
    ),
  );

  /// Data Sources
  getIt.registerLazySingleton<AuthenticationDataSourceImpl>(
    () => AuthenticationDataSourceImpl(
      getIt<HttpHelper>(),
    ),
  );

  getIt.registerLazySingleton<CalendarDataSourceImpl>(
    () => CalendarDataSourceImpl(
      getIt<HttpHelper>(),
    ),
  );

  getIt.registerLazySingleton<LibraryDataSourceImpl>(
    () => LibraryDataSourceImpl(
      getIt<HttpHelper>(),
    ),
  );

  getIt.registerLazySingleton<ProfileDataSourceImpl>(
    () => ProfileDataSourceImpl(
      getIt<HttpHelper>(),
    ),
  );

  getIt.registerLazySingleton<TodoDataSourceImpl>(
    () => TodoDataSourceImpl(
      getIt<HttpHelper>(),
    ),
  );

  /// Bloc
  getIt.registerFactory<SplashBloc>(
    () => SplashBloc(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory<SignUpBloc>(
    () => SignUpBloc(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory<VerificationBloc>(
    () => VerificationBloc(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory<ForgetPasswordBloc>(
    () => ForgetPasswordBloc(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory<VerifyForgetPasswordBloc>(
    () => VerifyForgetPasswordBloc(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory<ResetPasswordBloc>(
    () => ResetPasswordBloc(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory<CalendarBloc>(
    () => CalendarBloc(getIt<CalendarRepositoryImpl>()),
  );

  getIt.registerFactory<LibraryBloc>(
    () => LibraryBloc(getIt<LibraryRepositoryImpl>()),
  );

  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory<TodoBloc>(
    () => TodoBloc(getIt<TodoRepositoryImpl>()),
  );
}
