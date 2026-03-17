import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/category_chip.dart';
import '../models/mission_model.dart';
import '../models/day_model.dart';
import '../models/task_model.dart';
import '../providers/mission_provider.dart';

class CreateMissionPage extends StatefulWidget {
  const CreateMissionPage({super.key, this.preselectedCategory});

  final String? preselectedCategory;

  @override
  State<CreateMissionPage> createState() => _CreateMissionPageState();
}

class _CreateMissionPageState extends State<CreateMissionPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  late String _selectedCategory;

  final List<List<TextEditingController>> _dayTaskControllers =
      List.generate(
    7,
    (_) => [TextEditingController(), TextEditingController()],
  );

  @override
  void initState() {
    super.initState();
    _selectedCategory =
        widget.preselectedCategory ?? AppStrings.categories.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    for (final day in _dayTaskControllers) {
      for (final c in day) {
        c.dispose();
      }
    }
    super.dispose();
  }

  void _addTaskToDay(int dayIndex) {
    setState(() {
      _dayTaskControllers[dayIndex].add(TextEditingController());
    });
  }

  void _saveMission() {
    if (!_formKey.currentState!.validate()) return;

    final days = List.generate(7, (dayIndex) {
      final controllers = _dayTaskControllers[dayIndex];
      final tasks = <TaskModel>[];
      for (int i = 0; i < controllers.length; i++) {
        final text = controllers[i].text.trim();
        if (text.isNotEmpty) {
          tasks.add(TaskModel(
            id: 'custom_d${dayIndex}_t$i',
            title: text,
          ));
        }
      }
      return DayModel(
        dayNumber: dayIndex + 1,
        title: 'Day ${dayIndex + 1}',
        tasks: tasks,
      );
    });

    final mission = MissionModel(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      category: _selectedCategory,
      totalDays: 7,
      days: days,
      createdAt: DateTime.now(),
    );

    context.read<MissionProvider>().addMission(mission);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const CustomAppBar(title: AppStrings.createMission),
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionLabel(AppStrings.missionTitle),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _titleController,
                      hintText: 'e.g. Morning Routine',
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    const _SectionLabel(AppStrings.missionDescription),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _descController,
                      hintText: 'Describe your mission...',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    const _SectionLabel(AppStrings.selectCategory),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AppStrings.categories.map((cat) {
                        return CategoryChip(
                          label: cat,
                          isSelected: _selectedCategory == cat,
                          onTap: () =>
                              setState(() => _selectedCategory = cat),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    const _SectionLabel('Daily Tasks'),
                    const SizedBox(height: 12),
                    ...List.generate(7, (dayIndex) {
                      return _DayTaskSection(
                        dayNumber: dayIndex + 1,
                        controllers: _dayTaskControllers[dayIndex],
                        onAddTask: () => _addTaskToDay(dayIndex),
                      );
                    }),
                    const SizedBox(height: 28),
                    PrimaryButton(
                      label: AppStrings.save,
                      onPressed: _saveMission,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
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
        color: AppColors.primary,
      ),
    );
  }
}

class _DayTaskSection extends StatelessWidget {
  const _DayTaskSection({
    required this.dayNumber,
    required this.controllers,
    required this.onAddTask,
  });

  final int dayNumber;
  final List<TextEditingController> controllers;
  final VoidCallback onAddTask;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Day $dayNumber',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.darkText,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          ...controllers.asMap().entries.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextField(
                controller: e.value,
                decoration: InputDecoration(
                  hintText: 'Task ${e.key + 1}...',
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  isDense: true,
                ),
                style: const TextStyle(fontSize: 13),
              ),
            );
          }),
          TextButton.icon(
            onPressed: onAddTask,
            icon: const Icon(Icons.add_rounded,
                size: 16, color: AppColors.primary),
            label: const Text(
              AppStrings.addTask,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
          ),
        ],
      ),
    );
  }
}
