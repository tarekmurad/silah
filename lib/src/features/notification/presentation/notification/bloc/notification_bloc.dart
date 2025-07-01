import 'package:bloc/bloc.dart';

import '../../../data/models/notification_model.dart';
import '../../../data/repositories/notification_repository_impl.dart';
import 'bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationRepositoryImpl notificationRepository;

  List<NotificationModel>? notificationsList;

  NotificationBloc(this.notificationRepository)
      : super(InitialNotificationState()) {
    on<GetNotification>(_onGetNotification);
    on<MarkAllAsRead>(_onMarkAllAsRead);
  }

  Future<void> _onGetNotification(
    GetNotification event,
    Emitter<NotificationState> emit,
  ) async {
    if (event.currentPage == 1) emit(GetNotificationLoadingState());

    // try {
    final result =
        await notificationRepository.getNotifications(event.currentPage);

    if (result.hasDataOnly) {
      if (event.currentPage == 1) {
        notificationsList = [];
      }

      notificationsList?.addAll(result.data! ?? []);

      emit(GetNotificationSucceedState(notifications: notificationsList!));
    } else if (result.hasErrorOnly) {
      emit(GetNotificationFailedState());
    }
    // } catch (e) {
    //   emit(GetNotificationFailedState());
    // }
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    emit(MarkAllAsReadLoadingState());

    // try {
    final result = await notificationRepository.markAllAsRead();

    if (result.hasDataOnly) {
      emit(MarkAllAsReadSucceedState());
    } else if (result.hasErrorOnly) {
      emit(MarkAllAsReadFailedState());
    }
    // } catch (e) {
    //   emit(GetNotificationFailedState());
    // }
  }
}
