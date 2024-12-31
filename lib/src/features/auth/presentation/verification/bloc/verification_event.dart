abstract class VerificationEvent {}

class VerificationCodeChanged extends VerificationEvent {
  final String name;
  final String email;
  final String password;
  final String code;

  VerificationCodeChanged({
    required this.name,
    required this.email,
    required this.password,
    required this.code,
  });
}
