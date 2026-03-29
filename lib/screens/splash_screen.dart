import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/quiz_controller.dart';
import '../models/quiz.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/bottom_nav_widget.dart';
import 'quiz_screen.dart';

class QuizSplashScreen extends StatelessWidget {
  const QuizSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const AppBarWidget(title: 'Choisir le niveau', showBack: true),
      bottomNavigationBar: const BottomNavWidget(),
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
            colors: [Color(0xFF1E1E2E), Color(0xFF3A0CA3), Color(0xFF4361EE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          ),
          child: SafeArea(
            child: Consumer<QuizController>(
            builder: (context, ctrl, _) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Flag + glow effect
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.cardColor,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.quizColor.withValues(alpha: 0.25),
                            blurRadius: 32,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('🇹🇳', style: TextStyle(fontSize: 44)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [AppTheme.accentCyan, AppTheme.accentPurple],
                      ).createShader(bounds),
                      child: const Text(
                        'Quiz Tunisie',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Testez vos connaissances sur la Tunisie\nhistoire · culture · géographie',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                        fontFamily: 'Poppins',
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Info row
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _InfoChip(icon: Icons.quiz_outlined, label: '10 questions'),
                        SizedBox(width: 12),
                        _InfoChip(icon: Icons.favorite_outline, label: '3 vies'),
                        SizedBox(width: 12),
                        _InfoChip(icon: Icons.auto_awesome_outlined, label: 'Agent AI'),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Level label
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'CHOISIR UN NIVEAU',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Level tiles
                    ...List.generate(kQuizLevels.length, (i) {
                      return _LevelTile(
                        level: kQuizLevels[i],
                        index: i,
                        selected: ctrl.levelIndex == i,
                        onTap: () => ctrl.setLevel(i),
                      );
                    }),
                    const SizedBox(height: 32),

                    // Start button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ctrl.startGame();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider.value(
                                value: ctrl,
                                child: const QuizGameScreen(),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0077AA),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Commencer le quiz',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        )
      )
    );
  }
}

class _LevelTile extends StatelessWidget {
  final QuizLevel level;
  final int index;
  final bool selected;
  final VoidCallback onTap;

  const _LevelTile({
    required this.level,
    required this.index,
    required this.selected,
    required this.onTap,
  });

  Color get _tagColor {
    switch (index) {
      case 0: return AppTheme.accentGreen;
      case 1: return AppTheme.accentYellow;
      default: return const Color(0xFFFF6B6B);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.accentCyan.withValues(alpha: 0.8)
              : AppTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppTheme.accentCyan : AppTheme.surface,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    level.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: selected ? const Color(0xFF0D0D2B) : AppTheme.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${level.timePerQuestion}s · x${level.scoreMultiplier} score',
                    style: TextStyle(
                      fontSize: 12,
                      color: selected ? const Color(0xFF1A3A4A) : AppTheme.textSecondary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _tagColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _tagColor.withValues(alpha: 0.4)),
              ),
              child: Text(
                level.difficulty,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: selected ? const Color(0xFF0D0D2B) : _tagColor,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.surface),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppTheme.textSecondary),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondary,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}