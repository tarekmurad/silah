import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../data/models/email.dart';
import '../../../data/models/name.dart';
import '../../../data/models/password.dart';

class SignUpState extends Equatable {
  const SignUpState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.name = const Name.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.exceptionError,
  });

  final Email email;
  final Password password;
  final Name name;
  final FormzSubmissionStatus status;
  final String? exceptionError;

  @override
  List<Object> get props =>
      [email, password, name, status, exceptionError ?? ''];

  SignUpState copyWith({
    Email? email,
    Password? password,
    Name? name,
    FormzSubmissionStatus? status,
    String? error,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      status: status ?? this.status,
      exceptionError: error ?? exceptionError,
    );
  }
}
