import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_management/shared/widgets/loading_button.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_paddings.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/spacings.dart';
import '../../data/models/task_model.dart';
import '../providers/task_providers.dart';

class CreateTaskPage extends ConsumerStatefulWidget {
  const CreateTaskPage({super.key});

  @override
  ConsumerState<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends ConsumerState<CreateTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  final String _status = 'Pending';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                AppStrings.userNotAuthenticated,
              ),
            ),
          );
        }
        return;
      }

      final task = TaskModel(
        id: const Uuid().v4(),
        userId: currentUser.uid,
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _dueDate,
        status: _status,
      );

      try {
        await ref.read(createTaskProvider).call(task);
        if (mounted) {
          context.goNamed('dashboard');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.taskCreated),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppStrings.taskCreationError} $e',
              ),
            ),
          );
        }
      }
    }
  }

  Widget _buildForm(BuildContext context, BoxConstraints constraints) {
    final isWideScreen = constraints.maxWidth > 600;
    final contentPadding = isWideScreen ? 32.0 : 16.0;
    final maxWidth = isWideScreen ? 800.0 : constraints.maxWidth * 0.95;

    return Container(
      width: maxWidth,
      constraints: const BoxConstraints(maxWidth: 800),
      padding: EdgeInsets.all(contentPadding),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: AppStrings.taskManagement,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              style: AppTextStyles.s16W400,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.emailAlert;
                }
                return null;
              },
            ),
            const Spacing.vertical(16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: AppStrings.createAccount,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              maxLines: isWideScreen ? 5 : 3,
              style: AppTextStyles.s16W400,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.passwordAlert;
                }
                return null;
              },
            ),
            const Spacing.vertical(16),
            Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                title: Text(
                  '${AppStrings.dueDate} ${_dueDate.toString().split(' ')[0]}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  color: AppColors.colorScheme.primary,
                  onPressed: () => _selectDate(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(AppStrings.taskManagement),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed('dashboard'),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildForm(context, constraints),
                  ),
                ),
                SafeArea(
                  child: Container(
                    width: constraints.maxWidth > 600
                        ? 800
                        : constraints.maxWidth * 0.95,
                    constraints: const BoxConstraints(maxWidth: 800),
                    padding: AppPaddings.gV16,
                    child: LoadingButton(
                      onPressed: _submit,
                      text: AppStrings.taskManagement,
                      isLoading: false,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
