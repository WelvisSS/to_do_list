part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTasksEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final String title;

  const AddTaskEvent(this.title);

  @override
  List<Object> get props => [title];
}

class DeleteTaskEvent extends TaskEvent {
  final String id;

  const DeleteTaskEvent(this.id);

  @override
  List<Object> get props => [id];
}

class ToggleTaskEvent extends TaskEvent {
  final String id;

  const ToggleTaskEvent(this.id);

  @override
  List<Object> get props => [id];
}

class FilterTasksEvent extends TaskEvent {
  final TaskFilter filter;

  const FilterTasksEvent(this.filter);

  @override
  List<Object> get props => [filter];
}
