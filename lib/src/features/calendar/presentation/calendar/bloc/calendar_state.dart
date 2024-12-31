import '../../../data/models/calendar_model.dart';

abstract class CalendarState {}

class InitialCalendarState extends CalendarState {}

/// Get Calendar Schedules

class GetCalendarSchedulesLoadingState extends CalendarState {}

class GetCalendarSchedulesSucceedState extends CalendarState {
  final List<CalendarModel> schedules;

  GetCalendarSchedulesSucceedState({
    required this.schedules,
  });
}

class GetCalendarSchedulesFailedState extends CalendarState {}
