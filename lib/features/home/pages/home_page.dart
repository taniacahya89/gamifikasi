import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../routes/app_router.dart';
import '../../auth/providers/auth_provider.dart';
import '../../mission/providers/mission_provider.dart';
import '../widgets/home_header.dart';
import '../widgets/category_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final missionProvider = context.watch<MissionProvider>();

    if (user == null) return const SizedBox.shrink();

    // Categories that have ≥1 completed mission
    final completedCategories = missionProvider.completedMissions
        .map((m) => m.category)
        .toSet();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: HomeHeader(user: user)),
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
            sliver: SliverToBoxAdapter(
              child: Text(
                AppStrings.dailyActivity,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final cat = appCategories[index];
                  final hasCompleted =
                      completedCategories.contains(cat.id);
                  return CategoryCard(
                    data: cat,
                    hasCompletedMission: hasCompleted,
                    // Always navigate to mission list
                    onTap: () => context
                        .push(AppRoutes.missionListPath(cat.id)),
                  );
                },
                childCount: appCategories.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.9,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
