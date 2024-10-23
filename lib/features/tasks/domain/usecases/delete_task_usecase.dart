import '../repositories/task_repository.dart';

class DeleteTaskUsecase {
  final TasksRepository repository;

  DeleteTaskUsecase(this.repository);

  Future<void> call(String taskId) async {
    return await repository.deleteTask(taskId);
  }
}
