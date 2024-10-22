import 'package:flutter/material.dart';

class Spacing extends StatelessWidget {
  final double size;
  final bool isVertical;

  const Spacing.vertical(this.size, {super.key}) : isVertical = true;
  const Spacing.horizontal(this.size, {super.key}) : isVertical = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isVertical ? 0 : size,
      height: isVertical ? size : 0,
    );
  }
}
