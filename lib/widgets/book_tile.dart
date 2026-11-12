import 'package:flutter/material.dart';
import '../models/book.dart';

class BookTile extends StatelessWidget {
  final Book book;
  final ValueChanged<bool?> onReadChanged;
  final VoidCallback onTap;

  const BookTile({
    super.key,
    required this.book,
    required this.onReadChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Checkbox(value: book.isRead, onChanged: onReadChanged),
      title: Text(
        book.title,
        style: TextStyle(
          decoration: book.isRead
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
      ),
      subtitle: Text(book.author),
      trailing: book.rating != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                Text(book.rating!.toString()),
              ],
            )
          : null,
    );
  }
}
