class Reservation {
  final String bookId;
  final String bookTitle;
  final DateTime returnDate;
  final DateTime reservedAt;

  const Reservation({
    required this.bookId,
    required this.bookTitle,
    required this.returnDate,
    required this.reservedAt,
  });
}
