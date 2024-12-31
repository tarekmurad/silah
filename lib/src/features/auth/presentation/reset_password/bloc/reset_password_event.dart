abstract class ResetPasswordEvent {}

class PasswordChanged extends ResetPasswordEvent {
  final String password;

  PasswordChanged({
    required this.password,
  });
}

class ConfirmPasswordChanged extends ResetPasswordEvent {
  final String confirmPassword;

  ConfirmPasswordChanged({
    required this.confirmPassword,
  });
}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  final String email;
  final String code;

  ResetPasswordSubmitted({
    required this.email,
    required this.code,
  });
}
