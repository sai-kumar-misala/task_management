import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_datasource.dart';
import '../models/task_model.dart';

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

  @override
  Future<void> updateTask(TaskModel taskId) {
    return remoteDataSource.updateTask(taskId);
  }

  @override
  Future<void> deleteTask(String taskId) {
    return remoteDataSource.deleteTask(taskId);
  }

  @override
  Future<List<TaskModel>> getPaginatedTasks(int limit, String? lastDocumentId) {
    return remoteDataSource.getPaginatedTasks(limit, lastDocumentId);
  }
}
