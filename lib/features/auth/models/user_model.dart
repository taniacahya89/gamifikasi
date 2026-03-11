class UserModel {
  final String id;
  final String fullName;
  final String email;
  final int xp;
  final int level;
  final int streak;
  final int completedMissionsCount;
  final List<String> badges;
  final DateTime? lastActivityDate;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.xp = 0,
    this.level = 1,
    this.streak = 0,
    this.completedMissionsCount = 0,
    this.badges = const [],
    this.lastActivityDate,
  });

  /// XP needed per level = 1000
  static const int xpPerLevel = 1000;
  /// XP reward per completed mission
  static const int xpPerMission = 166;

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    int? xp,
    int? level,
    int? streak,
    int? completedMissionsCount,
    List<String>? badges,
    DateTime? lastActivityDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      streak: streak ?? this.streak,
      completedMissionsCount:
          completedMissionsCount ?? this.completedMissionsCount,
      badges: badges ?? this.badges,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'xp': xp,
        'level': level,
        'streak': streak,
        'completedMissionsCount': completedMissionsCount,
        'badges': badges,
        'lastActivityDate': lastActivityDate?.toIso8601String(),
      };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map['id'] ?? '',
        fullName: map['fullName'] ?? '',
        email: map['email'] ?? '',
        xp: map['xp'] ?? 0,
        level: map['level'] ?? 1,
        streak: map['streak'] ?? 0,
        completedMissionsCount: map['completedMissionsCount'] ?? 0,
        badges: List<String>.from(map['badges'] ?? []),
        lastActivityDate: map['lastActivityDate'] != null
            ? DateTime.tryParse(map['lastActivityDate'])
            : null,
      );
}
