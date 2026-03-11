import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../routes/app_router.dart';
import '../../auth/providers/auth_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/stats_row.dart';
import '../widgets/settings_item.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    if (user == null) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(user: user),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatsRow(user: user),
                  const SizedBox(height: 24),
                  const Text(
                    AppStrings.badges,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  user.badges.isEmpty
                      ? const Text(
                          'Complete missions to earn badges!',
                          style: TextStyle(
                            color: AppColors.greyText,
                            fontSize: 13,
                          ),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: user.badges
                              .map((b) => _BadgeChip(label: b))
                              .toList(),
                        ),
                  const SizedBox(height: 24),
                  const Text(
                    AppStrings.settings,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SettingsItem(label: AppStrings.notifications, onTap: () {}),
                  SettingsItem(label: AppStrings.darkMode, onTap: () {}),
                  SettingsItem(label: AppStrings.language, onTap: () {}),
                  SettingsItem(label: AppStrings.helpSupport, onTap: () {}),
                  SettingsItem(
                    label: 'Edit Profile',
                    onTap: () => context.push(AppRoutes.editProfile),
                  ),
                  SettingsItem(
                    label: AppStrings.logout,
                    isDestructive: true,
                    onTap: () {
                      context.read<AuthProvider>().logout();
                      context.go(AppRoutes.login);
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 4),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.darkText,
        ),
      ),
    );
  }
}
