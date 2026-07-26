import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../data/sample_data.dart';
import '../providers/saved_recipes_provider.dart';
import '../theme/ladle_colors.dart';

class RecipeDetailScreen extends ConsumerStatefulWidget {
  const RecipeDetailScreen({super.key, required this.recipeId});

  final String recipeId;

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  bool _showAllIngredients = false;
  bool _addedToList = false;
  bool _timerOn = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<LadleColors>()!;
    final recipe = allRecipes.firstWhere(
      (r) => r.id == widget.recipeId,
      orElse: () => allRecipes.first,
    );
    final isSaved = ref.watch(savedRecipesProvider).contains(recipe.id);
    final visibleIngredients = _showAllIngredients ? ingredients : ingredients.take(3).toList();

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 210,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: recipe.heroPhoto,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: colors.muted),
                      errorWidget: (context, url, error) => Container(color: colors.muted),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0x66000000), Colors.transparent],
                          stops: [0.0, 0.55],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 16,
                      right: 16,
                      child: SafeArea(
                        bottom: false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => context.pop(),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  color: Color(0x66000000),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(LucideIcons.chevronLeft, size: 18, color: Colors.white),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => ref.read(savedRecipesProvider.notifier).toggle(recipe.id),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  color: Color(0x66000000),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  LucideIcons.bookmark,
                                  size: 15,
                                  color: isSaved ? colors.primary : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            recipe.name,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                              color: colors.heading,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Icon(LucideIcons.star, size: 14, color: colors.starFg),
                              const SizedBox(width: 4),
                              Text(
                                recipe.rating,
                                style: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: colors.starFg,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _Pill(icon: LucideIcons.clock, label: recipe.time, colors: colors),
                        _Pill(icon: LucideIcons.users, label: 'Serves ${recipe.serves}', colors: colors),
                        _Pill(icon: null, label: recipe.cat, colors: colors),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colors.cardBorder),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: colors.divider)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ingredients · ${ingredients.length}',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: colors.heading,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => setState(() => _addedToList = !_addedToList),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _addedToList ? colors.primary : colors.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          LucideIcons.shoppingBag,
                                          size: 11,
                                          color: _addedToList ? colors.primaryFg : colors.primary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          _addedToList ? '✓ Added' : '+ Add all to list',
                                          style: GoogleFonts.dmSans(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: _addedToList ? colors.primaryFg : colors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          for (var i = 0; i < visibleIngredients.length; i++)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                border: i < visibleIngredients.length - 1
                                    ? Border(bottom: BorderSide(color: colors.divider))
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    visibleIngredients[i].name,
                                    style: GoogleFonts.dmSans(fontSize: 13, color: colors.body),
                                  ),
                                  Text(
                                    visibleIngredients[i].amount,
                                    style: GoogleFonts.dmSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: colors.meta,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          GestureDetector(
                            onTap: () => setState(() => _showAllIngredients = !_showAllIngredients),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                border: Border(top: BorderSide(color: colors.divider)),
                              ),
                              child: Text(
                                _showAllIngredients
                                    ? 'Show less ↑'
                                    : 'See all ${ingredients.length} ingredients ↓',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: colors.meta,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.guidedBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'GUIDED COOK',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1,
                                      color: colors.guidedFg.withValues(alpha: 0.6),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Step 4 of 7',
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: colors.guidedFg,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: colors.timerBg,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(LucideIcons.timer, size: 13, color: colors.timerFg),
                                    const SizedBox(width: 6),
                                    Text(
                                      '30:00',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: colors.timerFg,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Simmer low and slow — 30 minutes, stir twice.',
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              height: 1.3,
                              color: colors.guidedFg.withValues(alpha: 0.9),
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () => setState(() => _timerOn = !_timerOn),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: colors.guidedFg,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _timerOn ? LucideIcons.pause : LucideIcons.play,
                                    size: 13,
                                    color: colors.guidedBg,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _timerOn ? 'Pause timer' : 'Start timer ▶',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: colors.guidedBg,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.reviewBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colors.cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: colors.avatar,
                                child: Text(
                                  'S',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: colors.avatarFg,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sam T.',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: colors.heading,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        for (var i = 0; i < 5; i++)
                                          Icon(LucideIcons.star, size: 10, color: colors.starFg),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: recipe.photo,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(width: 40, height: 40, color: colors.muted),
                                  errorWidget: (context, url, error) =>
                                      Container(width: 40, height: 40, color: colors.muted),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '"Rich and easy — attached a photo of my plate."',
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              height: 1.3,
                              color: colors.body.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
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

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label, required this.colors});

  final IconData? icon;
  final String label;
  final LadleColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colors.pill,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.pillBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: colors.pillFg),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600, color: colors.pillFg),
          ),
        ],
      ),
    );
  }
}
