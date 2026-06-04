/// The main navigation shell of the LearnHub application.
///
/// Displays a [BottomNavigationBar] with three tabs:
/// - Home (course catalog)
/// - My Courses (enrolled courses)
/// - Profile (settings)
///
/// Uses [IndexedStack] to preserve the state of each screen
/// across tab switches without rebuilding them.
library;

import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'my_courses_screen.dart';
import 'profile_screen.dart';

/// Root navigation widget that manages the three main screens.
///
/// Implements the Observer Pattern indirectly — each child screen
/// watches [CoursesProvider] independently for reactive updates.
class MainNavigation extends StatefulWidget {
  /// Creates the main navigation shell.
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  /// Index of the currently selected tab.
  int _currentIndex = 0;

  /// The three main screens of the application.
  /// Wrapped in [IndexedStack] to preserve state across tab switches.
  final List<Widget> _screens = const [
    HomeScreen(),
    MyCoursesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps all screens alive — only the active one is visible.
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFF6C63FF),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined),
            activeIcon: Icon(Icons.library_books),
            label: 'My Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
