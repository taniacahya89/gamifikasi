class UserModel {
  final String id;
  final String fullName;
  final String email;
  final int xp;
  final int level;
  final List<String> badges;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.xp = 166,
    this.level = 1,
    this.badges = const [],
  });

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    int? xp,
    int? level,
    List<String>? badges,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      badges: badges ?? this.badges,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'xp': xp,
        'level': level,
        'badges': badges,
      };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map['id'] ?? '',
        fullName: map['fullName'] ?? '',
        email: map['email'] ?? '',
        xp: map['xp'] ?? 0,
        level: map['level'] ?? 1,
        badges: List<String>.from(map['badges'] ?? []),
      );
}
