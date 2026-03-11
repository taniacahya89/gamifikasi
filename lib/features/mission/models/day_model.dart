import 'task_model.dart';

class DayModel {
  final int dayNumber;
  final String title;
  final List<TaskModel> tasks;

  const DayModel({
    required this.dayNumber,
    required this.title,
    required this.tasks,
  });

  bool get isCompleted => tasks.isNotEmpty && tasks.every((t) => t.isCompleted);

  int get completedCount => tasks.where((t) => t.isCompleted).length;

  DayModel copyWith({
    int? dayNumber,
    String? title,
    List<TaskModel>? tasks,
  }) {
    return DayModel(
      dayNumber: dayNumber ?? this.dayNumber,
      title: title ?? this.title,
      tasks: tasks ?? this.tasks,
    );
  }

  Map<String, dynamic> toMap() => {
        'dayNumber': dayNumber,
        'title': title,
        'tasks': tasks.map((t) => t.toMap()).toList(),
      };

  factory DayModel.fromMap(Map<String, dynamic> map) => DayModel(
        dayNumber: map['dayNumber'] ?? 0,
        title: map['title'] ?? '',
        tasks: (map['tasks'] as List<dynamic>?)
                ?.map((t) => TaskModel.fromMap(t))
                .toList() ??
            [],
      );
}
