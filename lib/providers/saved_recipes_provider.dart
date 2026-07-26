import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shared across Home/Search/Detail/Saved/Profile so bookmarking a recipe on
/// one screen shows up on all the others.
class SavedRecipesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {'pancakes', 'ragu'};

  void toggle(String recipeId) {
    final next = {...state};
    if (!next.remove(recipeId)) {
      next.add(recipeId);
    }
    state = next;
  }

  bool isSaved(String recipeId) => state.contains(recipeId);
}

final savedRecipesProvider = NotifierProvider<SavedRecipesNotifier, Set<String>>(
  SavedRecipesNotifier.new,
);
