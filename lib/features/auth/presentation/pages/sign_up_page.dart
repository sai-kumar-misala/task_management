import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_page_layout.dart';
import '../widgets/auth_form.dart';
import '../widgets/auth_bottom_text.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      try {
        await ref.read(authNotifierProvider.notifier).signUp(
              _emailController.text,
              _passwordController.text,
            );
        context.goNamed('dashboard');
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageLayout(
      title: AppStrings.createAccount,
      subtitle: AppStrings.signUpText,
      errorMessage: _errorMessage,
      bottomSection: AuthBottomText(
        message: AppStrings.alreadyHaveAccount,
        buttonText: AppStrings.signIn,
        onPressed: () => context.goNamed('login'),
      ),
      children: [
        AuthForm(
          formKey: _formKey,
          emailController: _emailController,
          passwordController: _passwordController,
          onSubmit: _signUp,
          submitButtonText: AppStrings.signUp,
          isLoading: _isLoading,
        ),
      ],
    );
  }
}
