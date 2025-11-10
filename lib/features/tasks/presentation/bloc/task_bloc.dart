import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/toggle_task.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final DeleteTask deleteTask;
  final ToggleTask toggleTask;

  TaskBloc({
    required this.getTasks,
    required this.addTask,
    required this.deleteTask,
    required this.toggleTask,
  }) : super(TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleTaskEvent>(_onToggleTask);
    on<FilterTasksEvent>(_onFilterTasks);
  }

  Future<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    final result = await getTasks(NoParams());
    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (tasks) => emit(
        TaskLoaded(
          allTasks: tasks,
          filteredTasks: tasks,
          currentFilter: TaskFilter.all,
        ),
      ),
    );
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: event.title,
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      final result = await addTask(AddTaskParams(task: newTask));
      result.fold((failure) => emit(TaskError(failure.message)), (_) {
        final updatedTasks = [...currentState.allTasks, newTask];
        final filteredTasks = _filterTasks(
          updatedTasks,
          currentState.currentFilter,
        );
        emit(
          currentState.copyWith(
            allTasks: updatedTasks,
            filteredTasks: filteredTasks,
          ),
        );
      });
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      final result = await deleteTask(DeleteTaskParams(id: event.id));
      result.fold((failure) => emit(TaskError(failure.message)), (_) {
        final updatedTasks = currentState.allTasks
            .where((task) => task.id != event.id)
            .toList();
        final filteredTasks = _filterTasks(
          updatedTasks,
          currentState.currentFilter,
        );
        emit(
          currentState.copyWith(
            allTasks: updatedTasks,
            filteredTasks: filteredTasks,
          ),
        );
      });
    }
  }

  Future<void> _onToggleTask(
    ToggleTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      final result = await toggleTask(ToggleTaskParams(id: event.id));
      result.fold((failure) => emit(TaskError(failure.message)), (_) {
        final updatedTasks = currentState.allTasks.map((task) {
          if (task.id == event.id) {
            return task.copyWith(isCompleted: !task.isCompleted);
          }
          return task;
        }).toList();
        final filteredTasks = _filterTasks(
          updatedTasks,
          currentState.currentFilter,
        );
        emit(
          currentState.copyWith(
            allTasks: updatedTasks,
            filteredTasks: filteredTasks,
          ),
        );
      });
    }
  }

  void _onFilterTasks(FilterTasksEvent event, Emitter<TaskState> emit) {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      final filteredTasks = _filterTasks(currentState.allTasks, event.filter);
      emit(
        currentState.copyWith(
          filteredTasks: filteredTasks,
          currentFilter: event.filter,
        ),
      );
    }
  }

  List<Task> _filterTasks(List<Task> tasks, TaskFilter filter) {
    switch (filter) {
      case TaskFilter.pending:
        return tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.done:
        return tasks.where((task) => task.isCompleted).toList();
      case TaskFilter.all:
        return tasks;
    }
  }
}
