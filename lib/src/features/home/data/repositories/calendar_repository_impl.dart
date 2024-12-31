import 'package:dartz/dartz.dart';

import '../../../../core/data/errors/base_error.dart';
import '../../../../core/data/models/results/result.dart';
import '../dataSources/calendar_data_source.dart';
import '../models/calendar_model.dart';

class CalendarRepositoryImpl {
  final CalendarDataSourceImpl _calendarDataSource;

  CalendarRepositoryImpl(this._calendarDataSource);

  Future<Result<BaseError, List<CalendarModel>>> getCalendarSchedules(
      String startDate, String endDate) async {
    final response =
        await _calendarDataSource.getCalendarSchedules(startDate, endDate);
    if (response!.isRight()) {
      return Result(
          data: (response as Right<BaseError, List<CalendarModel>>).value);
    } else {
      return Result(
          error: (response as Left<BaseError, List<CalendarModel>>).value);
    }
  }
}
