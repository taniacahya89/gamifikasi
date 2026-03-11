import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/models/user_model.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(icon: '⭐', label: 'XP', value: '${user.xp}'),
        const SizedBox(width: 10),
        _StatCard(
            icon: '🏆',
            label: 'Missions',
            value: '${user.completedMissionsCount}'),
        const SizedBox(width: 10),
        _StatCard(icon: '🔥', label: 'Streak', value: '${user.streak}d'),
        const SizedBox(width: 10),
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
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
