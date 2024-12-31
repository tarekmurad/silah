import 'package:email_validator/email_validator.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Helper {
  /// Time Parser
  static DateFormat timeParser = DateFormat('HH:mm:ss');
  static DateFormat dateParser = DateFormat('yyyy-MM-dd');

  /// Time Formatter
  static DateFormat dateTimeFormatter = DateFormat('E dd MMM . hh:mm a');
  static DateFormat dateFormatter = DateFormat('dd MMM yyyy');
  static DateFormat timeFormatter = DateFormat('hh:mm a');
  static DateFormat dayMonthFormatter = DateFormat('dd MMMM');

  /// Sub String Text
  static String subStringText(String text, int numberOfChars) {
    if (text.length < numberOfChars) {
      return text;
    } else {
      return '${text.substring(0, numberOfChars - 1)}...';
    }
  }

  /// Validation
  static bool validateEmail(String email) {
    if (email.isEmpty) {
      return false;
    } else if (!EmailValidator.validate(email)) {
      return false;
    }
    return true;
  }

  static bool validateFullName(String fullName) {
    if (fullName.trim().length < 2 ||
        fullName.trim().contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return false;
    }
    return true;
  }

  static bool validateUAEPhone(String phone) {
    const String pattern =
        r'^(?:\+971|00971|0)?(?:50|51|52|55|56|2|3|4|6|7|9)\d{7}$';
    final RegExp regExp = RegExp(pattern);
    if (phone.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(phone)) {
      return false;
    }
    return true;
  }

  /// Capitalize
  static String convertToTitleCase(String text) {
    if (text.length <= 1) {
      return text.toUpperCase();
    }

    // Split string into multiple words
    final List<String> words = text.split(' ');

    // Capitalize first letter of each words
    final capitalizedWords = words.map((word) {
      if (word.trim().isNotEmpty) {
        final String firstLetter = word.trim().substring(0, 1).toUpperCase();
        final String remainingLetters = word.trim().substring(1);

        return '$firstLetter$remainingLetters';
      }
      return '';
    });

    // Join/Merge all words back to one String
    return capitalizedWords.join(' ');
  }

  /// Remove chars from phone number
  static String removeCharsFromPhoneNumber(String contactNumber) {
    const englishNumbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String phoneNumber = contactNumber.replaceAll(RegExp('\\+'), '');
    phoneNumber = phoneNumber.replaceAll(RegExp('-'), '');
    phoneNumber = phoneNumber.replaceAll(RegExp(' '), '');
    for (int i = 0; i < englishNumbers.length; i++) {
      phoneNumber = phoneNumber.replaceAll(arabicNumbers[i], englishNumbers[i]);
    }

    return phoneNumber;
  }

  static Future<String> getAppGUID() async {
    return const Uuid().v4();
  }
}
