import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';

import '../../../../../core/data/errors/http_error.dart';
import '../../../data/models/email.dart';
import '../../../data/repositories/authentication_repository_impl.dart';
import 'bloc.dart';

class ForgetPasswordBloc
    extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  AuthRepositoryImpl authRepository;

  ForgetPasswordBloc(this.authRepository) : super(const ForgetPasswordState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<ForgetPasswordSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(
    LoginEmailChanged event,
    Emitter<ForgetPasswordState> emit,
  ) {
    final email = Email.dirty(event.email);

    emit(state.copyWith(
      email: email,
    ));
  }

  Future<void> _onSubmitted(
    ForgetPasswordSubmitted event,
    Emitter<ForgetPasswordState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    // try {
    final result = await authRepository.forgetPassword(state.email.value);

    if (result.hasDataOnly) {
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } else if (result.hasErrorOnly) {
      if (result.error is HttpError) {
        emit(state.copyWith(
            status: FormzSubmissionStatus.failure,
            error: (result.error as HttpError).message));
      } else {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
    // } catch (e) {
    //   emit(state.copyWith(status: FormzSubmissionStatus.failure));
    // }
  }
}
