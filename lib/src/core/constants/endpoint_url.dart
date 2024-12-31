import 'app_url.dart';

class EndpointUrl {
  EndpointUrl._();

  /// Authentication
  static String reqSignupCodeUrl = '${AppUrl.baseUrlApi}auth/reqSignupCode';
  static String signUpUrl = '${AppUrl.baseUrlApi}auth/signup';
  static String loginUrl = '${AppUrl.baseUrlApi}auth/login';
  static String reqForgotPasswordCodeUrl =
      '${AppUrl.baseUrlApi}auth/reqForgotPasswordCode';
  static String verifyForgotPasswordCodeUrl =
      '${AppUrl.baseUrlApi}auth/checkForgotPasswordCode';
  static String forgotPasswordUrl = '${AppUrl.baseUrlApi}auth/forgotPassword';

  static String getUserInfoUrl = '${AppUrl.baseUrlApi}api/general/me';
  static String refreshTokenUrl = '${AppUrl.baseUrlApi}auth/token';
  static String logoutUserUrl = '${AppUrl.baseUrlApi}auth/logout';
  static String updateFirebaseTokenUrl =
      '${AppUrl.baseUrlApi}users/firebase-token';
  static String changePasswordUrl = '${AppUrl.baseUrlApi}auth/change-password';

  static String getCalendarSchedulesUrl =
      '${AppUrl.baseUrlApi}api/calendar/schedules';
  static String getMediaFoldersUrl =
      '${AppUrl.baseUrlApi}api/library/getChildren';
  static String searchLibraryUrl = '${AppUrl.baseUrlApi}api/library/finder';
  static String getFavoritesUrl = '${AppUrl.baseUrlApi}api/favorites/getFavorites';
  static String interactionFavoritesUrl = '${AppUrl.baseUrlApi}api/favorites/interaction';
  static String pushProgressUrl =
      '${AppUrl.baseUrlApi}api/library/pushProgress';

  /// reset password
  static String forgetPasswordUrl = '${AppUrl.baseUrlApi}auth/forget-password';
  static String confirmResetPasswordUrl =
      '${AppUrl.baseUrlApi}auth/confirm-reset-password-token';
  static String resetPasswordUrl = '${AppUrl.baseUrlApi}auth/reset-password';

  /// register
  static String signupUrl = '${AppUrl.baseUrlApi}auth/signup';
  static String confirmOTPUrl = '${AppUrl.baseUrlApi}auth/confirm';
  static String setPasswordUrl = '${AppUrl.baseUrlApi}auth/set-password';

  /// alarms
  static String getAlarmsUrl = '${AppUrl.baseUrlApi}alarms';
  static String updateAlarmUrl = '${AppUrl.baseUrlApi}alarms/update-status';
  static String clearAlarmsHistoryUrl = '${AppUrl.baseUrlApi}alarms/clear';

  /// sensors
  static String locationsUrl = '${AppUrl.baseUrlApi}locations';
  static String sensorsByLocationUrl =
      '${AppUrl.baseUrlApi}sensors/get-by-location';
}
