import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../core/constants/app_paddings.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/custom_icon_button.dart';
import '../../../../shared/widgets/custom_snackbar.dart';
import '../../../../shared/widgets/spacings.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/pagination_state.dart';
import '../providers/task_providers.dart';
import '../widgets/task_card.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paginatedTasksProvider.notifier).loadInitial();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      ref.read(paginatedTasksProvider.notifier).loadMore();
    }
  }

  Future<void> _showLogoutConfirmation() async {
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

    if (willLogout == true && mounted) {
      try {
        await ref.read(authNotifierProvider.notifier).signOut();
        if (mounted) {
          context.goNamed('login');
        }
      } catch (e) {
        if (mounted) {
          CustomSnackBar.show(context, '${AppStrings.logOutError} $e');
        }
      }
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 64,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const Spacing.vertical(16),
            const Text(
              AppStrings.noTasksAvailable,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const Spacing.vertical(16),
            Text(
              '${AppStrings.errorLoadingTask} $error',
              textAlign: TextAlign.center,
            ),
            const Spacing.vertical(8),
            ElevatedButton.icon(
              onPressed: () =>
                  ref.read(paginatedTasksProvider.notifier).refresh(),
              icon: const Icon(Icons.refresh),
              label: const Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreCard() {
    return Card(
      child: InkWell(
        onTap: () => ref.read(paginatedTasksProvider.notifier).loadMore(),
        child: Container(
          padding: AppPaddings.g16,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(paginatedTasksProvider);
                  return state.isLoading
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.add, size: 32);
                },
              ),
              const Spacing.vertical(8),
              const Text(AppStrings.loadMore),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskGrid(PaginationState state) {
    return Padding(
      padding: AppPaddings.gH16,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1600),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverMasonryGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == state.tasks.length) {
                      return _buildLoadMoreCard();
                    }
                    final task = state.tasks[index];
                    return TaskCard(
                      task: task,
                      onTap: () => context.goNamed(
                        'task-details',
                        pathParameters: {'taskId': task.id},
                      ),
                    );
                  },
                  childCount: state.hasMore
                      ? state.tasks.length + 1
                      : state.tasks.length,
                ),
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _calculateCrossAxisCount(
                      MediaQuery.of(context).size.width),
                ),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              const SliverPadding(
                padding: AppPaddings.gB80,
              ),
            ],
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
  Widget build(BuildContext context) {
    final state = ref.watch(paginatedTasksProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dashboard),
        centerTitle: screenWidth > 600,
        actions: [
          CustomIconButton(
            toolTip: AppStrings.logout,
            onPressed: _showLogoutConfirmation,
            icon: Icons.logout,
          )
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(paginatedTasksProvider.notifier).refresh();
          },
          child: state.error != null
              ? _buildErrorState(state.error!)
              : state.tasks.isEmpty && !state.isLoading
                  ? _buildEmptyState()
                  : _buildTaskGrid(state),
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
