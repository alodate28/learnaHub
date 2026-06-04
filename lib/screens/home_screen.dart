/// Home screen displaying the full course catalog with search and filter.
///
/// This screen is the default tab in [MainNavigation].
/// It watches [CoursesProvider] via [context.watch] (Observer Pattern)
/// and rebuilds whenever the course list, category, or search query changes.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/courses_provider.dart';
import '../data/courses_data.dart';
import '../widgets/course_card.dart';
import 'course_detail_screen.dart';

/// Displays all available courses with real-time search and category filtering.
///
/// Uses [StatefulWidget] to manage the [TextEditingController] for the
/// search bar. All business logic is delegated to [CoursesProvider].
class HomeScreen extends StatefulWidget {
  /// Creates the [HomeScreen].
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Controller for the search input field.
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Observer Pattern: rebuilds when filteredCourses or username changes.
    final provider = context.watch<CoursesProvider>();
    final courses = provider.filteredCourses;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hello, ${provider.username} 👋',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  const SizedBox(height: 4),
                  const Text('What do you want\nto learn today?',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  // Search bar — updates provider on every keystroke.
                  TextField(
                    controller: _searchController,
                    onChanged: (value) => provider.setSearchQuery(value),
                    decoration: InputDecoration(
                      hintText: 'Search courses...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          provider.setSearchQuery('');
                        },
                      )
                          : null,
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Horizontal category filter chips.
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = provider.selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => provider.setCategory(cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF6C63FF) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(cat,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          )),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${courses.length} course${courses.length == 1 ? '' : 's'} found',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ),

            const SizedBox(height: 8),

            // Course list or empty state.
            Expanded(
              child: courses.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                    const SizedBox(height: 12),
                    Text('No courses found',
                        style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return CourseCard(
                    course: course,
                    // Navigate to CourseDetailScreen on tap.
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourseDetailScreen(course: course),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
