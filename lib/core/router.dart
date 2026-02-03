import 'package:ai_travel_planner/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/day_plan.dart';
import '../models/explore_template.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/explore_screen.dart';
import '../screens/library_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/plan_details_screen.dart';
import '../widgets/main_scaffold.dart';
import '../screens/еxplore_plan_details_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final _homeNavKey = GlobalKey<NavigatorState>(debugLabel: 'homeTab');
final _exploreNavKey = GlobalKey<NavigatorState>(debugLabel: 'exploreTab');
final _libraryNavKey = GlobalKey<NavigatorState>(debugLabel: 'libraryTab');
final _profileNavKey = GlobalKey<NavigatorState>(debugLabel: 'profileTab');

GoRouter createRouter(AuthProvider auth) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',

    refreshListenable: auth,

    redirect: (context, state) {
      final loggedIn = auth.isLoggedIn;
      final path = state.uri.path;

      final isAuthRoute = path == '/login' || path == '/register';

      if (!loggedIn && !isAuthRoute) return '/login';
      if (loggedIn && isAuthRoute) return '/home';

      return null;
    },

    routes: [
      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RegisterScreen(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavKey,
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _exploreNavKey,
            routes: [
              GoRoute(
                path: '/explore',
                builder: (context, state) => const ExploreScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _libraryNavKey,
            routes: [
              GoRoute(
                path: '/library',
                builder: (context, state) => const LibraryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _profileNavKey,
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: '/plan-details',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final plan = state.extra as DayPlan?;
          return PlanDetailsScreen(existingPlan: plan);
        },
      ),
      GoRoute(
        path: '/explore-plan',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final t = state.extra as ExploreTemplate;
          return ExplorePlanDetailsScreen(template: t);
        },
      ),
      GoRoute(
        path: '/my-plans',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LibraryScreen(),
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          return const SettingsScreen();
        },
      ),
    ],
  );
}