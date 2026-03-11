import 'day_model.dart';

class MissionModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final int totalDays;
  final List<DayModel> days;
  final DateTime createdAt;

  const MissionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.totalDays = 7,
    required this.days,
    required this.createdAt,
  });

  int get totalTasks => days.fold(0, (sum, d) => sum + d.tasks.length);

  int get completedTasks =>
      days.fold(0, (sum, d) => sum + d.completedCount);

  double get progressPercentage =>
      totalTasks == 0 ? 0 : completedTasks / totalTasks;

  bool get isCompleted => completedTasks == totalTasks && totalTasks > 0;

  MissionModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    int? totalDays,
    List<DayModel>? days,
    DateTime? createdAt,
  }) {
    return MissionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      totalDays: totalDays ?? this.totalDays,
      days: days ?? this.days,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'totalDays': totalDays,
        'days': days.map((d) => d.toMap()).toList(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory MissionModel.fromMap(Map<String, dynamic> map) => MissionModel(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        description: map['description'] ?? '',
        category: map['category'] ?? '',
        totalDays: map['totalDays'] ?? 7,
        days: (map['days'] as List<dynamic>?)
                ?.map((d) => DayModel.fromMap(d))
                .toList() ??
            [],
        createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      );
}
