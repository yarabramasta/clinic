// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dash_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $dashboardRoute,
    ];

RouteBase get $dashboardRoute => StatefulShellRouteData.$route(
      restorationScopeId: DashboardRoute.$restorationScopeId,
      navigatorContainerBuilder: DashboardRoute.$navigatorContainerBuilder,
      factory: $DashboardRouteExtension._fromState,
      branches: [
        StatefulShellBranchData.$branch(
          restorationScopeId: HomeBranch.$restorationScopeId,
          routes: [
            GoRouteData.$route(
              path: '/app/home',
              factory: $HomeRouteExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          restorationScopeId: AppointmentsBranch.$restorationScopeId,
          routes: [
            GoRouteData.$route(
              path: '/app/appointment',
              factory: $AppointmentsRouteExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          restorationScopeId: AccountBranch.$restorationScopeId,
          routes: [
            GoRouteData.$route(
              path: '/app/account',
              factory: $AccountRouteExtension._fromState,
            ),
          ],
        ),
      ],
    );

extension $DashboardRouteExtension on DashboardRoute {
  static DashboardRoute _fromState(GoRouterState state) =>
      const DashboardRoute();
}

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  String get location => GoRouteData.$location(
        '/app/home',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AppointmentsRouteExtension on AppointmentsRoute {
  static AppointmentsRoute _fromState(GoRouterState state) =>
      const AppointmentsRoute();

  String get location => GoRouteData.$location(
        '/app/appointment',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AccountRouteExtension on AccountRoute {
  static AccountRoute _fromState(GoRouterState state) => const AccountRoute();

  String get location => GoRouteData.$location(
        '/app/account',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
