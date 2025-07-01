import 'package:dartz/dartz.dart';

import '../../../../core/data/errors/base_error.dart';
import '../../../../core/data/models/results/result.dart';
import '../dataSources/notification_data_source.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl {
  final NotificationDataSourceImpl _notificationDataSource;

  NotificationRepositoryImpl(this._notificationDataSource);

  Future<Result<BaseError, List<NotificationModel>>> getNotifications(
      int currentPage) async {
    final response =
        await _notificationDataSource.getNotifications(currentPage);
    if (response!.isRight()) {
      return Result(
          data: (response as Right<BaseError, List<NotificationModel>>).value);
    } else {
      return Result(
          error: (response as Left<BaseError, List<NotificationModel>>).value);
    }
  }

  Future<Result<BaseError, dynamic>> markAllAsRead() async {
    final response = await _notificationDataSource.markAllAsRead();
    if (response!.isRight()) {
      return Result(data: (response as Right<BaseError, dynamic>).value);
    } else {
      return Result(error: (response as Left<BaseError, dynamic>).value);
    }
  }

  Future<Result<BaseError, dynamic>> pushFCMToken(
      String token, String deviceId) async {
    final response =
        await _notificationDataSource.pushFCMToken(token, deviceId);
    if (response!.isRight()) {
      return Result(data: (response as Right<BaseError, dynamic>).value);
    } else {
      return Result(error: (response as Left<BaseError, dynamic>).value);
    }
  }

  Future<Result<BaseError, dynamic>> getUnreadCount() async {
    final response =
        await _notificationDataSource.getUnreadCount();
    if (response!.isRight()) {
      return Result(data: (response as Right<BaseError, dynamic>).value);
    } else {
      return Result(error: (response as Left<BaseError, dynamic>).value);
    }
  }
}
