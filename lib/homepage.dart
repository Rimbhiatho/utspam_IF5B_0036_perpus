import 'package:flutter/material.dart';
import 'page/home.dart';
import 'page/bookmarks.dart';
import 'page/peminjaman.dart';
import 'page/profile.dart';
import 'search.dart';
import 'login.dart';
import 'data/auth/auth_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _UtamaState();
}

class _UtamaState extends State<Homepage> {
  int _selectedIndex = 0;

  static const _labels = ['Home', 'Bookmarks', 'Peminjaman', 'Profile'];

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeTab(),
      const BookmarkPage(),
      const PeminjamanTab(),
      const ProfileTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Titho e-Library',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              _labels[_selectedIndex],
              style: const TextStyle(
                fontSize: 12,
                color: Color.fromARGB(136, 255, 255, 255),
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 51, 58, 68),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              AuthService.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 51, 58, 68),
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border_outlined),
            selectedIcon: Icon(Icons.bookmark_rounded),
            label: 'Bookmarks',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book_rounded),
            label: 'Peminjaman',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 254, 236, 195),
      ),
    );
  }
}
