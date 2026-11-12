enum BookGenre { novel, history, fantasy, poetry }

class Book {
  final int id;
  final String title;
  final String author;
  final BookGenre genre;

  bool isRead;
  double? rating;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    this.isRead = false,
    this.rating,
  });
}
