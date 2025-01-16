abstract class TodoEvent {}

class GetTodoList extends TodoEvent {}

class InteractionTodo extends TodoEvent {
  final String taskId;
  final String forDate;
  final int record;

  InteractionTodo({
    required this.taskId,
    required this.forDate,
    required this.record,
  });
}
