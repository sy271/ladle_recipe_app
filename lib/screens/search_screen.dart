import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../data/sample_data.dart';
import '../providers/saved_recipes_provider.dart';
import '../theme/ladle_colors.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/category_chip.dart';
import '../widgets/recipe_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _queryController = TextEditingController();
  String _query = '';
  String _selectedCategory = 'All';

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _openRecipe(String recipeId) {
    context.push('/recipe/$recipeId');
  }

  void _goToProfile() {
    context.push('/profile');
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<LadleColors>()!;
    final savedIds = ref.watch(savedRecipesProvider);
    final cats = ['All', ...categories.take(6)];
    final query = _query.toLowerCase();
    final results = allRecipes.where((recipe) {
      final matchesQuery =
          query.isEmpty ||
          recipe.name.toLowerCase().contains(query) ||
          recipe.cat.toLowerCase().contains(query);
      final matchesCategory = _selectedCategory == 'All' || recipe.cat == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();

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
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: colors.inputBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: colors.inputBorder),
                        ),
                        child: Row(
                          children: [
                            Icon(LucideIcons.search, size: 16, color: colors.meta),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _queryController,
                                autofocus: true,
                                style: GoogleFonts.dmSans(fontSize: 14, color: colors.inputFg),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  hintText: 'Search recipes, ingredients…',
                                  hintStyle: GoogleFonts.dmSans(fontSize: 14, color: colors.muted),
                                ),
                                onChanged: (value) => setState(() => _query = value),
                              ),
                            ),
                            if (_query.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  _queryController.clear();
                                  setState(() => _query = '');
                                },
                                child: Icon(LucideIcons.x, size: 15, color: colors.muted),
                              ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: cats.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final category = cats[index];
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
                      child: Text(
                        '${results.length} recipe${results.length != 1 ? 's' : ''}',
                        style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600, color: colors.muted),
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (results.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              const Text('🍳', style: TextStyle(fontSize: 32)),
                              const SizedBox(height: 8),
                              Text(
                                'No recipes found',
                                style: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: colors.heading,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Try a different search',
                                style: GoogleFonts.dmSans(fontSize: 12, color: colors.muted),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            for (final recipe in results)
                              RecipeCard(
                                recipe: recipe,
                                size: RecipeCardSize.sm,
                                isSaved: savedIds.contains(recipe.id),
                                onSave: () => ref.read(savedRecipesProvider.notifier).toggle(recipe.id),
                                onTap: () => _openRecipe(recipe.id),
                              ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            BottomNav(
              active: BottomNavTab.search,
              onTabSelected: (tab) {
                switch (tab) {
                  case BottomNavTab.home:
                    context.go('/home');
                    break;
                  case BottomNavTab.search:
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
