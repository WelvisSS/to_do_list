import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/task_repository.dart';

class ToggleTask implements UseCase<Unit, ToggleTaskParams> {
  final TaskRepository repository;

  ToggleTask(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ToggleTaskParams params) async {
    return await repository.toggleTask(params.id);
  }
}

class ToggleTaskParams extends Equatable {
  final String id;

  const ToggleTaskParams({required this.id});

  @override
  List<Object> get props => [id];
}
