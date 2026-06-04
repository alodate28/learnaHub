/// Entry point for the LearnHub e-learning application.
///
/// This file bootstraps the Flutter app by:
/// 1. Initialising Flutter bindings.
/// 2. Pre-loading persisted data via [CoursesProvider.loadFromPrefs].
/// 3. Injecting [CoursesProvider] at the root of the widget tree.
/// 4. Running [LearnHubApp].
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/courses_provider.dart';
import 'screens/splash_screen.dart';

/// Application entry point.
///
/// Marked `async` because [CoursesProvider.loadFromPrefs] must complete
/// before the UI renders, ensuring the app starts with the correct state.
void main() async {
  // Required before any async work or plugin usage before runApp.
  WidgetsFlutterBinding.ensureInitialized();

  // Create provider and load all persisted data before rendering.
  final provider = CoursesProvider();
  await provider.loadFromPrefs();

  runApp(
    // Inject CoursesProvider at the top of the widget tree so every
    // descendant widget can access it via context.watch / context.read.
    ChangeNotifierProvider.value(
      value: provider,
      child: const LearnHubApp(),
    ),
  );
}

/// The root widget of the LearnHub application.
///
/// Watches [CoursesProvider.isDarkMode] to dynamically switch between
/// [ThemeMode.light] and [ThemeMode.dark] without requiring a restart.
class LearnHubApp extends StatelessWidget {
  /// Creates the root [LearnHubApp] widget.
  const LearnHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Observer Pattern: rebuilds when isDarkMode changes.
    final isDark = context.watch<CoursesProvider>().isDarkMode;

    return MaterialApp(
      title: 'LearnHub',
      debugShowCheckedModeBanner: false,

      /// Light theme using Material 3 with the LearnHub purple seed color.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black87,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
        ),
      ),

      /// Dark theme — same seed color with dark brightness.
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),

      // Apply the theme chosen by the user in Profile settings.
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

      home: const SplashScreen(),
    );
  }
}
