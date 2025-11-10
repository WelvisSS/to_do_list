import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:to_do_list/features/tasks/domain/repositories/task_repository.dart';
import 'package:to_do_list/features/tasks/domain/usecases/delete_task.dart';

import 'delete_task_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  late DeleteTask usecase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    usecase = DeleteTask(mockTaskRepository);
  });

  const tTaskId = '1';

  test('should delete task from the repository', () async {
    // arrange
    when(
      mockTaskRepository.deleteTask(any),
    ).thenAnswer((_) async => const Right(unit));

    // act
    final result = await usecase(const DeleteTaskParams(id: tTaskId));

    // assert
    expect(result, const Right(unit));
    verify(mockTaskRepository.deleteTask(tTaskId));
    verifyNoMoreInteractions(mockTaskRepository);
  });
}
