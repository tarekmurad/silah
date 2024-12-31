abstract class SignUpEvent {}

class SignUpEmailChanged extends SignUpEvent {
  final String email;

  SignUpEmailChanged({
    required this.email,
  });
}

class SignUpPasswordChanged extends SignUpEvent {
  final String password;

  SignUpPasswordChanged({
    required this.password,
  });
}

class SignUpNameChanged extends SignUpEvent {
  final String name;

  SignUpNameChanged({
    required this.name,
  });
}

class SignUpSubmitted extends SignUpEvent {}
