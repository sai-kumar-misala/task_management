import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

Color getStatusColor(String taskStatus) {
  switch (taskStatus.toLowerCase()) {
    case 'pending':
      return AppColors.pendingColor;
    case 'in progress':
      return AppColors.inProgressColor;
    case 'completed':
      return AppColors.completedColor;
    default:
      return AppColors.defaultColor;
  }
}
