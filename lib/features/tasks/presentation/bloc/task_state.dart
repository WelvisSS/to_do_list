part of 'task_bloc.dart';

enum TaskFilter { all, pending, done }

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> allTasks;
  final List<Task> filteredTasks;
  final TaskFilter currentFilter;

  const TaskLoaded({
    required this.allTasks,
    required this.filteredTasks,
    required this.currentFilter,
  });

  @override
  List<Object> get props => [allTasks, filteredTasks, currentFilter];

  TaskLoaded copyWith({
    List<Task>? allTasks,
    List<Task>? filteredTasks,
    TaskFilter? currentFilter,
  }) {
    return TaskLoaded(
      allTasks: allTasks ?? this.allTasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object> get props => [message];
}
