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
import '../widgets/category_chip.dart';
import '../widgets/recipe_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _authService = AuthService();
  String _selectedCategory = categories.first;

  String get _greetingName {
    final user = _authService.currentUser;
    final displayName = user?.displayName;
    if (displayName != null && displayName.trim().isNotEmpty) {
      return displayName.trim();
    }
    final email = user?.email;
    if (email != null && email.contains('@')) {
      return email.split('@').first;
    }
    return 'there';
  }

  String get _avatarInitial {
    final displayName = _authService.currentUser?.displayName;
    final name = (displayName != null && displayName.trim().isNotEmpty) ? displayName.trim() : 'Maya Chen';
    return name[0].toUpperCase();
  }

  void _openRecipe(Recipe recipe) {
    context.push('/recipe/${recipe.id}');
  }

  void _goToSearch() {
    context.go('/search');
  }

  void _goToProfile() {
    context.push('/profile');
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<LadleColors>()!;

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
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good evening,',
                                style: GoogleFonts.dmSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: colors.meta,
                                ),
                              ),
                              Text(
                                'Hey $_greetingName 👋',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                  color: colors.heading,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              _CircleIconButton(
                                icon: LucideIcons.search,
                                colors: colors,
                                onTap: _goToSearch,
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: _goToProfile,
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: colors.avatar,
                                  child: Text(
                                    _avatarInitial,
                                    style: GoogleFonts.dmSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: colors.avatarFg,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: _goToSearch,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: colors.inputBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: colors.inputBorder),
                          ),
                          child: Row(
                            children: [
                              Icon(LucideIcons.search, size: 16, color: colors.muted),
                              const SizedBox(width: 12),
                              Text(
                                "What's in your fridge?",
                                style: GoogleFonts.dmSans(fontSize: 14, color: colors.muted),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return CategoryChip(
                            label: category,
                            selected: category == _selectedCategory,
                            onTap: () => setState(() => _selectedCategory = category),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tonight's picks",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 16,
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
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 196,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: picks.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final recipe = picks[index];
                          final savedIds = ref.watch(savedRecipesProvider);
                          return RecipeCard(
                            recipe: recipe,
                            isSaved: savedIds.contains(recipe.id),
                            onSave: () => ref.read(savedRecipesProvider.notifier).toggle(recipe.id),
                            onTap: () => _openRecipe(recipe),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: _goToSearch,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color: colors.bannerBg,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Cook with what you have',
                                      style: GoogleFonts.playfairDisplay(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Search by ingredients →',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: colors.bannerAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: colors.bannerAccent.withValues(alpha: 0.13),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(LucideIcons.arrowRight, size: 16, color: colors.bannerAccent),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recommended',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 16,
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
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          for (final recipe in recommended) ...[
                            _RecommendedRow(
                              recipe: recipe,
                              isLiked: ref.watch(likedRecipesProvider).contains(recipe.id),
                              onToggleLike: () => ref.read(likedRecipesProvider.notifier).toggle(recipe.id),
                              onTap: () => _openRecipe(recipe),
                              colors: colors,
                            ),
                            if (recipe != recommended.last) const SizedBox(height: 12),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            BottomNav(
              active: BottomNavTab.home,
              onTabSelected: (tab) {
                switch (tab) {
                  case BottomNavTab.home:
                    break;
                  case BottomNavTab.search:
                    _goToSearch();
                    break;
                  case BottomNavTab.saved:
                    context.go('/saved');
                    break;
                  case BottomNavTab.profile:
                    _goToProfile();
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

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.colors, required this.onTap});

  final IconData icon;
  final LadleColors colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.inputBg,
          border: Border.all(color: colors.border),
        ),
        child: Icon(icon, size: 16, color: colors.meta),
      ),
    );
  }
}

class _RecommendedRow extends StatelessWidget {
  const _RecommendedRow({
    required this.recipe,
    required this.isLiked,
    required this.onToggleLike,
    required this.onTap,
    required this.colors,
  });

  final Recipe recipe;
  final bool isLiked;
  final VoidCallback onToggleLike;
  final VoidCallback onTap;
  final LadleColors colors;

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
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(width: 56, height: 56, color: colors.muted),
                errorWidget: (context, url, error) => Container(width: 56, height: 56, color: colors.muted),
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
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: colors.heading,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text.rich(
                    TextSpan(
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: colors.meta,
                      ),
                      children: [
                        TextSpan(text: '${recipe.cat} · ${recipe.time} · ${recipe.by} · '),
                        TextSpan(text: '★', style: TextStyle(color: colors.starFg)),
                        TextSpan(text: recipe.rating),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onToggleLike,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  LucideIcons.heart,
                  size: 18,
                  color: isLiked ? colors.heartFill : colors.muted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
