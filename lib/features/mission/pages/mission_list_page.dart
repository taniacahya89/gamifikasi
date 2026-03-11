import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../routes/app_router.dart';
import '../providers/mission_provider.dart';
import '../models/mission_model.dart';
import '../widgets/mission_card_item.dart';
import '../../home/widgets/category_card.dart';

class MissionListPage extends StatelessWidget {
  const MissionListPage({super.key, required this.category});

  final String category;

  CategoryData get _catData => appCategories.firstWhere(
        (c) => c.id == category,
        orElse: () => appCategories.first,
      );

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MissionProvider>();
    final missions = provider.getMissionsByCategory(category);
    final cat = _catData;

    final templates = missions.where((m) => m.isTemplate).toList();
    final custom = missions.where((m) => !m.isTemplate).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _CategoryHeader(cat: cat),
          Expanded(
            child: missions.isEmpty
                ? _EmptyState(category: category)
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (templates.isNotEmpty) ...[
                          _SectionLabel('📋 Mission Templates'),
                          const SizedBox(height: 10),
                          ...templates.map((m) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: MissionCardItem(
                                  mission: m,
                                  onTap: () => context.push(
                                      AppRoutes.missionDetailPath(m.id)),
                                ),
                              )),
                          const SizedBox(height: 8),
                        ],
                        if (custom.isNotEmpty) ...[
                          _SectionLabel('✏️ My Missions'),
                          const SizedBox(height: 10),
                          ...custom.map((m) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: MissionCardItem(
                                  mission: m,
                                  onTap: () => context.push(
                                      AppRoutes.missionDetailPath(m.id)),
                                  onDelete: () =>
                                      provider.deleteMission(m.id),
                                ),
                              )),
                          const SizedBox(height: 8),
                        ],
                        PrimaryButton(
                          label: '+ ${AppStrings.createMission}',
                          onPressed: () => context.push(
                            AppRoutes.createMission,
                            extra: category,
                          ),
                          backgroundColor: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: missions.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () => context.push(
                AppRoutes.createMission,
                extra: category,
              ),
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                AppStrings.createMission,
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({required this.cat});
  final CategoryData cat;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cat.iconBgColor,
        borderRadius:
            const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 52, 16, 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0x33FFFFFF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 16, color: AppColors.white),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            cat.icon,
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(width: 10),
          Text(
            cat.label,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: AppColors.darkText,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📭', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            'No missions in $category yet.',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.darkText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Create your first mission to get started!',
            style: TextStyle(color: AppColors.greyText, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            label: '+ Create Mission',
            onPressed: () => context.push(
              AppRoutes.createMission,
              extra: category,
            ),
            minimumSize: const Size(200, 52),
          ),
        ],
      ),
    );
  }
}
