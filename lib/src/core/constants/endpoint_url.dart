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

  /// Calendar
  static String getCalendarSchedulesUrl =
      '${AppUrl.baseUrlApi}api/calendar/schedules';

  /// Library
  static String getMediaFoldersUrl =
      '${AppUrl.baseUrlApi}api/library/getChildren';
  static String searchLibraryUrl = '${AppUrl.baseUrlApi}api/library/finder';
  static String getFavoritesUrl =
      '${AppUrl.baseUrlApi}api/favorites/getFavorites';
  static String interactionFavoritesUrl =
      '${AppUrl.baseUrlApi}api/favorites/interaction';
  static String pushProgressUrl =
      '${AppUrl.baseUrlApi}api/library/pushProgress';

  /// Tasks
  static String getTasksUrl = '${AppUrl.baseUrlApi}api/tasks/getTasks';
  static String interactionTasksUrl =
      '${AppUrl.baseUrlApi}api/tasks/interaction';
}
