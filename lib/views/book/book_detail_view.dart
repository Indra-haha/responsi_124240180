import 'package:flutter/material.dart';
import '../../models/book_model.dart';

class BookDetailView extends StatelessWidget {
  final Book book;

  const BookDetailView({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    // final houseColor = _getHouseColor(book.hogwartsHouse);
    // final houseAccent = _getHouseAccent(book.hogwartsHouse);

    return Scaffold(
      backgroundColor: const Color(0xFF141324),
      appBar: AppBar(
        title: Text(
          book.title.isNotEmpty ? book.title : 'Detail Buku',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        // backgroundColor: houseColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Book Cover Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Container(
                  height: 220,
                  width: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    // border: Border.all(color: houseAccent, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.6),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: book.image.isNotEmpty
                      ? Image.network(
                          book.image,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: const Color(0xFF23223A),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFFD3A625),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFF23223A),
                              child: const Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.white54,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: const Color(0xFF23223A),
                          child: const Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.white54,
                          ),
                        ),
                ),
              ),
            ),

            // Main Info Container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full Name & Nickname Header
                  Center(
                    child: Column(
                      children: [
                        Text(
                          book.title.isNotEmpty ? book.title : '-',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (book.originalTitle.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            '"${book.originalTitle}"',
                            style: const TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFFD3A625),
                            ),
                          ),
                        ],
                        // const SizedBox(height: 12),
                        // // House Badge
                        // Container(
                        //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        //   // decoration: BoxDecoration(
                        //   //   color: houseColor.withValues(alpha: 0.4),
                        //   //   borderRadius: BorderRadius.circular(20),
                        //   //   border: Border.all(color: houseAccent, width: 1.5),
                        //   // ),
                        //   // child: Row(
                        //   //   mainAxisSize: MainAxisSize.min,
                        //   //   children: [
                        //   //     Icon(Icons.shield, color: houseAccent, size: 18),
                        //   //     const SizedBox(width: 8),
                        //   //     // Text(
                        //   //     //   book.hogwartsHouse.isNotEmpty
                        //   //     //       ? book.hogwartsHouse
                        //   //     //       : 'Unknown House',
                        //   //     //   style: const TextStyle(
                        //   //     //     color: Colors.white,
                        //   //     //     fontWeight: FontWeight.bold,
                        //   //     //     letterSpacing: 1,
                        //   //     //   ),
                        //   //     // ),
                        //   //   ],
                        //   // ),
                        // ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Informasi Lengkap',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD3A625),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Divider(color: Colors.white24, height: 20),

                  // Property 1: number
                  _buildPropertyCard(
                    icon: Icons.tag,
                    label: 'Number',
                    value: book.number,
                  ),

                  // Property 2: title
                  _buildPropertyCard(
                    icon: Icons.badge,
                    label: 'Title',
                    value: book.title.isNotEmpty ? book.title : '-',
                  ),

                  // Property 3: relase
                  _buildPropertyCard(
                    icon: Icons.person_pin,
                    label: 'Release Date',
                    value: book.releaseDate.toString(),
                  ),

                  // Property 4: description
                  _buildPropertyCard(
                    icon: Icons.home,
                    label: 'Description',
                    value: book.description.isNotEmpty ? book.description : '-',
                  ),

                  // Property 5: pages
                  _buildPropertyCard(
                    icon: Icons.movie_creation,
                    label: 'Pages',
                    value: book.pages.isNotEmpty ? book.pages : '-',
                  ),

                  // Property 6: index
                  _buildPropertyCard(
                    icon: Icons.cake,
                    label: 'Index',
                    value: book.index.toString(),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1E33),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFD3A625).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFFD3A625), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
