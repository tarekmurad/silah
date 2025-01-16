import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../../../core/constants/endpoint_url.dart';
import '../../../../core/data/errors/base_error.dart';
import '../../../../core/data/http_helper.dart';
import '../models/todo_model.dart';

class TodoDataSourceImpl {
  final HttpHelper _httpHelper;

  TodoDataSourceImpl(this._httpHelper);

  Future<Either<BaseError, List<TodoModel>>>? getTodoList(
      String startDate, String endDate) async {
    final response = await _httpHelper.postRequest(
      EndpointUrl.getTasksUrl,
      withAuthentication: true,
    );

    return response!.fold(
      (error) => Left(error),
      (data) {
        final List<TodoModel> schedules = (data.data["tasks"] as List)
            .map((json) => TodoModel.fromJson(json))
            .toList();
        return Right(schedules);
      },
    );
  }

  Future<Either<BaseError, TodoModel>>? interactionTasks(
      String taskId, String forDate, int record) async {
    final response = await _httpHelper.postRequest(
      EndpointUrl.interactionTasksUrl,
      withAuthentication: true,
      rawDataString: jsonEncode({
        'taskId': taskId,
        'forDate': forDate,
        'record': record,
      }),
    );

    return response!.fold(
      (error) => Left(error),
      (data) => Right(TodoModel.fromJson(data.data!)),
    );
  }
}
