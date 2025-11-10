import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:to_do_list/core/errors/failures.dart';
import 'package:to_do_list/features/tasks/domain/entities/task.dart';
import 'package:to_do_list/features/tasks/domain/usecases/add_task.dart';
import 'package:to_do_list/features/tasks/domain/usecases/delete_task.dart';
import 'package:to_do_list/features/tasks/domain/usecases/get_tasks.dart';
import 'package:to_do_list/features/tasks/domain/usecases/toggle_task.dart';
import 'package:to_do_list/features/tasks/presentation/bloc/task_bloc.dart';

import 'task_bloc_test.mocks.dart';

@GenerateMocks([GetTasks, AddTask, DeleteTask, ToggleTask])
void main() {
  late TaskBloc bloc;
  late MockGetTasks mockGetTasks;
  late MockAddTask mockAddTask;
  late MockDeleteTask mockDeleteTask;
  late MockToggleTask mockToggleTask;

  setUp(() {
    mockGetTasks = MockGetTasks();
    mockAddTask = MockAddTask();
    mockDeleteTask = MockDeleteTask();
    mockToggleTask = MockToggleTask();
    bloc = TaskBloc(
      getTasks: mockGetTasks,
      addTask: mockAddTask,
      deleteTask: mockDeleteTask,
      toggleTask: mockToggleTask,
    );
  });

  tearDown(() {
    bloc.close();
  });

  final tTasks = [
    Task(
      id: '1',
      title: 'Test Task 1',
      isCompleted: false,
      createdAt: DateTime(2024, 1, 1),
    ),
    Task(
      id: '2',
      title: 'Test Task 2',
      isCompleted: true,
      createdAt: DateTime(2024, 1, 2),
    ),
  ];

  test('initial state should be TaskInitial', () {
    expect(bloc.state, TaskInitial());
  });

  group('LoadTasksEvent', () {
    blocTest<TaskBloc, TaskState>(
      'should emit [TaskLoading, TaskLoaded] when data is gotten successfully',
      build: () {
        when(mockGetTasks(any)).thenAnswer((_) async => Right(tTasks));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadTasksEvent()),
      expect: () => [
        TaskLoading(),
        TaskLoaded(
          allTasks: tTasks,
          filteredTasks: tTasks,
          currentFilter: TaskFilter.all,
        ),
      ],
      verify: (_) {
        verify(mockGetTasks(any));
      },
    );

    blocTest<TaskBloc, TaskState>(
      'should emit [TaskLoading, TaskError] when getting data fails',
      build: () {
        when(
          mockGetTasks(any),
        ).thenAnswer((_) async => const Left(CacheFailure('Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadTasksEvent()),
      expect: () => [TaskLoading(), const TaskError('Error')],
    );
  });

  group('AddTaskEvent', () {
    blocTest<TaskBloc, TaskState>(
      'should emit updated TaskLoaded with new task',
      build: () {
        when(mockGetTasks(any)).thenAnswer((_) async => Right(tTasks));
        when(mockAddTask(any)).thenAnswer((_) async => const Right(unit));
        return bloc;
      },
      act: (bloc) {
        bloc.add(LoadTasksEvent());
        return Future.delayed(
          const Duration(milliseconds: 100),
          () => bloc.add(const AddTaskEvent('New Task')),
        );
      },
      skip: 2,
      verify: (_) {
        verify(mockAddTask(any));
      },
    );
  });

  group('DeleteTaskEvent', () {
    blocTest<TaskBloc, TaskState>(
      'should emit updated TaskLoaded without deleted task',
      build: () {
        when(mockGetTasks(any)).thenAnswer((_) async => Right(tTasks));
        when(mockDeleteTask(any)).thenAnswer((_) async => const Right(unit));
        return bloc;
      },
      act: (bloc) {
        bloc.add(LoadTasksEvent());
        return Future.delayed(
          const Duration(milliseconds: 100),
          () => bloc.add(const DeleteTaskEvent('1')),
        );
      },
      skip: 2,
      verify: (_) {
        verify(mockDeleteTask(any));
      },
    );
  });

  group('ToggleTaskEvent', () {
    blocTest<TaskBloc, TaskState>(
      'should emit updated TaskLoaded with toggled task',
      build: () {
        when(mockGetTasks(any)).thenAnswer((_) async => Right(tTasks));
        when(mockToggleTask(any)).thenAnswer((_) async => const Right(unit));
        return bloc;
      },
      act: (bloc) {
        bloc.add(LoadTasksEvent());
        return Future.delayed(
          const Duration(milliseconds: 100),
          () => bloc.add(const ToggleTaskEvent('1')),
        );
      },
      skip: 2,
      verify: (_) {
        verify(mockToggleTask(any));
      },
    );
  });

  group('FilterTasksEvent', () {
    blocTest<TaskBloc, TaskState>(
      'should emit TaskLoaded with filtered tasks for pending',
      build: () {
        when(mockGetTasks(any)).thenAnswer((_) async => Right(tTasks));
        return bloc;
      },
      act: (bloc) {
        bloc.add(LoadTasksEvent());
        return Future.delayed(
          const Duration(milliseconds: 100),
          () => bloc.add(const FilterTasksEvent(TaskFilter.pending)),
        );
      },
      skip: 2,
      expect: () => [
        TaskLoaded(
          allTasks: tTasks,
          filteredTasks: [tTasks[0]],
          currentFilter: TaskFilter.pending,
        ),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'should emit TaskLoaded with filtered tasks for done',
      build: () {
        when(mockGetTasks(any)).thenAnswer((_) async => Right(tTasks));
        return bloc;
      },
      act: (bloc) {
        bloc.add(LoadTasksEvent());
        return Future.delayed(
          const Duration(milliseconds: 100),
          () => bloc.add(const FilterTasksEvent(TaskFilter.done)),
        );
      },
      skip: 2,
      expect: () => [
        TaskLoaded(
          allTasks: tTasks,
          filteredTasks: [tTasks[1]],
          currentFilter: TaskFilter.done,
        ),
      ],
    );
  });
}
