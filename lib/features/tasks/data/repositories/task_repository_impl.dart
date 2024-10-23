import '../datasources/task_remote_datasource.dart';
import '../models/task_model.dart';

abstract class TasksRepository {
  Future<void> createTask(TaskModel task);
  Stream<List<TaskModel>> getTasks();
}

class TasksRepositoryImpl implements TasksRepository {
  final TasksRemoteDataSource remoteDataSource;

  TasksRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createTask(TaskModel task) async {
    return remoteDataSource.createTask(task);
  }

  @override
  Stream<List<TaskModel>> getTasks() {
    return remoteDataSource.getTasks();
  }

  Stream<TaskModel?> getTaskById(String taskId) {
    return remoteDataSource.getTaskById(taskId);
  }
}
