import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:to_do_list/core/usecases/usecase.dart';
import 'package:to_do_list/features/tasks/domain/entities/task.dart';
import 'package:to_do_list/features/tasks/domain/repositories/task_repository.dart';
import 'package:to_do_list/features/tasks/domain/usecases/get_tasks.dart';

import 'get_tasks_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  late GetTasks usecase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    usecase = GetTasks(mockTaskRepository);
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

  test('should get tasks from the repository', () async {
    // arrange
    when(mockTaskRepository.getTasks()).thenAnswer((_) async => Right(tTasks));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, Right(tTasks));
    verify(mockTaskRepository.getTasks());
    verifyNoMoreInteractions(mockTaskRepository);
  });
}
