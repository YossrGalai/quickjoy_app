import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/game_provider.dart';
import '../router/app_router.dart';
import '../widgets/category_card.dart';
import '../widgets/score_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),

                  // Header avec score
                  ScoreHeader(totalScore: provider.totalScore),

                  const SizedBox(height: 40),

                  // Titre
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Turn waiting\ninto ',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                            height: 1.2,
                          ),
                        ),
                        TextSpan(
                          text: 'something.',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.accentCyan,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Pick a category and snap into it.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      color: AppTheme.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Label section
                  const Text(
                    'CHOOSE YOUR VIBE',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                      letterSpacing: 2.5,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Carte Quiz
                  CategoryCard(
                    title: 'Quiz Time',
                    subtitle: 'Test your knowledge\nin 60 seconds',
                    emoji: '🧠',
                    color: AppTheme.quizColor,
                    tag: 'EDUCATIVE',
                    onTap: () {
                      provider.selectCategory(GameCategory.quiz);
                      Navigator.pushNamed(context, AppRouter.levelSelect);
                    },
                  ),

                  const SizedBox(height: 16),

                  // Carte Puzzle
                  CategoryCard(
                    title: 'Puzzle Drop',
                    subtitle: 'Slide pieces,\nbig satisfaction',
                    emoji: '🧩',
                    color: AppTheme.puzzleColor,
                    tag: 'FUNNY',
                    onTap: () {
                      provider.selectCategory(GameCategory.puzzle);
                      Navigator.pushNamed(context, AppRouter.selectImage);
                    },
                  ),

                  const Spacer(),

                  // Sessions du jour
                  Center(
                    child: Text(
                      '${provider.sessionsToday} sessions today',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}