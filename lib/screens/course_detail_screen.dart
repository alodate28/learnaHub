/// Course detail screen showing full course information and enrollment controls.
///
/// This screen is pushed onto the navigation stack via [Navigator.push]
/// from [HomeScreen] or [MyCoursesScreen].
///
/// Features:
/// - Collapsible purple [SliverAppBar] with course emoji and category badge.
/// - Course metadata: title, rating, instructor, lesson count, duration.
/// - Enroll / Unenroll button that persists state via [CoursesProvider].
/// - Progress slider (visible only when enrolled) to update completion %.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/courses_provider.dart';

/// Displays full details for a single [Course] and allows enrollment.
///
/// Watches [CoursesProvider] (Observer Pattern) so enrollment status
/// and progress update reactively without manual refresh.
class CourseDetailScreen extends StatelessWidget {
  /// The course whose details are displayed.
  final Course course;

  /// Creates a [CourseDetailScreen] for the given [course].
  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    // Observer Pattern: rebuilds when enrollment or progress changes.
    final provider = context.watch<CoursesProvider>();
    final isEnrolled = provider.isEnrolled(course.id);
    final progress = provider.getProgress(course.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsible app bar with course icon and category badge.
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: const Color(0xFF6C63FF),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: const Color(0xFF6C63FF),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Text(course.icon, style: const TextStyle(fontSize: 72)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(course.category,
                          style: const TextStyle(color: Colors.white, fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and rating row.
                  Text(course.title,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(course.rating.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 16),
                      Icon(Icons.person, color: Colors.grey[500], size: 18),
                      const SizedBox(width: 4),
                      Text(course.instructor,
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Lesson count and duration stats.
                  Row(
                    children: [
                      _StatItem(
                          icon: Icons.play_circle_outline,
                          label: '${course.lessons} Lessons'),
                      const SizedBox(width: 20),
                      _StatItem(icon: Icons.access_time, label: course.duration),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),

                  const Text('About this course',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(course.description,
                      style: TextStyle(
                          fontSize: 15, color: Colors.grey[700], height: 1.6)),

                  // Progress section — visible only when enrolled.
                  if (isEnrolled) ...[
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Your Progress',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('$progress%',
                            style: const TextStyle(
                                color: Color(0xFF6C63FF), fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress / 100,
                        minHeight: 10,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation(Color(0xFF6C63FF)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Slider allows the user to manually update their progress.
                    Slider(
                      value: progress.toDouble(),
                      min: 0,
                      max: 100,
                      divisions: 10,
                      activeColor: const Color(0xFF6C63FF),
                      label: '$progress%',
                      onChanged: (val) {
                        context.read<CoursesProvider>()
                            .updateProgress(course.id, val.toInt());
                      },
                    ),
                    Text('Drag slider to update your progress',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                        textAlign: TextAlign.center),
                  ],

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // Sticky enroll / unenroll button at the bottom.
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnrolled ? Colors.red[400] : const Color(0xFF6C63FF),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: () async {
            await context.read<CoursesProvider>().toggleEnrollment(course.id);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isEnrolled
                      ? 'Unenrolled from ${course.title}'
                      : 'Enrolled in ${course.title}!'),
                  backgroundColor:
                  isEnrolled ? Colors.red[400] : const Color(0xFF6C63FF),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          child: Text(isEnrolled ? 'Unenroll' : 'Enroll Now',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

/// A small icon + label pair used to display course stats.
class _StatItem extends StatelessWidget {
  /// The icon to display.
  final IconData icon;

  /// The label text shown next to the icon.
  final String label;

  /// Creates a [_StatItem] with the given [icon] and [label].
  const _StatItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6C63FF), size: 20),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
      ],
    );
  }
}
