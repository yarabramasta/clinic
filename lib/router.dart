import 'package:clinic/screens/account_settings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'screens/account.dart';
import 'screens/histories.dart';
import 'screens/home.dart';
import 'screens/onboarding.dart';
import 'screens/signin.dart';
import 'screens/signup.dart';
import 'screens/verification.dart';
import 'widgets/app_layout.dart';
import 'widgets/auth/auth_guard.dart';

part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _historiesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _accountNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'account');

@riverpod
GoRouter router(RouterRef ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: AuthGuard(),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) => const MaterialPage(
          child: OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/signin',
        pageBuilder: (context, state) => const MaterialPage(
          child: SignInScreen(),
        ),
      ),
      GoRoute(
        path: '/signup',
        pageBuilder: (context, state) => const MaterialPage(
          child: SignUpScreen(),
        ),
      ),
      GoRoute(
        path: '/verification',
        pageBuilder: (context, state) => const MaterialPage(
          child: VerificationScreen(),
        ),
      ),
      StatefulShellRoute(
        builder: (context, state, navigationShell) => navigationShell,
        navigatorContainerBuilder: (context, navigationShell, children) {
          return AppLayout(
            navigationShell: navigationShell,
            children: children,
          );
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _historiesNavigatorKey,
            routes: [
              GoRoute(
                path: '/histories',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HistoriesScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _accountNavigatorKey,
            routes: [
              GoRoute(
                path: '/account',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: AccountScreen(),
                ),
              )
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/account/settings',
        pageBuilder: (context, state) => const MaterialPage(
          child: AccountSettingsScreen(),
        ),
      ),
    ],
  );
}
