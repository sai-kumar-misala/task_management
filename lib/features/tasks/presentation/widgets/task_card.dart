import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_paddings.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/status_color.dart';
import '../../../../shared/widgets/custom_icon_button.dart';
import '../../../../shared/widgets/custom_snackbar.dart';
import '../../../../shared/widgets/spacings.dart';
import '../../data/models/task_model.dart';
import '../providers/task_providers.dart';

class TaskCard extends ConsumerWidget {
  final TaskModel task;
  final void Function()? onTap;
  const TaskCard({super.key, required this.task, this.onTap});

  Future<void> _showDeleteConfirmation(
      BuildContext context, WidgetRef ref) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(AppStrings.deleteTask),
          content: const Text(AppStrings.deleteAlert),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(AppStrings.cancel),
            ),
            FilledButton(
              onPressed: () async {
                await ref.read(deleteTaskProvider.notifier).deleteTask(task.id);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
                // ignore: use_build_context_synchronously
                CustomSnackBar.show(context, AppStrings.deleteSuccessful);
              },
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                foregroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.hovered)) {
                      return Colors.white;
                    }
                    return AppColors.errorColor;
                  },
                ),
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.hovered)) {
                      return AppColors.errorColor;
                    }
                    return AppColors.errorColor.withOpacity(0.15);
                  },
                ),
                overlayColor: WidgetStateProperty.all(Colors.transparent),
              ),
              child: const Text(AppStrings.delete),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 175,
      child: Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: AppPaddings.g16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacing.horizontal(8),
                    Row(
                      children: [
                        CustomIconButton(
                          toolTip: AppStrings.edit,
                          onPressed: () => context.goNamed(
                            'edit-task',
                            pathParameters: {'taskId': task.id},
                          ),
                          icon: Icons.edit,
                        ),
                        const Spacing.horizontal(8),
                        CustomIconButton(
                          toolTip: AppStrings.delete,
                          onPressed: () =>
                              _showDeleteConfirmation(context, ref),
                          icon: Icons.delete,
                        )
                      ],
                    )
                  ],
                ),
                const Spacing.vertical(8),
                SizedBox(
                  height: 48,
                  child: Text(
                    task.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_today, size: 16),
                          const Spacing.horizontal(4),
                          Expanded(
                            child: Text(
                              task.dueDate.toLocal().toString().split(' ')[0],
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: getStatusColor(task.status).withOpacity(0.125),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        task.status,
                        style: TextStyle(
                          color: getStatusColor(task.status),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
