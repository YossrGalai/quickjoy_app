import 'package:flutter/material.dart';
import '../router/app_router.dart';
import '../theme/app_theme.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final bool showHome;
  final VoidCallback? onBack;
  final VoidCallback? onHome;

  const AppBarWidget({
    super.key,
    required this.title,
    this.showBack = false,
    this.showHome = false,
    this.onBack,
    this.onHome,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.surface,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppTheme.textPrimary, size: 18),
              onPressed: onBack ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
      actions: [
        if (showHome)
          IconButton(
            icon: const Icon(Icons.home_rounded,
                color: AppTheme.accentCyan, size: 22),
            onPressed: onHome ??
                () => Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRouter.home,
                      (_) => false,
                    ),
          ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: AppTheme.surface.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}