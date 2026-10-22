import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/book_service.dart';

class MyBooksScreen extends StatelessWidget {
  const MyBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reservations = BookService.reservations;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мої книги'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: reservations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.menu_book, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Поки немає заброньованих книг'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.go('/catalog'),
                    child: const Text('До каталогу'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final r = reservations[index];
                final dateStr =
                    '${r.returnDate.day.toString().padLeft(2, '0')}.'
                    '${r.returnDate.month.toString().padLeft(2, '0')}.'
                    '${r.returnDate.year}';
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    leading: const Icon(Icons.bookmark),
                    title: Text(r.bookTitle),
                    subtitle: Text('Повернути до $dateStr'),
                    onTap: () => context.go('/catalog/book/${r.bookId}'),
                  ),
                );
              },
            ),
    );
  }
}
