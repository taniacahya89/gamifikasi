import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/mission_provider.dart';
import '../widgets/mission_plan_card.dart';
import '../widgets/day_quest_card.dart';
import '../../../core/widgets/level_up_overlay.dart';

class MissionDetailPage extends StatefulWidget {
  const MissionDetailPage({super.key, required this.missionId});

  final String missionId;

  @override
  State<MissionDetailPage> createState() => _MissionDetailPageState();
}

class _MissionDetailPageState extends State<MissionDetailPage> {
  bool _showingLevelUp = false;

  void _onToggleTask(int dayIndex, int taskIndex) {
    final missionProvider = context.read<MissionProvider>();
    final authProvider = context.read<AuthProvider>();

    // toggleTask returns true if mission just completed
    missionProvider.toggleTask(widget.missionId, dayIndex, taskIndex);

    // Record activity for streak
    authProvider.recordActivity();

    // Check if level-up happened
    if (authProvider.justLeveledUp && !_showingLevelUp) {
      setState(() => _showingLevelUp = true);
      authProvider.clearLevelUp();
      _showLevelUpDialog(authProvider.newLevel);
    }
  }

  void _showLevelUpDialog(int level) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => LevelUpOverlay(
        newLevel: level,
        onDismiss: () {
          Navigator.of(context).pop();
          setState(() => _showingLevelUp = false);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mission =
        context.watch<MissionProvider>().getMissionById(widget.missionId);

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
                  if (mission.isCompleted) ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.cardGreen,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('🎉', style: TextStyle(fontSize: 20)),
                          SizedBox(width: 8),
                          Text(
                            'Mission Complete! +166 XP',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.successGreen,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                        onToggleTask: (taskIndex) =>
                            _onToggleTask(dayIndex, taskIndex),
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
