import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../../../core/constants/endpoint_url.dart';
import '../../../../core/data/errors/base_error.dart';
import '../../../../core/data/http_helper.dart';
import '../models/notification_model.dart';

class NotificationDataSourceImpl {
  final HttpHelper _httpHelper;

  NotificationDataSourceImpl(this._httpHelper);

  Future<Either<BaseError, List<NotificationModel>>>? getNotifications(
      int currentPage) async {
    final response = await _httpHelper.postRequest(
      EndpointUrl.getNotificationsUrl,
      withAuthentication: true,
      rawDataString: jsonEncode({
        'page': currentPage,
        'pageSize': 10,
      }),
    );

    return response!.fold(
      (error) => Left(error),
      (data) {
        final List<NotificationModel> schedules =
            (data.data["notifications"] as List)
                .map((json) => NotificationModel.fromJson(json))
                .toList();
        return Right(schedules);
      },
    );
  }

  Future<Either<BaseError, dynamic>>? markAllAsRead() async {
    final response = await _httpHelper.postRequest(
      EndpointUrl.markAllAsReadUrl,
      withAuthentication: true,
    );

    if (response!.isRight()) {
      return Right(response);
    } else {
      return response;
    }
  }

  Future<Either<BaseError, dynamic>>? pushFCMToken(
      String token, String deviceId) async {
    final response = await _httpHelper.postRequest(
      EndpointUrl.pushFCMTokenUrl,
      withAuthentication: true,
      rawDataString: jsonEncode({
        'token': token,
        'deviceId': deviceId,
      }),
    );

    if (response!.isRight()) {
      return Right(response);
    } else {
      return response;
    }
  }

  Future<Either<BaseError, dynamic>>? getUnreadCount() async {
    final response = await _httpHelper.postRequest(
      EndpointUrl.getUnreadCountUrl,
      withAuthentication: true,
    );

    return response!.fold(
      (error) => Left(error),
      (data) {
        return Right(data.data["unreadCount"] as int);
      },
    );
  }
}
