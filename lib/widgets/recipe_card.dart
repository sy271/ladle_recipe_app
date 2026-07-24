import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../models/recipe.dart';
import '../theme/ladle_colors.dart';

/// Matches the React `size?: "sm" | "md"` prop on `RecipeCard`.
enum RecipeCardSize { sm, md }

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
    required this.isSaved,
    required this.onSave,
    required this.onTap,
    this.size = RecipeCardSize.md,
  });

  final Recipe recipe;
  final bool isSaved;
  final VoidCallback onSave;
  final VoidCallback onTap;
  final RecipeCardSize size;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<LadleColors>()!;
    final width = size == RecipeCardSize.sm ? 130.0 : 148.0;
    final imageHeight = size == RecipeCardSize.sm ? 88.0 : 100.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colors.cardBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: imageHeight,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: recipe.photo,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: colors.muted),
                    errorWidget: (context, url, error) => Container(
                      color: colors.muted,
                      child: Icon(LucideIcons.image, size: 20, color: colors.card),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onSave,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          // Photo scrim: hardcoded in the source for both
                          // themes (not a `t(dark)` token), so it stays fixed
                          // here too.
                          color: Colors.black.withValues(alpha: 0.35),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.bookmark,
                          size: 13,
                          color: isSaved ? colors.navActive : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
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
                      height: 1.1,
                      color: colors.heading,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text.rich(
                    TextSpan(
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: colors.meta,
                      ),
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
          ],
        ),
      ),
    );
  }
}
