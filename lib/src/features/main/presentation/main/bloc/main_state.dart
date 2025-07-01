import '../../../../calendar/data/models/calendar_model.dart';
import '../../../../library/data/models/folder.dart';
import '../../../data/models/announcement_model.dart';

abstract class MainState {}

class InitialMainState extends MainState {}

/// Get Main Schedules

class GetAnnouncementsLoadingState extends MainState {}

class GetAnnouncementsSucceedState extends MainState {
  final List<AnnouncementModel> announcements;

  GetAnnouncementsSucceedState({
    required this.announcements,
  });
}

class GetAnnouncementsFailedState extends MainState {}

/// Get Library

class GetLibraryLoadingState extends MainState {}

class GetLibrarySucceedState extends MainState {
  final List<Folder> folders;

  GetLibrarySucceedState({
    required this.folders,
  });
}

class GetLibraryFailedState extends MainState {}

/// Get Watched History

class GetWatchedHistoryLoadingState extends MainState {}

class GetWatchedHistorySucceedState extends MainState {
  final List<Folder> folders;

  GetWatchedHistorySucceedState({
    required this.folders,
  });
}

class GetWatchedHistoryFailedState extends MainState {}

/// Get Watched History

class GetUnreadNotificationsCountLoadingState extends MainState {}

class GetUnreadNotificationsCountSucceedState extends MainState {
  final int count;

  GetUnreadNotificationsCountSucceedState({
    required this.count,
  });
}

class GetUnreadNotificationsCountFailedState extends MainState {}

class ResetUnreadNotificationsCountState extends MainState {
  final int count;

  ResetUnreadNotificationsCountState({
    required this.count,
  });
}

/// Get Calendar Schedules

class GetCalendarSchedulesLoadingState extends MainState {}

class GetCalendarSchedulesSucceedState extends MainState {
  final List<CalendarModel> schedules;

  GetCalendarSchedulesSucceedState({
    required this.schedules,
  });
}

class GetCalendarSchedulesFailedState extends MainState {}
