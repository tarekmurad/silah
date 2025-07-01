import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/constants/endpoint_url.dart';
import '../../../../core/data/errors/base_error.dart';
import '../../../../core/data/http_helper.dart';
import '../models/announcement_model.dart';

class MainDataSourceImpl {
  final HttpHelper _httpHelper;

  MainDataSourceImpl(this._httpHelper);

  Future<Either<BaseError, List<AnnouncementModel>>>? getAnnouncements() async {
    final response = await _httpHelper.postRequest(
      EndpointUrl.getAnnouncementUrl,
      withAuthentication: true,
    );

    return response!.fold(
      (error) => Left(error),
      (data) {
        final List<AnnouncementModel> schedules =
            (data.data["announcements"] as List)
                .map((json) => AnnouncementModel.fromJson(json))
                .toList();
        return Right(schedules);
      },
    );
  }
}
