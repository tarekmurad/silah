abstract class VerificationEvent {}

class VerificationCodeChanged extends VerificationEvent {
  final String email;
  final String code;

  VerificationCodeChanged({
    required this.email,
    required this.code,
  });
}
