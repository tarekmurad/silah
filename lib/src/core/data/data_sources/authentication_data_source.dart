// import 'dart:async';
//
// import 'package:dartz/dartz.dart';
// import 'package:boilerplate_flutter/src/constants/endpoint_url.dart';
// import 'package:boilerplate_flutter/src/data/http_helper.dart';
//
// import '../../screens/login/models/login_param.dart';
// import '../../screens/login/models/update_firebase_token_param.dart';
// import '../errors/base_error.dart';
//
// class AuthenticationDataSource {
//   final HttpHelper _httpHelper;
//
//   AuthenticationDataSource(this._httpHelper);
//
//   /// User
//
//   Future<Either<BaseError, dynamic>?> login(LoginParam loginParam) async {
//     return await _httpHelper.postRequest(
//       EndpointUrl.loginUrl,
//       data: loginParam.toJson(),
//       withAuthentication: false,
//     );
//   }
//
//   Future<Either<BaseError, dynamic>?> getUserInfo() async {
//     return await _httpHelper.getRequest(
//       EndpointUrl.getUserInfoUrl,
//       withAuthentication: true,
//     );
//   }
//
//   Future<Either<BaseError, dynamic>?> updateFirebaseToken(
//       UpdateFirebaseTokenParam updateFirebaseTokenParam) async {
//     return await _httpHelper.postRequest(
//       EndpointUrl.updateFirebaseTokenUrl,
//       data: updateFirebaseTokenParam.toJson(),
//       withAuthentication: true,
//     );
//   }
//
//   // Future<Either<BaseError, dynamic>?> logout(LogoutParam logoutParam) async {
//   //   return await _httpHelper.postRequest(
//   //     EndpointUrl.logoutUserUrl,
//   //     data: logoutParam.toJson(),
//   //     withAuthentication: true,
//   //   );
//   // }
//   //
//   // Future<Either<BaseError, dynamic>?> register(
//   //     RegisterParam registerParam) async {
//   //   return await _httpHelper.postRequest(
//   //     EndpointUrl.signupUrl,
//   //     data: registerParam.toJson(),
//   //     withAuthentication: false,
//   //   );
//   // }
// }
