// ignore_for_file: deprecated_member_use

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ─── Timer Ring ───────────────────────────────────────────────────────────────
class TimerRing extends StatelessWidget {
  final int value;
  final double progress;

  const TimerRing({super.key, required this.value, required this.progress});

  Color get _strokeColor {
    if (progress > 0.5) return AppTheme.accentCyan;
    if (progress > 0.25) return AppTheme.accentYellow;
    return const Color(0xFFFF6B6B);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(60, 60),
            painter: _RingPainter(progress: progress, color: _strokeColor),
          ),
          Text(
            '$value',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: progress < 0.25 ? const Color(0xFFFF6B6B) : AppTheme.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  _RingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppTheme.surface
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color;
}

// ─── XP Bar ───────────────────────────────────────────────────────────────────
class XpBar extends StatelessWidget {
  final int xp;
  final int xpNeeded;
  final double progress;
  final int playerLevel;

  const XpBar({
    super.key,
    required this.xp,
    required this.xpNeeded,
    required this.progress,
    required this.playerLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'XP $xp/$xpNeeded',
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.textSecondary,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppTheme.surface,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentPurple),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: AppTheme.accentPurple.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.accentPurple.withOpacity(0.4)),
          ),
          child: Text(
            'Niv. $playerLevel',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.accentPurple,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Lifeline Button ──────────────────────────────────────────────────────────
class LifelineButton extends StatelessWidget {
  final String label;
  final bool available;
  final VoidCallback onTap;

  const LifelineButton({
    super.key,
    required this.label,
    required this.available,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: available ? onTap : null,
      child: AnimatedOpacity(
        opacity: available ? 1.0 : 0.3,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: available
                  ? AppTheme.accentCyan.withOpacity(0.4)
                  : AppTheme.surface,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: available ? AppTheme.accentCyan : AppTheme.textSecondary,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Option Button ────────────────────────────────────────────────────────────
enum OptionState { idle, correct, wrong }

class OptionButton extends StatelessWidget {
  final String letter;
  final String text;
  final OptionState optionState;
  final bool hidden;
  final VoidCallback? onTap;

  const OptionButton({
    super.key,
    required this.letter,
    required this.text,
    required this.optionState,
    this.hidden = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (hidden) return const SizedBox.shrink();

    Color bg, borderColor, textColor, letterBg, letterText;
    switch (optionState) {
      case OptionState.correct:
        bg = AppTheme.accentGreen.withOpacity(0.15);
        borderColor = AppTheme.accentGreen;
        textColor = AppTheme.accentGreen;
        letterBg = AppTheme.accentGreen;
        letterText = AppTheme.background;
        break;
      case OptionState.wrong:
        bg = const Color(0xFFFF6B6B).withOpacity(0.15);
        borderColor = const Color(0xFFFF6B6B);
        textColor = const Color(0xFFFF6B6B);
        letterBg = const Color(0xFFFF6B6B);
        letterText = AppTheme.background;
        break;
      default:
        bg = AppTheme.cardColor;
        borderColor = AppTheme.surface;
        textColor = AppTheme.textPrimary;
        letterBg = AppTheme.surface;
        letterText = AppTheme.textSecondary;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(color: letterBg, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(
                letter,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: letterText,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: textColor,
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

// ─── AI Explanation Box ───────────────────────────────────────────────────────
class AiBox extends StatelessWidget {
  final String text;
  final bool loading;
  final bool isCorrect;

  const AiBox({
    super.key,
    required this.text,
    required this.loading,
    this.isCorrect = true,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = isCorrect ? AppTheme.accentGreen : AppTheme.accentCyan;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.surface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 13, color: accentColor),
              const SizedBox(width: 6),
              Text(
                'Agent AI',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                  fontFamily: 'Poppins',
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (loading)
            const _TypingDots()
          else
            Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
                fontFamily: 'Poppins',
                height: 1.6,
              ),
            ),
        ],
      ),
    );
  }
}

class _TypingDots extends StatefulWidget {
  const _TypingDots();
  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
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
                    .withOpacity(0.3 + 0.7 * math.sin(phase).abs()),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}

// ─── Stat Card ────────────────────────────────────────────────────────────────
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? accent;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surface),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.textSecondary,
              fontFamily: 'Poppins',
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: accent ?? AppTheme.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Lives Display ────────────────────────────────────────────────────────────
class LivesDisplay extends StatelessWidget {
  final int lives;
  final int maxLives;

  const LivesDisplay({super.key, required this.lives, this.maxLives = 3});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxLives, (i) {
        final filled = i < lives;
        return Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Icon(
            filled ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
            color: filled ? const Color(0xFFFF6B6B) : AppTheme.surface,
            size: 18,
          ),
        );
      }),
    );
  }
}

// ─── Score Pop (overlay) ──────────────────────────────────────────────────────
class ScorePop extends StatefulWidget {
  final int xp;
  final int combo;
  const ScorePop({super.key, required this.xp, required this.combo});

  @override
  State<ScorePop> createState() => _ScorePopState();
}

class _ScorePopState extends State<ScorePop>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _fade = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0.5, 1.0)));
    _slide = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1))
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCombo = widget.combo >= 2;
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: isCombo
                ? AppTheme.accentYellow.withOpacity(0.2)
                : AppTheme.accentGreen.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isCombo ? AppTheme.accentYellow : AppTheme.accentGreen,
              width: 1.2,
            ),
          ),
          child: Text(
            isCombo
                ? '+${widget.xp} pts 🔥 x${widget.combo}'
                : '+${widget.xp} pts',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isCombo ? AppTheme.accentYellow : AppTheme.accentGreen,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Category badge ───────────────────────────────────────────────────────────
class CategoryBadge extends StatelessWidget {
  final String category;
  const CategoryBadge({super.key, required this.category});

  Color get _color {
    switch (category) {
      case 'HISTOIRE': return AppTheme.accentCyan;
      case 'GÉOGRAPHIE': return AppTheme.accentGreen;
      case 'CULTURE': return AppTheme.accentPurple;
      case 'ÉCONOMIE': return AppTheme.accentYellow;
      default: return AppTheme.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _color.withOpacity(0.4)),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: _color,
          fontFamily: 'Poppins',
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}