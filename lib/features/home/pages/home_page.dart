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

    final completedCategories =
        missionProvider.completedMissions.map((m) => m.category).toSet();

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.createMission),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          AppStrings.createMission,
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: HomeHeader(user: user)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            sliver: SliverToBoxAdapter(
              child: Text(
                AppStrings.dailyActivity,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final cat = appCategories[index];
                  final isCompleted = completedCategories.contains(cat.id);
                  final missions =
                      missionProvider.getMissionsByCategory(cat.id);
                  final mission =
                      missions.isNotEmpty ? missions.first : null;

                  return CategoryCard(
                    data: cat,
                    isCompleted: isCompleted,
                    onTap: () {
                      if (mission != null) {
                        context.push(AppRoutes.missionDetailPath(mission.id));
                      } else {
                        context.push(
                          AppRoutes.createMission,
                          extra: cat.id,
                        );
                      }
                    },
                  );
                },
                childCount: appCategories.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
