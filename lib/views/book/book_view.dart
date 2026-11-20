import 'package:flutter/material.dart';
import '../../models/book_model.dart';
import '../../services/api_service.dart';
import '../profile_view.dart';
import 'book_detail_view.dart';

class BookView extends StatefulWidget {
  const BookView({super.key});

  @override
  State<BookView> createState() => _BookViewState();
}

class _BookViewState extends State<BookView> {
  late Future<List<Book>> _BooksFuture;
  List<Book> _allBooks = [];
  List<Book> _filteredBooks = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadBooks() {
    setState(() {
      _BooksFuture = ApiService.getBooks().then((Books) {
        _allBooks = Books;
        _applyFilter();
        return Books;
      });
    });
  }

  void _applyFilter() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      _filteredBooks = _allBooks.where((Book) {
        final matchesQuery = Book.originalTitle.toLowerCase().contains(query);
        return matchesQuery;
      }).toList();
    });
  }

  Future<void> _handleLogout() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ProfileView(),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141324),
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.shield, color: Color(0xFFD3A625), size: 22),
            SizedBox(width: 10),
            Text(
              'Daftar Buku',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1F1E33),
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white70),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Section
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            color: const Color(0xFF1A192E),
            child: Column(
              children: [
                // Search Field
                TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (_) => _applyFilter(),
                  decoration: InputDecoration(
                    hintText: 'Cari judul buku...',
                    hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFFD3A625)),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.white54, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              _applyFilter();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFF26253F),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFD3A625)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Book List
          Expanded(
            child: FutureBuilder<List<Book>>(
              future: _BooksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Color(0xFFD3A625)),
                        SizedBox(height: 16),
                        Text(
                          'Memuat data buku...',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cloud_off, size: 64, color: Colors.redAccent),
                          const SizedBox(height: 16),
                          Text(
                            'Gagal memuat data:\n${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD3A625),
                              foregroundColor: const Color(0xFF141324),
                            ),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                            onPressed: _loadBooks,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (_filteredBooks.isEmpty) {
                  return const Center(
                    child: Text(
                      'Tidak ada buku yang cocok.',
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                  );
                }

                return RefreshIndicator(
                  color: const Color(0xFFD3A625),
                  backgroundColor: const Color(0xFF1F1E33),
                  onRefresh: () async {
                    _loadBooks();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    itemCount: _filteredBooks.length,
                    itemBuilder: (context, index) {
                      final Book = _filteredBooks[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        color: const Color(0xFF1F1E33),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        elevation: 3,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BookDetailView(book: Book),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                // Book Thumbnail
                                Container(
                                  width: 65,
                                  height: 85,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFF2A2845),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Book.image.isNotEmpty
                                      ? Image.network(
                                          Book.image,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) =>
                                              const Icon(Icons.person, color: Colors.white38),
                                        )
                                      : const Icon(Icons.person, color: Colors.white38),
                                ),
                                const SizedBox(width: 14),

                                // Book Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Book.title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (Book.title.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          '"${Book.originalTitle}"',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontStyle: FontStyle.italic,
                                            color: Color(0xFFD3A625),
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 6),
                                      if (Book.releaseDate.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          Book.releaseDate,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white54,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),

                                // Chevron Arrow
                                const Icon(
                                  Icons.chevron_right,
                                  color: Color(0xFFD3A625),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
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
