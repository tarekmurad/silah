import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';

import '../../../data/models/email.dart';
import '../../../data/models/name.dart';
import '../../../data/models/password.dart';
import '../../../data/repositories/authentication_repository_impl.dart';
import 'bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  AuthRepositoryImpl authRepository;

  SignUpBloc(this.authRepository) : super(const SignUpState()) {
    on<SignUpEmailChanged>(_onEmailChanged);
    on<SignUpPasswordChanged>(_onPasswordChanged);
    on<SignUpNameChanged>(_onNameChanged);
    on<SignUpSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(
    SignUpEmailChanged event,
    Emitter<SignUpState> emit,
  ) {
    final email = Email.dirty(event.email);

    emit(state.copyWith(
      email: email,
    ));
  }

  void _onPasswordChanged(
    SignUpPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
    ));
  }

  void _onNameChanged(
    SignUpNameChanged event,
    Emitter<SignUpState> emit,
  ) {
    final name = Name.dirty(event.name);

    emit(state.copyWith(
      name: name,
    ));
  }

  Future<void> _onSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final result = await authRepository.signUp(state.email.value);

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
