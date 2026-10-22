import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'services/auth_service.dart';
import 'screens/catalog_screen.dart';
import 'screens/book_screen.dart';
import 'screens/reserve_screen.dart';
import 'screens/date_picker_screen.dart';
import 'screens/my_books_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/error_screen.dart';
import 'screens/scaffold_with_nav.dart';

/// Root navigator key (for routes above the shell, e.g. reserve).
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/catalog',
  refreshListenable: authService,
  debugLogDiagnostics: true,
  errorBuilder: (context, state) => ErrorScreen(error: state.error),
  redirect: (context, state) {
    final loggedIn = authService.isLoggedIn;
    final loc = state.matchedLocation;
    final fullPath = state.uri.toString();

    // Protect /reserve
    final isReserve = loc.contains('/reserve') && !loc.endsWith('/date');
    if (isReserve && !loggedIn) {
      return '/login?from=${Uri.encodeComponent(fullPath)}';
    }

    // Already logged in and on login → go to from or catalog
    if (loggedIn && loc == '/login') {
      final from = state.uri.queryParameters['from'];
      if (from != null && from.isNotEmpty) {
        return from;
      }
      return '/catalog';
    }

    return null;
  },
  routes: [
    // Login (outside shell)
    GoRoute(
      path: '/login',
      builder: (context, state) {
        final from = state.uri.queryParameters['from'];
        return LoginScreen(from: from);
      },
    ),

    // Main shell with 3 tabs
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // Tab 0: Catalog
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/catalog',
              builder: (context, state) {
                final genre = state.uri.queryParameters['genre'];
                return CatalogScreen(genre: genre);
              },
              routes: [
                GoRoute(
                  path: 'book/:bookId',
                  builder: (context, state) {
                    final bookId = state.pathParameters['bookId']!;
                    return BookScreen(bookId: bookId);
                  },
                  routes: [
                    // Reserve opens ABOVE the bottom bar
                    GoRoute(
                      path: 'reserve',
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (context, state) {
                        final bookId = state.pathParameters['bookId']!;
                        return ReserveScreen(bookId: bookId);
                      },
                      routes: [
                        GoRoute(
                          path: 'date',
                          parentNavigatorKey: rootNavigatorKey,
                          builder: (context, state) => const DatePickerScreen(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // Tab 1: My Books
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/my-books',
              builder: (context, state) => const MyBooksScreen(),
            ),
          ],
        ),

        // Tab 2: Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
