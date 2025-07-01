import 'package:bloc/bloc.dart';

import '../../../../calendar/data/repositories/calendar_repository_impl.dart';
import '../../../../library/data/repositories/library_repository_impl.dart';
import '../../../../notification/data/repositories/notification_repository_impl.dart';
import '../../../data/repositories/main_repository_impl.dart';
import 'bloc.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainRepositoryImpl mainRepository;
  LibraryRepositoryImpl libraryRepository;
  NotificationRepositoryImpl notificationRepository;
  CalendarRepositoryImpl calendarRepository;

  MainBloc(this.mainRepository, this.libraryRepository,
      this.notificationRepository, this.calendarRepository)
      : super(InitialMainState()) {
    on<GetAnnouncements>(_onGetAnnouncements);
    on<GetLibrary>(_onGetLibrary);
    on<GetWatchedHistoryLibrary>(_onGetWatchedHistoryLibrary);
    on<GetUnreadNotificationsCount>(_onGetUnreadNotificationsCount);
    on<ResetUnreadNotificationsCount>(_onResetUnreadNotificationsCount);
    on<GetCalendarSchedules>(_onGetCalendarSchedules);
  }

  Future<void> _onGetCalendarSchedules(
    GetCalendarSchedules event,
    Emitter<MainState> emit,
  ) async {
    emit(GetCalendarSchedulesLoadingState());

    final now = DateTime.now().toUtc();

    // try {
    final result = await calendarRepository.getCalendarSchedules(
        DateTime.utc(now.year, now.month, now.day, 0, 0, 0).toIso8601String(),
        DateTime.utc(now.year, now.month, now.day, 23, 59, 0)
            .toIso8601String());

    if (result.hasDataOnly) {
      emit(GetCalendarSchedulesSucceedState(schedules: result.data!));
    } else if (result.hasErrorOnly) {
      emit(GetCalendarSchedulesFailedState());
    }
    // } catch (e) {
    //   emit(GetCalendarSchedulesFailedState());
    // }
  }

  Future<void> _onGetAnnouncements(
    GetAnnouncements event,
    Emitter<MainState> emit,
  ) async {
    emit(GetAnnouncementsLoadingState());

    // try {
    final result = await mainRepository.getAnnouncements();

    if (result.hasDataOnly) {
      emit(GetAnnouncementsSucceedState(announcements: result.data!));
    } else if (result.hasErrorOnly) {
      emit(GetAnnouncementsFailedState());
    }
    // } catch (e) {
    //   emit(GetAnnouncementsFailedState());
    // }
  }

  Future<void> _onGetLibrary(
    GetLibrary event,
    Emitter<MainState> emit,
  ) async {
    emit(GetLibraryLoadingState());

    // try {
    final result = await libraryRepository.getNewContent();

    if (result.hasDataOnly) {
      emit(GetLibrarySucceedState(folders: result.data!.folders!));
    } else if (result.hasErrorOnly) {
      emit(GetLibraryFailedState());
    }
    // } catch (e) {
    //   emit(GetLibraryFailedState());
    // }
  }

  Future<void> _onGetWatchedHistoryLibrary(
    GetWatchedHistoryLibrary event,
    Emitter<MainState> emit,
  ) async {
    emit(GetWatchedHistoryLoadingState());

    // try {
    final result = await libraryRepository.getWatchedHistory();

    if (result.hasDataOnly) {
      emit(GetWatchedHistorySucceedState(folders: result.data!.folders!));
    } else if (result.hasErrorOnly) {
      emit(GetWatchedHistoryFailedState());
    }
    // } catch (e) {
    //   emit(GetLibraryFailedState());
    // }
  }

  Future<void> _onGetUnreadNotificationsCount(
    GetUnreadNotificationsCount event,
    Emitter<MainState> emit,
  ) async {
    emit(GetUnreadNotificationsCountLoadingState());

    // try {
    final result = await notificationRepository.getUnreadCount();

    if (result.hasDataOnly) {
      emit(GetUnreadNotificationsCountSucceedState(count: result.data!));
    } else if (result.hasErrorOnly) {
      emit(GetUnreadNotificationsCountFailedState());
    }
    // } catch (e) {
    //   emit(GetLibraryFailedState());
    // }
  }

  Future<void> _onResetUnreadNotificationsCount(
    ResetUnreadNotificationsCount event,
    Emitter<MainState> emit,
  ) async {
    emit(ResetUnreadNotificationsCountState(count: 0));
  }
}
