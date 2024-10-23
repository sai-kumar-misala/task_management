import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';

class DatePickerCard extends StatelessWidget {
  final DateTime date;
  final Function(DateTime) onDateSelected;

  const DatePickerCard({
    super.key,
    required this.date,
    required this.onDateSelected,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != date) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        title: Text(
          '${AppStrings.dueDate} ${date.toString().split(' ')[0]}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context),
        ),
      ),
    );
  }
}
