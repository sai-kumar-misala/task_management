import '../../data/models/task_model.dart';

abstract class TasksRepository {
  Future<void> createTask(TaskModel task);
  Stream<List<TaskModel>> getTasks();
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
}
