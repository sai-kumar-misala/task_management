import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/spacings.dart';

class ErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.errorColor,
            size: 60,
          ),
          const Spacing.vertical(16),
          Text(
            AppStrings.errorLoadingTask,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Spacing.vertical(8),
          Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const Spacing.vertical(16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text(AppStrings.goBack),
          ),
        ],
      ),
    );
  }
}
