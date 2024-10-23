import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/task_remote_datasource.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/entities/pagination_state.dart';
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

final deleteTaskProvider =
    StateNotifierProvider<DeleteTaskNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(tasksRepositoryProvider);
  return DeleteTaskNotifier(repository, ref);
});

class DeleteTaskNotifier extends StateNotifier<AsyncValue<void>> {
  final TasksRepositoryImpl _repository;
  final Ref _ref;

  DeleteTaskNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> deleteTask(String taskId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteTask(taskId);
      _ref.read(paginatedTasksProvider.notifier).handleTaskDeletion(taskId);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

class PaginationNotifier extends StateNotifier<PaginationState> {
  PaginationNotifier(this._repository) : super(PaginationState.initial());
  final TasksRepositoryImpl _repository;
  static const int _limit = 10;

  Future<void> loadInitial() async {
    state = state.copyWith(isLoading: true);
    try {
      final tasks = await _repository.getPaginatedTasks(_limit, null);
      state = state.copyWith(
        tasks: tasks,
        isLoading: false,
        hasMore: tasks.length >= _limit,
        lastDocument: tasks.isNotEmpty ? tasks.last.id : null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);
    try {
      final moreTasks = await _repository.getPaginatedTasks(
        _limit,
        state.lastDocument,
      );

      state = state.copyWith(
        tasks: [...state.tasks, ...moreTasks],
        isLoading: false,
        hasMore: moreTasks.length >= _limit,
        lastDocument:
            moreTasks.isNotEmpty ? moreTasks.last.id : state.lastDocument,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    state = PaginationState.initial();
    await loadInitial();
  }

  Future<void> handleTaskDeletion(String taskId) async {
    final updatedTasks =
        state.tasks.where((task) => task.id != taskId).toList();

    if (updatedTasks.length < state.tasks.length && state.hasMore) {
      try {
        final additionalTasks = await _repository.getPaginatedTasks(
          1,
          state.lastDocument,
        );

        if (additionalTasks.isNotEmpty) {
          updatedTasks.addAll(additionalTasks);
          state = state.copyWith(
            tasks: updatedTasks,
            lastDocument: additionalTasks.last.id,
          );
        } else {
          state = state.copyWith(
            tasks: updatedTasks,
            hasMore: false,
          );
        }
      } catch (e) {
        state = state.copyWith(
          tasks: updatedTasks,
          error: e.toString(),
        );
      }
    } else {
      state = state.copyWith(tasks: updatedTasks);
    }
  }
}

final paginatedTasksProvider =
    StateNotifierProvider<PaginationNotifier, PaginationState>((ref) {
  return PaginationNotifier(ref.watch(tasksRepositoryProvider));
});
