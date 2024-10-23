import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/tasks/presentation/pages/create_task_page.dart';
import '../../features/tasks/presentation/pages/dashboard_page.dart';
import '../../features/tasks/presentation/pages/task_details_page.dart';
import '../../shared/pages/page_not_found.dart';
import 'route_guards.dart';
import 'router_refresh_stream.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    refreshListenable: GoRouterRefreshStream(RouteGuards.authStateChanges()),
    redirect: (context, state) =>
        RouteGuards.authGuard(context, state.uri.path),
    routes: [
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/create-task',
        name: 'create-task',
        builder: (context, state) => const CreateTaskPage(),
      ),
      GoRoute(
        path: '/task/:taskId',
        name: 'task-details',
        builder: (context, state) {
          final taskId = state.pathParameters['taskId']!;
          return TaskDetailsPage(taskId: taskId);
        },
      ),
    ],
    errorBuilder: (context, state) => const PageNotFound(),
  );
});
