import 'package:bloc/bloc.dart';
import 'package:rrule/rrule.dart';

import '../../../data/models/todo_model.dart';
import '../../../data/repositories/todo_repository_impl.dart';
import 'bloc.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoRepositoryImpl calendarRepository;

  TodoBloc(this.calendarRepository) : super(InitialTodoState()) {
    on<GetTodoList>(_onGetTodoList);
    on<InteractionTodo>(_onInteractionTodo);
  }

  Future<void> _onGetTodoList(
    GetTodoList event,
    Emitter<TodoState> emit,
  ) async {
    emit(GetTodoListLoadingState());

    // try {
    final result = await calendarRepository.getTodoList(
        "2024-01-01T17:50:42.852Z", "2025-12-31T17:50:42.852Z");

    if (result.hasDataOnly) {
      final List<TodoModel> dailyTasks = [];
      final List<TodoModel> weeklyTasks = [];
      final List<TodoModel> monthlyTasks = [];
      final List<TodoModel> yearlyTasks = [];

      for (final task in result.data!) {
        try {
          final rrule = RecurrenceRule.fromString(task.recurrence!);
          switch (rrule.frequency) {
            case Frequency.daily:
              dailyTasks.add(task);
              break;
            case Frequency.weekly:
              weeklyTasks.add(task);
              break;
            case Frequency.monthly:
              monthlyTasks.add(task);
              break;
            case Frequency.yearly:
              yearlyTasks.add(task);
              break;
            default:
              print('Unknown frequency for task: ${task.title}');
          }
        } catch (e) {
          print(
              'Error parsing recurrence rule for task: ${task.title}. Error: $e');
        }
      }

      emit(GetTodoListSucceedState(
        dailyTasks: dailyTasks,
        weeklyTasks: weeklyTasks,
        monthlyTasks: monthlyTasks,
        yearlyTasks: yearlyTasks,
      ));
    } else if (result.hasErrorOnly) {
      emit(GetTodoListFailedState());
    }
    // } catch (e) {
    //   emit(GetTodoListFailedState());
    // }
  }

  Future<void> _onInteractionTodo(
    InteractionTodo event,
    Emitter<TodoState> emit,
  ) async {
    emit(InteractionTodoLoadingState());

    // try {
    final result = await calendarRepository.interactionTasks(
        event.taskId, event.forDate, event.record);

    if (result.hasDataOnly) {
      emit(InteractionTodoSucceedState());
    } else if (result.hasErrorOnly) {
      emit(InteractionTodoFailedState());
    }
    // } catch (e) {
    //   emit(GetTodoListFailedState());
    // }
  }
}
