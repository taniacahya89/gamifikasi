import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/mission_model.dart';

class MissionPlanCard extends StatelessWidget {
  const MissionPlanCard({super.key, required this.mission});

  final MissionModel mission;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.coralLight,
        borderRadius: BorderRadius.circular(16),
        border: const Border(
          left: BorderSide(color: AppColors.coral, width: 4),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mission.title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.darkText,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${mission.totalDays} Days',
            style: const TextStyle(
              color: AppColors.coral,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            mission.description,
            style: const TextStyle(
              color: AppColors.darkText,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
