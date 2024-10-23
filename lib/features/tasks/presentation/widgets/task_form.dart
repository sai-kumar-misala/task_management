import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/task_model.dart';
import '../../../../core/utils/task_status.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/spacings.dart';
import '../../domain/entities/task_form_data.dart';
import 'date_picker.dart';
import 'responsive_container.dart';
import 'task_submission_button.dart';
import 'task_text_field.dart';

class TaskForm extends ConsumerStatefulWidget {
  final TaskModel? initialData;
  final Function(TaskFormData) onSubmit;
  final bool showStatus;

  const TaskForm({
    super.key,
    this.initialData,
    required this.onSubmit,
    this.showStatus = false,
  });

  @override
  ConsumerState<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends ConsumerState<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late DateTime _dueDate;
  late TaskStatus _status;

  @override
  void initState() {
    super.initState();
    _initializeFormData();
  }

  void _initializeFormData() {
    final initialData = widget.initialData;
    _titleController.text = initialData?.title ?? '';
    _descriptionController.text = initialData?.description ?? '';
    _dueDate = initialData?.dueDate ?? DateTime.now();
    _status = TaskStatus.fromString(
      initialData?.status ?? TaskStatus.pending.display,
    );
  }

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

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSubmit(
        TaskFormData(
          title: _titleController.text,
          description: _descriptionController.text,
          dueDate: _dueDate,
          status: _status,
        ),
      );
    }
  }

  Widget _buildStatusRadio() {
    if (!widget.showStatus) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.status,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Spacing.vertical(8),
        Wrap(
          spacing: 16,
          children: TaskStatus.values.map((status) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<TaskStatus>(
                  value: status,
                  groupValue: _status,
                  onChanged: (TaskStatus? value) {
                    if (value != null) {
                      setState(() => _status = value);
                    }
                  },
                ),
                Text(status.display),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return Center(
      child: ResponsiveContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TaskTextField(
                      controller: _titleController,
                      labelText: AppStrings.title,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.titleAlert;
                        }
                        return null;
                      },
                    ),
                    const Spacing.vertical(16),
                    TaskTextField(
                      controller: _descriptionController,
                      labelText: AppStrings.description,
                      maxLines: isWideScreen ? 5 : 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.descriptionAlert;
                        }
                        return null;
                      },
                    ),
                    const Spacing.vertical(16),
                    DatePickerCard(
                      date: _dueDate,
                      onDateSelected: (date) => setState(() => _dueDate = date),
                    ),
                    if (widget.showStatus) ...[
                      const Spacing.vertical(16),
                      _buildStatusRadio(),
                    ],
                  ],
                ),
              ),
            ),
            TaskSubmitButton(
              onSubmit: _handleSubmit,
              text: widget.initialData == null
                  ? AppStrings.create
                  : AppStrings.save,
            ),
          ],
        ),
      ),
    );
  }
}
