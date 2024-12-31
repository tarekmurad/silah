import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../injection_container.dart';
import '../constants/constants.dart';
import '../constants/endpoint_url.dart';
import '../navigation/app_router.dart';
import '../utils/global_config.dart';
import 'errors/bad_request_error.dart';
import 'errors/base_error.dart';
import 'errors/cancel_error.dart';
import 'errors/conflict_error.dart';
import 'errors/custom_error.dart';
import 'errors/forbidden_error.dart';
import 'errors/http_error.dart';
import 'errors/internal_server_error.dart';
import 'errors/not_found_error.dart';
import 'errors/socket_error.dart';
import 'errors/timeout_error.dart';
import 'errors/unauthorized_error.dart';
import 'errors/unknown_error.dart';
import 'models/responses/list_response.dart';
import 'models/responses/object_response.dart';
import 'prefs_helper.dart';

enum HttpMethod {
  get,
  post,
  put,
  delete,
}

class HttpHelper {
  final Dio dio;
  final PrefsHelper _prefsHelper;

  HttpHelper(this.dio, this._prefsHelper) {
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
        options.headers['api-version'] = getIt<GlobalConfig>().version;

        var token = await _prefsHelper.getUserToken();

        if (options.headers.containsKey(Constants.authorization)) {
          options.headers[Constants.authorization] = 'Bearer $token';
          print(token);
        } else {
          debugPrint('Auth token is null');
        }

        return handler.next(options);
      }, onError: (DioException error, ErrorInterceptorHandler handler) async {
        /// Unauthorized Error
        /// need to refresh token
        if (error.response?.statusCode == 401) {
          if (error.requestOptions.uri.toString().contains('auth/token')) {
            /// logout and navigate to welcome screen
            _prefsHelper.clearData();
            getIt<AppRouter>().pushAndPopUntil(
              const WelcomeRoute(),
              predicate: (_) => false,
            );
          }

          var userRefreshToken = await _prefsHelper.getUserRefreshToken();
          if (userRefreshToken.isNotEmpty) {
            /// get new access token by refresh token
            String? newUserRefreshToken = await refreshToken(userRefreshToken);

            /// if there is a new access token resend the request
            if (newUserRefreshToken != null) {
              final opts = Options(
                method: error.requestOptions.method,
                headers: error.requestOptions.headers,
              );
              final cloneRequest = await dio.request(error.requestOptions.path,
                  options: opts,
                  data: error.requestOptions.data,
                  queryParameters: error.requestOptions.queryParameters);

              return handler.resolve(cloneRequest);
            }
            return handler.next(error);
          }
        }

        /// Forbidden Error
        /// need to login again
        else if (error.response?.statusCode == 403) {
          /// logout and navigate to welcome screen
          _prefsHelper.clearData();
          getIt<AppRouter>().pushAndPopUntil(
            const WelcomeRoute(),
            predicate: (_) => false,
          );

          return;
        } else if (error.response?.statusCode == 406) {
          getIt<AppRouter>().pushAndPopUntil(
            AdminApprovalRoute(newAccount: false),
            predicate: (_) => false,
          );
          return;
        }
        return handler.next(error);
      }),
    );
  }

  Future<String?> refreshToken(String refreshToken) async {
    try {
      final response = await dio.post(
        EndpointUrl.refreshTokenUrl,
        data: {'refreshToken': refreshToken},
        options: Options(
          headers: {
            'api-version': getIt<GlobalConfig>().version,
          },
        ),
      );

      var responseDate =
          (json.decode(response.data as String) as Map<String, dynamic>);

      if (response.statusCode == 200) {
        String newToken = responseDate['data']['token'];
        _prefsHelper.saveUserToken(newToken);
        getIt<GlobalConfig>().token = newToken;
        return newToken;
      } else {}
    } catch (e, _) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<Either<BaseError, dynamic>?>? getRequest(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool withAuthentication = false,
    bool isList = false,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    final Map<String, dynamic> headers = {};

    if (withAuthentication) {
      headers.putIfAbsent(Constants.authorization, () => '');
    }

    return await sendRequest(
      method: HttpMethod.get,
      url: url,
      headers: headers,
      options: options,
      isList: isList,
      queryParameters: queryParameters ?? {},
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Either<BaseError, dynamic>?>? postRequest(
    String url, {
    Map<String, dynamic>? data,
    String? rawDataString,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool withAuthentication = false,
    bool isList = false,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final Map<String, dynamic> headers = {};

    if (withAuthentication) {
      headers.putIfAbsent(Constants.authorization, () => '');
    }

    return await sendRequest(
      method: HttpMethod.post,
      url: url,
      headers: headers,
      options: options,
      queryParameters: queryParameters ?? {},
      data: data,
      dataString: rawDataString,
      isList: isList,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
    );
  }

  Future<Either<BaseError, dynamic>?>? putRequest(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool withAuthentication = false,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final Map<String, dynamic> headers = {};

    if (withAuthentication) {
      headers.putIfAbsent(Constants.authorization, () => '');
    }

    return await sendRequest(
      method: HttpMethod.get,
      url: url,
      headers: headers,
      options: options,
      queryParameters: queryParameters ?? {},
      data: data,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
    );
  }

  Future<Either<BaseError, dynamic>?>? deleteRequest(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool withAuthentication = false,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final Map<String, dynamic> headers = {};

    if (withAuthentication) {
      headers.putIfAbsent(Constants.authorization, () => '');
    }

    return await sendRequest(
      method: HttpMethod.delete,
      url: url,
      headers: headers,
      options: options,
      queryParameters: queryParameters ?? {},
      data: data,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
    );
  }

  Future<Either<BaseError, dynamic>> sendRequest({
    required HttpMethod method,
    required String url,
    required Map<String, dynamic> headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    String? dataString,
    Options? options,
    bool withAuthentication = false,
    bool isList = false,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      Response response;

      switch (method) {
        case HttpMethod.get:
          response = await dio.get(
            url,
            queryParameters: queryParameters,
            options: options ?? Options(headers: headers),
            cancelToken: cancelToken,
          );
          break;
        case HttpMethod.post:
          response = await dio.post(
            url,
            data: dataString ?? data,
            queryParameters: queryParameters,
            options: options ??
                Options(headers: headers, contentType: "application/json"),
            cancelToken: cancelToken,
          );
          break;
        case HttpMethod.put:
          response = await dio.put(
            url,
            data: data,
            queryParameters: queryParameters,
            options: options ?? Options(headers: headers),
            cancelToken: cancelToken,
          );
          break;
        case HttpMethod.delete:
          response = await dio.delete(
            url,
            data: data,
            queryParameters: queryParameters,
            options: options ?? Options(headers: headers),
            cancelToken: cancelToken,
          );
          break;
      }

      var responseData;
      if (response.data != null) {
        responseData =
            (json.decode(response.data as String) as Map<String, dynamic>);
      }

      if (responseData["code"] != -1) {
        try {
          var responseModel;

          if (isList) {
            responseModel = ListResponse.fromJson(responseData);
          } else {
            responseModel = ObjectResponse.fromJson(responseData);
          }
          return Right(responseModel);
        } catch (e, stack) {
          debugPrint('Error');
          debugPrint(e.toString());
          debugPrint(stack.toString());
          return Left(CustomError(message: e.toString()));
        }
      } else if (responseData["code"] == -1) {
        return Left(CustomError(message: responseData["message"]));
      } else {
        return Left(CustomError(message: "Null Json response in api provider"));
      }
    }

    /// Handling errors
    on DioException catch (e) {
      debugPrint("e.message");
      debugPrint(e.message);
      return Left(_handleDioError(e));
    }

    /// Couldn't reach out the server
    on SocketException catch (e, stacktrace) {
      debugPrint(e.message);
      debugPrint(stacktrace.toString());
      return Left(SocketError());
    }
  }

  static BaseError _handleDioError(DioException error) {
    var details;
    if (error.response?.data != null) {
      var response =
          (json.decode(error.response?.data as String) as Map<String, dynamic>);
      if (response['details'] != null) {
        details = response['details'][0];
      }
    }

    if (error.type == DioExceptionType.unknown ||
        error.type == DioExceptionType.badResponse) {
      if (error.error is SocketException) {
        return SocketError();
      } else if (error.type == DioExceptionType.badResponse) {
        switch (error.response!.statusCode) {
          case 400:
            return BadRequestError(message: details);
          case 401:
            return UnauthorizedError();
          case 403:
            return ForbiddenError();
          case 404:
            return NotFoundError();
          case 409:
            return ConflictError();
          case 500:
            if (error.response?.data != null) {
              var response = (json.decode(error.response?.data as String)
                  as Map<String, dynamic>);
              if (response['message'] != null) {
                var message = response['message'];
                return CustomError(message: message);
              }
            }

            return InternalServerError();
          default:
            return HttpError();
        }
      }
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return TimeoutError();
    } else if (error.type == DioExceptionType.cancel) {
      return CancelError();
    }
    return UnknownError();
  }

  Future<Response> downloadMediaFile(String url, String fileName) async {
    String filePath = '';
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      filePath = '${directory?.path}/$fileName';
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      filePath = '${directory.path}/$fileName';
    }

    final Map<String, dynamic> headers = {};
    headers.putIfAbsent(Constants.authorization, () => '');

    final Response response = await dio.download(
      url,
      filePath,
      options: Options(headers: headers),
    );

    return response;
  }
}
