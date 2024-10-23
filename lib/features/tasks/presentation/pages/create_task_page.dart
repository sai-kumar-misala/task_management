import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/app_strings.dart';

import '../../../../shared/widgets/custom_snackbar.dart';
import '../../data/models/task_model.dart';
import '../providers/task_providers.dart';
import '../widgets/task_form.dart';

class CreateTaskPage extends ConsumerWidget {
  const CreateTaskPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(AppStrings.createTask),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed('dashboard'),
        ),
      ),
      body: TaskForm(
        onSubmit: (formData) async {
          final currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser == null) {
            CustomSnackBar.show(context, AppStrings.userNotAuthenticated);
            return;
          }

          final task = TaskModel(
            id: const Uuid().v4(),
            userId: currentUser.uid,
            title: formData.title,
            description: formData.description,
            dueDate: formData.dueDate,
            status: formData.status.display,
          );

          try {
            await ref.read(createTaskProvider).call(task);
            if (context.mounted) {
              context.goNamed('dashboard');
              CustomSnackBar.show(context, AppStrings.taskCreated);
            }
          } catch (e) {
            if (context.mounted) {
              CustomSnackBar.show(
                  context, '${AppStrings.taskCreationError} $e');
            }
          }
        },
      ),
    );
  }
}
