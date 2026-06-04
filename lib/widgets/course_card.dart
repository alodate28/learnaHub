/// Reusable course card widget used in [HomeScreen].
///
/// Displays a [Course] summary including icon, category badge, title,
/// instructor, star rating, lesson count, and an "Enrolled" badge
/// if the user has enrolled in this course.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/courses_provider.dart';

/// A tappable card that summarises a single [Course].
///
/// Watches [CoursesProvider] (Observer Pattern) to reactively show
/// or hide the "Enrolled" badge without requiring a screen rebuild.
class CourseCard extends StatelessWidget {
  /// The course data to display.
  final Course course;

  /// Callback invoked when the card is tapped.
  final VoidCallback onTap;

  /// Creates a [CourseCard] for the given [course].
  const CourseCard({super.key, required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Observer Pattern: rebuilds only when enrollment status changes.
    final isEnrolled = context.watch<CoursesProvider>().isEnrolled(course.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course emoji icon inside a rounded container.
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                    child: Text(course.icon, style: const TextStyle(fontSize: 30))),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category badge.
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(course.category,
                          style: const TextStyle(
                              color: Color(0xFF6C63FF), fontSize: 11)),
                    ),
                    const SizedBox(height: 6),

                    // Course title — up to 2 lines with ellipsis.
                    Text(course.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),

                    // Instructor name.
                    Text(course.instructor,
                        style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                    const SizedBox(height: 8),

                    // Rating, lesson count, and optional Enrolled badge.
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text(course.rating.toString(),
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 12),
                        Icon(Icons.play_circle_outline,
                            color: Colors.grey[400], size: 14),
                        const SizedBox(width: 2),
                        Text('${course.lessons} lessons',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[500])),
                        const Spacer(),
                        // Enrolled badge — shown only when user is enrolled.
                        if (isEnrolled)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.green),
                            ),
                            child: const Text('Enrolled',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
