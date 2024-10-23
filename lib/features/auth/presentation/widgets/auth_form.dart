import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_paddings.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validation_utils.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/loading_button.dart';
import '../../../../shared/widgets/spacings.dart';

class AuthForm extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;
  final String submitButtonText;
  final bool showPasswordStrength;
  final bool isLoading;

  const AuthForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
    required this.submitButtonText,
    required this.isLoading,
    this.showPasswordStrength = false,
  });

  @override
  ConsumerState<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends ConsumerState<AuthForm> {
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            label: AppStrings.email,
            controller: widget.emailController,
            validator: ValidationUtils.validateEmail,
          ),
          const Spacing.vertical(16),
          CustomTextField(
            label: AppStrings.password,
            controller: widget.passwordController,
            obscureText: _obscurePassword,
            isPassword: true,
            onToggleVisibility: _togglePasswordVisibility,
            validator: ValidationUtils.validatePassword,
          ),
          const Spacing.vertical(24),
          LoadingButton(
            text: widget.submitButtonText,
            onPressed: widget.onSubmit,
            isLoading: widget.isLoading,
            padding: AppPaddings.gV16,
          ),
        ],
      ),
    );
  }
}
