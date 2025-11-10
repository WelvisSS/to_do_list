import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:to_do_list/features/tasks/domain/entities/task.dart';
import 'package:to_do_list/features/tasks/domain/repositories/task_repository.dart';
import 'package:to_do_list/features/tasks/domain/usecases/add_task.dart';

import 'add_task_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  late AddTask usecase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    usecase = AddTask(mockTaskRepository);
  });

  final tTask = Task(
    id: '1',
    title: 'Test Task',
    isCompleted: false,
    createdAt: DateTime(2024, 1, 1),
  );

  test('should add task to the repository', () async {
    // arrange
    when(
      mockTaskRepository.addTask(any),
    ).thenAnswer((_) async => const Right(unit));

    // act
    final result = await usecase(AddTaskParams(task: tTask));

    // assert
    expect(result, const Right(unit));
    verify(mockTaskRepository.addTask(tTask));
    verifyNoMoreInteractions(mockTaskRepository);
  });
}
