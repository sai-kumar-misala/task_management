import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_management/core/constants/app_strings.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              AppStrings.pageNotFound,
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.goNamed('login'),
              child: const Text(AppStrings.goToHome),
            ),
          ],
        ),
      ),
    );
  }
}
