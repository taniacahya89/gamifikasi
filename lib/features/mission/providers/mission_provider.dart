import 'package:flutter/foundation.dart';
import '../models/mission_model.dart';
import '../models/day_model.dart';
import '../models/task_model.dart';

/// Callback fired when a mission is freshly completed.
/// [xpEarned] = XP to award, [isLevelUp] = whether the new XP crosses a level.
typedef MissionCompletedCallback = void Function(int xpEarned);

class MissionProvider extends ChangeNotifier {
  final List<MissionModel> _missions = [];

  /// Called by AuthProvider when a mission finishes.
  MissionCompletedCallback? onMissionCompleted;

  List<MissionModel> get missions => List.unmodifiable(_missions);

  List<MissionModel> get completedMissions =>
      _missions.where((m) => m.isCompleted).toList();

  List<MissionModel> getMissionsByCategory(String category) =>
      _missions.where((m) => m.category == category).toList();

  MissionModel? getMissionById(String id) {
    try {
      return _missions.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  MissionProvider() {
    _loadTemplates();
  }

  // ─── Template data ────────────────────────────────────────────────────────

  void _loadTemplates() {
    _missions.addAll([
      _template(
        id: 'tpl_mindset_1',
        title: 'Positive Mind Challenge',
        description: "Let's build a positive mindset",
        category: 'Mindset',
        dayTitles: [
          'Gratitude Start', 'Positive Affirmation', 'Mind Reflection',
          'Mindful Moment', 'Self Appreciation', 'Learn Something New',
          'Weekly Reflection',
        ],
        dayTasks: [
          ['Write 3 things you are grateful for', 'Smile and say something positive about today'],
          ['Say 3 positive affirmations', 'Write one thing you like about yourself'],
          ['Write one negative thought you had today', 'Change it into a positive perspective'],
          ['Do 5–10 minutes meditation', 'Take 5 deep breaths slowly'],
          ['Write one achievement today', 'Say thank you to yourself'],
          ['Watch 10 min educational content', 'Write one new thing you learned'],
          ['Write one lesson from this week', 'Write one habit you want to keep'],
        ],
      ),
      _template(
        id: 'tpl_health_1',
        title: 'Morning Wellness Routine',
        description: 'Build a healthy morning habit',
        category: 'Health',
        dayTitles: [
          'Hydration Start', 'Move Your Body', 'Nourish Well',
          'Rest & Recover', 'Breathe Deep', 'Body Check', 'Health Review',
        ],
        dayTasks: [
          ['Drink 2 glasses of water', 'Stretch for 5 minutes'],
          ['Do 10 minutes of exercise', 'Take a short walk outside'],
          ['Eat a healthy breakfast', 'Avoid sugary drinks today'],
          ['Sleep by 10:30 PM', 'No screens 30 min before bed'],
          ['Do breathing exercises', 'Meditate for 5 minutes'],
          ['Write how your body feels', 'Drink 8 glasses of water'],
          ['List 3 healthy choices made', 'Plan next week\'s meals'],
        ],
      ),
      _template(
        id: 'tpl_productivity_1',
        title: 'Focus Flow Week',
        description: 'Master your productivity system',
        category: 'Productivity',
        dayTitles: [
          'Priority Setup', 'Deep Work', 'Time Blocking',
          'Energy Management', 'Clear the Clutter', 'Reflect & Adjust', 'Weekly Win',
        ],
        dayTasks: [
          ['Write 3 top goals for the week', 'Create a daily to-do list'],
          ['Do 25-min focused work session', 'Eliminate one distraction today'],
          ['Schedule tomorrow in advance', 'Review what took too long today'],
          ['Take a proper lunch break', 'Work during your peak hours'],
          ['Organize your workspace', 'Archive old files or emails'],
          ['What did you accomplish this week?', 'What needs improvement?'],
          ['Celebrate one big win', 'Set intentions for next week'],
        ],
      ),
      _template(
        id: 'tpl_finance_1',
        title: 'Money Mindset Week',
        description: 'Build better financial habits',
        category: 'Finance',
        dayTitles: [
          'Track Expenses', 'Budget Review', 'Save First',
          'Cut One Cost', 'Learn Finance', 'Set Goals', 'Weekly Review',
        ],
        dayTasks: [
          ['Write down all expenses today', 'Categorize your spending'],
          ['Review last month\'s budget', 'Find one area to improve'],
          ['Set aside 10% of income', 'Open a savings tracker'],
          ['Cancel one unused subscription', 'Cook at home today'],
          ['Read 10 min about investing', 'Write one thing you learned'],
          ['Set a 3-month savings goal', 'Write your financial why'],
          ['Review your progress this week', 'Plan next week\'s budget'],
        ],
      ),
      _template(
        id: 'tpl_selfgrowth_1',
        title: 'Level Up Yourself',
        description: 'Invest in personal development',
        category: 'Self Growth',
        dayTitles: [
          'Read & Learn', 'Reflect Deep', 'Face a Fear',
          'New Skill Day', 'Connect & Share', 'Rest Mindfully', 'Growth Review',
        ],
        dayTasks: [
          ['Read for 20 minutes', 'Write one key takeaway'],
          ['Journal about your goals', 'Write what holds you back'],
          ['Do one thing outside comfort zone', 'Reflect on how it felt'],
          ['Practice a new skill for 30 min', 'Watch a tutorial video'],
          ['Share something you learned', 'Listen actively to someone'],
          ['Do a digital detox for 2 hours', 'Practice mindful breathing'],
          ['Write 3 ways you grew this week', 'Set 1 goal for next week'],
        ],
      ),
      _template(
        id: 'tpl_lifestyle_1',
        title: 'Balanced Life Challenge',
        description: 'Create a fulfilling daily routine',
        category: 'Lifestyle',
        dayTitles: [
          'Morning Ritual', 'Social Day', 'Creative Hour',
          'Nature Time', 'Digital Detox', 'Gratitude Day', 'Life Review',
        ],
        dayTasks: [
          ['Wake up 30 min earlier', 'Write your intention for the day'],
          ['Reach out to a friend or family', 'Plan a social activity'],
          ['Spend 30 min on a creative hobby', 'Try something new today'],
          ['Spend 20 min outside', 'Notice 3 things in nature'],
          ['Limit social media to 30 min', 'Enjoy an offline activity'],
          ['Write 5 things you\'re grateful for', 'Do something kind for someone'],
          ['Review your week\'s highlights', 'Plan one fun thing next week'],
        ],
      ),
    ]);
  }

  MissionModel _template({
    required String id,
    required String title,
    required String description,
    required String category,
    required List<String> dayTitles,
    required List<List<String>> dayTasks,
  }) {
    return MissionModel(
      id: id,
      title: title,
      description: description,
      category: category,
      totalDays: 7,
      isTemplate: true,
      createdAt: DateTime.now(),
      days: List.generate(7, (i) {
        return DayModel(
          dayNumber: i + 1,
          title: dayTitles[i],
          tasks: List.generate(dayTasks[i].length, (j) {
            return TaskModel(
              id: '${id}_d${i + 1}_t$j',
              title: dayTasks[i][j],
            );
          }),
        );
      }),
    );
  }

  // ─── Actions ──────────────────────────────────────────────────────────────

  void addMission(MissionModel mission) {
    _missions.add(mission);
    notifyListeners();
  }

  void deleteMission(String id) {
    _missions.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  /// Toggle a task checkbox. Returns true if the mission just became completed.
  bool toggleTask(String missionId, int dayIndex, int taskIndex) {
    final idx = _missions.indexWhere((m) => m.id == missionId);
    if (idx == -1) return false;

    final mission = _missions[idx];
    final wasCompleted = mission.isCompleted;

    final day = mission.days[dayIndex];
    final task = day.tasks[taskIndex];

    final updatedTasks = List<TaskModel>.from(day.tasks)
      ..[taskIndex] = task.copyWith(isCompleted: !task.isCompleted);
    final updatedDays = List<DayModel>.from(mission.days)
      ..[dayIndex] = day.copyWith(tasks: updatedTasks);

    final updatedMission = mission.copyWith(
      days: updatedDays,
      completedAt: (!wasCompleted &&
              updatedDays.every((d) =>
                  d.tasks.isNotEmpty && d.tasks.every((t) => t.isCompleted)))
          ? DateTime.now()
          : mission.completedAt,
    );

    _missions[idx] = updatedMission;
    notifyListeners();

    // Fire callback if just completed
    final nowCompleted = updatedMission.isCompleted;
    if (!wasCompleted && nowCompleted) {
      onMissionCompleted?.call(166); // 166 XP per completed mission
      return true;
    }
    return false;
  }
}
