import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';

import '../../../data/models/confirm_password.dart';
import '../../../data/models/password.dart';
import '../../../data/repositories/authentication_repository_impl.dart';
import 'bloc.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  AuthRepositoryImpl authRepository;

  ResetPasswordBloc(this.authRepository) : super(const ResetPasswordState()) {
    on<PasswordChanged>(_onPasswordChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<ResetPasswordSubmitted>(_onSubmitted);
  }

  void _onPasswordChanged(
    PasswordChanged event,
    Emitter<ResetPasswordState> emit,
  ) {
    final password = Password.dirty(event.password);
    final confirmPassword = ConfirmPassword.dirty(
      value: state.confirmPassword.value,
      password: password.value,
    );

    emit(state.copyWith(
      password: password,
      confirmPassword: confirmPassword,
    ));
  }

  void _onConfirmPasswordChanged(
    ConfirmPasswordChanged event,
    Emitter<ResetPasswordState> emit,
  ) {
    final confirmPassword = ConfirmPassword.dirty(
        value: event.confirmPassword, password: state.password.value);
    emit(state.copyWith(
      confirmPassword: confirmPassword,
    ));
  }

  Future<void> _onSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final result = await authRepository.resetPassword(
          event.email, event.code, state.password.value);

      if (result.hasDataOnly) {
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } else if (result.hasErrorOnly) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    } catch (e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
