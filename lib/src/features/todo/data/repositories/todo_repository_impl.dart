import 'package:dartz/dartz.dart';

import '../../../../core/data/errors/base_error.dart';
import '../../../../core/data/models/results/result.dart';
import '../dataSources/todo_data_source.dart';
import '../models/todo_model.dart';

class TodoRepositoryImpl {
  final TodoDataSourceImpl _calendarDataSource;

  TodoRepositoryImpl(this._calendarDataSource);

  Future<Result<BaseError, List<TodoModel>>> getTodoList(
      String startDate, String endDate) async {
    final response = await _calendarDataSource.getTodoList(startDate, endDate);
    if (response!.isRight()) {
      return Result(
          data: (response as Right<BaseError, List<TodoModel>>).value);
    } else {
      return Result(
          error: (response as Left<BaseError, List<TodoModel>>).value);
    }
  }

  Future<Result<BaseError, TodoModel>> interactionTasks(
      String taskId, String forDate, int record) async {
    final response =
        await _calendarDataSource.interactionTasks(taskId, forDate, record);
    if (response!.isRight()) {
      return Result(data: (response as Right<BaseError, TodoModel>).value);
    } else {
      return Result(error: (response as Left<BaseError, TodoModel>).value);
    }
  }
}
