import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../data/models/email.dart';

class ForgetPasswordState extends Equatable {
  const ForgetPasswordState({
    this.email = const Email.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.exceptionError,
  });

  final Email email;
  final FormzSubmissionStatus status;
  final String? exceptionError;

  @override
  List<Object> get props => [email, status, exceptionError ?? ''];

  ForgetPasswordState copyWith({
    Email? email,
    FormzSubmissionStatus? status,
    String? error,
  }) {
    return ForgetPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
      exceptionError: error ?? exceptionError,
    );
  }
}
