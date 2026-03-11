import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../mission/models/mission_model.dart';
import '../../home/widgets/category_card.dart';

class ProgressMissionCard extends StatelessWidget {
  const ProgressMissionCard({
    super.key,
    required this.mission,
    required this.onTap,
  });

  final MissionModel mission;
  final VoidCallback onTap;

  CategoryData get _catData {
    return appCategories.firstWhere(
      (c) => c.id == mission.category,
      orElse: () => appCategories.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cat = _catData;
    final pct = (mission.progressPercentage * 100).round();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: cat.iconBgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(cat.icon, style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mission.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: AppColors.darkText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    mission.category,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.greyText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  AppProgressBar(
                    value: mission.completedTasks.toDouble(),
                    max: mission.totalTasks.toDouble(),
                    height: 10,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${mission.completedTasks}/${mission.totalTasks} tasks • $pct%'
                    '${mission.isCompleted ? ' ✓ Complete!' : ''}',
                    style: TextStyle(
                      fontSize: 11,
                      color: mission.isCompleted
                          ? AppColors.successGreen
                          : AppColors.greyText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.lightGrey,
            ),
          ],
        ),
      ),
    );
  }
}
