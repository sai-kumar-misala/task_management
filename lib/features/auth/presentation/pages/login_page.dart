import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_paddings.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/spacings.dart';
import '../widgets/custom_text_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    AppStrings.welcome,
                    style: AppTextStyles.s32Bold,
                    textAlign: TextAlign.center,
                  ),
                  const Spacing.vertical(12),
                  const Text(
                    AppStrings.signInText,
                    style: AppTextStyles.s20W500,
                    textAlign: TextAlign.center,
                  ),
                  const Spacing.vertical(48),
                  CustomTextField(
                    label: AppStrings.username,
                    controller: _usernameController,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return AppStrings.usernameAlert;
                      }
                      return null;
                    },
                  ),
                  const Spacing.vertical(16),
                  CustomTextField(
                    label: AppStrings.password,
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    isPassword: true,
                    onToggleVisibility: _togglePasswordVisibility,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return AppStrings.passwordAlert;
                      }
                      if ((value?.length ?? 0) < 6) {
                        return AppStrings.passwordLengthAlert;
                      }
                      return null;
                    },
                  ),
                  const Spacing.vertical(24),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(padding: AppPaddings.gV16),
                    child: const Text(AppStrings.login),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
