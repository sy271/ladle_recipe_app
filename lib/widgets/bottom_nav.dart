import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../theme/ladle_colors.dart';

enum BottomNavTab { home, search, saved, profile }

class BottomNav extends StatelessWidget {
  const BottomNav({
    super.key,
    required this.active,
    required this.onTabSelected,
    required this.onAddTapped,
  });

  final BottomNavTab active;
  final ValueChanged<BottomNavTab> onTabSelected;
  final VoidCallback onAddTapped;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<LadleColors>()!;

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
      decoration: BoxDecoration(
        color: colors.navBg,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            tab: BottomNavTab.home,
            icon: LucideIcons.home,
            label: 'Home',
            active: active,
            colors: colors,
            onTap: onTabSelected,
          ),
          _NavItem(
            tab: BottomNavTab.search,
            icon: LucideIcons.search,
            label: 'Search',
            active: active,
            colors: colors,
            onTap: onTabSelected,
          ),
          _AddButton(colors: colors, onTap: onAddTapped),
          _NavItem(
            tab: BottomNavTab.saved,
            icon: LucideIcons.bookmark,
            label: 'Saved',
            active: active,
            colors: colors,
            onTap: onTabSelected,
          ),
          _NavItem(
            tab: BottomNavTab.profile,
            icon: LucideIcons.user,
            label: 'Profile',
            active: active,
            colors: colors,
            onTap: onTabSelected,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.icon,
    required this.label,
    required this.active,
    required this.colors,
    required this.onTap,
  });

  final BottomNavTab tab;
  final IconData icon;
  final String label;
  final BottomNavTab active;
  final LadleColors colors;
  final ValueChanged<BottomNavTab> onTap;

  @override
  Widget build(BuildContext context) {
    final color = tab == active ? colors.navActive : colors.navInactive;
    return GestureDetector(
      onTap: () => onTap(tab),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.dmSans(fontSize: 9, fontWeight: FontWeight.w600, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.colors, required this.onTap});

  final LadleColors colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(LucideIcons.plus, size: 22, color: colors.primaryFg),
        ),
      ),
    );
  }
}
