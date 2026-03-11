import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/auth/providers/auth_provider.dart';
import 'features/mission/providers/mission_provider.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';

void main() {
  runApp(const HabitQuestApp());
}

class HabitQuestApp extends StatelessWidget {
  const HabitQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, MissionProvider>(
          create: (_) => MissionProvider(),
          update: (_, auth, missions) {
            // Wire callback: mission completion → auth XP/streak
            missions!.onMissionCompleted = (xpEarned) {
              auth.onMissionCompleted(xpEarned);
              auth.recordActivity();
            };
            return missions;
          },
        ),
      ],
      child: const _RouterApp(),
    );
  }
}

class _RouterApp extends StatefulWidget {
  const _RouterApp();

  @override
  State<_RouterApp> createState() => _RouterAppState();
}

class _RouterAppState extends State<_RouterApp> {
  late final _router = createRouter(context);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'HabitQuest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}
