abstract class ForgetPasswordEvent {}

class LoginEmailChanged extends ForgetPasswordEvent {
  final String email;

  LoginEmailChanged({
    required this.email,
  });
}

class LoginPasswordChanged extends ForgetPasswordEvent {
  final String password;

  LoginPasswordChanged({
    required this.password,
  });
}

class ForgetPasswordSubmitted extends ForgetPasswordEvent {}
