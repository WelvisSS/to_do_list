import 'package:dartz/dartz.dart' hide Task;

import '../../../../core/errors/failures.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Task>>> getTasks() async {
    try {
      final tasks = await localDataSource.getTasks();
      return Right(tasks);
    } catch (e) {
      return Left(CacheFailure('Failed to get tasks: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> addTask(Task task) async {
    try {
      final tasks = await localDataSource.getTasks();
      final newTask = TaskModel.fromEntity(task);
      tasks.add(newTask);
      await localDataSource.cacheTasks(tasks);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('Failed to add task: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTask(String id) async {
    try {
      final tasks = await localDataSource.getTasks();
      tasks.removeWhere((task) => task.id == id);
      await localDataSource.cacheTasks(tasks);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('Failed to delete task: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> toggleTask(String id) async {
    try {
      final tasks = await localDataSource.getTasks();
      final taskIndex = tasks.indexWhere((task) => task.id == id);
      if (taskIndex != -1) {
        final task = tasks[taskIndex];
        tasks[taskIndex] = TaskModel(
          id: task.id,
          title: task.title,
          isCompleted: !task.isCompleted,
          createdAt: task.createdAt,
        );
        await localDataSource.cacheTasks(tasks);
      }
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('Failed to toggle task: ${e.toString()}'));
    }
  }
}
