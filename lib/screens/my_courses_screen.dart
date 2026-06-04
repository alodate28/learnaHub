/// My Courses screen displaying all courses the user has enrolled in.
///
/// Shows a summary bar with aggregate statistics and a scrollable list
/// of enrolled courses, each with a progress bar and completion percentage.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/courses_provider.dart';
import '../models/course.dart';
import 'course_detail_screen.dart';

/// Displays the user's enrolled courses with progress tracking.
///
/// Watches [CoursesProvider] (Observer Pattern) so the list updates
/// automatically when the user enrolls, unenrolls, or updates progress.
class MyCoursesScreen extends StatelessWidget {
  /// Creates the [MyCoursesScreen].
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Observer Pattern: rebuilds when enrolledCourses or progress changes.
    final provider = context.watch<CoursesProvider>();
    final enrolled = provider.enrolledCourses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        elevation: 0,
      ),
      body: enrolled.isEmpty
          ? _EmptyState()
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SummaryBar(enrolled: enrolled, provider: provider),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: enrolled.length,
              itemBuilder: (context, index) {
                final course = enrolled[index];
                final progress = provider.getProgress(course.id);
                return _EnrolledCourseCard(
                  course: course,
                  progress: progress,
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
    );
  }
}

/// Summary bar showing aggregate enrollment statistics.
///
/// Displays enrolled count, average progress, and completed course count
/// in a purple gradient container at the top of [MyCoursesScreen].
class _SummaryBar extends StatelessWidget {
  /// The list of currently enrolled courses.
  final List<Course> enrolled;

  /// Reference to [CoursesProvider] for reading progress values.
  final CoursesProvider provider;

  const _SummaryBar({required this.enrolled, required this.provider});

  @override
  Widget build(BuildContext context) {
    // Calculate average progress across all enrolled courses.
    final avgProgress = enrolled.isEmpty
        ? 0
        : enrolled.map((c) => provider.getProgress(c.id)).reduce((a, b) => a + b) ~/
        enrolled.length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF9C8FFF)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SummaryItem(label: 'Enrolled', value: enrolled.length.toString()),
          Container(width: 1, height: 40, color: Colors.white38),
          _SummaryItem(label: 'Avg Progress', value: '$avgProgress%'),
          Container(width: 1, height: 40, color: Colors.white38),
          _SummaryItem(
              label: 'Completed',
              value: enrolled
                  .where((c) => provider.getProgress(c.id) == 100)
                  .length
                  .toString()),
        ],
      ),
    );
  }
}

/// A single statistic item inside [_SummaryBar].
class _SummaryItem extends StatelessWidget {
  /// The statistic label (e.g. 'Enrolled').
  final String label;

  /// The statistic value (e.g. '3').
  final String value;

  const _SummaryItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
      ],
    );
  }
}

/// A card displaying a single enrolled course with its progress bar.
class _EnrolledCourseCard extends StatelessWidget {
  /// The enrolled course to display.
  final Course course;

  /// The current completion percentage (0–100).
  final int progress;

  /// Callback invoked when the card is tapped.
  final VoidCallback onTap;

  const _EnrolledCourseCard({
    required this.course,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Course icon container.
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                    child: Text(course.icon, style: const TextStyle(fontSize: 28))),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(course.instructor,
                        style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                    const SizedBox(height: 8),
                    // Progress bar with percentage label.
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress / 100,
                              minHeight: 6,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation(
                                progress == 100
                                    ? Colors.green
                                    : const Color(0xFF6C63FF),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          progress == 100 ? '✓' : '$progress%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: progress == 100
                                ? Colors.green
                                : const Color(0xFF6C63FF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

/// Empty state widget shown when the user has no enrolled courses.
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.library_books_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('No courses yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Go to Home and enroll in a course!',
              style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    );
  }
}
