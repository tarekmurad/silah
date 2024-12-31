import 'package:formz/formz.dart';

enum ConfirmPasswordValidationError { mismatch }

class ConfirmPassword
    extends FormzInput<String, ConfirmPasswordValidationError> {
  final String password;

  const ConfirmPassword.pure({this.password = ''}) : super.pure('');

  const ConfirmPassword.dirty({required this.password, String value = ''})
      : super.dirty(value);

  @override
  ConfirmPasswordValidationError? validator(String? value) {
    return value == password ? null : ConfirmPasswordValidationError.mismatch;
  }
}
