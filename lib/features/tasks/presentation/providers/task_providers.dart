import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/task_remote_datasource.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/usecases/create_task_usecase.dart';
import '../../domain/usecases/update_task_usecase.dart';

final tasksRepositoryProvider = Provider(
    (ref) => TasksRepositoryImpl(remoteDataSource: TasksRemoteDataSource()));

final createTaskProvider = Provider((ref) {
  return CreateTaskUseCase(ref.watch(tasksRepositoryProvider));
});

final getTasksProvider = StreamProvider<List<TaskModel>>((ref) {
  return ref.watch(tasksRepositoryProvider).getTasks();
});

final getTaskByIdProvider =
    StreamProvider.family<TaskModel?, String>((ref, taskId) {
  return ref.read(tasksRepositoryProvider).getTaskById(taskId);
});

final updateTaskUseCaseProvider = Provider<UpdateTaskUsecase>((ref) {
  final repository = ref.watch(tasksRepositoryProvider);
  return UpdateTaskUsecase(repository);
});

final updateTaskProvider = Provider<UpdateTaskUsecase>((ref) {
  return ref.watch(updateTaskUseCaseProvider);
});

final deleteTaskProvider = Provider((ref) {
  final repository = ref.watch(tasksRepositoryProvider);
  return (String taskId) => repository.deleteTask(taskId);
});
