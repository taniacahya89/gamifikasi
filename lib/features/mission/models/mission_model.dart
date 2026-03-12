// ============================================================
// FILE: mission_model.dart
// FUNGSI: Model data untuk satu mission (tantangan 7 hari).
//
// Mission adalah inti dari aplikasi HabitQuest. Setiap mission
// adalah tantangan 7 hari yang terdiri dari aktivitas harian.
//
// Ada dua jenis mission:
//   1. Template  → disediakan sistem, isTemplate = true
//   2. Custom    → dibuat user sendiri, isTemplate = false
// ============================================================

import 'day_model.dart';

class MissionModel {
  final String id;           // ID unik mission
  final String title;        // Nama mission, misal "Positive Mind Challenge"
  final String description;  // Deskripsi singkat tujuan mission
  final String category;     // Kategori: 'Mindset', 'Health', dll.
  final int totalDays;       // Jumlah hari (selalu 7)
  final List<DayModel> days; // Data 7 hari yang berisi task harian
  final DateTime createdAt;  // Waktu mission dibuat

  /// True jika mission ini adalah template bawaan sistem.
  /// Template tidak bisa dihapus oleh user.
  final bool isTemplate;

  /// Waktu mission selesai 100%. Null jika belum selesai.
  /// Diisi otomatis saat semua task berhasil dicentang.
  final DateTime? completedAt;

  const MissionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.totalDays = 7,
    required this.days,
    required this.createdAt,
    this.isTemplate = false,
    this.completedAt,
  });

  // ──────────────────────────────────────────────────────────
  // COMPUTED PROPERTIES (Nilai yang dihitung otomatis)
  // ──────────────────────────────────────────────────────────

  /// Jumlah total task di seluruh 7 hari.
  /// Dihitung dengan menjumlahkan task dari semua DayModel.
  int get totalTasks => days.fold(0, (sum, d) => sum + d.tasks.length);

  /// Jumlah task yang sudah selesai di seluruh 7 hari.
  int get completedTasks => days.fold(0, (sum, d) => sum + d.completedCount);

  /// Persentase kemajuan mission dalam bentuk angka 0.0 – 1.0.
  /// Contoh: 0.5 berarti 50% task sudah selesai.
  double get progressPercentage =>
      totalTasks == 0 ? 0 : completedTasks / totalTasks;

  /// Mengembalikan true jika SEMUA task di semua hari sudah selesai.
  /// Saat ini true, user mendapat reward XP dan badge popup ditampilkan.
  bool get isCompleted => totalTasks > 0 && completedTasks == totalTasks;

  /// Membuat salinan MissionModel dengan nilai yang diperbarui.
  MissionModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    int? totalDays,
    List<DayModel>? days,
    DateTime? createdAt,
    bool? isTemplate,
    DateTime? completedAt,
  }) {
    return MissionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      totalDays: totalDays ?? this.totalDays,
      days: days ?? this.days,
      createdAt: createdAt ?? this.createdAt,
      isTemplate: isTemplate ?? this.isTemplate,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  /// Mengubah MissionModel ke format Map untuk disimpan ke database.
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'totalDays': totalDays,
        'days': days.map((d) => d.toMap()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'isTemplate': isTemplate,
        'completedAt': completedAt?.toIso8601String(),
      };

  /// Membuat MissionModel dari data Map (misalnya dari database).
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
        createdAt:
            DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
        isTemplate: map['isTemplate'] ?? false,
        completedAt: map['completedAt'] != null
            ? DateTime.tryParse(map['completedAt'])
            : null,
      );
}
