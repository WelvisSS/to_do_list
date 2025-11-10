import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:to_do_list/features/tasks/domain/repositories/task_repository.dart';
import 'package:to_do_list/features/tasks/domain/usecases/toggle_task.dart';

import 'toggle_task_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  late ToggleTask usecase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    usecase = ToggleTask(mockTaskRepository);
  });

  const tTaskId = '1';

  test('should toggle task status in the repository', () async {
    // arrange
    when(
      mockTaskRepository.toggleTask(any),
    ).thenAnswer((_) async => const Right(unit));

    // act
    final result = await usecase(const ToggleTaskParams(id: tTaskId));

    // assert
    expect(result, const Right(unit));
    verify(mockTaskRepository.toggleTask(tTaskId));
    verifyNoMoreInteractions(mockTaskRepository);
  });
}
