import '../../data/models/task_model.dart';
import '../repositories/task_repository.dart';

class CreateTaskUseCase {
  final TasksRepository repository;

  CreateTaskUseCase(this.repository);

  Future<void> call(TaskModel task) async {
    return await repository.createTask(task);
  }
}
