import 'package:flutter/material.dart';

import '../data/book_data.dart';
import '../models/book.dart';
import '../widgets/book_tile.dart';
import 'book_details_page.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  final TextEditingController _searchController = TextEditingController();

  BookGenre? _selectedGenre;

  List<Book> get filteredBooks {
    return books.where((book) {
      final query = _searchController.text.toLowerCase().trim();

      final matchesSearch =
          book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query);

      final matchesGenre =
          _selectedGenre == null || book.genre == _selectedGenre;

      return matchesSearch && matchesGenre;
    }).toList();
  }

  int get readBooksCount {
    return books.where((book) => book.isRead).length;
  }

  String genreName(BookGenre genre) {
    switch (genre) {
      case BookGenre.novel:
        return 'Վեպ';
      case BookGenre.history:
        return 'Պատմություն';
      case BookGenre.fantasy:
        return 'Ֆանտաստիկա';
      case BookGenre.poetry:
        return 'Բանաստեղծություն';
    }
  }

  void deleteBook(Book book) {
    final index = books.indexOf(book);

    setState(() {
      books.remove(book);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${book.title} գիրքը ջնջվեց'),
        action: SnackBarAction(
          label: 'Վերականգնել',
          onPressed: () {
            setState(() {
              books.insert(index.clamp(0, books.length), book);
            });
          },
        ),
      ),
    );
  }

  Future<void> openBookDetails(Book book) async {
    final rating = await Navigator.push<double>(
      context,
      MaterialPageRoute(
        builder: (context) {
          return BookDetailsPage(book: book);
        },
      ),
    );

    if (!mounted) return;

    if (rating != null) {
      setState(() {
        book.rating = rating;
        book.isRead = true;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleBooks = filteredBooks;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('BookNest'),
            Text(
              'Կարդացված՝ $readBooksCount / ${books.length}',
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Որոնել գիրք կամ հեղինակ...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: const Text('Բոլորը'),
                    selected: _selectedGenre == null,
                    onSelected: (selected) {
                      setState(() {
                        _selectedGenre = null;
                      });
                    },
                  ),
                ),

                ...BookGenre.values.map((genre) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(genreName(genre)),
                      selected: _selectedGenre == genre,
                      onSelected: (selected) {
                        setState(() {
                          _selectedGenre = selected ? genre : null;
                        });
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: visibleBooks.isEmpty
                ? const Center(
                    child: Text(
                      'Գիրք չի գտնվել։',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.separated(
                    itemCount: visibleBooks.length,
                    separatorBuilder: (context, index) {
                      return const Divider(height: 1);
                    },
                    itemBuilder: (context, index) {
                      final book = visibleBooks[index];

                      return Dismissible(
                        key: ValueKey(book.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          deleteBook(book);
                        },
                        child: BookTile(
                          book: book,
                          onReadChanged: (value) {
                            setState(() {
                              book.isRead = value ?? false;
                            });
                          },
                          onTap: () {
                            openBookDetails(book);
                          },
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
