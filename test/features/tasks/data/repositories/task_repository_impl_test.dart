import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:to_do_list/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:to_do_list/features/tasks/data/models/task_model.dart';
import 'package:to_do_list/features/tasks/data/repositories/task_repository_impl.dart';

import 'task_repository_impl_test.mocks.dart';

@GenerateMocks([TaskLocalDataSource])
void main() {
  late TaskRepositoryImpl repository;
  late MockTaskLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockTaskLocalDataSource();
    repository = TaskRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  group('getTasks', () {
    final tTaskModels = [
      TaskModel(
        id: '1',
        title: 'Test Task 1',
        isCompleted: false,
        createdAt: DateTime(2024, 1, 1),
      ),
      TaskModel(
        id: '2',
        title: 'Test Task 2',
        isCompleted: true,
        createdAt: DateTime(2024, 1, 2),
      ),
    ];

    test(
      'should return tasks when call to local data source is successful',
      () async {
        // arrange
        when(
          mockLocalDataSource.getTasks(),
        ).thenAnswer((_) async => tTaskModels);

        // act
        final result = await repository.getTasks();

        // assert
        verify(mockLocalDataSource.getTasks());
        expect(result, Right(tTaskModels));
      },
    );

    test(
      'should return CacheFailure when call to local data source fails',
      () async {
        // arrange
        when(
          mockLocalDataSource.getTasks(),
        ).thenThrow(Exception('Cache error'));

        // act
        final result = await repository.getTasks();

        // assert
        verify(mockLocalDataSource.getTasks());
        expect(result.isLeft(), true);
      },
    );
  });

  group('addTask', () {
    final tTaskModel = TaskModel(
      id: '1',
      title: 'New Task',
      isCompleted: false,
      createdAt: DateTime(2024, 1, 1),
    );

    test('should cache task when adding is successful', () async {
      // arrange
      when(mockLocalDataSource.getTasks()).thenAnswer((_) async => []);
      when(mockLocalDataSource.cacheTasks(any)).thenAnswer((_) async => {});

      // act
      final result = await repository.addTask(tTaskModel);

      // assert
      verify(mockLocalDataSource.getTasks());
      verify(mockLocalDataSource.cacheTasks(any));
      expect(result, const Right(unit));
    });
  });

  group('deleteTask', () {
    const tTaskId = '1';
    final tTaskModels = [
      TaskModel(
        id: '1',
        title: 'Test Task',
        isCompleted: false,
        createdAt: DateTime(2024, 1, 1),
      ),
    ];

    test('should delete task and cache updated list', () async {
      // arrange
      when(mockLocalDataSource.getTasks()).thenAnswer((_) async => tTaskModels);
      when(mockLocalDataSource.cacheTasks(any)).thenAnswer((_) async => {});

      // act
      final result = await repository.deleteTask(tTaskId);

      // assert
      verify(mockLocalDataSource.getTasks());
      verify(mockLocalDataSource.cacheTasks(any));
      expect(result, const Right(unit));
    });
  });

  group('toggleTask', () {
    const tTaskId = '1';
    final tTaskModels = [
      TaskModel(
        id: '1',
        title: 'Test Task',
        isCompleted: false,
        createdAt: DateTime(2024, 1, 1),
      ),
    ];

    test(
      'should toggle task completion status and cache updated list',
      () async {
        // arrange
        when(
          mockLocalDataSource.getTasks(),
        ).thenAnswer((_) async => tTaskModels);
        when(mockLocalDataSource.cacheTasks(any)).thenAnswer((_) async => {});

        // act
        final result = await repository.toggleTask(tTaskId);

        // assert
        verify(mockLocalDataSource.getTasks());
        verify(mockLocalDataSource.cacheTasks(any));
        expect(result, const Right(unit));
      },
    );
  });
}
