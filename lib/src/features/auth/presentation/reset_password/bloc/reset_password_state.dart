import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../data/models/confirm_password.dart';
import '../../../data/models/password.dart';

class ResetPasswordState extends Equatable {
  const ResetPasswordState({
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.exceptionError,
  });

  final Password password;
  final ConfirmPassword confirmPassword;
  final FormzSubmissionStatus status;
  final String? exceptionError;

  @override
  List<Object> get props =>
      [password, confirmPassword, status, exceptionError ?? ''];

  ResetPasswordState copyWith({
    Password? password,
    ConfirmPassword? confirmPassword,
    FormzSubmissionStatus? status,
    String? error,
  }) {
    return ResetPasswordState(
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
      exceptionError: error ?? exceptionError,
    );
  }
}
