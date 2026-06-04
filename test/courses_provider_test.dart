/// Unit tests for [CoursesProvider].
///
/// Tests cover the Observer Pattern implementation, enrollment logic,
/// progress tracking, search/filter functionality, and user preferences.
///
/// Run with: `flutter test`
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learnhub/providers/courses_provider.dart';
import 'package:learnhub/data/courses_data.dart';

void main() {
  // Set up fake SharedPreferences before every test so tests are isolated.
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  // ============================================================
  // Group 1: Initial State
  // ============================================================
  group('Initial State', () {
    test('provider starts with no enrolled courses', () {
      final provider = CoursesProvider();
      expect(provider.enrolledCourses, isEmpty);
    });

    test('provider starts with username "Student"', () {
      final provider = CoursesProvider();
      expect(provider.username, equals('Student'));
    });

    test('provider starts with dark mode disabled', () {
      final provider = CoursesProvider();
      expect(provider.isDarkMode, isFalse);
    });

    test('provider starts with category "All"', () {
      final provider = CoursesProvider();
      expect(provider.selectedCategory, equals('All'));
    });

    test('filteredCourses returns all courses by default', () {
      final provider = CoursesProvider();
      expect(provider.filteredCourses.length, equals(allCourses.length));
    });
  });

  // ============================================================
  // Group 2: Enrollment — Observer Pattern (toggleEnrollment)
  // ============================================================
  group('Enrollment', () {
    test('enrolling a course adds it to enrolledCourses', () async {
      final provider = CoursesProvider();
      await provider.toggleEnrollment('1');
      expect(provider.isEnrolled('1'), isTrue);
      expect(provider.enrolledCourses.length, equals(1));
    });

    test('unenrolling removes the course from enrolledCourses', () async {
      final provider = CoursesProvider();
      await provider.toggleEnrollment('1');
      await provider.toggleEnrollment('1'); // unenroll
      expect(provider.isEnrolled('1'), isFalse);
      expect(provider.enrolledCourses, isEmpty);
    });

    test('enrolling multiple courses works correctly', () async {
      final provider = CoursesProvider();
      await provider.toggleEnrollment('1');
      await provider.toggleEnrollment('2');
      await provider.toggleEnrollment('3');
      expect(provider.enrolledCourses.length, equals(3));
    });

    test('unenrolling resets progress to zero', () async {
      final provider = CoursesProvider();
      await provider.toggleEnrollment('1');
      await provider.updateProgress('1', 50);
      await provider.toggleEnrollment('1'); // unenroll
      await provider.toggleEnrollment('1'); // re-enroll
      expect(provider.getProgress('1'), equals(0));
    });

    test('isEnrolled returns false for non-enrolled course', () {
      final provider = CoursesProvider();
      expect(provider.isEnrolled('99'), isFalse);
    });
  });

  // ============================================================
  // Group 3: Progress Tracking
  // ============================================================
  group('Progress Tracking', () {
    test('progress starts at 0 after enrollment', () async {
      final provider = CoursesProvider();
      await provider.toggleEnrollment('1');
      expect(provider.getProgress('1'), equals(0));
    });

    test('updateProgress sets the correct value', () async {
      final provider = CoursesProvider();
      await provider.toggleEnrollment('1');
      await provider.updateProgress('1', 75);
      expect(provider.getProgress('1'), equals(75));
    });

    test('progress is clamped to 100 maximum', () async {
      final provider = CoursesProvider();
      await provider.toggleEnrollment('1');
      await provider.updateProgress('1', 150);
      expect(provider.getProgress('1'), equals(100));
    });

    test('progress is clamped to 0 minimum', () async {
      final provider = CoursesProvider();
      await provider.toggleEnrollment('1');
      await provider.updateProgress('1', -10);
      expect(provider.getProgress('1'), equals(0));
    });

    test('getProgress returns 0 for unenrolled course', () {
      final provider = CoursesProvider();
      expect(provider.getProgress('99'), equals(0));
    });
  });

  // ============================================================
  // Group 4: Search & Filter
  // ============================================================
  group('Search and Filter', () {
    test('setSearchQuery filters by course title', () {
      final provider = CoursesProvider();
      provider.setSearchQuery('Flutter');
      expect(
        provider.filteredCourses.every(
              (c) => c.title.toLowerCase().contains('flutter') ||
              c.instructor.toLowerCase().contains('flutter'),
        ),
        isTrue,
      );
    });

    test('setSearchQuery with empty string returns all courses', () {
      final provider = CoursesProvider();
      provider.setSearchQuery('Flutter');
      provider.setSearchQuery('');
      expect(provider.filteredCourses.length, equals(allCourses.length));
    });

    test('setCategory filters courses correctly', () {
      final provider = CoursesProvider();
      provider.setCategory('Programming');
      expect(
        provider.filteredCourses.every((c) => c.category == 'Programming'),
        isTrue,
      );
    });

    test('setCategory "All" returns all courses', () {
      final provider = CoursesProvider();
      provider.setCategory('Programming');
      provider.setCategory('All');
      expect(provider.filteredCourses.length, equals(allCourses.length));
    });

    test('search and category filter work together', () {
      final provider = CoursesProvider();
      provider.setCategory('Programming');
      provider.setSearchQuery('Flutter');
      for (final c in provider.filteredCourses) {
        expect(c.category, equals('Programming'));
        expect(
          c.title.toLowerCase().contains('flutter') ||
              c.instructor.toLowerCase().contains('flutter'),
          isTrue,
        );
      }
    });

    test('search with no match returns empty list', () {
      final provider = CoursesProvider();
      provider.setSearchQuery('xyznotacourse123');
      expect(provider.filteredCourses, isEmpty);
    });
  });

  // ============================================================
  // Group 5: User Preferences
  // ============================================================
  group('User Preferences', () {
    test('toggleDarkMode switches from false to true', () async {
      final provider = CoursesProvider();
      await provider.toggleDarkMode();
      expect(provider.isDarkMode, isTrue);
    });

    test('toggleDarkMode switches back to false', () async {
      final provider = CoursesProvider();
      await provider.toggleDarkMode();
      await provider.toggleDarkMode();
      expect(provider.isDarkMode, isFalse);
    });

    test('setUsername updates the username', () async {
      final provider = CoursesProvider();
      await provider.setUsername('Eman');
      expect(provider.username, equals('Eman'));
    });

    test('setUsername with empty string defaults to "Student"', () async {
      final provider = CoursesProvider();
      await provider.setUsername('   ');
      expect(provider.username, equals('Student'));
    });

    test('setUsername trims whitespace', () async {
      final provider = CoursesProvider();
      await provider.setUsername('  Eman  ');
      expect(provider.username, equals('Eman'));
    });
  });

  // ============================================================
  // Group 6: Clear All Data
  // ============================================================
  group('Clear All Data', () {
    test('clearAllData resets enrolled courses', () async {
      final provider = CoursesProvider();
      await provider.toggleEnrollment('1');
      await provider.toggleEnrollment('2');
      await provider.clearAllData();
      expect(provider.enrolledCourses, isEmpty);
    });

    test('clearAllData resets username to "Student"', () async {
      final provider = CoursesProvider();
      await provider.setUsername('Eman');
      await provider.clearAllData();
      expect(provider.username, equals('Student'));
    });

    test('clearAllData disables dark mode', () async {
      final provider = CoursesProvider();
      await provider.toggleDarkMode();
      await provider.clearAllData();
      expect(provider.isDarkMode, isFalse);
    });
  });

  // ============================================================
  // Group 7: SharedPreferences Persistence
  // ============================================================
  group('SharedPreferences Persistence', () {
    test('enrolled course persists after loadFromPrefs', () async {
      final provider = CoursesProvider();
      await provider.toggleEnrollment('1');

      // Simulate app restart: new provider loads saved data
      final provider2 = CoursesProvider();
      await provider2.loadFromPrefs();

      expect(provider2.isEnrolled('1'), isTrue);
    });

    test('progress persists after loadFromPrefs', () async {
      final provider = CoursesProvider();
      await provider.toggleEnrollment('1');
      await provider.updateProgress('1', 60);

      final provider2 = CoursesProvider();
      await provider2.loadFromPrefs();

      expect(provider2.getProgress('1'), equals(60));
    });

    test('username persists after loadFromPrefs', () async {
      final provider = CoursesProvider();
      await provider.setUsername('Eman');

      final provider2 = CoursesProvider();
      await provider2.loadFromPrefs();

      expect(provider2.username, equals('Eman'));
    });

    test('dark mode persists after loadFromPrefs', () async {
      final provider = CoursesProvider();
      await provider.toggleDarkMode();

      final provider2 = CoursesProvider();
      await provider2.loadFromPrefs();

      expect(provider2.isDarkMode, isTrue);
    });
  });
}
