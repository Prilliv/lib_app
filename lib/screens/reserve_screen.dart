import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/reservation.dart';
import '../services/book_service.dart';

class ReserveScreen extends StatefulWidget {
  final String bookId;

  const ReserveScreen({super.key, required this.bookId});

  @override
  State<ReserveScreen> createState() => _ReserveScreenState();
}

class _ReserveScreenState extends State<ReserveScreen> {
  DateTime? _returnDate;
  bool _dirty = false;

  @override
  Widget build(BuildContext context) {
    final book = BookService.findById(widget.bookId);

    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldLeave = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Незбережені зміни'),
            content: const Text(
              'Ви обрали дату, але не підтвердили бронювання. Вийти?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Залишитись'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Вийти'),
              ),
            ],
          ),
        );
        if (shouldLeave == true && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Бронювання'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: book == null
            ? const Center(child: Text('Книгу не знайдено'))
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(book.author),
                    const SizedBox(height: 24),
                    const Text('Оберіть дату повернення:'),
                    const SizedBox(height: 8),
                    ListTile(
                      title: Text(
                        _returnDate == null
                            ? 'Не обрано'
                            : '${_returnDate!.day.toString().padLeft(2, '0')}.'
                                '${_returnDate!.month.toString().padLeft(2, '0')}.'
                                '${_returnDate!.year}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final date = await context.push<DateTime>(
                          '/catalog/book/${widget.bookId}/reserve/date',
                        );
                        if (date != null) {
                          setState(() {
                            _returnDate = date;
                            _dirty = true;
                          });
                        }
                      },
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _returnDate == null
                            ? null
                            : () {
                                BookService.addReservation(
                                  Reservation(
                                    bookId: book.id,
                                    bookTitle: book.title,
                                    returnDate: _returnDate!,
                                    reservedAt: DateTime.now(),
                                  ),
                                );
                                setState(() => _dirty = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Книгу заброньовано!'),
                                  ),
                                );
                                context.go('/my-books');
                              },
                        child: const Text('Підтвердити бронювання'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
