import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/sample_data.dart';
import '../providers/saved_recipes_provider.dart';
import '../theme/ladle_colors.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/recipe_card.dart';

class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<LadleColors>()!;
    final savedIds = ref.watch(savedRecipesProvider);
    final saved = allRecipes.where((r) => savedIds.contains(r.id)).toList();

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Saved',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: colors.heading,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.inputBg,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${saved.length} recipes',
                      style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600, color: colors.meta),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: saved.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🔖', style: TextStyle(fontSize: 40)),
                            const SizedBox(height: 12),
                            Text(
                              'Nothing saved yet',
                              style: GoogleFonts.dmSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: colors.heading,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap the bookmark icon on any recipe to save it here.',
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
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          for (final recipe in saved)
                            RecipeCard(
                              recipe: recipe,
                              size: RecipeCardSize.sm,
                              isSaved: true,
                              onSave: () => ref.read(savedRecipesProvider.notifier).toggle(recipe.id),
                              onTap: () => context.push('/recipe/${recipe.id}'),
                            ),
                        ],
                      ),
                    ),
            ),
            BottomNav(
              active: BottomNavTab.saved,
              onTabSelected: (tab) {
                switch (tab) {
                  case BottomNavTab.home:
                    context.go('/home');
                    break;
                  case BottomNavTab.search:
                    context.go('/search');
                    break;
                  case BottomNavTab.saved:
                    break;
                  case BottomNavTab.profile:
                    context.push('/profile');
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
