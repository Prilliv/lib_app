class Book {
  final String id;
  final String title;
  final String author;
  final String genre;
  final String description;
  final int year;
  final bool available;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.description,
    required this.year,
    this.available = true,
  });
}
