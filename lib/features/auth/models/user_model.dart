// ============================================================
// FILE: user_model.dart
// FUNGSI: Model data untuk menyimpan semua informasi user.
//
// Model ini digunakan di seluruh aplikasi sebagai "blueprint"
// data user. Setiap perubahan data user (XP naik, streak
// bertambah, dll) dilakukan dengan membuat salinan baru
// menggunakan fungsi copyWith().
// ============================================================

class UserModel {
  // --- Identitas Akun ---
  final String id;        // ID unik user (tidak berubah)
  final String fullName;  // Nama lengkap (bisa diubah di Edit Profile)
  final String email;     // Email akun (tidak bisa diubah — identitas tetap)

  // --- Statistik Gamifikasi ---
  final int xp;                      // Total XP yang sudah dikumpulkan user
  final int level;                   // Level saat ini, dihitung dari total XP
  final int streak;                  // Jumlah hari berturut-turut user aktif
  final int completedMissionsCount;  // Berapa mission yang sudah 100% selesai

  // --- Koleksi Badge ---
  // Badge adalah penghargaan khusus yang diraih user berdasarkan pencapaian.
  // Contoh badge: '🌟 First Quest', '🔥 On Fire', '💪 Consistent'
  final List<String> badges;

  // --- Tracking Aktivitas Harian (untuk sistem streak) ---
  final DateTime? lastActivityDate; // Tanggal terakhir user menyelesaikan task

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

  // ──────────────────────────────────────────────────────────
  // KONSTANTA SISTEM GAMIFIKASI
  // ──────────────────────────────────────────────────────────

  /// Jumlah XP yang dibutuhkan untuk naik 1 level.
  /// Contoh: 0–999 XP = Level 1, 1000–1999 XP = Level 2, dst.
  static const int xpPerLevel = 1000;

  /// Jumlah XP yang didapat saat menyelesaikan 1 mission penuh (7 hari).
  static const int xpPerMission = 166;

  // ──────────────────────────────────────────────────────────
  // FUNGSI UTAMA
  // ──────────────────────────────────────────────────────────

  /// Membuat salinan UserModel dengan beberapa nilai yang diperbarui.
  ///
  /// Kenapa pakai copyWith? Karena objek UserModel bersifat immutable
  /// (tidak bisa diubah langsung). Jadi setiap kali ada data yang berubah,
  /// kita buat objek baru dengan data yang sudah diperbarui.
  ///
  /// Contoh penggunaan:
  ///   user.copyWith(xp: 500, level: 2) → UserModel baru dengan XP 500 dan Level 2
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

  /// Mengubah UserModel menjadi format Map<String, dynamic>.
  /// Digunakan saat menyimpan data ke database atau local storage.
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

  /// Membuat UserModel dari data Map (misalnya dari database).
  /// Menggunakan nilai default jika ada field yang kosong atau null.
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

  /// Membuat UserModel dari JSON response dari backend API.
  /// Digunakan saat menerima data dari server.
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['_id'] ?? json['id'] ?? '',
        fullName: json['fullName'] ?? '',
        email: json['email'] ?? '',
        xp: json['xp'] ?? 0,
        level: json['level'] ?? 1,
        streak: json['streak'] ?? 0,
        completedMissionsCount: json['completedMissionsCount'] ?? 0,
        badges: List<String>.from(json['badges'] ?? []),
        lastActivityDate: json['lastActivityDate'] != null
            ? DateTime.tryParse(json['lastActivityDate'])
            : null,
      );

  /// Mengubah UserModel menjadi JSON untuk dikirim ke backend API.
  Map<String, dynamic> toJson() => {
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
}
