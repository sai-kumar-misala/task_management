import 'package:flutter/material.dart';

import '../../../../core/constants/app_paddings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/spacings.dart';

class AuthPageLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? errorMessage;
  final List<Widget> children;
  final Widget bottomSection;

  const AuthPageLayout({
    super.key,
    required this.title,
    required this.subtitle,
    this.errorMessage,
    required this.children,
    required this.bottomSection,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: AppPaddings.g24,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 400,
              minHeight: size.height * 0.5,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: AppTextStyles.s32Bold,
                  textAlign: TextAlign.center,
                ),
                const Spacing.vertical(12),
                Text(
                  subtitle,
                  style: AppTextStyles.s20W500,
                  textAlign: TextAlign.center,
                ),
                if (errorMessage != null) ...[
                  const Spacing.vertical(12),
                  Text(
                    errorMessage!,
                    style: AppTextStyles.errorText,
                  ),
                ],
                const Spacing.vertical(48),
                ...children,
                const Spacing.vertical(24),
                bottomSection,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
