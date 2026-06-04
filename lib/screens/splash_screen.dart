/// Splash screen and onboarding flow for LearnHub.
///
/// On first launch: shows a 2-second splash then opens [_OnboardingDialog].
/// On subsequent launches: navigates directly to [MainNavigation].
///
/// The first-launch flag is stored in [SharedPreferences] under the key
/// `first_launch` and set to `false` after onboarding completes.
library;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_navigation.dart';

/// Entry screen that handles splash animation and first-launch onboarding.
class SplashScreen extends StatefulWidget {
  /// Creates the [SplashScreen].
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  /// Checks [SharedPreferences] to decide whether to show onboarding.
  ///
  /// - First launch → waits 2 seconds then shows [_OnboardingDialog].
  /// - Subsequent launches → navigates immediately to [MainNavigation].
  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('first_launch') ?? true;

    if (!isFirstLaunch) {
      _navigateToMain();
      return;
    }

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) _showOnboarding();
  }

  /// Replaces this screen with [MainNavigation].
  void _navigateToMain() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainNavigation()),
    );
  }

  /// Shows the onboarding dialog as a non-dismissible overlay.
  void _showOnboarding() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _OnboardingDialog(onDone: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('first_launch', false);
        if (mounted) _navigateToMain();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6C63FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.school_rounded, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text('LearnHub',
                style: TextStyle(color: Colors.white, fontSize: 36,
                    fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            const SizedBox(height: 8),
            Text('Learn Anywhere, Anytime',
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16)),
            const SizedBox(height: 40),
            const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
          ],
        ),
      ),
    );
  }
}

/// A 3-step onboarding dialog shown only on the first app launch.
///
/// Each page shows an emoji icon, a title, and a subtitle.
/// Navigation between pages uses a [_currentPage] index with dot indicators.
class _OnboardingDialog extends StatefulWidget {
  /// Callback invoked when the user taps "Get Started" on the last page.
  final VoidCallback onDone;

  const _OnboardingDialog({required this.onDone});

  @override
  State<_OnboardingDialog> createState() => _OnboardingDialogState();
}

class _OnboardingDialogState extends State<_OnboardingDialog> {
  /// Index of the currently displayed onboarding page.
  int _currentPage = 0;

  /// Content for each onboarding step.
  final List<Map<String, String>> _pages = [
    {'icon': '📚', 'title': 'Hundreds of Courses',
      'subtitle': 'Browse courses in programming, design, and more.'},
    {'icon': '🎯', 'title': 'Track Your Progress',
      'subtitle': 'Mark lessons complete and see your learning journey.'},
    {'icon': '🌙', 'title': 'Study Your Way',
      'subtitle': 'Use dark mode and customize your profile.'},
  ];

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];
    final isLast = _currentPage == _pages.length - 1;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(page['icon']!, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(page['title']!,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text(page['subtitle']!,
                style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            // Page indicator dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (i) => Container(
                width: _currentPage == i ? 20 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: _currentPage == i ? const Color(0xFF6C63FF) : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              )),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (isLast) {
                    Navigator.of(context).pop();
                    widget.onDone();
                  } else {
                    setState(() => _currentPage++);
                  }
                },
                child: Text(isLast ? 'Get Started' : 'Next',
                    style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
