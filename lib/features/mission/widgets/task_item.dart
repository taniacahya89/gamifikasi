// ============================================================
// FILE: task_item.dart
// FUNGSI: Satu baris task dengan checkbox yang bisa dicentang.
//
// Saat task selesai, teks menampilkan strikethrough (dicoret)
// dan warna menjadi abu-abu sebagai feedback visual.
//
// Callback onToggle diteruskan ke atas:
//   TaskItem → DayQuestCard → MissionDetailPage → MissionProvider
// ============================================================

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/task_model.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
  });

  final TaskModel task;     // Data task (judul dan status selesai)
  final VoidCallback onToggle; // Dipanggil saat checkbox atau baris ditekan

  @override
  Widget build(BuildContext context) {
    // GestureDetector membuat seluruh baris bisa ditekan (bukan hanya checkbox)
    return GestureDetector(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            // Checkbox: menampilkan status selesai dan memicu toggle
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: task.isCompleted,
                onChanged: (_) => onToggle(), // Delegasi ke callback
                activeColor: AppColors.primary, // Warna saat tercentang
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: const BorderSide(color: AppColors.lightGrey),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 10),

            // Teks task: dicoret dan abu-abu jika sudah selesai
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  // Teks abu-abu jika selesai, gelap jika belum
                  color: task.isCompleted
                      ? AppColors.greyText
                      : AppColors.darkText,
                  // Strikethrough jika selesai (tanda visual "sudah dikerjakan")
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
