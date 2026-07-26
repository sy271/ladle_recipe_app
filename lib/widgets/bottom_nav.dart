import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../data/sample_data.dart';
import '../theme/ladle_colors.dart';

enum BottomNavTab { home, search, saved, profile }

class BottomNav extends StatelessWidget {
  const BottomNav({
    super.key,
    required this.active,
    required this.onTabSelected,
  });

  final BottomNavTab active;
  final ValueChanged<BottomNavTab> onTabSelected;

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
          const _QuickActionsButton(),
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

/// The raised "+" FAB. Tapping it rotates the icon 45° into an "×" and opens
/// a blurred quick-actions sheet; tapping the sheet's backdrop, an action, or
/// the same button again dismisses it.
class _QuickActionsButton extends StatefulWidget {
  const _QuickActionsButton();

  @override
  State<_QuickActionsButton> createState() => _QuickActionsButtonState();
}

class _QuickActionsButtonState extends State<_QuickActionsButton> {
  bool _isOpen = false;

  Future<void> _openSheet() async {
    setState(() => _isOpen = true);
    final outerContext = context;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (sheetContext) => _QuickActionsSheet(outerContext: outerContext),
    );
    if (mounted) setState(() => _isOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<LadleColors>()!;

    return Transform.translate(
      offset: const Offset(0, -20),
      child: GestureDetector(
        onTap: _isOpen ? null : _openSheet,
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
          child: AnimatedRotation(
            turns: _isOpen ? 0.125 : 0,
            duration: const Duration(milliseconds: 200),
            child: Icon(LucideIcons.plus, size: 22, color: colors.primaryFg),
          ),
        ),
      ),
    );
  }
}

class _QuickAction {
  const _QuickAction(this.emoji, this.label, this.onSelect);

  final String emoji;
  final String label;
  final void Function(BuildContext outerContext) onSelect;
}

final List<_QuickAction> _quickActions = [
  _QuickAction(
    '🔥',
    'Start Cooking',
    (outerContext) => outerContext.push('/recipe/${allRecipes.first.id}'),
  ),
  _QuickAction('📝', 'Add a Recipe', (outerContext) => outerContext.go('/saved')),
  _QuickAction('📷', 'Scan Ingredients', (outerContext) => outerContext.go('/search')),
  _QuickAction('📅', 'Plan My Week', (outerContext) => outerContext.push('/profile')),
];

class _QuickActionsSheet extends StatelessWidget {
  const _QuickActionsSheet({required this.outerContext});

  final BuildContext outerContext;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<LadleColors>()!;

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.cardBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final action in _quickActions) ...[
              _QuickActionRow(
                action: action,
                colors: colors,
                onTap: () {
                  debugPrint('QUICK ACTION TAPPED: ${action.label}');
                  Navigator.of(context).pop();
                  action.onSelect(outerContext);
                },
              ),
              if (action != _quickActions.last) Divider(height: 1, color: colors.divider),
            ],
          ],
        ),
      ),
    );
  }
}

class _QuickActionRow extends StatelessWidget {
  const _QuickActionRow({required this.action, required this.colors, required this.onTap});

  final _QuickAction action;
  final LadleColors colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Text(action.emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 14),
            Text(
              action.label,
              style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600, color: colors.heading),
            ),
          ],
        ),
      ),
    );
  }
}
