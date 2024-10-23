import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.toolTip,
    required this.onPressed,
    required this.icon,
  });

  final String toolTip;
  final void Function() onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 2.0,
      icon: Icon(icon),
      tooltip: toolTip,
      onPressed: onPressed,
    );
  }
}
