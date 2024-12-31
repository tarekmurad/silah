import 'package:dartz/dartz.dart';

import '../../../../core/data/errors/base_error.dart';
import '../../../../core/data/models/results/result.dart';
import '../../../../core/data/prefs_helper.dart';
import '../dataSources/authentication_data_source.dart';
import '../models/authentication_model.dart';
import '../models/update_firebase_token_param.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl {
  final AuthenticationDataSourceImpl _authenticationDataSource;
  final PrefsHelper _prefsHelper;

  AuthRepositoryImpl(this._authenticationDataSource, this._prefsHelper);

  /// Shared Preferences

  Future<Map<String, dynamic>> getAllDate() => _prefsHelper.getAllDate();

  Future<bool> clearUserInfo() => _prefsHelper.clearData();

  Future<String> getUserToken() => _prefsHelper.getUserToken();

  Future<int> getUserId() => _prefsHelper.getUserId();

  Future<String> getAppLanguage() => _prefsHelper.getAppLanguage();

  Future<String> getAppGUID() => _prefsHelper.getAppGUID();

  void saveUserToken(String? token) => _prefsHelper.saveUserToken(token);

  void saveUserRefreshToken(String? userRefreshToken) =>
      _prefsHelper.saveUserRefreshToken(userRefreshToken);

  void saveUserTokenType(String? userTokenType) =>
      _prefsHelper.saveUserTokenType(userTokenType);

  void saveUserId(int? id) => _prefsHelper.saveUserId(id);

  void saveAppLanguage(String lang) => _prefsHelper.saveAppLanguage(lang);

  void saveAppGUID(String appGUID) => _prefsHelper.saveAppGUID(appGUID);

  // Future<Result<BaseError, dynamic>> logIn(LoginParam loginParam) async {
  //   final remote = await _authenticationDataSource.login(loginParam);
  //
  //   if (remote!.isRight()) {
  //     return Result(data: (remote as Right<BaseError, dynamic>).value);
  //   } else {
  //     return Result(error: (remote as Left<BaseError, dynamic>).value);
  //   }
  // }

  Future<Result<BaseError, dynamic>> signUp(String email) async {
    final response = await _authenticationDataSource.signUp(email);
    if (response!.isRight()) {
      return Result(data: (response as Right<BaseError, dynamic>).value);
    } else {
      return Result(error: (response as Left<BaseError, dynamic>).value);
    }
  }

  Future<Result<BaseError, AuthenticationModel>> login(
      String email, String password) async {
    final response = await _authenticationDataSource.login(email, password);
    if (response!.isRight()) {
      return Result(
          data: (response as Right<BaseError, AuthenticationModel>).value);
    } else {
      return Result(
          error: (response as Left<BaseError, AuthenticationModel>).value);
    }
  }

  Future<Result<BaseError, AuthenticationModel>> verify(
      String name, String email, String password, String code) async {
    final response =
        await _authenticationDataSource.verify(name, email, password, code);
    if (response!.isRight()) {
      return Result(
          data: (response as Right<BaseError, AuthenticationModel>).value);
    } else {
      return Result(
          error: (response as Left<BaseError, AuthenticationModel>).value);
    }
  }

  Future<Result<BaseError, dynamic>> forgetPassword(String email) async {
    final response = await _authenticationDataSource.forgetPassword(email);
    if (response!.isRight()) {
      return Result(data: (response as Right<BaseError, dynamic>).value);
    } else {
      return Result(error: (response as Left<BaseError, dynamic>).value);
    }
  }

  Future<Result<BaseError, AuthenticationModel>> verifyForgetPassword(
      String email, String code) async {
    final response =
        await _authenticationDataSource.verifyForgetPassword(email, code);
    if (response!.isRight()) {
      return Result(
          data: (response as Right<BaseError, AuthenticationModel>).value);
    } else {
      return Result(
          error: (response as Left<BaseError, AuthenticationModel>).value);
    }
  }

  Future<Result<BaseError, dynamic>> resetPassword(
      String email, String code, String password) async {
    final response =
        await _authenticationDataSource.resetPassword(email, code, password);
    if (response!.isRight()) {
      return Result(data: (response as Right<BaseError, dynamic>).value);
    } else {
      return Result(error: (response as Left<BaseError, dynamic>).value);
    }
  }

  Future<Result<BaseError, dynamic>> updateFirebaseToken(
      UpdateFirebaseTokenParam updateFirebaseTokenParam) async {
    final remote = await _authenticationDataSource
        .updateFirebaseToken(updateFirebaseTokenParam);

    if (remote!.isRight()) {
      return Result(data: (remote as Right<BaseError, dynamic>).value);
    } else {
      return Result(error: (remote as Left<BaseError, dynamic>).value);
    }
  }

  Future<Result<BaseError, UserModel>> getUserInfo() async {
    final remote = await _authenticationDataSource.getUserInfo();

    if (remote!.isRight()) {
      return Result(data: (remote as Right<BaseError, dynamic>).value);
    } else {
      return Result(error: (remote as Left<BaseError, dynamic>).value);
    }
  }

// Future<Result<BaseError, dynamic>> logout(LogoutParam logoutParam) async {
//   final remote = await _authenticationDataSource.logout(logoutParam);
//
//   if (remote!.isRight()) {
//     return Result(data: (remote as Right<BaseError, dynamic>).value);
//   } else {
//     return Result(error: (remote as Left<BaseError, dynamic>).value);
//   }
// }
//
// Future<Result<BaseError, dynamic>> register(
//     RegisterParam registerParam) async {
//   final remote = await _authenticationDataSource.register(registerParam);
//
//   if (remote!.isRight()) {
//     return Result(data: (remote as Right<BaseError, dynamic>).value);
//   } else {
//     return Result(error: (remote as Left<BaseError, dynamic>).value);
//   }
// }
}
