import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';

import '../../../../shared/widgets/custom_snackbar.dart';
import '../../data/models/task_model.dart';
import '../providers/task_providers.dart';
import '../widgets/error_view.dart';
import '../widgets/task_form.dart';

class EditTaskPage extends ConsumerWidget {
  final String taskId;

  const EditTaskPage({
    super.key,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskDetails = ref.watch(getTaskByIdProvider(taskId));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(AppStrings.editTask),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed('dashboard'),
        ),
      ),
      body: taskDetails.when(
        data: (task) => TaskForm(
          initialData: task,
          showStatus: true,
          onSubmit: (formData) async {
            final currentUser = FirebaseAuth.instance.currentUser;
            if (currentUser == null) {
              throw Exception(AppStrings.userNotAuthenticated);
            }

            final updatedTask = TaskModel(
              id: taskId,
              userId: currentUser.uid,
              title: formData.title,
              description: formData.description,
              dueDate: formData.dueDate,
              status: formData.status.display,
            );

            try {
              await ref.read(updateTaskProvider).call(updatedTask);
              if (context.mounted) {
                context.goNamed('dashboard');
                CustomSnackBar.show(context, AppStrings.taskUpdateSuccessful);
              }
            } catch (e) {
              if (context.mounted) {
                CustomSnackBar.show(
                    context, '${AppStrings.errorUpdatingTask}: $e');
              }
            }
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ErrorView(
          error: error,
          onRetry: () => context.goNamed('dashboard'),
        ),
      ),
    );
  }
}
