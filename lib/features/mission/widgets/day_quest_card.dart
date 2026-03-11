import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/day_model.dart';
import 'task_item.dart';

class DayQuestCard extends StatelessWidget {
  const DayQuestCard({
    super.key,
    required this.day,
    required this.dayIndex,
    required this.onToggleTask,
  });

  final DayModel day;
  final int dayIndex;
  final void Function(int taskIndex) onToggleTask;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: day.isCompleted ? AppColors.cardGreen : AppColors.cardBlue,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _DayCircle(dayNumber: day.dayNumber, isCompleted: day.isCompleted),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Day ${day.dayNumber} – ${day.title}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: AppColors.darkText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...List.generate(day.tasks.length, (i) {
            return TaskItem(
              task: day.tasks[i],
              onToggle: () => onToggleTask(i),
            );
          }),
        ],
      ),
    );
  }
}

class _DayCircle extends StatelessWidget {
  const _DayCircle({required this.dayNumber, required this.isCompleted});

  final int dayNumber;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted ? AppColors.successGreen : AppColors.white,
        border: Border.all(
          color: isCompleted ? AppColors.successGreen : AppColors.lightGrey,
          width: 2,
        ),
      ),
      child: Center(
        child: isCompleted
            ? const Text(
                '✓',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              )
            : Text(
                '$dayNumber',
                style: const TextStyle(
                  color: AppColors.greyText,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}
