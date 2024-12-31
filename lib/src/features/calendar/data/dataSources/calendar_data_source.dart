import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../../../core/constants/endpoint_url.dart';
import '../../../../core/data/errors/base_error.dart';
import '../../../../core/data/http_helper.dart';
import '../models/calendar_model.dart';

class CalendarDataSourceImpl {
  final HttpHelper _httpHelper;

  CalendarDataSourceImpl(this._httpHelper);

  Future<Either<BaseError, List<CalendarModel>>>? getCalendarSchedules(
      String startDate, String endDate) async {
    final response = await _httpHelper.postRequest(
      EndpointUrl.getCalendarSchedulesUrl,
      withAuthentication: true,
      rawDataString: jsonEncode({
        'startDate': startDate,
        'endDate': endDate,
      }),
    );

    return response!.fold(
      (error) => Left(error),
      (data) {
        final List<CalendarModel> schedules = (data.data["schedules"] as List)
            .map((json) => CalendarModel.fromJson(json))
            .toList();
        return Right(schedules);
      },
    );
  }
}
