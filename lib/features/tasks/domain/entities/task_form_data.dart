import '../../../../core/utils/task_status.dart';

class TaskFormData {
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskStatus status;

  TaskFormData({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
  });
}
