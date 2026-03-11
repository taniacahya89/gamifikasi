import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../features/auth/pages/login_page.dart';
import '../features/auth/pages/signup_page.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/mission/pages/mission_detail_page.dart';
import '../features/mission/pages/create_mission_page.dart';
import '../features/mission/pages/mission_progress_detail_page.dart';
import '../features/profile/pages/edit_profile_page.dart';
import '../shell/main_shell.dart';
import '../splash/splash_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String createMission = '/create-mission';
  static const String editProfile = '/edit-profile';

  static String missionDetailPath(String id) => '/mission/$id';
  static String missionProgressPath(String id) => '/mission-progress/$id';
}

GoRouter createRouter(BuildContext context) {
  final authProvider = context.read<AuthProvider>();

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: authProvider,
    redirect: (context, state) {
      final isAuth = authProvider.isAuthenticated;
      final loc = state.matchedLocation;
      final isPublic = loc == AppRoutes.splash ||
          loc == AppRoutes.login ||
          loc == AppRoutes.signUp;
      if (!isAuth && !isPublic) return AppRoutes.login;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const SizedBox.shrink(),
          ),
          GoRoute(
            path: '/progress-tab',
            builder: (context, state) => const SizedBox.shrink(),
          ),
          GoRoute(
            path: '/profile-tab',
            builder: (context, state) => const SizedBox.shrink(),
          ),
        ],
      ),
      GoRoute(
        path: '/mission/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return MissionDetailPage(missionId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.createMission,
        builder: (context, state) {
          final preselected = state.extra as String?;
          return CreateMissionPage(preselectedCategory: preselected);
        },
      ),
      GoRoute(
        path: '/mission-progress/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return MissionProgressDetailPage(missionId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfilePage(),
      ),
    ],
  );
}
