import '../../../data/models/notification_model.dart';

abstract class NotificationState {}

class InitialNotificationState extends NotificationState {}

/// Get Notification

class GetNotificationLoadingState extends NotificationState {}

class GetNotificationSucceedState extends NotificationState {
  final List<NotificationModel> notifications;

  GetNotificationSucceedState({
    required this.notifications,
  });
}

class GetNotificationFailedState extends NotificationState {}

/// Mark All As Read

class MarkAllAsReadLoadingState extends NotificationState {}

class MarkAllAsReadSucceedState extends NotificationState {}

class MarkAllAsReadFailedState extends NotificationState {}
