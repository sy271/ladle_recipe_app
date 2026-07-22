# Ladle — Flutter Recipe App

Flutter port of a Figma AI React export. The React source is reference material only, not something to run.

## Source of truth

- `docs/figma-export/App.tsx` — **the authoritative spec.** All 8 screens and 15 components live in this one file. The `t(dark)` function is the complete design token map.
- `docs/figma-export/style/theme.css` — supplementary tokens (has `--destructive` and chart colors that `t(dark)` lacks). If it conflicts with `t(dark)`, **`t(dark)` wins.**
- `docs/figma-export/style/fonts.css` — font families only.

Never port React code structurally. Extract colors, spacing, radii, and layout; design the Flutter structure fresh.

## Palette

Both themes come from `t(dark)` in `App.tsx`. Do not retype them here — read them from the source.

Light theme is "Deep Plum & Blush": primary `#5C3A4D`, background `#F7ECE9`, secondary `#C88B94`, heading text `#4B1528`, meta text `#993556`.

Dark theme is "Terracotta Night": background `#241E1A`, card `#33291F`, primary `#C67B4C`, body text `#F5EFE4`.

## Hard rules

1. **Never hardcode a color in a widget.** Always `Theme.of(context).extension<LadleColors>()!`.
2. **No `dark` boolean prop.** The React code threads `dark` through every component. Delete that pattern entirely — Flutter's theme system handles it.
3. **One widget per file.** No 800-line files.
4. Run `flutter analyze` after every change; keep it clean.
5. Use `const` constructors wherever possible.

## Fonts

Via `google_fonts`, no asset files.

- Headings: **Playfair Display**, weights 700 and 800, italic available
- Body: **DM Sans**, weights 400, 500, 600

## Icons

The React export uses `lucide-react` (25 icons). Use the `lucide_icons` Flutter package with matching names — `UtensilsCrossed` becomes `LucideIcons.utensilsCrossed`. Do not substitute Material icons.

## Project structure

```
lib/
  main.dart
  theme/
    ladle_colors.dart      ThemeExtension holding every t(dark) token
    app_theme.dart         light + dark ThemeData
  models/
    recipe.dart
    ingredient.dart
  data/
    sample_data.dart       dummy data ported from ALL_RECIPES
  screens/
    sign_in_screen.dart
    sign_up_screen.dart
    forgot_password_screen.dart
    home_screen.dart
    search_screen.dart
    recipe_detail_screen.dart
    saved_screen.dart
    profile_screen.dart
  widgets/
    recipe_card.dart
    category_chip.dart
    bottom_nav.dart
    ingredient_row.dart
    guided_cook_card.dart
  providers/
```

## Components to skip

These exist only for the Figma web preview and have no Flutter equivalent:

- `PhoneFrame` — device mockup chrome
- `StatusBar` — the real device provides this
- `GoogleIcon` — use an asset or the `sign_in_button` package
- Anything in `components/figma/` or `components/ui/` — confirmed unused by `App.tsx`

## Conversion mapping

| React / Tailwind | Flutter |
|---|---|
| `Screen` type + `navigate()` | `go_router` named routes |
| `savedIds` / `likedIds` state | Riverpod `StateNotifierProvider<Set<String>>` |
| `useRef` + `useEffect` timer | `Timer.periodic` in a `StatefulWidget` |
| Unsplash URLs | `cached_network_image` |
| `flex flex-col` / `flex-row` | `Column` / `Row` |
| `gap-3` | `spacing: 12` |
| `p-4` | `EdgeInsets.all(16)` |
| `px-4 py-2` | `EdgeInsets.symmetric(horizontal: 16, vertical: 8)` |
| `rounded-2xl` | `BorderRadius.circular(16)` |
| `overflow-x-auto` | `SingleChildScrollView(scrollDirection: Axis.horizontal)` |
| `.map()` over an array | `ListView.builder` |
| `absolute top-2 right-2` | `Stack` + `Positioned` |
| Props interface | Constructor params on a `StatelessWidget` |

Tailwind spacing scale: multiply by 4 for Flutter pixels. `p-4` is 16, `gap-3` is 12.

## Known bug in the export

In `ALL_RECIPES`, the "Summer Grain Bowl" entry has a quoted key: `cat: "Vegetarian","time": "20 min"`. Treat it as a normal `time` field.

## Dependencies

```yaml
dependencies:
  google_fonts: ^6.2.1
  lucide_icons: ^0.257.0
  cached_network_image: ^3.4.1
  go_router: ^14.0.0
  flutter_riverpod: ^2.5.1
```

## Build order

Work one step per prompt. Commit after each.

1. `theme/` — ThemeExtension and both ThemeData
2. `models/` and `data/` — dummy data, no backend yet
3. `widgets/` — reusable pieces
4. Screens, simplest first. `recipe_detail_screen.dart` last, it has the timer.
5. Navigation wiring
6. Firebase auth on the sign-in screen
7. Firestore, replacing dummy data

Do not attempt more than one step in a single response.
