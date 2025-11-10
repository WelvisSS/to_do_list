import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class AddTask implements UseCase<Unit, AddTaskParams> {
  final TaskRepository repository;

  AddTask(this.repository);

  @override
  Future<Either<Failure, Unit>> call(AddTaskParams params) async {
    return await repository.addTask(params.task);
  }
}

class AddTaskParams extends Equatable {
  final Task task;

  const AddTaskParams({required this.task});

  @override
  List<Object> get props => [task];
}
