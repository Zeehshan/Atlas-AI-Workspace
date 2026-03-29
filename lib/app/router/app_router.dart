import 'package:faiapp/app/widgets/app_shell.dart';
import 'package:faiapp/core/config/app_config.dart';
import 'package:faiapp/features/auth/presentation/controllers/auth_controller.dart';
import 'package:faiapp/features/auth/presentation/screens/login_screen.dart';
import 'package:faiapp/features/settings/presentation/screens/settings_screen.dart';
import 'package:faiapp/features/splash/presentation/screens/splash_screen.dart';
import 'package:faiapp/features/workspace/presentation/screens/workspace_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);
  final config = ref.watch(appConfigProvider);

  return GoRouter(
    initialLocation: SplashScreen.routePath,
    debugLogDiagnostics: config.enableVerboseLogs,
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isBootstrapping = authState.isBootstrapping;
      final isAuthenticated = authState.isAuthenticated;

      if (isBootstrapping) {
        return location == SplashScreen.routePath
            ? null
            : SplashScreen.routePath;
      }

      if (!isAuthenticated) {
        return location == LoginScreen.routePath ? null : LoginScreen.routePath;
      }

      if (location == SplashScreen.routePath ||
          location == LoginScreen.routePath) {
        return WorkspaceScreen.routePath;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: SplashScreen.routePath,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: LoginScreen.routePath,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: WorkspaceScreen.routePath,
        builder: (context, state) => const AppShell(
          destination: AppDestination.workspace,
          child: WorkspaceScreen(),
        ),
      ),
      GoRoute(
        path: SettingsScreen.routePath,
        builder: (context, state) => const AppShell(
          destination: AppDestination.settings,
          child: SettingsScreen(),
        ),
      ),
    ],
  );
});
