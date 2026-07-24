import '../models/ingredient.dart';
import '../models/recipe.dart';

/// Ported from `PHOTOS` in docs/figma-export/App.tsx.
class _Photos {
  static const ragu =
      'https://images.unsplash.com/photo-1611270629569-8b357cb88da9?w=400&h=280&fit=crop&auto=format';
  static const raguHero =
      'https://images.unsplash.com/photo-1600803907087-f56d462fd26b?w=800&h=500&fit=crop&auto=format';
  static const slaw =
      'https://images.unsplash.com/photo-1573403707491-38a4ea19edc1?w=400&h=280&fit=crop&auto=format';
  static const pancakes =
      'https://images.unsplash.com/photo-1612182062633-9ff3b3598e96?w=400&h=280&fit=crop&auto=format';
  static const miso =
      'https://images.unsplash.com/photo-1763470260582-894ae15f43bb?w=400&h=280&fit=crop&auto=format';
  static const chocTart =
      'https://images.unsplash.com/photo-1616031037011-087000171abe?w=400&h=280&fit=crop&auto=format';
  static const shakshuka =
      'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=300&h=300&fit=crop&auto=format';
  static const tomSoup =
      'https://images.unsplash.com/photo-1547592180-85f173990554?w=300&h=300&fit=crop&auto=format';
  static const chicken =
      'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=300&h=300&fit=crop&auto=format';
  static const bowl =
      'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300&h=300&fit=crop&auto=format';
  static const avocado =
      'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=300&h=300&fit=crop&auto=format';
}

const _ragu = Recipe(
  id: 'ragu',
  name: 'Weeknight Ragu',
  cat: 'Main',
  time: '45 min',
  rating: '4.8',
  photo: _Photos.ragu,
  heroPhoto: _Photos.raguHero,
  serves: '4',
  by: '@theladle',
);
const _slaw = Recipe(
  id: 'slaw',
  name: 'Citrus Slaw',
  cat: 'Side',
  time: '15 min',
  rating: '4.5',
  photo: _Photos.slaw,
  heroPhoto: _Photos.slaw,
  serves: '4',
  by: '@freshbowl',
);
const _pancakes = Recipe(
  id: 'pancakes',
  name: 'Berry Pancakes',
  cat: 'Breakfast',
  time: '20 min',
  rating: '4.9',
  photo: _Photos.pancakes,
  heroPhoto: _Photos.pancakes,
  serves: '2',
  by: '@morningkitchen',
);
const _miso = Recipe(
  id: 'miso',
  name: 'Miso Soup',
  cat: 'Soup',
  time: '10 min',
  rating: '4.6',
  photo: _Photos.miso,
  heroPhoto: _Photos.miso,
  serves: '2',
  by: '@notethanun',
);
const _tart = Recipe(
  id: 'tart',
  name: 'Choc Tart',
  cat: 'Dessert',
  time: '60 min',
  rating: '4.7',
  photo: _Photos.chocTart,
  heroPhoto: _Photos.chocTart,
  serves: '8',
  by: '@sweettable',
);
const _shakshuka = Recipe(
  id: 'shakshuka',
  name: 'Golden Shakshuka',
  cat: 'Breakfast',
  time: '25 min',
  rating: '4.7',
  photo: _Photos.shakshuka,
  heroPhoto: _Photos.shakshuka,
  serves: '2',
  by: '@nourish',
);
const _tomsoup = Recipe(
  id: 'tomsoup',
  name: 'Roasted Tomato Soup',
  cat: 'Soup',
  time: '35 min',
  rating: '4.6',
  photo: _Photos.tomSoup,
  heroPhoto: _Photos.tomSoup,
  serves: '4',
  by: '@warmkitchen',
);
const _chicken = Recipe(
  id: 'chicken',
  name: 'Lemon Olive Chicken',
  cat: 'Main',
  time: '55 min',
  rating: '4.9',
  photo: _Photos.chicken,
  heroPhoto: _Photos.chicken,
  serves: '4',
  by: '@theladle',
);
// Note: source has a quoted-key bug (`cat: "Vegetarian","time": "20 min"`)
// in this entry; `time` is treated as a normal field.
const _bowl = Recipe(
  id: 'bowl',
  name: 'Summer Grain Bowl',
  cat: 'Vegetarian',
  time: '20 min',
  rating: '4.8',
  photo: _Photos.bowl,
  heroPhoto: _Photos.bowl,
  serves: '2',
  by: '@greenbite',
);
const _avo = Recipe(
  id: 'avo',
  name: 'Avocado Toast',
  cat: 'Breakfast',
  time: '10 min',
  rating: '4.5',
  photo: _Photos.avocado,
  heroPhoto: _Photos.avocado,
  serves: '1',
  by: '@brunchclub',
);

/// Ported from `ALL_RECIPES` in docs/figma-export/App.tsx.
const List<Recipe> allRecipes = [
  _ragu,
  _slaw,
  _pancakes,
  _miso,
  _tart,
  _shakshuka,
  _tomsoup,
  _chicken,
  _bowl,
  _avo,
];

/// `PICKS = ALL_RECIPES.slice(0, 5)`
const List<Recipe> picks = [_ragu, _slaw, _pancakes, _miso, _tart];

/// `RECOMMENDED = ALL_RECIPES.slice(5, 8)`
const List<Recipe> recommended = [_shakshuka, _tomsoup, _chicken];

/// Ported from `CATEGORIES` in docs/figma-export/App.tsx.
const List<String> categories = [
  'Main course',
  'Side',
  'Beverage',
  'Breakfast',
  'Dessert',
  'Soup',
  'Salad',
  'Snack',
  'Vegetarian',
];

/// Ported from `INGREDIENTS` in docs/figma-export/App.tsx.
const List<Ingredient> ingredients = [
  Ingredient(name: 'Beef mince', amount: '500g'),
  Ingredient(name: 'Passata', amount: '700ml'),
  Ingredient(name: 'Pancetta', amount: '120g'),
  Ingredient(name: 'Soffritto mix', amount: '1 cup'),
  Ingredient(name: 'Red wine', amount: '150ml'),
  Ingredient(name: 'Garlic cloves', amount: '4'),
  Ingredient(name: 'Bay leaves', amount: '2'),
  Ingredient(name: 'Olive oil', amount: '2 tbsp'),
  Ingredient(name: 'Salt & pepper', amount: 'to taste'),
];
