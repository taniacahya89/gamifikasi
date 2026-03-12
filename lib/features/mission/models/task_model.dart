// ============================================================
// FILE: task_model.dart
// FUNGSI: Model data untuk satu task (aktivitas) dalam sehari.
//
// Setiap hari di dalam mission memiliki beberapa task.
// Task adalah hal yang harus dilakukan user, seperti:
// "Tulis 3 hal yang kamu syukuri" atau "Minum 2 gelas air".
// ============================================================

class TaskModel {
  final String id;          // ID unik task
  final String title;       // Nama/deskripsi task yang harus dilakukan
  bool isCompleted;         // Status apakah task sudah dicentang atau belum

  TaskModel({
    required this.id,
    required this.title,
    this.isCompleted = false, // Default: belum selesai
  });

  /// Membuat salinan TaskModel dengan nilai yang diperbarui.
  /// Sering digunakan saat user mencentang task (isCompleted berubah).
  TaskModel copyWith({String? id, String? title, bool? isCompleted}) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// Mengubah TaskModel ke format Map untuk disimpan ke database.
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'isCompleted': isCompleted,
      };

  /// Membuat TaskModel dari data Map (misalnya dari database).
  factory TaskModel.fromMap(Map<String, dynamic> map) => TaskModel(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        isCompleted: map['isCompleted'] ?? false,
      );
}
