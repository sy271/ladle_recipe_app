import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../data/sample_data.dart';
import '../models/recipe.dart';
import '../providers/liked_recipes_provider.dart';
import '../theme/ladle_colors.dart';

class FavouritesScreen extends ConsumerWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<LadleColors>()!;
    final likedIds = ref.watch(likedRecipesProvider);
    final liked = allRecipes.where((r) => likedIds.contains(r.id)).toList();

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 8),
              child: Row(
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
                    'Favourites',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: colors.heading,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.inputBg,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${liked.length} recipes',
                      style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600, color: colors.meta),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: liked.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('❤️', style: TextStyle(fontSize: 40)),
                            const SizedBox(height: 12),
                            Text(
                              'No favourites yet',
                              style: GoogleFonts.dmSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: colors.heading,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap the heart icon on any recipe to add it here.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dmSans(fontSize: 13, color: colors.muted),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.primary,
                                foregroundColor: colors.primaryFg,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                shape: const StadiumBorder(),
                                elevation: 0,
                              ),
                              onPressed: () => context.go('/home'),
                              child: Text(
                                'Browse recipes',
                                style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                      child: Column(
                        children: [
                          for (final recipe in liked) ...[
                            _FavouriteRow(
                              recipe: recipe,
                              colors: colors,
                              onTap: () => context.push('/recipe/${recipe.id}'),
                              onUnlike: () => ref.read(likedRecipesProvider.notifier).toggle(recipe.id),
                            ),
                            if (recipe != liked.last) const SizedBox(height: 12),
                          ],
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavouriteRow extends StatelessWidget {
  const _FavouriteRow({
    required this.recipe,
    required this.colors,
    required this.onTap,
    required this.onUnlike,
  });

  final Recipe recipe;
  final LadleColors colors;
  final VoidCallback onTap;
  final VoidCallback onUnlike;

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
                      style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w500, color: colors.meta),
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
            GestureDetector(
              onTap: onUnlike,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(LucideIcons.heart, size: 18, color: colors.heartFill),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
