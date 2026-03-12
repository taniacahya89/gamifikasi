// ============================================================
// FILE: mission_detail_page.dart
// FUNGSI: Halaman utama untuk melihat dan mengerjakan mission.
//
// Halaman ini menampilkan:
//   1. Kartu ringkasan mission (judul, deskripsi, durasi)
//   2. Progress bar keseluruhan mission
//   3. Daftar hari 1–7 dengan task-task yang bisa dicentang
//
// ALUR REWARD SAAT MISSION SELESAI:
//   User centang task terakhir
//   → toggleTask() di MissionProvider mendeteksi mission selesai
//   → onMissionCompleted callback dipanggil → AuthProvider tambah XP
//   → _onToggleTask() di halaman ini menangkap event ini
//   → Tampilkan badge popup dulu (showMissionCompletePopup)
//   → Setelah badge ditutup: cek apakah level naik
//   → Jika level naik → tampilkan animasi level-up
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../../core/widgets/mission_complete_popup.dart';
import '../../../core/widgets/level_up_overlay.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/mission_provider.dart';
import '../widgets/mission_plan_card.dart';
import '../widgets/day_quest_card.dart';

class MissionDetailPage extends StatefulWidget {
  const MissionDetailPage({super.key, required this.missionId});

  final String missionId; // ID mission yang sedang dibuka

  @override
  State<MissionDetailPage> createState() => _MissionDetailPageState();
}

class _MissionDetailPageState extends State<MissionDetailPage> {

  /// Flag untuk mencegah popup muncul dua kali saat rebuild terjadi.
  bool _sedangTampilPopup = false;

  // ──────────────────────────────────────────────────────────
  // FUNGSI UTAMA: Mencentang Task
  // ──────────────────────────────────────────────────────────

  /// Dipanggil setiap kali user mencentang atau membatalkan centang task.
  ///
  /// ALUR LENGKAP:
  ///   1. Panggil toggleTask() di MissionProvider → update data task
  ///   2. Catat aktivitas user hari ini → update streak
  ///   3. Jika mission baru saja selesai → tampilkan badge popup
  ///   4. Setelah badge popup ditutup → cek level-up → tampilkan jika perlu
  ///
  /// [dayIndex]  → Hari ke berapa (0 = Hari 1)
  /// [taskIndex] → Task ke berapa dalam hari tersebut
  void _onToggleTask(int dayIndex, int taskIndex) {
    final missionProvider = context.read<MissionProvider>();
    final authProvider = context.read<AuthProvider>();

    // Centang/batalkan centang task, dapatkan info apakah mission selesai
    final missionBaruSelesai = missionProvider.toggleTask(
      widget.missionId,
      dayIndex,
      taskIndex,
    );

    // Catat aktivitas hari ini untuk sistem streak
    authProvider.recordActivity();

    // Jika mission baru saja selesai dan belum ada popup yang tampil
    if (missionBaruSelesai && !_sedangTampilPopup) {
      _sedangTampilPopup = true;
      _tampilkanBadgePopup();
    }
  }

  /// Menampilkan popup badge reward setelah mission selesai.
  ///
  /// Badge popup ditampilkan PERTAMA KALI setelah mission selesai.
  /// Setelah user menutupnya, fungsi ini mengecek apakah user
  /// juga naik level, dan menampilkan animasi level-up jika perlu.
  void _tampilkanBadgePopup() {
    // Ambil data mission saat ini untuk judul dan kategori
    final mission = context
        .read<MissionProvider>()
        .getMissionById(widget.missionId);

    if (mission == null || !mounted) return;

    // Tampilkan badge popup — barrierDismissible: false (harus tekan tombol)
    showMissionCompletePopup(
      context: context,
      missionTitle: mission.title,
      category: mission.category,
      onDismiss: () {
        // Tutup badge popup
        Navigator.of(context).pop();
        setState(() => _sedangTampilPopup = false);

        // Setelah badge ditutup, cek apakah user juga naik level
        final authProvider = context.read<AuthProvider>();
        if (authProvider.justLeveledUp) {
          authProvider.clearLevelUp(); // Reset flag agar tidak muncul lagi
          _tampilkanLevelUp(authProvider.newLevel);
        }
      },
    );
  }

  /// Menampilkan animasi level-up setelah badge popup ditutup.
  ///
  /// Popup ini berbeda dari badge popup — menampilkan ikon 🔥 berapi
  /// dengan latar gradien ungu dan pesan motivasi level naik.
  void _tampilkanLevelUp(int levelBaru) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => LevelUpOverlay(
        newLevel: levelBaru,
        onDismiss: () => Navigator.of(context).pop(),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // BUILD UI
  // ──────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // context.watch: rebuild otomatis saat data mission berubah
    final mission = context
        .watch<MissionProvider>()
        .getMissionById(widget.missionId);

    // Tampilkan error jika mission tidak ditemukan (misal sudah dihapus)
    if (mission == null) {
      return Scaffold(
        appBar: const CustomAppBar(title: AppStrings.missionDetail),
        body: const Center(
          child: Text('Mission tidak ditemukan'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // AppBar dengan tombol kembali
          const CustomAppBar(title: AppStrings.missionDetail),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Ringkasan Mission ──────────────────────────────
                  const Text(
                    AppStrings.planForWeek,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  MissionPlanCard(mission: mission),
                  const SizedBox(height: 24),

                  // ── Progress Bar ────────────────────────────────────
                  const Text(
                    AppStrings.progressBar,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppProgressBar(
                    value: mission.completedTasks.toDouble(),
                    max: mission.totalTasks.toDouble(),
                    height: 24,
                    showLabel: true, // Tampilkan persentase di dalam bar
                  ),

                  // Banner "Mission Selesai" jika sudah 100%
                  if (mission.isCompleted) ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.cardGreen,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('🎉', style: TextStyle(fontSize: 20)),
                          SizedBox(width: 8),
                          Text(
                            'Mission Selesai! +166 XP',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.successGreen,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),

                  // ── Daftar Hari & Task ─────────────────────────────
                  const Text(
                    AppStrings.dailyQuest,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Generate kartu untuk setiap hari (Hari 1–7)
                  ...List.generate(mission.days.length, (dayIndex) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DayQuestCard(
                        day: mission.days[dayIndex],
                        dayIndex: dayIndex,
                        // Saat task dicentang, panggil _onToggleTask
                        onToggleTask: (taskIndex) =>
                            _onToggleTask(dayIndex, taskIndex),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
