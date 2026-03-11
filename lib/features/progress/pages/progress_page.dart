import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../../routes/app_router.dart';
import '../../auth/providers/auth_provider.dart';
import '../../mission/providers/mission_provider.dart';
import '../widgets/progress_mission_card.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final missionProvider = context.watch<MissionProvider>();
    final missions = missionProvider.missions;
    final completedCount = missionProvider.completedMissions.length;

    final totalDoneTasks =
        missions.fold(0, (sum, m) => sum + m.completedTasks);
    final streak = (completedCount * 2 + totalDoneTasks).clamp(0, 7);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _ProgressHeader()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _XpSummaryCard(
                    xp: user?.xp ?? 0,
                    level: user?.level ?? 1,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    AppStrings.missionProgress,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),
          missions.isEmpty
              ? const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Text(
                        'No missions yet.\nStart a mission from Home!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.greyText,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final mission = missions[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: ProgressMissionCard(
                            mission: mission,
                            onTap: () => context.push(
                              AppRoutes.missionProgressPath(mission.id),
                            ),
                          ),
                        );
                      },
                      childCount: missions.length,
                    ),
                  ),
                ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            sliver: SliverToBoxAdapter(
              child: _StreakCard(streak: streak),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 28),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 ${AppStrings.myProgress}',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            AppStrings.trackJourney,
            style: TextStyle(fontSize: 13, color: Color(0xCCFFFFFF)),
          ),
        ],
      ),
    );
  }
}

class _XpSummaryCard extends StatelessWidget {
  const _XpSummaryCard({required this.xp, required this.level});

  final int xp;
  final int level;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Color(0x1A6B63D4), blurRadius: 12),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.totalXp,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$xp',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: AppColors.coral,
                  ),
                ),
                const TextSpan(
                  text: ' XP',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.greyText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Level $level • Keep going! 🔥',
            style: const TextStyle(fontSize: 12, color: AppColors.greyText),
          ),
          const SizedBox(height: 12),
          AppProgressBar(value: xp.toDouble(), max: 1000, height: 10),
        ],
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF8B7FE8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🔥 ${AppStrings.currentStreak}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$streak',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: AppColors.white,
                  ),
                ),
                const TextSpan(
                  text: AppStrings.days,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xCCFFFFFF),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            AppStrings.keepGoing,
            style: TextStyle(fontSize: 12, color: Color(0xCCFFFFFF)),
          ),
        ],
      ),
    );
  }
}
