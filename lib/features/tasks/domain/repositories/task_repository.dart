import '../../data/models/task_model.dart';

abstract class TasksRepository {
  Future<void> createTask(TaskModel task);
  Stream<List<TaskModel>> getTasks();
  Future<List<TaskModel>> getPaginatedTasks(int limit, String? lastDocumentId);
  Stream<TaskModel?> getTaskById(String id);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
}
