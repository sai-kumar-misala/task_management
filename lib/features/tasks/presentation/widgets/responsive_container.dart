import 'package:flutter/material.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;

  const ResponsiveContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;
    final contentPadding = isWideScreen ? 32.0 : 16.0;
    final maxWidth =
        isWideScreen ? 600.0 : MediaQuery.of(context).size.width * 0.95;

    return Container(
      width: maxWidth,
      constraints: const BoxConstraints(maxWidth: 600),
      padding: EdgeInsets.all(contentPadding),
      child: child,
    );
  }
}
