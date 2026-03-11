import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../auth/models/user_model.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppStrings.greeting}${user.fullName}${AppStrings.greetingSuffix} 👋',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      AppStrings.whatImprove,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xCCFFFFFF),
                      ),
                    ),
                  ],
                ),
              ),
              // Streak badge
              _StreakBadge(streak: user.streak),
            ],
          ),
          const SizedBox(height: 18),
          _ProgressRow(
            label: AppStrings.xpPoints,
            value: (user.xp % UserModel.xpPerLevel).toDouble(),
            max: UserModel.xpPerLevel.toDouble(),
            display: '${user.xp} XP',
          ),
          const SizedBox(height: 8),
          _ProgressRow(
            label: AppStrings.level,
            value: user.level.toDouble(),
            max: 100,
            display: 'Lv. ${user.level}',
          ),
        ],
      ),
    );
  }
}

class _StreakBadge extends StatelessWidget {
  const _StreakBadge({required this.streak});
  final int streak;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x33FFFFFF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 20)),
          Text(
            '$streak day${streak == 1 ? '' : 's'}',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.label,
    required this.value,
    required this.max,
    required this.display,
  });

  final String label;
  final double value;
  final double max;
  final String display;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xCCFFFFFF),
              ),
            ),
            const Spacer(),
            Text(
              display,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xCCFFFFFF),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        AppProgressBar(
          value: value.clamp(0, max),
          max: max,
          height: 14,
          fillColor: AppColors.barFill,
          backgroundColor: const Color(0x44FFFFFF),
        ),
      ],
    );
  }
}
