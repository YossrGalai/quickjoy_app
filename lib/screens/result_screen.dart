import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/quiz_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_widget.dart';
import '../widgets/quiz_widgets.dart';
import 'splash_screen.dart';
import 'quiz_screen.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key});

  String _emoji(double accuracy) {
    if (accuracy >= 0.9) return '🏆';
    if (accuracy >= 0.7) return '🥇';
    if (accuracy >= 0.5) return '👏';
    return '😅';
  }

  String _message(double accuracy) {
    if (accuracy >= 0.9) return 'Exceptionnel!';
    if (accuracy >= 0.7) return 'Très bien!';
    if (accuracy >= 0.5) return 'Pas mal!';
    return 'Continuez!';
  }

  Color _scoreColor(double accuracy) {
    if (accuracy >= 0.7) return AppTheme.accentGreen;
    if (accuracy >= 0.5) return AppTheme.accentYellow;
    return const Color(0xFFFF6B6B);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizController>(
      builder: (context, ctrl, _) {
        final result = ctrl.result;
        if (result == null) return const SizedBox();

        final pct = (result.accuracy * 100).round();

        return Scaffold(
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  children: [
                    // Emoji + score
                    Text(_emoji(result.accuracy),
                        style: const TextStyle(fontSize: 60)),
                    const SizedBox(height: 12),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          _scoreColor(result.accuracy),
                          AppTheme.accentPurple,
                        ],
                      ).createShader(bounds),
                      child: Text(
                        '${result.score}',
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    const Text (
                      'points',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _message(result.accuracy),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _scoreColor(result.accuracy),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Stats grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.0,
                      children: [
                        StatCard(
                          label: 'BONNES RÉP.',
                          value: '${result.correct}/${result.total}',
                          accent: AppTheme.accentGreen,
                        ),
                        StatCard(
                          label: 'PRÉCISION',
                          value: '$pct%',
                          accent: _scoreColor(result.accuracy),
                        ),
                        StatCard(
                          label: 'COMBO MAX',
                          value: '${result.maxCombo}x',
                          accent: AppTheme.accentYellow,
                        ),
                        StatCard(
                          label: 'XP GAGNÉE',
                          value: '+${result.xpEarned}',
                          accent: AppTheme.accentPurple,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Player level banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: AppTheme.accentPurple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppTheme.accentPurple.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'NIVEAU JOUEUR',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppTheme.accentPurple,
                              fontFamily: 'Poppins',
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Niv. ${result.playerLevel}',
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.accentPurple,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // AI summary — affiché seulement si chargement ou texte disponible
                    if (ctrl.aiLoading || ctrl.aiText.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.surface, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.auto_awesome, size: 13, color: AppTheme.accentCyan),
                                SizedBox(width: 6),
                                Text(
                                  'Agent AI — Bilan personnalisé',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.accentCyan,
                                    fontFamily: 'Poppins',
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            if (ctrl.aiLoading)
                              const _DotsLoader()
                            else
                              Text(
                                ctrl.aiText,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.textSecondary,
                                  fontFamily: 'Poppins',
                                  height: 1.6,
                                ),
                              ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 28),

                    // Replay button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ctrl.resetGame();
                          ctrl.startGame();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider.value(
                                value: ctrl,
                                child: const QuizGameScreen(),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentCyan,
                          foregroundColor: AppTheme.background,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Rejouer',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Change level button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          ctrl.resetGame();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider.value(
                                value: ctrl,
                                child: const QuizSplashScreen(),
                              ),
                            ),
                            (_) => false,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.textPrimary,
                          side: const BorderSide(color: AppTheme.surface),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Changer de niveau',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        );
      },
    );
  }
}

class _DotsLoader extends StatefulWidget {
  const _DotsLoader();
  @override
  State<_DotsLoader> createState() => _DotsLoaderState();
}

class _DotsLoaderState extends State<_DotsLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Row(
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) {
            final phase = ((_ctrl.value + i * 0.3) % 1.0) * math.pi;
            return Container(
              margin: const EdgeInsets.only(right: 5),
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: AppTheme.accentCyan
                    .withValues(alpha: 0.3 + 0.7 * math.sin(phase).abs()),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}