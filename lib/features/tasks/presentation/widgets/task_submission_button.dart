import 'package:flutter/material.dart';

import '../../../../shared/widgets/loading_button.dart';

class TaskSubmitButton extends StatelessWidget {
  final VoidCallback onSubmit;
  final String text;
  final bool isLoading;

  const TaskSubmitButton({
    super.key,
    required this.onSubmit,
    required this.text,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingButton(
      onPressed: onSubmit,
      text: text,
      isLoading: isLoading,
    );
  }
}
