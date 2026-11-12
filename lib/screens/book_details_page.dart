import 'package:flutter/material.dart';
import '../models/book.dart';

class BookDetailsPage extends StatefulWidget {
  final Book book;

  const BookDetailsPage({super.key, required this.book});

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  double rating = 0;

  @override
  void initState() {
    super.initState();
    rating = widget.book.rating ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Գրքի մանրամասները')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            Text(
              widget.book.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text(widget.book.author, style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 40),

            const Text('Գնահատիր գիրքը', style: TextStyle(fontSize: 20)),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starNumber = index + 1;

                return IconButton(
                  onPressed: () {
                    setState(() {
                      rating = starNumber.toDouble();
                    });
                  },
                  icon: Icon(
                    starNumber <= rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 38,
                  ),
                );
              }),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: rating == 0
                    ? null
                    : () {
                        Navigator.pop(context, rating);
                      },
                child: const Text('Պահպանել'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
