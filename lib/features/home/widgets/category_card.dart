import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class CategoryData {
  final String id;
  final String label;
  final String icon;
  final Color cardColor;
  final Color iconBgColor;

  const CategoryData({
    required this.id,
    required this.label,
    required this.icon,
    required this.cardColor,
    required this.iconBgColor,
  });
}

const List<CategoryData> appCategories = [
  CategoryData(
    id: 'Mindset',
    label: 'Mindset',
    icon: '🧠',
    cardColor: AppColors.cardBlue,
    iconBgColor: AppColors.iconBlueTeal,
  ),
  CategoryData(
    id: 'Health',
    label: 'Health',
    icon: '❤️',
    cardColor: AppColors.cardLavender,
    iconBgColor: AppColors.primary,
  ),
  CategoryData(
    id: 'Productivity',
    label: 'Productivity',
    icon: '📖',
    cardColor: AppColors.cardPink,
    iconBgColor: AppColors.iconRed,
  ),
  CategoryData(
    id: 'Finance',
    label: 'Finance',
    icon: '💰',
    cardColor: Color(0xFFE8F4FB),
    iconBgColor: AppColors.iconTeal,
  ),
  CategoryData(
    id: 'Self Growth',
    label: 'Self Growth',
    icon: '🧘',
    cardColor: AppColors.cardBlue,
    iconBgColor: AppColors.iconBlue,
  ),
  CategoryData(
    id: 'Lifestyle',
    label: 'Lifestyle',
    icon: '🌱',
    cardColor: AppColors.cardMint,
    iconBgColor: AppColors.iconGreen,
  ),
];

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.data,
    required this.hasCompletedMission,
    required this.onTap,
  });

  final CategoryData data;
  final bool hasCompletedMission;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: data.cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x12000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: data.iconBgColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child:
                        Text(data.icon, style: const TextStyle(fontSize: 26)),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  data.label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkText,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8D8E8),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Select',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF555555),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (hasCompletedMission)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: AppColors.successGreen,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '✓',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
