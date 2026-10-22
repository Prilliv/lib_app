import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/book_service.dart';

class BookScreen extends StatelessWidget {
  final String bookId;

  const BookScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    final book = BookService.findById(bookId);

    if (book == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Книга не знайдена')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Книгу з таким id не знайдено'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go('/catalog'),
                child: const Text('До каталогу'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              book.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              book.author,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text(book.genre)),
                Chip(label: Text('${book.year}')),
                Chip(
                  label: Text(book.available ? 'Доступна' : 'Зайнята'),
                  backgroundColor:
                      book.available ? Colors.green[100] : Colors.red[100],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              book.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            if (book.available)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () =>
                      context.push('/catalog/book/${book.id}/reserve'),
                  icon: const Icon(Icons.bookmark_add),
                  label: const Text('Забронювати'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
