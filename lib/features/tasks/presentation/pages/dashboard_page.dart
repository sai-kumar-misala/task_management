import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:task_management/core/constants/app_paddings.dart';
import 'package:task_management/shared/widgets/spacings.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/task_providers.dart';
import '../widgets/task_card.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  Future<void> _showLogoutConfirmation(
      BuildContext context, WidgetRef ref) async {
    final willLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.confirmLogout),
        content: const Text(AppStrings.logoutText),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(AppStrings.logout),
          ),
        ],
      ),
    );

    if (willLogout == true && context.mounted) {
      try {
        await ref.read(authNotifierProvider.notifier).signOut();
        if (context.mounted) {
          context.goNamed('login');
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${AppStrings.taskCreationError} $e')),
          );
        }
      }
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt,
                size: 64, color: Theme.of(context).colorScheme.secondary),
            const Spacing.vertical(16),
            const Text(
              AppStrings.noTasksAvailable,
              style: TextStyle(fontSize: 18),
            ),
            const Spacing.vertical(8),
            ElevatedButton.icon(
              onPressed: () => context.goNamed('create-task'),
              icon: const Icon(Icons.add),
              label: const Text(AppStrings.createTask),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(dynamic error, WidgetRef ref) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const Spacing.vertical(16),
            Text(
              '${AppStrings.taskCreationError} $error',
              textAlign: TextAlign.center,
            ),
            const Spacing.vertical(8),
            ElevatedButton.icon(
              onPressed: () => ref.refresh(getTasksProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskGrid(List<dynamic> tasks, BuildContext context) {
    return Padding(
      padding: AppPaddings.gH16,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1600),
          child: MasonryGridView.count(
            crossAxisCount:
                _calculateCrossAxisCount(MediaQuery.of(context).size.width),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskCard(
                task: task,
                onTap: () => context.goNamed(
                  'task-details',
                  pathParameters: {'taskId': task.id},
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  int _calculateCrossAxisCount(double width) {
    if (width > 1600) return 6;
    if (width > 1200) return 5;
    if (width > 900) return 4;
    if (width > 600) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsyncValue = ref.watch(getTasksProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dashboard),
        centerTitle: screenWidth > 600,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: AppStrings.logout,
            onPressed: () => _showLogoutConfirmation(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => ref.refresh(getTasksProvider),
          child: tasksAsyncValue.when(
            data: (tasks) {
              if (tasks.isEmpty) {
                return _buildEmptyState(context);
              }
              return _buildTaskGrid(tasks, context);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _buildErrorState(error, ref),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed('create-task'),
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.createTask),
      ),
    );
  }
}
