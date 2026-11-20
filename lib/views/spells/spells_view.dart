import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsi_124240180/views/profile_view.dart';
import '../../models/spell_model.dart';
import '../../services/api_service.dart';
import '../../services/hive_service.dart';
import '../../widgets/top_snackbar.dart';
import 'favorite_spells_view.dart';

class SpellsView extends StatefulWidget {
  const SpellsView({super.key});

  @override
  State<SpellsView> createState() => _SpellsViewState();
}

class _SpellsViewState extends State<SpellsView> {
  late Future<List<Spell>> _spellsFuture;
  List<Spell> _allSpells = [];
  List<Spell> _filteredSpells = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSpells();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadSpells() {
    setState(() {
      _spellsFuture = ApiService.getSpells().then((spells) {
        _allSpells = spells;
        _applyFilter();
        return spells;
      });
    });
  }

  void _applyFilter() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      _filteredSpells = _allSpells.where((spell) {
        return spell.spell.toLowerCase().contains(query) ||
            spell.use.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _toggleFavorite(Spell spell) async {
    final isFav = HiveService.isFavorite(spell.index);

    if (isFav) {
      await HiveService.removeFavorite(spell.index);
      if (mounted) {
        showTopSnackBar(
          context,
          content: Row(
            children: [
              const Icon(Icons.favorite_border, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Spell "${spell.spell}" dihapus dari favorit!'),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade700,
        );
      }
    } else {
      await HiveService.addFavorite(spell);
      if (mounted) {
        showTopSnackBar(
          context,
          content: Row(
            children: [
              const Icon(Icons.favorite, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Spell "${spell.spell}" ditambahkan ke favorit!'),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade700,
        );
      }
    }
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
            Icon(Icons.auto_fix_high, color: Color(0xFFD3A625), size: 22),
            SizedBox(width: 10),
            Text(
              'Daftar Sihir (Spells)',
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
          // Tombol Logout
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FavoriteSpellsView()),
          );
        },
        backgroundColor: const Color(0xFFD3A625),
        child: const Icon(Icons.bookmark, color: Color(0xFF1F1E33)),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            color: const Color(0xFF1A192E),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              onChanged: (_) => _applyFilter(),
              decoration: InputDecoration(
                hintText: 'Cari mantra atau efek sihir...',
                hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFD3A625)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.white54,
                          size: 18,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          _applyFilter();
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFF26253F),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFD3A625)),
                ),
              ),
            ),
          ),

          // Spells List
          Expanded(
            child: FutureBuilder<List<Spell>>(
              future: _spellsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Color(0xFFD3A625)),
                        SizedBox(height: 16),
                        Text(
                          'Memuat daftar sihir...',
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
                          const Icon(
                            Icons.cloud_off,
                            size: 64,
                            color: Colors.redAccent,
                          ),
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
                            onPressed: _loadSpells,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (_filteredSpells.isEmpty) {
                  return const Center(
                    child: Text(
                      'Tidak ada sihir yang ditemukan.',
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                  );
                }

                return ValueListenableBuilder<Box>(
                  valueListenable: HiveService.listenable(),
                  builder: (context, box, _) {
                    return RefreshIndicator(
                      color: const Color(0xFFD3A625),
                      backgroundColor: const Color(0xFF1F1E33),
                      onRefresh: () async {
                        _loadSpells();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(14),
                        itemCount: _filteredSpells.length,
                        itemBuilder: (context, index) {
                          final spell = _filteredSpells[index];
                          final isFav = HiveService.isFavorite(spell.index);

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            color: const Color(0xFF1F1E33),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(
                                color: isFav
                                    ? const Color(
                                        0xFFD3A625,
                                      ).withValues(alpha: 0.5)
                                    : Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Wand Icon Container
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isFav
                                          ? const Color(
                                              0xFFD3A625,
                                            ).withValues(alpha: 0.2)
                                          : Colors.white.withValues(
                                              alpha: 0.06,
                                            ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.auto_fix_high,
                                      color: isFav
                                          ? const Color(0xFFD3A625)
                                          : Colors.white54,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 14),

                                  // Spell Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          spell.spell,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          spell.use.isNotEmpty
                                              ? spell.use
                                              : 'Tidak ada deskripsi efek sihir.',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.white70,
                                            height: 1.3,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.06,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
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

                                  // Favorite Button (Toggle)
                                  IconButton(
                                    icon: Icon(
                                      isFav
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isFav
                                          ? Colors.redAccent
                                          : Colors.white54,
                                      size: 26,
                                    ),
                                    tooltip: isFav
                                        ? 'Hapus dari favorit'
                                        : 'Tambah ke favorit',
                                    onPressed: () => _toggleFavorite(spell),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
