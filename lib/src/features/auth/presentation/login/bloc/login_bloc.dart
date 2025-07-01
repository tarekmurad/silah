import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';

import '../../../../../core/data/errors/http_error.dart';
import '../../../../../core/utils/global_config.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../injection_container.dart';
import '../../../../notification/data/repositories/notification_repository_impl.dart';
import '../../../data/models/email.dart';
import '../../../data/models/password.dart';
import '../../../data/repositories/authentication_repository_impl.dart';
import 'bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AuthRepositoryImpl authRepository;
  NotificationRepositoryImpl notificationRepository;

  LoginBloc(this.authRepository, this.notificationRepository)
      : super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) {
    final email = Email.dirty(event.email);

    emit(state.copyWith(
      email: email,
    ));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
    ));
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    final result =
        await authRepository.login(state.email.value, state.password.value);

    if (result.hasDataOnly) {
      authRepository.saveUserToken(result.data?.token);
      authRepository.saveUserRefreshToken(result.data?.refreshToken);
      getIt<GlobalConfig>().token = result.data?.token;

      await _onUpdateFireBaseToken(emit);
    } else if (result.hasErrorOnly) {
      if (result.error is HttpError) {
        emit(state.copyWith(
            status: FormzSubmissionStatus.failure,
            error: (result.error as HttpError).message));
      } else {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }

  Future<void> _onUpdateFireBaseToken(
    Emitter<LoginState> emit,
  ) async {
    String? firebaseToken;
    await FirebaseMessaging.instance.getToken().then((token) {
      debugPrint('Firebase token: $token');
      firebaseToken = token;
    });

    String deviceId = await Helper.getAppGUID();
    authRepository.saveAppGUID(deviceId);

    final result = await authRepository.getUserInfo();
    getIt<GlobalConfig>().currentUser = result.data!;

    final updateFirebaseTokenResult =
        await notificationRepository.pushFCMToken(firebaseToken!, deviceId);

    if (updateFirebaseTokenResult.hasDataOnly) {
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } else if (updateFirebaseTokenResult.hasErrorOnly) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
