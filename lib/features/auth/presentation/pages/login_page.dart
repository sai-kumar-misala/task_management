import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';

import '../providers/auth_providers.dart';
import '../widgets/auth_bottom_text.dart';
import '../widgets/auth_form.dart';
import '../widgets/auth_page_layout.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ref.read(authNotifierProvider.notifier).signIn(
              _emailController.text,
              _passwordController.text,
            );
        context.go('/dashboard');
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageLayout(
      title: AppStrings.welcome,
      subtitle: AppStrings.signInText,
      errorMessage: _errorMessage,
      bottomSection: AuthBottomText(
        message: AppStrings.notAUser,
        buttonText: AppStrings.signUp,
        onPressed: () => context.goNamed('signup'),
      ),
      children: [
        AuthForm(
          formKey: _formKey,
          emailController: _emailController,
          passwordController: _passwordController,
          onSubmit: _login,
          submitButtonText: AppStrings.signIn,
        ),
      ],
    );
  }
}
