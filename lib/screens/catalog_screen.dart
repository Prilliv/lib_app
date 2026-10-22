import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/book_service.dart';

class CatalogScreen extends StatefulWidget {
  final String? genre;

  const CatalogScreen({super.key, this.genre});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late String _selectedGenre;

  @override
  void initState() {
    super.initState();
    _selectedGenre = widget.genre ?? 'Усі';
  }

  @override
  void didUpdateWidget(covariant CatalogScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.genre != oldWidget.genre) {
      _selectedGenre = widget.genre ?? 'Усі';
    }
  }

  @override
  Widget build(BuildContext context) {
    final books = BookService.filterByGenre(
      _selectedGenre == 'Усі' ? null : _selectedGenre,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог бібліотеки'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: DropdownButtonFormField<String>(
              value: _selectedGenre,
              decoration: const InputDecoration(
                labelText: 'Жанр',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: BookService.genres
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedGenre = value);
                final query = value == 'Усі' ? '' : '?genre=${Uri.encodeComponent(value)}';
                context.go('/catalog$query');
              },
            ),
          ),
          Expanded(
            child: books.isEmpty
                ? const Center(child: Text('Книг не знайдено'))
                : ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(book.id),
                          ),
                          title: Text(book.title),
                          subtitle: Text('${book.author} · ${book.genre}'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.go('/catalog/book/${book.id}'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
