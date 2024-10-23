import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

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

    if (willLogout == true) {
      if (context.mounted) {
        await ref.read(authNotifierProvider.notifier).signOut();
        if (context.mounted) {
          context.goNamed('login');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dashboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: AppStrings.logout,
            onPressed: () => _showLogoutConfirmation(context, ref),
          ),
        ],
      ),
      body: const Center(
        child: Text(AppStrings.welcomeToDashboard),
      ),
    );
  }
}
