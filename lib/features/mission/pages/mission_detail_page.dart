import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../providers/mission_provider.dart';
import '../widgets/mission_plan_card.dart';
import '../widgets/day_quest_card.dart';

class MissionDetailPage extends StatelessWidget {
  const MissionDetailPage({super.key, required this.missionId});

  final String missionId;

  @override
  Widget build(BuildContext context) {
    final mission =
        context.watch<MissionProvider>().getMissionById(missionId);

    if (mission == null) {
      return Scaffold(
        appBar: const CustomAppBar(title: AppStrings.missionDetail),
        body: const Center(child: Text('Mission not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const CustomAppBar(title: AppStrings.missionDetail),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.planForWeek,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  MissionPlanCard(mission: mission),
                  const SizedBox(height: 24),
                  const Text(
                    AppStrings.progressBar,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppProgressBar(
                    value: mission.completedTasks.toDouble(),
                    max: mission.totalTasks.toDouble(),
                    height: 24,
                    showLabel: true,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    AppStrings.dailyQuest,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...List.generate(mission.days.length, (dayIndex) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DayQuestCard(
                        day: mission.days[dayIndex],
                        dayIndex: dayIndex,
                        onToggleTask: (taskIndex) {
                          context.read<MissionProvider>().toggleTask(
                                missionId,
                                dayIndex,
                                taskIndex,
                              );
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
