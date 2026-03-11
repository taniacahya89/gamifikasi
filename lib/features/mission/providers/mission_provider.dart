import 'package:flutter/foundation.dart';
import '../models/mission_model.dart';
import '../models/day_model.dart';
import '../models/task_model.dart';

class MissionProvider extends ChangeNotifier {
  final List<MissionModel> _missions = [];

  List<MissionModel> get missions => List.unmodifiable(_missions);

  List<MissionModel> get completedMissions =>
      _missions.where((m) => m.isCompleted).toList();

  MissionModel? getMissionById(String id) {
    try {
      return _missions.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  List<MissionModel> getMissionsByCategory(String category) =>
      _missions.where((m) => m.category == category).toList();

  MissionProvider() {
    _loadDefaultMissions();
  }

  void _loadDefaultMissions() {
    _missions.addAll([
      _buildDefaultMission(
        id: 'mindset_1',
        title: 'Positive Mind Challenge',
        description: "Let's build a positive mindset",
        category: 'Mindset',
      ),
      _buildDefaultMission(
        id: 'health_1',
        title: 'Morning Wellness Routine',
        description: 'Build a healthy morning habit',
        category: 'Health',
      ),
      _buildDefaultMission(
        id: 'productivity_1',
        title: 'Focus Flow Week',
        description: 'Master your productivity system',
        category: 'Productivity',
      ),
    ]);
  }

  MissionModel _buildDefaultMission({
    required String id,
    required String title,
    required String description,
    required String category,
  }) {
    final dayTitles = [
      'Gratitude Start',
      'Positive Affirmation',
      'Mind Reflection',
      'Mindful Moment',
      'Self Appreciation',
      'Learn Something New',
      'Weekly Reflection',
    ];

    final dayTasks = [
      ['Write 3 things you are grateful for', 'Smile and say something positive'],
      ['Say 3 positive affirmations', 'Write one thing you like about yourself'],
      ['Write one negative thought you had', 'Change it into a positive perspective'],
      ['Do 5–10 minutes meditation', 'Take 5 deep breaths slowly'],
      ['Write one achievement today', 'Say thank you to yourself'],
      ['Watch 10 min educational content', 'Write one new thing you learned'],
      ['Write one lesson from this week', 'Write one habit you want to keep'],
    ];

    return MissionModel(
      id: id,
      title: title,
      description: description,
      category: category,
      totalDays: 7,
      createdAt: DateTime.now(),
      days: List.generate(7, (i) {
        return DayModel(
          dayNumber: i + 1,
          title: dayTitles[i],
          tasks: List.generate(dayTasks[i].length, (j) {
            return TaskModel(
              id: '${id}_day${i + 1}_task$j',
              title: dayTasks[i][j],
            );
          }),
        );
      }),
    );
  }

  void addMission(MissionModel mission) {
    _missions.add(mission);
    notifyListeners();
  }

  void toggleTask(String missionId, int dayIndex, int taskIndex) {
    final missionIndex = _missions.indexWhere((m) => m.id == missionId);
    if (missionIndex == -1) return;

    final mission = _missions[missionIndex];
    final day = mission.days[dayIndex];
    final task = day.tasks[taskIndex];

    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    final updatedTasks = List<TaskModel>.from(day.tasks);
    updatedTasks[taskIndex] = updatedTask;

    final updatedDay = day.copyWith(tasks: updatedTasks);
    final updatedDays = List<DayModel>.from(mission.days);
    updatedDays[dayIndex] = updatedDay;

    _missions[missionIndex] = mission.copyWith(days: updatedDays);
    notifyListeners();
  }

  void deleteMission(String id) {
    _missions.removeWhere((m) => m.id == id);
    notifyListeners();
  }
}
