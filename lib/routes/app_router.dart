import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../views/dashboard_view.dart';
import '../views/endpoint_detail_view.dart';
import '../views/endpoint_list_view.dart';
import '../views/not_found_view.dart';

/// Nombres de rutas usados con `context.pushNamed` / `goNamed`.
class RouteNames {
  RouteNames._();

  static const String dashboard = 'dashboard';
  static const String list = 'list';
  static const String detail = 'detail';
}

/// Configuración central de navegación con `go_router`.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: kDebugMode,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: RouteNames.dashboard,
      builder: (_, _) => const DashboardView(),
    ),
    GoRoute(
      path: '/catalog/:endpoint',
      name: RouteNames.list,
      builder: (_, GoRouterState state) => EndpointListView(
        endpointRoute: state.pathParameters['endpoint'] ?? '',
      ),
      routes: <RouteBase>[
        GoRoute(
          path: ':id',
          name: RouteNames.detail,
          builder: (_, GoRouterState state) => EndpointDetailView(
            endpointRoute: state.pathParameters['endpoint'] ?? '',
            id: int.tryParse(state.pathParameters['id'] ?? ''),
            extra: state.extra,
          ),
        ),
      ],
    ),
  ],
  errorBuilder: (_, GoRouterState state) =>
      NotFoundView(message: state.error?.toString()),
);
