import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/spell_model.dart';
import '../../services/hive_service.dart';
import '../../services/notification_service.dart';
import '../../widgets/top_snackbar.dart';

class FavoriteSpellsView extends StatelessWidget {
  const FavoriteSpellsView({super.key});

  Future<void> _removeFavorite(BuildContext context, Spell spell) async {

    await HiveService.removeFavorite(spell.index);

    await NotificationService.showImmediateNotification(
      title: 'Spell Dihapus dari Favorit',
      body: '${spell.spell} telah dihapus dari daftar favorit.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141324),
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.star, color: Color(0xFFD3A625), size: 22),
            SizedBox(width: 10),
            Text(
              'Favorite Spells',
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
      ),
      body: ValueListenableBuilder<Box>(
        valueListenable: HiveService.listenable(),
        builder: (context, box, _) {
          final favorites = HiveService.getFavorites();

          if (favorites.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFD3A625).withValues(alpha: 0.1),
                        border: Border.all(
                          color: const Color(0xFFD3A625).withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.bookmark_border,
                        size: 64,
                        color: Color(0xFFD3A625),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Belum Ada Spell Favorit',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tandai mantra favorit Anda di halaman Sihir untuk menyimpannya di sini.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white60, fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final spell = favorites[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: const Color(0xFF1F1E33),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: const Color(0xFFD3A625).withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Magic wand icon with badge
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD3A625).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.auto_fix_high,
                          color: Color(0xFFD3A625),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Spell Name and Use
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              spell.spell,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              spell.use.isNotEmpty
                                  ? spell.use
                                  : 'Tidak ada deskripsi kegunaan.',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white70,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '#${spell.index}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFD3A625),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Delete Button
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                          size: 26,
                        ),
                        tooltip: 'Hapus dari favorit',
                        onPressed: () => _removeFavorite(context, spell),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
