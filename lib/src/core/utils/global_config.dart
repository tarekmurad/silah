import 'dart:convert';

import 'package:boilerplate_flutter/src/initialize_app.dart';
import 'package:flutter/services.dart';

import '../../features/auth/data/models/user_model.dart';
import '../constants/app_url.dart';
import '../constants/constants.dart';

class GlobalConfig {
  factory GlobalConfig() {
    return _globalConfig;
  }

  GlobalConfig._internal();

  static final GlobalConfig _globalConfig = GlobalConfig._internal();

  /// firebase messaging permission
  bool isNotificationPermissionEnabledFromUser = true;

  /// current language of the app
  String currentLanguage = Constants.englishLanguage;

  /// login status
  bool isUserLoggedIn = true;

  /// current logged user
  String? token;
  UserModel? currentUser;

  String version = '5.4.0';

  static Future<void> forEnvironment(Environment env) async {
    final contents = await rootBundle.loadString(
      'assets/config/${env.name}.json',
    );

    final json = jsonDecode(contents);

    AppUrl.baseUrl = json['base_url'];
  }
}
