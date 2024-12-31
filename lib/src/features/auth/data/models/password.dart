import 'package:formz/formz.dart';

enum PasswordValidationError { empty, tooShort }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');

  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String? value) {
    if (value == null) {
      return PasswordValidationError.empty;
    } else if (value.isEmpty == true) {
      return PasswordValidationError.empty;
    } else if (value.length < 8) {
      return PasswordValidationError.tooShort;
    }
    return null;
  }
}
