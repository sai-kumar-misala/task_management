import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_paddings.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/status_color.dart';
import '../../../../shared/widgets/spacings.dart';
import '../../data/models/task_model.dart';
import '../providers/task_providers.dart';

class TaskDetailsPage extends ConsumerWidget {
  final String taskId;
  const TaskDetailsPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsync = ref.watch(getTaskByIdProvider(taskId));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(AppStrings.taskDetails),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed('dashboard'),
        ),
      ),
      body: taskAsync.when(
        data: (task) => _buildTaskDetails(context, task!),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('${AppStrings.errorLoadingTask}: $error'),
        ),
      ),
    );
  }

  Widget _buildTaskDetails(BuildContext context, TaskModel task) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 600;
        final contentPadding = isWideScreen ? 32.0 : 24.0;
        final maxWidth = isWideScreen ? 600.0 : constraints.maxWidth * 0.95;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: maxWidth,
              constraints: const BoxConstraints(maxWidth: 600),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(contentPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const Spacing.vertical(16),
                    Container(
                      padding: AppPaddings.gH12V6,
                      decoration: BoxDecoration(
                        color: getStatusColor(task.status).withOpacity(0.125),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        task.status,
                        style: TextStyle(
                          color: getStatusColor(task.status),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacing.vertical(24),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 20),
                        const Spacing.horizontal(8),
                        Text(
                          '${AppStrings.dueDate} ${formatDate(task.dueDate)}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    const Spacing.vertical(16),
                    const Divider(),
                    const Spacing.vertical(16),
                    Text(
                      AppStrings.description,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Spacing.vertical(12),
                    Text(
                      task.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
