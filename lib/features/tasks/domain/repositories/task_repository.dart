import 'package:dartz/dartz.dart' hide Task;

import '../../../../core/errors/failures.dart';
import '../entities/task.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<Task>>> getTasks();
  Future<Either<Failure, Unit>> addTask(Task task);
  Future<Either<Failure, Unit>> deleteTask(String id);
  Future<Either<Failure, Unit>> toggleTask(String id);
}
