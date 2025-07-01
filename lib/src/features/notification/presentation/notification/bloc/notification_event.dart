abstract class NotificationEvent {}

class GetNotification extends NotificationEvent {
  final int currentPage;

  GetNotification({
    required this.currentPage,
  });
}

class MarkAllAsRead extends NotificationEvent {}
