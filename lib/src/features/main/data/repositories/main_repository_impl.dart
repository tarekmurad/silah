import 'package:dartz/dartz.dart';

import '../../../../core/data/errors/base_error.dart';
import '../../../../core/data/models/results/result.dart';
import '../dataSources/main_data_source.dart';
import '../models/announcement_model.dart';

class MainRepositoryImpl {
  final MainDataSourceImpl _mainDataSource;

  MainRepositoryImpl(this._mainDataSource);

  Future<Result<BaseError, List<AnnouncementModel>>> getAnnouncements() async {
    final response = await _mainDataSource.getAnnouncements();
    if (response!.isRight()) {
      return Result(
          data: (response as Right<BaseError, List<AnnouncementModel>>).value);
    } else {
      return Result(
          error: (response as Left<BaseError, List<AnnouncementModel>>).value);
    }
  }
}
