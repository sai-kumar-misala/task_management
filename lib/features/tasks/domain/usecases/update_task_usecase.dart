import '../../data/models/task_model.dart';
import '../repositories/task_repository.dart';

class UpdateTaskUsecase {
  final TasksRepository repository;

  UpdateTaskUsecase(this.repository);

  Future<void> call(TaskModel task) async {
    return await repository.updateTask(task);
  }
}
