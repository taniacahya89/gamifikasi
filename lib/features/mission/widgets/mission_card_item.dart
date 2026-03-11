import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../models/mission_model.dart';

class MissionCardItem extends StatelessWidget {
  const MissionCardItem({
    super.key,
    required this.mission,
    required this.onTap,
    this.onDelete,
  });

  final MissionModel mission;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (mission.isTemplate)
                            Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                'Template',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          if (mission.isCompleted)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.cardGreen,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                '✓ Done',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.successGreen,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mission.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.darkText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        mission.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.greyText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: AppColors.coral, size: 20),
                    onPressed: () => _confirmDelete(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.lightGrey),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppProgressBar(
                    value: mission.completedTasks.toDouble(),
                    max: mission.totalTasks.toDouble(),
                    height: 10,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '$pct%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.greyText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${mission.completedTasks}/${mission.totalTasks} tasks • ${mission.totalDays} days',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.greyText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Mission'),
        content:
            const Text('Are you sure you want to delete this mission?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.coral),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) onDelete?.call();
  }
}
