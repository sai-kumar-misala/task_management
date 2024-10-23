import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository_impl.dart';

class CreateTaskUseCase {
  final TasksRepository repository;

  CreateTaskUseCase(this.repository);

  Future<void> call(TaskModel task) async {
    return await repository.createTask(task);
  }
}
