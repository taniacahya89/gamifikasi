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
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppStrings.greeting}${user.fullName}${AppStrings.greetingSuffix} 👋',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            AppStrings.whatImprove,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xCCFFFFFF),
            ),
          ),
          const SizedBox(height: 20),
          _XpLevelSection(user: user),
        ],
      ),
    );
  }
}

class _XpLevelSection extends StatelessWidget {
  const _XpLevelSection({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProgressRow(
          label: AppStrings.xpPoints,
          value: user.xp.toDouble(),
          max: 1000,
          display: '${user.xp}/1000',
        ),
        const SizedBox(height: 10),
        _ProgressRow(
          label: AppStrings.level,
          value: user.level.toDouble(),
          max: 100,
          display: '${user.level}/100',
        ),
      ],
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
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Color(0xCCFFFFFF),
          ),
        ),
        const SizedBox(height: 6),
        Stack(
          alignment: Alignment.center,
          children: [
            AppProgressBar(
              value: value,
              max: max,
              height: 22,
              fillColor: AppColors.barFill,
              backgroundColor: AppColors.barPink,
            ),
            Text(
              display,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.darkText,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
