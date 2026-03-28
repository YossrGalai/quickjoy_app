import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../router/app_router.dart';

class BottomNavWidget extends StatelessWidget {
  final Color backgroundColor;

  const BottomNavWidget({
    super.key,
    this.backgroundColor = const Color(0xFF1A1A3E),
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Accueil',
                onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRouter.home, (_) => false,
                ),
              ),
              _NavItem(
                icon: Icons.history_rounded,
                label: 'Historique',
                onTap: () {}, // à brancher plus tard
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppTheme.textSecondary, size: 22),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.textSecondary,
                fontFamily: 'Poppins',
              )),
        ],
      ),
    );
  }
}