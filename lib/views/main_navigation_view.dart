import 'package:flutter/material.dart';
import '../widgets/top_snackbar.dart';
import 'book/book_view.dart';
import 'spells/spells_view.dart';

class MainNavigationView extends StatefulWidget {
  final String? welcomeMessage;

  const MainNavigationView({super.key, this.welcomeMessage});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  int _currentIndex = 0;

  final List<Widget> _views = const [
    BookView(),
    SpellsView(),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.welcomeMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showTopSnackBar(
          context,
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(widget.welcomeMessage!),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade700,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _views,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1F1E33),
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: const Color(0xFF1F1E33),
          selectedItemColor: const Color(0xFFD3A625),
          unselectedItemColor: Colors.white54,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book),
              label: 'Buku',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_fix_normal),
              activeIcon: Icon(Icons.auto_fix_high),
              label: 'Sihir (Spells)',
            ),
          ],
        ),
      ),
    );
  }
}
