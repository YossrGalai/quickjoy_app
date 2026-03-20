import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PuzzleScreen extends StatelessWidget {
  const PuzzleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Puzzle Drop 🧩',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
      body: const Center(
        child: Text(
          '🧩 Puzzle coming soon...',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            color: AppTheme.puzzleColor,
          ),
        ),
      ),
    );
  }
}