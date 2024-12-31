import 'package:bloc/bloc.dart';

import '../../../data/repositories/calendar_repository_impl.dart';
import 'bloc.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarRepositoryImpl calendarRepository;

  CalendarBloc(this.calendarRepository) : super(InitialCalendarState()) {
    on<GetCalendarSchedules>(_onGetCalendarSchedules);
  }

  Future<void> _onGetCalendarSchedules(
    GetCalendarSchedules event,
    Emitter<CalendarState> emit,
  ) async {
    emit(GetCalendarSchedulesLoadingState());

    // try {
    final result = await calendarRepository.getCalendarSchedules(
        "2024-01-01T17:50:42.852Z", "2025-12-31T17:50:42.852Z");

    if (result.hasDataOnly) {
      emit(GetCalendarSchedulesSucceedState(schedules: result.data!));
    } else if (result.hasErrorOnly) {
      emit(GetCalendarSchedulesFailedState());
    }
    // } catch (e) {
    //   emit(GetCalendarSchedulesFailedState());
    // }
  }
}
