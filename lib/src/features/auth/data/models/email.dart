import 'package:formz/formz.dart';

import '../../../../core/utils/helpers.dart';

enum EmailValidationError { empty, invalid }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');

  const Email.dirty([super.value = '']) : super.dirty();

  @override
  EmailValidationError? validator(String? value) {
    if (value == null) {
      return EmailValidationError.empty;
    } else if (value.isEmpty == true) {
      return EmailValidationError.empty;
    } else if (!Helper.validateEmail(value)) {
      return EmailValidationError.invalid;
    }
    return null;
  }
}
