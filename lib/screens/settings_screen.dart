import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../providers/theme_mode_provider.dart';
import '../services/auth_service.dart';
import '../theme/ladle_colors.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<LadleColors>()!;
    final themeMode = ref.watch(themeModeProvider);
    final email = AuthService().currentUser?.email;

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.inputBg,
                        border: Border.all(color: colors.border),
                      ),
                      child: Icon(LucideIcons.chevronLeft, size: 18, color: colors.meta),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Settings',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: colors.heading,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                'APPEARANCE',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: colors.muted,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.cardBorder),
                ),
                child: Column(
                  children: [
                    for (final option in [
                      (ThemeMode.system, 'System', LucideIcons.smartphone),
                      (ThemeMode.light, 'Light', LucideIcons.sun),
                      (ThemeMode.dark, 'Dark', LucideIcons.moon),
                    ])
                      _ThemeModeRow(
                        mode: option.$1,
                        label: option.$2,
                        icon: option.$3,
                        selected: themeMode == option.$1,
                        showDivider: option.$1 != ThemeMode.dark,
                        colors: colors,
                        onTap: () => ref.read(themeModeProvider.notifier).setThemeMode(option.$1),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'ACCOUNT',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: colors.muted,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.cardBorder),
                ),
                child: Row(
                  children: [
                    Icon(LucideIcons.mail, size: 15, color: colors.muted),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        email ?? 'Not signed in',
                        style: GoogleFonts.dmSans(fontSize: 14, color: colors.body),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeModeRow extends StatelessWidget {
  const _ThemeModeRow({
    required this.mode,
    required this.label,
    required this.icon,
    required this.selected,
    required this.showDivider,
    required this.colors,
    required this.onTap,
  });

  final ThemeMode mode;
  final String label;
  final IconData icon;
  final bool selected;
  final bool showDivider;
  final LadleColors colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: showDivider ? Border(bottom: BorderSide(color: colors.divider)) : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: selected ? colors.primary : colors.muted),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? colors.heading : colors.body,
                ),
              ),
            ),
            if (selected) Icon(LucideIcons.check, size: 16, color: colors.primary),
          ],
        ),
      ),
    );
  }
}
