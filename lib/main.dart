import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';
import 'providers/theme_mode_provider.dart';
import 'screens/favourites_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/recipe_detail_screen.dart';
import 'screens/saved_screen.dart';
import 'screens/search_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'services/auth_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AuthService.initialize();
  runApp(const ProviderScope(child: MyApp()));
}

const _authRoutes = {'/', '/sign-up', '/forgot-password'};

final _authService = AuthService();

final _router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final loggedIn = _authService.currentUser != null;
    if (loggedIn && _authRoutes.contains(state.matchedLocation)) {
      return '/home';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SignInScreen()),
    GoRoute(path: '/sign-up', builder: (context, state) => const SignUpScreen()),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
    GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
    GoRoute(path: '/saved', builder: (context, state) => const SavedScreen()),
    GoRoute(path: '/favourites', builder: (context, state) => const FavouritesScreen()),
    GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
    GoRoute(
      path: '/recipe/:id',
      builder: (context, state) => RecipeDetailScreen(recipeId: state.pathParameters['id']!),
    ),
  ],
);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Ladle',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(themeModeProvider),
      routerConfig: _router,
    );
  }
}
