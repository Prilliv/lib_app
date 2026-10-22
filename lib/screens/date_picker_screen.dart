import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Screen that returns a selected DateTime via context.pop.
class DatePickerScreen extends StatefulWidget {
  const DatePickerScreen({super.key});

  @override
  State<DatePickerScreen> createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<DatePickerScreen> {
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    _selected = DateTime.now().add(const Duration(days: 14));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Дата повернення'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: CalendarDatePicker(
              initialDate: _selected,
              firstDate: DateTime.now().add(const Duration(days: 1)),
              lastDate: DateTime.now().add(const Duration(days: 90)),
              onDateChanged: (date) => setState(() => _selected = date),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => context.pop(_selected),
                child: const Text('Обрати'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
