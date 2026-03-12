// ============================================================
// FILE: day_model.dart
// FUNGSI: Model data untuk satu hari dalam sebuah mission.
//
// Setiap mission terdiri dari 7 DayModel (Hari 1 sampai Hari 7).
// Setiap hari punya judul dan beberapa task yang harus diselesaikan.
// Hari dianggap selesai jika semua task di dalamnya sudah dicentang.
// ============================================================

import 'task_model.dart';

class DayModel {
  final int dayNumber;          // Nomor hari (1–7)
  final String title;           // Judul hari, misalnya "Gratitude Start"
  final List<TaskModel> tasks;  // Daftar task yang harus diselesaikan hari ini

  const DayModel({
    required this.dayNumber,
    required this.title,
    required this.tasks,
  });

  // ──────────────────────────────────────────────────────────
  // COMPUTED PROPERTIES (Nilai yang dihitung otomatis)
  // ──────────────────────────────────────────────────────────

  /// Mengembalikan true jika SEMUA task di hari ini sudah dicentang.
  /// Digunakan untuk menampilkan tanda centang hijau di kartu hari.
  bool get isCompleted =>
      tasks.isNotEmpty && tasks.every((t) => t.isCompleted);

  /// Menghitung berapa task yang sudah dicentang di hari ini.
  /// Digunakan untuk menampilkan progress, misalnya "1/2 tasks done".
  int get completedCount => tasks.where((t) => t.isCompleted).length;

  /// Membuat salinan DayModel dengan nilai yang diperbarui.
  /// Dipanggil dari MissionProvider saat task dalam hari ini diubah.
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

  /// Mengubah DayModel ke format Map untuk disimpan ke database.
  Map<String, dynamic> toMap() => {
        'dayNumber': dayNumber,
        'title': title,
        'tasks': tasks.map((t) => t.toMap()).toList(),
      };

  /// Membuat DayModel dari data Map (misalnya dari database).
  factory DayModel.fromMap(Map<String, dynamic> map) => DayModel(
        dayNumber: map['dayNumber'] ?? 0,
        title: map['title'] ?? '',
        tasks: (map['tasks'] as List<dynamic>?)
                ?.map((t) => TaskModel.fromMap(t))
                .toList() ??
            [],
      );
}
