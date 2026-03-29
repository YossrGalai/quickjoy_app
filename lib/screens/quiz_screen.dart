import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/quiz_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_widget.dart';
import '../widgets/quiz_widgets.dart';
import 'result_screen.dart';

class QuizGameScreen extends StatefulWidget {
  const QuizGameScreen({super.key});

  @override
  State<QuizGameScreen> createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _popEntry;
  late AnimationController _xpAnim;

  @override
  void initState() {
    super.initState();
    _xpAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizController>().startGame();
    });
  }

  @override
  void dispose() {
    _popEntry?.remove();
    _xpAnim.dispose();
    super.dispose();
  }


  void _showScorePop(int xp, int combo) {
    _popEntry?.remove();
    final overlay = Overlay.of(context);
    _popEntry = OverlayEntry(
      builder: (_) => Positioned(
        top: 100,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: ScorePop(xp: xp, combo: combo),
        ),
      ),
    );
    overlay.insert(_popEntry!);
    Future.delayed(const Duration(milliseconds: 1300), () {
      _popEntry?.remove();
      _popEntry = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizController>(
      builder: (context, ctrl, _) {
        // ── Guard: not yet started ──────────────────────────────
        if (ctrl.state == QuizState.idle || ctrl.currentQuestion == null) {
            return Scaffold(
              bottomNavigationBar: const BottomNavWidget(),
              appBar: AppBar(
                  backgroundColor: AppTheme.surface,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppTheme.textPrimary, size: 18),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              body: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1E1E2E), Color(0xFF3A0CA3), Color(0xFF4361EE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(child: CircularProgressIndicator()),
              ),
            );
          }
  
        // Navigate to results when finished
        if (ctrl.state == QuizState.finished && ctrl.result != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider.value(
                    value: ctrl,
                    child: const QuizResultScreen(),
                  ),
                ),
              );
            }
          });
        }

        final q = ctrl.currentQuestion;
        final letters = ['A', 'B', 'C', 'D'];
        void confirmQuit(BuildContext context, QuizController ctrl, {bool goHome = false}) {
          showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
              backgroundColor: AppTheme.cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text(
                'Quitter la partie ?',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              content: const Text(
                'Ta progression sera perdue.',
                style: TextStyle(color: AppTheme.textSecondary, fontFamily: 'Poppins'),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Continuer',
                      style: TextStyle(color: AppTheme.accentCyan)),
                ),
                TextButton(
                  onPressed: () {
                    ctrl.resetGame();
                    Navigator.pop(dialogContext);
                    if (goHome) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home', (_) => false,
                      );
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Quitter',
                      style: TextStyle(color: Color(0xFFFF6B6B))),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          bottomNavigationBar: const BottomNavWidget(),
          appBar: AppBar(
            backgroundColor: AppTheme.surface,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppTheme.textPrimary, size: 18),
              onPressed: () => confirmQuit(context, ctrl),
            ),
            centerTitle: true,
            title: Text(
              ctrl.currentLevel.name,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.home_rounded,
                    color: AppTheme.accentCyan, size: 22),
                onPressed: () => confirmQuit(context, ctrl, goHome: true),
              ),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E1E2E), Color(0xFF3A0CA3), Color(0xFF4361EE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                // ─── Header ─────────────────────────────────────────────
                _buildHeader(ctrl),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // XP Bar
                        _XpBarAnimated(ctrl: ctrl),
                        const SizedBox(height: 12),

                        // Progress
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: ctrl.qIndex / ctrl.totalQuestions,
                            minHeight: 3,
                            backgroundColor: AppTheme.surface,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppTheme.accentPurple),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Question ${ctrl.qIndex + 1}/${ctrl.totalQuestions}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.textSecondary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            _ComboChip(combo: ctrl.combo, state: ctrl.state),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Lifelines
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            LifelineButton(
                              label: '50/50',
                              available: ctrl.ll50Available &&
                                  ctrl.state == QuizState.playing,
                              onTap: ctrl.useLifeline50,
                            ),
                            const SizedBox(width: 6),
                            LifelineButton(
                              label: '⟳ Passer',
                              available: ctrl.llSkipAvailable &&
                                  ctrl.state == QuizState.playing,
                              onTap: ctrl.useLifelineSkip,
                            ),
                            const SizedBox(width: 6),
                            LifelineButton(
                              label: '? Indice',
                              available: ctrl.llHintAvailable &&
                                  ctrl.state == QuizState.playing,
                              onTap: ctrl.useLifelineHint,
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Question card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppTheme.cardColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppTheme.surface),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.quizColor.withValues(alpha: 0.06),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CategoryBadge(category: q!.category),
                              const SizedBox(height: 12),
                              Text(
                                q.question,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                  fontFamily: 'Poppins',
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Options
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 2.1,
                          ),
                          itemCount: q.options.length,
                          itemBuilder: (_, i) {
                            final isHidden = ctrl.hiddenOptions.contains(i);
                            final isAnswered =
                                ctrl.state == QuizState.answered ||
                                    ctrl.state == QuizState.timeout;
                            OptionState optState = OptionState.idle;
                            if (isAnswered) {
                              if (i == q.correctIndex) {
                                optState = OptionState.correct;
                              } else if (i == ctrl.selectedIndex) {
                                optState = OptionState.wrong;
                              }
                            }
                            return OptionButton(
                              letter: letters[i],
                              text: q.options[i],
                              optionState: optState,
                              hidden: isHidden,
                              onTap: isAnswered || isHidden
                                  ? null
                                  : () {
                                      ctrl.selectAnswer(i);
                                      if (ctrl.lastXpGained > 0) {
                                        _showScorePop(
                                            ctrl.lastXpGained, ctrl.combo);
                                      }
                                    },
                            );
                          },
                        ),
                        const SizedBox(height: 14),

                        // Timeout chip
                        if (ctrl.state == QuizState.timeout)
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6B6B).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: const Color(0xFFFF6B6B)
                                        .withValues(alpha: 0.4)),
                              ),
                              child: const Text(
                                '⏱ Temps écoulé!',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFFF6B6B),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),

                        // AI Box
                        if (ctrl.aiVisible) ...[
                          const SizedBox(height: 14),
                          AiBox(
                            text: ctrl.aiText,
                            loading: ctrl.aiLoading,
                            isCorrect: ctrl.selectedIndex ==
                              ctrl.currentQuestion?.correctIndex,
                          ),
                        ],

                        // Next button
                        if (ctrl.state == QuizState.answered ||
                            ctrl.state == QuizState.timeout) ...[
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: ctrl.nextQuestion,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.accentCyan,
                                foregroundColor: AppTheme.background,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                ctrl.qIndex >= ctrl.totalQuestions - 1
                                    ? 'Voir les résultats →'
                                    : 'Question suivante →',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        );
      },
    );
  }

  Widget _buildHeader(QuizController ctrl) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          bottom: BorderSide(color: AppTheme.cardColor),
        ),
      ),
      child: Row(
        children: [
          // Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SCORE',
                style: TextStyle(
                  fontSize: 10,
                  color: AppTheme.textSecondary,
                  fontFamily: 'Poppins',
                  letterSpacing: 1,
                ),
              ),
              Text(
                '${ctrl.score}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.accentYellow,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          const Spacer(),
          // Timer
          TimerRing(
              value: ctrl.timerValue, progress: ctrl.timerProgress),
          const Spacer(),
          // Lives
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'VIES',
                style: TextStyle(
                  fontSize: 10,
                  color: AppTheme.textSecondary,
                  fontFamily: 'Poppins',
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 2),
              LivesDisplay(lives: ctrl.lives),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── XP Bar with animated progress ───────────────────────────────────────────
class _XpBarAnimated extends StatefulWidget {
  final QuizController ctrl;
  const _XpBarAnimated({required this.ctrl});

  @override
  State<_XpBarAnimated> createState() => _XpBarAnimatedState();
}

class _XpBarAnimatedState extends State<_XpBarAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  double _prev = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _anim = Tween<double>(begin: 0, end: widget.ctrl.xpProgress).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(_XpBarAnimated old) {
    super.didUpdateWidget(old);
    if (old.ctrl.xpProgress != widget.ctrl.xpProgress) {
      _prev = old.ctrl.xpProgress;
      _anim = Tween<double>(begin: _prev, end: widget.ctrl.xpProgress).animate(
          CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
      _ctrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => XpBar(
        xp: widget.ctrl.xp,
        xpNeeded: widget.ctrl.xpNeeded,
        progress: _anim.value,
        playerLevel: widget.ctrl.playerLevel,
      ),
    );
  }
}

// ─── Combo chip ───────────────────────────────────────────────────────────────
class _ComboChip extends StatelessWidget {
  final int combo;
  final QuizState state;
  const _ComboChip({required this.combo, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state == QuizState.timeout) {
      return const Text(
        '⏱ Temps écoulé',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFFFF6B6B),
          fontFamily: 'Poppins',
        ),
      );
    }
    if (combo >= 2) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppTheme.accentYellow.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
          border:
              Border.all(color: AppTheme.accentYellow.withValues(alpha: 0.4)),
        ),
        child: Text(
          '🔥 Combo x$combo',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppTheme.accentYellow,
            fontFamily: 'Poppins',
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}