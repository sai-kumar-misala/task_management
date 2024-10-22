import 'package:flutter/material.dart';

import '../../../../core/constants/app_text_styles.dart';

class AuthBottomText extends StatelessWidget {
  final String message;
  final String buttonText;
  final VoidCallback onPressed;

  const AuthBottomText({
    super.key,
    required this.message,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message,
          style: AppTextStyles.s16W400,
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: AppTextStyles.s16Bold,
          ),
        ),
      ],
    );
  }
}
