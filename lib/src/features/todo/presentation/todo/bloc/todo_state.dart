import '../../../data/models/todo_model.dart';

abstract class TodoState {}

class InitialTodoState extends TodoState {}

/// Get Todo List

class GetTodoListLoadingState extends TodoState {}

class GetTodoListSucceedState extends TodoState {
  final List<TodoModel> dailyTasks;
  final List<TodoModel> weeklyTasks;
  final List<TodoModel> monthlyTasks;
  final List<TodoModel> yearlyTasks;

  GetTodoListSucceedState({
    required this.dailyTasks,
    required this.weeklyTasks,
    required this.monthlyTasks,
    required this.yearlyTasks,
  });
}

class GetTodoListFailedState extends TodoState {}

///

class InteractionTodoLoadingState extends TodoState {}

class InteractionTodoSucceedState extends TodoState {}

class InteractionTodoFailedState extends TodoState {}
