// ============================================================
// FILE: day_quest_card.dart
// FUNGSI: Kartu yang menampilkan satu hari dalam mission beserta
//         task-task yang bisa dicentang oleh user.
//
// Kartu berubah warna menjadi hijau saat semua task di hari
// tersebut sudah selesai — memberi feedback visual yang jelas.
// ============================================================

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/day_model.dart';
import 'task_item.dart';

class DayQuestCard extends StatelessWidget {
  const DayQuestCard({
    super.key,
    required this.day,
    required this.dayIndex,
    required this.onToggleTask,
  });

  final DayModel day;     // Data hari (nomor, judul, daftar task)
  final int dayIndex;     // Indeks hari dalam mission (0 = Hari 1)

  /// Callback yang dipanggil saat user mencentang/membatalkan task.
  /// Parameter [taskIndex] adalah indeks task yang diubah.
  /// Callback ini meneruskan aksi ke MissionDetailPage → MissionProvider.
  final void Function(int taskIndex) onToggleTask;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Warna kartu: hijau jika semua task selesai, biru jika belum
        color: day.isCompleted ? AppColors.cardGreen : AppColors.cardBlue,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header kartu: lingkaran hari + judul hari
          Row(
            children: [
              _DayCircle(
                dayNumber: day.dayNumber,
                isCompleted: day.isCompleted,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Day ${day.dayNumber} – ${day.title}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: AppColors.darkText,
                  ),
                ),
              ),
              // Tampilkan progress task hari ini (misal "1/2")
              Text(
                '${day.completedCount}/${day.tasks.length}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: day.isCompleted
                      ? AppColors.successGreen
                      : AppColors.greyText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Daftar task yang bisa dicentang
          ...List.generate(day.tasks.length, (i) {
            return TaskItem(
              task: day.tasks[i],
              // Saat task dicentang, kirim indeks task ke callback
              onToggle: () => onToggleTask(i),
            );
          }),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// WIDGET PEMBANTU: Lingkaran nomor hari
// ──────────────────────────────────────────────────────────

/// Lingkaran kecil yang menampilkan nomor hari.
/// Berubah menjadi lingkaran hijau dengan tanda centang
/// saat semua task di hari tersebut sudah selesai.
class _DayCircle extends StatelessWidget {
  const _DayCircle({required this.dayNumber, required this.isCompleted});

  final int dayNumber;   // Nomor hari yang ditampilkan
  final bool isCompleted; // true = tampilkan centang, false = tampilkan angka

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Latar hijau jika selesai, putih jika belum
        color: isCompleted ? AppColors.successGreen : AppColors.white,
        border: Border.all(
          color: isCompleted ? AppColors.successGreen : AppColors.lightGrey,
          width: 2,
        ),
      ),
      child: Center(
        child: isCompleted
            // Tanda centang untuk hari yang sudah selesai
            ? const Text(
                '✓',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              )
            // Nomor hari untuk yang belum selesai
            : Text(
                '$dayNumber',
                style: const TextStyle(
                  color: AppColors.greyText,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}
