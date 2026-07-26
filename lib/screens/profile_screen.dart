import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../data/sample_data.dart';
import '../models/recipe.dart';
import '../providers/liked_recipes_provider.dart';
import '../providers/saved_recipes_provider.dart';
import '../services/auth_service.dart';
import '../theme/ladle_colors.dart';
import '../widgets/bottom_nav.dart';

const _cuisineTags = ['Italian', 'Japanese', 'Mediterranean', 'Plant-based', 'Quick eats'];

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _authService = AuthService();
  bool _signingOut = false;

  Future<void> _signOut() async {
    setState(() => _signingOut = true);
    try {
      await _authService.signOut();
      if (mounted) context.go('/');
    } finally {
      if (mounted) setState(() => _signingOut = false);
    }
  }

  void _openRecipe(Recipe recipe) {
    context.push('/recipe/${recipe.id}');
  }

  void _goToSaved() {
    context.go('/saved');
  }

  void _goToSearch() {
    context.go('/search');
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<LadleColors>()!;
    final user = _authService.currentUser;
    final displayName = (user?.displayName?.isNotEmpty ?? false) ? user!.displayName! : 'Maya Chen';
    final joinYear = user?.metadata.creationTime?.year.toString() ?? '2024';
    final avatarInitial = displayName.trim().isEmpty ? 'M' : displayName.trim()[0].toUpperCase();
    final recent = allRecipes.take(3).toList();
    final savedCount = ref.watch(savedRecipesProvider).length;
    final likedIds = ref.watch(likedRecipesProvider);
    final likedPreview = allRecipes.where((r) => likedIds.contains(r.id)).take(3).toList();

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Profile',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: colors.heading,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.push('/settings'),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colors.inputBg,
                                border: Border.all(color: colors.border),
                              ),
                              child: Icon(LucideIcons.settings, size: 15, color: colors.meta),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: colors.cardBorder),
                        ),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: colors.avatar,
                              child: Text(
                                avatarInitial,
                                style: GoogleFonts.dmSans(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: colors.avatarFg,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              displayName,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: colors.heading,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '@mayacooks · Joined $joinYear',
                              style: GoogleFonts.dmSans(fontSize: 12, color: colors.muted),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _StatTile(
                                    label: 'Saved',
                                    value: '$savedCount',
                                    colors: colors,
                                    onTap: _goToSaved,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _StatTile(label: 'Cooked', value: '34', colors: colors),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _StatTile(label: 'Reviews', value: '12', colors: colors),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'FAVOURITE CUISINES',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: colors.muted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final tag in _cuisineTags)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: colors.tagBg,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: colors.tagBorder),
                              ),
                              child: Text(
                                tag,
                                style: GoogleFonts.dmSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: colors.tagFg,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Liked recipes',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: colors.heading,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.push('/favourites'),
                            child: Text(
                              'See all',
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: colors.seeAll,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (likedPreview.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'No liked recipes yet',
                          style: GoogleFonts.dmSans(fontSize: 12, color: colors.muted),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            for (final recipe in likedPreview) ...[
                              _RecentRow(
                                recipe: recipe,
                                colors: colors,
                                onTap: () => _openRecipe(recipe),
                              ),
                              if (recipe != likedPreview.last) const SizedBox(height: 10),
                            ],
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recently cooked',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: colors.heading,
                            ),
                          ),
                          GestureDetector(
                            onTap: _goToSearch,
                            child: Text(
                              'See all',
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: colors.seeAll,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          for (final recipe in recent) ...[
                            _RecentRow(
                              recipe: recipe,
                              colors: colors,
                              onTap: () => _openRecipe(recipe),
                            ),
                            if (recipe != recent.last) const SizedBox(height: 10),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          side: BorderSide(color: colors.inputBorder),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: _signingOut ? null : _signOut,
                        child: _signingOut
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: colors.muted),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(LucideIcons.logOut, size: 15, color: colors.muted),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Sign out',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: colors.muted,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BottomNav(
              active: BottomNavTab.profile,
              onTabSelected: (tab) {
                switch (tab) {
                  case BottomNavTab.home:
                    context.pop();
                    break;
                  case BottomNavTab.search:
                    _goToSearch();
                    break;
                  case BottomNavTab.saved:
                    _goToSaved();
                    break;
                  case BottomNavTab.profile:
                    break;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value, required this.colors, this.onTap});

  final String label;
  final String value;
  final LadleColors colors;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: colors.statsBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.statsBorder),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.w700, color: colors.heading),
            ),
            Text(
              label,
              style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w600, color: colors.meta),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentRow extends StatelessWidget {
  const _RecentRow({required this.recipe, required this.colors, required this.onTap});

  final Recipe recipe;
  final LadleColors colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.cardBorder),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: recipe.photo,
                width: 44,
                height: 44,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(width: 44, height: 44, color: colors.muted),
                errorWidget: (context, url, error) => Container(width: 44, height: 44, color: colors.muted),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: colors.heading,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text.rich(
                    TextSpan(
                      style: GoogleFonts.dmSans(fontSize: 10, color: colors.meta),
                      children: [
                        TextSpan(text: '${recipe.cat} · ${recipe.time} · '),
                        TextSpan(text: '★', style: TextStyle(color: colors.starFg)),
                        TextSpan(text: recipe.rating),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight, size: 14, color: colors.muted),
          ],
        ),
      ),
    );
  }
}
