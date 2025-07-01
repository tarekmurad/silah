abstract class ResetPasswordEvent {}

class OldPasswordChanged extends ResetPasswordEvent {
  final String oldPassword;

  OldPasswordChanged({
    required this.oldPassword,
  });
}

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

class ResetPasswordSubmitted extends ResetPasswordEvent {}
