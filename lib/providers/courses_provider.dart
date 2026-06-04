/// {@category State Management}
///
/// The [CoursesProvider] is the central state manager for the LearnHub app.
///
/// It implements the **Observer Pattern** via Flutter's [ChangeNotifier]:
/// - [CoursesProvider] acts as the **Subject** (Observable).
/// - Any widget that calls `context.watch<CoursesProvider>()` acts as an **Observer**.
/// - When state changes, [notifyListeners] is called and all observers rebuild automatically.
///
/// Responsibilities:
/// - Managing course enrollment state.
/// - Tracking per-course completion progress.
/// - Persisting all data to [SharedPreferences].
/// - Handling user preferences (dark mode, username).
/// - Filtering and searching the course catalog.
library;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course.dart';
import '../data/courses_data.dart';

/// State manager for LearnHub — implements the Observer Pattern.
///
/// Extends [ChangeNotifier] so that registered listeners (widgets using
/// `context.watch<CoursesProvider>()`) automatically rebuild when any
/// piece of state is mutated via [notifyListeners].
///
/// All mutable state is persisted immediately to [SharedPreferences]
/// via [_saveToPrefs] after every change.
class CoursesProvider extends ChangeNotifier {

  // ============================================================
  // Private State Fields
  // ============================================================

  /// Set of course IDs the user has enrolled in.
  Set<String> _enrolledIds = {};

  /// Maps course ID → completion percentage (0–100).
  Map<String, int> _progress = {};

  /// The currently selected category filter.
  /// Defaults to 'All' to show every course.
  String _selectedCategory = 'All';

  /// The active search keyword entered by the user.
  String _searchQuery = '';

  /// Whether dark mode is currently enabled.
  bool _isDarkMode = false;

  /// The user's chosen display name.
  String _username = 'Student';

  // ============================================================
  // Public Getters
  // ============================================================

  /// Returns `true` if dark mode is currently active.
  bool get isDarkMode => _isDarkMode;

  /// Returns the current user display name.
  String get username => _username;

  /// Returns the currently selected category filter string.
  String get selectedCategory => _selectedCategory;

  /// Returns the list of courses after applying the active category
  /// filter and search query.
  ///
  /// If [_selectedCategory] is 'All', no category filtering is applied.
  /// The search matches against both [Course.title] and [Course.instructor].
  List<Course> get filteredCourses {
    return allCourses.where((course) {
      final matchesCategory =
          _selectedCategory == 'All' || course.category == _selectedCategory;
      final matchesSearch =
          course.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              course.instructor.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  /// Returns the list of [Course] objects the user has enrolled in.
  List<Course> get enrolledCourses {
    return allCourses.where((c) => _enrolledIds.contains(c.id)).toList();
  }

  /// Returns `true` if the course with the given [id] is enrolled.
  bool isEnrolled(String id) => _enrolledIds.contains(id);

  /// Returns the completion percentage (0–100) for the course with [id].
  /// Returns 0 if no progress has been recorded.
  int getProgress(String id) => _progress[id] ?? 0;

  // ============================================================
  // Actions — Observer Pattern: Subject notifies Observers
  // ============================================================

  /// Updates the selected category filter and notifies all observers.
  ///
  /// Passing 'All' removes category filtering.
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners(); // Observer Pattern: notify all watching widgets
  }

  /// Updates the active search query and notifies all observers.
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Toggles enrollment for the course with the given [courseId].
  ///
  /// - If already enrolled: removes from [_enrolledIds] and clears progress.
  /// - If not enrolled: adds to [_enrolledIds] and initialises progress to 0.
  ///
  /// Persists the change to [SharedPreferences] immediately.
  Future<void> toggleEnrollment(String courseId) async {
    if (_enrolledIds.contains(courseId)) {
      _enrolledIds.remove(courseId);
      _progress.remove(courseId);
    } else {
      _enrolledIds.add(courseId);
      _progress[courseId] = 0;
    }
    notifyListeners();
    await _saveToPrefs();
  }

  /// Updates the completion progress for [courseId] to [value].
  ///
  /// [value] is clamped between 0 and 100.
  /// Persists immediately to [SharedPreferences].
  Future<void> updateProgress(String courseId, int value) async {
    _progress[courseId] = value.clamp(0, 100);
    notifyListeners();
    await _saveToPrefs();
  }

  /// Toggles dark mode on or off and persists the preference.
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    await _saveToPrefs();
  }

  /// Updates the user's display name.
  ///
  /// If [name] is blank after trimming, defaults to 'Student'.
  /// Persists immediately to [SharedPreferences].
  Future<void> setUsername(String name) async {
    _username = name.trim().isEmpty ? 'Student' : name.trim();
    notifyListeners();
    await _saveToPrefs();
  }

  /// Resets all state and clears every key from [SharedPreferences].
  ///
  /// Used by the "Clear All Data" option in the Profile screen.
  Future<void> clearAllData() async {
    _enrolledIds = {};
    _progress = {};
    _username = 'Student';
    _isDarkMode = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ============================================================
  // SharedPreferences — Persistence Layer
  // ============================================================

  /// Loads all persisted data from [SharedPreferences] into memory.
  ///
  /// Must be called **before** [runApp] in `main.dart` to ensure
  /// the UI initialises with the correct saved state.
  ///
  /// Loads:
  /// - `enrolled_ids` → [_enrolledIds]
  /// - `progress_{id}` → [_progress]
  /// - `dark_mode` → [_isDarkMode]
  /// - `username` → [_username]
  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final enrolled = prefs.getStringList('enrolled_ids') ?? [];
    _enrolledIds = enrolled.toSet();

    for (final id in _enrolledIds) {
      _progress[id] = prefs.getInt('progress_$id') ?? 0;
    }

    _isDarkMode = prefs.getBool('dark_mode') ?? false;
    _username = prefs.getString('username') ?? 'Student';

    notifyListeners();
  }

  /// Persists the current state to [SharedPreferences].
  ///
  /// Called internally after every state mutation.
  /// Saves:
  /// - [_enrolledIds] as a StringList under `enrolled_ids`
  /// - Each [_progress] entry as int under `progress_{id}`
  /// - [_isDarkMode] as bool under `dark_mode`
  /// - [_username] as String under `username`
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('enrolled_ids', _enrolledIds.toList());
    for (final entry in _progress.entries) {
      await prefs.setInt('progress_${entry.key}', entry.value);
    }
    await prefs.setBool('dark_mode', _isDarkMode);
    await prefs.setString('username', _username);
  }
}
