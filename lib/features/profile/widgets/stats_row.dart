import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../auth/models/user_model.dart';
import '../../mission/providers/mission_provider.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final completedCount =
        context.watch<MissionProvider>().completedMissions.length;

    return Row(
      children: [
        _StatCard(icon: '⭐', label: 'XP', value: '${user.xp}'),
        const SizedBox(width: 12),
        _StatCard(icon: '🏆', label: 'Missions', value: '$completedCount'),
        const SizedBox(width: 12),
        _StatCard(icon: '📈', label: 'Level', value: '${user.level}'),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final String icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Color(0x0A000000), blurRadius: 6),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.greyText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
