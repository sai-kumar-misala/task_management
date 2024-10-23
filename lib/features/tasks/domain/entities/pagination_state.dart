import '../../data/models/task_model.dart';

class PaginationState {
  final List<TaskModel> tasks;
  final bool isLoading;
  final bool hasMore;
  final String? lastDocument;
  final String? error;

  PaginationState({
    required this.tasks,
    required this.isLoading,
    required this.hasMore,
    this.lastDocument,
    this.error,
  });

  factory PaginationState.initial() => PaginationState(
        tasks: [],
        isLoading: false,
        hasMore: true,
        lastDocument: null,
        error: null,
      );

  PaginationState copyWith({
    List<TaskModel>? tasks,
    bool? isLoading,
    bool? hasMore,
    String? lastDocument,
    String? error,
  }) {
    return PaginationState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      lastDocument: lastDocument ?? this.lastDocument,
      error: error ?? this.error,
    );
  }
}
