import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/constants/endpoint_url.dart';
import '../../../../core/data/errors/base_error.dart';
import '../../../../core/data/http_helper.dart';
import '../models/authentication_model.dart';
import '../models/update_firebase_token_param.dart';
import '../models/user_model.dart';

class AuthenticationDataSourceImpl {
  final HttpHelper _httpHelper;

  AuthenticationDataSourceImpl(this._httpHelper);

  /// User

  Future<Either<BaseError, dynamic>>? signUp(String email) async {
    final response = await _httpHelper.postRequest(
      EndpointUrl.reqSignupCodeUrl,
      data: {
        'email': email,
      },
      withAuthentication: false,
    );

    if (response!.isRight()) {
      return Right(response);
    } else {
      return response;
    }
  }

  Future<Either<BaseError, AuthenticationModel>>? login(
      String email, String password) async {
    final response = await _httpHelper.postRequest(
      EndpointUrl.loginUrl,
      data: {
        'email': email,
        'password': password,
      },
      withAuthentication: false,
    );

    return response!.fold(
      (error) => Left(error),
      (data) => Right(AuthenticationModel.fromJson(data.data!)),
    );
  }

  Future<Either<BaseError, dynamic>>? forgetPassword(String email) async {
    final response = await _httpHelper.postRequest(
      EndpointUrl.reqForgotPasswordCodeUrl,
      data: {
        'email': email,
      },
      withAuthentication: false,
    );

    if (response!.isRight()) {
      return Right(response);
    } else {
      return response;
    }
  }

  Future<Either<BaseError, AuthenticationModel>>? verify(
      String name, String email, String password, String code) async {
    final response = await _httpHelper.postRequest(
      EndpointUrl.signUpUrl,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'code': code,
      },
      withAuthentication: false,
    );

    if (response!.isRight()) {
      AuthenticationModel authentication = AuthenticationModel.fromJson(
          (response as Right<BaseError, dynamic>).value.data!);
      return Right(authentication);
    } else {
      return response as Left<BaseError, AuthenticationModel>;
    }
  }

  Future<Either<BaseError, AuthenticationModel>>? verifyForgetPassword(
      String email, String code) async {
    final response = await _httpHelper.postRequest(
      EndpointUrl.verifyForgotPasswordCodeUrl,
      data: {
        'email': email,
        'code': code,
      },
      withAuthentication: false,
    );

    return response!.fold(
      (error) => Left(error),
      (data) => Right(AuthenticationModel.fromJson(data.data!)),
    );
  }

  Future<Either<BaseError, AuthenticationModel>>? resetPassword(
      String email, String code, String password) async {
    final response = await _httpHelper.postRequest(
      EndpointUrl.forgotPasswordUrl,
      data: {
        'email': email,
        'code': code,
        'password': password,
      },
      withAuthentication: false,
    );

    if (response!.isRight()) {
      AuthenticationModel authentication = AuthenticationModel.fromJson(
          (response as Right<BaseError, dynamic>).value.data!);
      return Right(authentication);
    } else {
      return response as Left<BaseError, AuthenticationModel>;
    }
  }

  Future<Either<BaseError, UserModel>?> getUserInfo() async {
    final response = await _httpHelper.getRequest(
      EndpointUrl.getUserInfoUrl,
      withAuthentication: true,
    );
    return response!.fold(
      (error) => Left(error),
      (data) => Right(UserModel.fromJson(data.data!['me'])),
    );
  }

  Future<Either<BaseError, dynamic>?> updateFirebaseToken(
      UpdateFirebaseTokenParam updateFirebaseTokenParam) async {
    return await _httpHelper.postRequest(
      EndpointUrl.updateFirebaseTokenUrl,
      data: updateFirebaseTokenParam.toJson(),
      withAuthentication: true,
    );
  }
}
