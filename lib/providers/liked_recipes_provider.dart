import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shared across Home/Favourites so hearting a recipe on one screen shows up
/// on the other. Separate concept from [savedRecipesProvider]'s bookmarks.
class LikedRecipesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggle(String recipeId) {
    final next = {...state};
    if (!next.remove(recipeId)) {
      next.add(recipeId);
    }
    state = next;
  }
}

final likedRecipesProvider = NotifierProvider<LikedRecipesNotifier, Set<String>>(
  LikedRecipesNotifier.new,
);
