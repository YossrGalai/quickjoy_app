import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/puzzle_screen.dart';
import '../screens/splash_screen.dart';
class AppRouter {
  static const String home = '/';
  static const String quiz = '/quiz';
  static const String puzzle = '/puzzle';
  static const String levelSelect = '/level-select';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _fadeRoute(const HomeScreen(), settings);
      case levelSelect:
        return _fadeRoute(const QuizSplashScreen(), settings);
      case quiz:
        return _fadeRoute(const QuizGameScreen(), settings);
      case puzzle:
        return _fadeRoute(const PuzzleScreen(), settings);
      default:
        return _fadeRoute(const HomeScreen(), settings);
    }
  }

  // Transition douce entre les écrans
  static PageRouteBuilder _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }
}