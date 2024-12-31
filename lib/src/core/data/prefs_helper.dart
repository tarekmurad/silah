import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';

class PrefsHelper {
  Future<SharedPreferences> _getPrefs() async {
    return SharedPreferences.getInstance();
  }

  Future<bool> clearData() async {
    return (await _getPrefs()).clear();
  }

  Future<Map<String, dynamic>> getAllDate() async {
    final keys = (await _getPrefs()).getKeys();
    final prefsMap = <String, dynamic>{};
    for (final key in keys) {
      prefsMap[key] = (await _getPrefs()).get(key);
    }
    return prefsMap;
  }

  ///

  Future<String?> getString(String key) async {
    final sharedPreferences = await _getPrefs();
    return sharedPreferences.getString(key);
  }

  Future<bool>? putString(String key, String value) async {
    final sharedPreferences = await _getPrefs();
    return sharedPreferences.setString(key, value);
  }

  Future<bool?> getBool(String key) async {
    final sharedPreferences = await _getPrefs();
    return sharedPreferences.getBool(key);
  }

  Future<bool>? putBool(String key, bool value) async {
    final sharedPreferences = await _getPrefs();
    return sharedPreferences.setBool(key, value);
  }

  Future<int?> getInt(String key) async {
    final sharedPreferences = await _getPrefs();
    return sharedPreferences.getInt(key);
  }

  Future<bool>? putInt(String key, int value) async {
    final sharedPreferences = await _getPrefs();
    return sharedPreferences.setInt(key, value);
  }

  ///

  void saveAppLanguage(String lang) async {
    final sharedPreferences = await _getPrefs();
    sharedPreferences.setString(Constants.applicationLanguage, lang);
  }

  void saveUserToken(String? token) async {
    final sharedPreferences = await _getPrefs();
    sharedPreferences.setString(Constants.userToken, token!);
  }

  void saveUserId(int? id) async {
    final sharedPreferences = await _getPrefs();
    sharedPreferences.setInt(Constants.userId, id ?? 0);
  }

  void saveAppGUID(String? appGUID) async {
    final sharedPreferences = await _getPrefs();
    sharedPreferences.setString(Constants.appGUID, appGUID ?? '');
  }

  void saveUserTokenType(String? userTokenType) async {
    final sharedPreferences = await _getPrefs();
    sharedPreferences.setString(Constants.userTokenType, userTokenType ?? '');
  }

  void saveUserRefreshToken(String? userRefreshToken) async {
    final sharedPreferences = await _getPrefs();
    sharedPreferences.setString(
        Constants.userRefreshToken, userRefreshToken ?? '');
  }

  ///

  Future<String> getAppLanguage() async =>
      (await _getPrefs()).getString(Constants.applicationLanguage) ??
      Constants.englishLanguage;

  Future<String> getUserToken() async =>
      (await _getPrefs()).getString(Constants.userToken) ?? '';

  Future<String> getUserTokenType() async =>
      (await _getPrefs()).getString(Constants.userTokenType) ?? '';

  Future<String> getUserRefreshToken() async =>
      (await _getPrefs()).getString(Constants.userRefreshToken) ?? '';

  Future<int> getUserId() async =>
      (await _getPrefs()).getInt(Constants.userId) ?? 0;

  Future<String> getAppGUID() async =>
      (await _getPrefs()).getString(Constants.appGUID) ?? '';
}
