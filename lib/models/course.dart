/// A model class representing a single e-learning course.
///
/// Each [Course] holds all the static metadata about a course,
/// including its title, instructor, category, and learning details.
/// Course objects are immutable (all fields are final).
///
/// Example usage:
/// ```dart
/// const course = Course(
///   id: '1',
///   title: 'Flutter Bootcamp',
///   instructor: 'Angela Yu',
///   category: 'Programming',
///   description: 'Learn Flutter from scratch.',
///   lessons: 28,
///   duration: '14h 30m',
///   rating: 4.8,
///   icon: '📱',
/// );
/// ```
class Course {
  /// Unique identifier for this course.
  final String id;

  /// The full display title of the course.
  final String title;

  /// The name of the course instructor.
  final String instructor;

  /// The category this course belongs to (e.g. 'Programming', 'Design').
  final String category;

  /// A short description of the course content.
  final String description;

  /// The total number of lessons in this course.
  final int lessons;

  /// The total duration of the course as a formatted string (e.g. '14h 30m').
  final String duration;

  /// The average star rating for this course, from 0.0 to 5.0.
  final double rating;

  /// An emoji character used as the visual icon for this course.
  final String icon;

  /// Creates a new immutable [Course] instance.
  ///
  /// All parameters are required.
  const Course({
    required this.id,
    required this.title,
    required this.instructor,
    required this.category,
    required this.description,
    required this.lessons,
    required this.duration,
    required this.rating,
    required this.icon,
  });
}
