import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/library/library_screen.dart';
import '../../features/book_detail/book_detail_screen.dart';
import '../../features/scanner/scanner_screen.dart';
import '../../features/statistics/statistics_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../shared/widgets/sidebar_layout.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/library',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return SidebarLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/library',
            pageBuilder: (context, state) => _buildPageTransition(
              child: const LibraryScreen(),
              key: state.pageKey,
            ),
            routes: [
              GoRoute(
                path: 'book/:id',
                parentNavigatorKey: _rootNavigatorKey, // Covers the sidebar
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return _buildPageTransition(
                    child: BookDetailScreen(bookId: id),
                    key: state.pageKey,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/statistics',
            pageBuilder: (context, state) => _buildPageTransition(
              child: const StatisticsScreen(),
              key: state.pageKey,
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => _buildPageTransition(
              child: const SettingsScreen(),
              key: state.pageKey,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/scanner',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => _buildPageTransition(
          child: const ScannerScreen(),
          key: state.pageKey,
        ),
      ),
    ],
  );
}

CustomTransitionPage _buildPageTransition({required Widget child, required LocalKey key}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 0.05); // 20px vertical slide roughly mapped to fraction
      const end = Offset.zero;
      const curve = Curves.easeOutCubic;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: offsetAnimation,
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}
