import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../data/models/email.dart';
import '../../../data/models/password.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.exceptionError,
  });

  final Email email;
  final Password password;
  final FormzSubmissionStatus status;
  final String? exceptionError;

  @override
  List<Object> get props => [email, password, status, exceptionError ?? ''];

  LoginState copyWith({
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
    String? error,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      exceptionError: error ?? exceptionError,
    );
  }
}
