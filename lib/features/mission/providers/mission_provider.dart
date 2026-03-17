// ============================================================
// FILE: mission_provider.dart
// FUNGSI: Mengelola semua data mission di aplikasi HabitQuest.
//
// Provider ini menyimpan daftar semua mission (template + custom)
// dan menangani semua aksi terkait mission: mencentang task,
// menambah mission baru, menghapus mission, dsb.
//
// HUBUNGAN DENGAN AUTH PROVIDER:
//   Saat mission selesai, provider ini memanggil callback
//   [onMissionCompleted] yang terhubung ke AuthProvider.
//   Koneksi ini dipasang di main.dart menggunakan
//   ChangeNotifierProxyProvider.
//
// ALUR SAAT TASK DICENTANG:
//   toggleTask() → update data → cek apakah semua task selesai
//   → jika selesai → panggil onMissionCompleted(xp)
//   → AuthProvider tambah XP + cek level-up + beri badge
// ============================================================

import 'package:flutter/foundation.dart';
import '../models/mission_model.dart';
import '../models/day_model.dart';
import '../models/task_model.dart';
import '../../auth/models/user_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/services/api_service.dart';

/// Tipe fungsi callback yang dipanggil saat mission selesai.
/// [xpEarned] adalah jumlah XP yang akan diberikan ke user.
typedef MissionCompletedCallback = void Function(int xpEarned);

class MissionProvider extends ChangeNotifier {
  // ──────────────────────────────────────────────────────────
  // STATE INTERNAL
  // ──────────────────────────────────────────────────────────

  /// Daftar semua mission (template bawaan + custom buatan user).
  final List<MissionModel> _missions = [];

  /// Callback ke AuthProvider — dipasang dari main.dart.
  /// Dipanggil saat sebuah mission baru saja selesai 100%.
  MissionCompletedCallback? onMissionCompleted;

  /// Service untuk komunikasi dengan backend
  final ApiService _apiService = ApiService();

  // ──────────────────────────────────────────────────────────
  // GETTERS
  // ──────────────────────────────────────────────────────────

  /// Semua mission yang ada (read-only dari luar provider).
  List<MissionModel> get missions => List.unmodifiable(_missions);

  /// Hanya mission yang sudah selesai 100%.
  List<MissionModel> get completedMissions =>
      _missions.where((m) => m.isCompleted).toList();

  /// Mengambil semua mission dalam satu kategori tertentu.
  /// Digunakan oleh MissionListPage untuk menampilkan daftar mission.
  List<MissionModel> getMissionsByCategory(String category) =>
      _missions.where((m) => m.category == category).toList();

  /// Mencari satu mission berdasarkan ID-nya.
  /// Mengembalikan null jika mission tidak ditemukan.
  MissionModel? getMissionById(String id) {
    try {
      return _missions.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Konstruktor: langsung muat semua template saat provider pertama dibuat.
  MissionProvider() {
    _muatSemuaTemplate();
  }

  // ──────────────────────────────────────────────────────────
  // TEMPLATE MISSION (Data Bawaan Sistem)
  // ──────────────────────────────────────────────────────────

  /// Memuat semua mission template untuk keenam kategori.
  ///
  /// Template adalah mission yang sudah dirancang oleh sistem.
  /// User tidak perlu membuatnya sendiri — langsung tersedia.
  /// isTemplate = true pada semua mission di sini.
  void _muatSemuaTemplate() {
    _missions.addAll([
      // ── MINDSET ──────────────────────────────────────────
      _buatTemplate(
        id: 'tpl_mindset_1',
        title: 'Positive Mind Challenge',
        description: 'Bangun mindset positif selama 7 hari',
        category: 'Mindset',
        judulHari: [
          'Gratitude Start', 'Positive Affirmation', 'Mind Reflection',
          'Mindful Moment', 'Self Appreciation', 'Learn Something New',
          'Weekly Reflection',
        ],
        taskHari: [
          ['Write 3 things you are grateful for', 'Smile and say something positive about today'],
          ['Say 3 positive affirmations', 'Write one thing you like about yourself'],
          ['Write one negative thought you had today', 'Change it into a positive perspective'],
          ['Do 5–10 minutes meditation', 'Take 5 deep breaths slowly'],
          ['Write one achievement today', 'Say thank you to yourself'],
          ['Watch 10 min educational content', 'Write one new thing you learned'],
          ['Write one lesson from this week', 'Write one habit you want to keep'],
        ],
      ),
      // ── HEALTH ───────────────────────────────────────────
      _buatTemplate(
        id: 'tpl_health_1',
        title: 'Morning Wellness Routine',
        description: 'Bangun kebiasaan pagi yang sehat',
        category: 'Health',
        judulHari: [
          'Hydration Start', 'Move Your Body', 'Nourish Well',
          'Rest & Recover', 'Breathe Deep', 'Body Check', 'Health Review',
        ],
        taskHari: [
          ['Drink 2 glasses of water', 'Stretch for 5 minutes'],
          ['Do 10 minutes of exercise', 'Take a short walk outside'],
          ['Eat a healthy breakfast', 'Avoid sugary drinks today'],
          ['Sleep by 10:30 PM', 'No screens 30 min before bed'],
          ['Do breathing exercises', 'Meditate for 5 minutes'],
          ['Write how your body feels', 'Drink 8 glasses of water'],
          ['List 3 healthy choices made', 'Plan next week\'s meals'],
        ],
      ),
      // ── PRODUCTIVITY ─────────────────────────────────────
      _buatTemplate(
        id: 'tpl_productivity_1',
        title: 'Focus Flow Week',
        description: 'Kuasai sistem produktivitasmu',
        category: 'Productivity',
        judulHari: [
          'Priority Setup', 'Deep Work', 'Time Blocking',
          'Energy Management', 'Clear the Clutter', 'Reflect & Adjust', 'Weekly Win',
        ],
        taskHari: [
          ['Write 3 top goals for the week', 'Create a daily to-do list'],
          ['Do 25-min focused work session', 'Eliminate one distraction today'],
          ['Schedule tomorrow in advance', 'Review what took too long today'],
          ['Take a proper lunch break', 'Work during your peak hours'],
          ['Organize your workspace', 'Archive old files or emails'],
          ['What did you accomplish this week?', 'What needs improvement?'],
          ['Celebrate one big win', 'Set intentions for next week'],
        ],
      ),
      // ── FINANCE ──────────────────────────────────────────
      _buatTemplate(
        id: 'tpl_finance_1',
        title: 'Money Mindset Week',
        description: 'Bangun kebiasaan finansial yang lebih baik',
        category: 'Finance',
        judulHari: [
          'Track Expenses', 'Budget Review', 'Save First',
          'Cut One Cost', 'Learn Finance', 'Set Goals', 'Weekly Review',
        ],
        taskHari: [
          ['Write down all expenses today', 'Categorize your spending'],
          ['Review last month\'s budget', 'Find one area to improve'],
          ['Set aside 10% of income', 'Open a savings tracker'],
          ['Cancel one unused subscription', 'Cook at home today'],
          ['Read 10 min about investing', 'Write one thing you learned'],
          ['Set a 3-month savings goal', 'Write your financial why'],
          ['Review your progress this week', 'Plan next week\'s budget'],
        ],
      ),
      // ── SELF GROWTH ──────────────────────────────────────
      _buatTemplate(
        id: 'tpl_selfgrowth_1',
        title: 'Level Up Yourself',
        description: 'Investasi dalam pengembangan diri',
        category: 'Self Growth',
        judulHari: [
          'Read & Learn', 'Reflect Deep', 'Face a Fear',
          'New Skill Day', 'Connect & Share', 'Rest Mindfully', 'Growth Review',
        ],
        taskHari: [
          ['Read for 20 minutes', 'Write one key takeaway'],
          ['Journal about your goals', 'Write what holds you back'],
          ['Do one thing outside comfort zone', 'Reflect on how it felt'],
          ['Practice a new skill for 30 min', 'Watch a tutorial video'],
          ['Share something you learned', 'Listen actively to someone'],
          ['Do a digital detox for 2 hours', 'Practice mindful breathing'],
          ['Write 3 ways you grew this week', 'Set 1 goal for next week'],
        ],
      ),
      // ── LIFESTYLE ────────────────────────────────────────
      _buatTemplate(
        id: 'tpl_lifestyle_1',
        title: 'Balanced Life Challenge',
        description: 'Ciptakan rutinitas harian yang lebih bermakna',
        category: 'Lifestyle',
        judulHari: [
          'Morning Ritual', 'Social Day', 'Creative Hour',
          'Nature Time', 'Digital Detox', 'Gratitude Day', 'Life Review',
        ],
        taskHari: [
          ['Wake up 30 min earlier', 'Write your intention for the day'],
          ['Reach out to a friend or family', 'Plan a social activity'],
          ['Spend 30 min on a creative hobby', 'Try something new today'],
          ['Spend 20 min outside', 'Notice 3 things in nature'],
          ['Limit social media to 30 min', 'Enjoy an offline activity'],
          ['Write 5 things you\'re grateful for', 'Do something kind for someone'],
          ['Review your week\'s highlights', 'Plan one fun thing next week'],
        ],
      ),
    ]);
  }

  /// Helper: membuat satu MissionModel bertipe template.
  ///
  /// Semua template memiliki 7 hari. Setiap hari memiliki judul
  /// dan daftar task. Parameter [judulHari] dan [taskHari]
  /// harus memiliki tepat 7 item.
  MissionModel _buatTemplate({
    required String id,
    required String title,
    required String description,
    required String category,
    required List<String> judulHari,
    required List<List<String>> taskHari,
  }) {
    return MissionModel(
      id: id,
      title: title,
      description: description,
      category: category,
      totalDays: 7,
      isTemplate: true,
      createdAt: DateTime.now(),
      days: List.generate(7, (i) {
        return DayModel(
          dayNumber: i + 1,
          title: judulHari[i],
          tasks: List.generate(taskHari[i].length, (j) {
            return TaskModel(
              id: '${id}_d${i + 1}_t$j',
              title: taskHari[i][j],
            );
          }),
        );
      }),
    );
  }

  // ──────────────────────────────────────────────────────────
  // AKSI MISSION (CRUD)
  // ──────────────────────────────────────────────────────────

  /// Menambahkan mission custom baru yang dibuat user.
  ///
  /// Dipanggil dari CreateMissionPage setelah user mengisi form
  /// dan menekan tombol Save. Mission langsung muncul di daftar.
  void addMission(MissionModel mission) {
    _missions.add(mission);
    notifyListeners();
  }

  /// Menghapus mission berdasarkan ID.
  ///
  /// Hanya bisa digunakan untuk mission custom (bukan template).
  /// Dipanggil dari MissionListPage saat user menekan ikon hapus.
  /// Juga menghapus dari backend jika user sudah login.
  Future<void> deleteMission(String id, String? token) async {
    _missions.removeWhere((m) => m.id == id);
    notifyListeners();

    // Jika user sudah login, hapus juga dari backend
    if (token != null) {
      try {
        await _apiService.deleteMission(token, id);
      } catch (e) {
        // Jika gagal menghapus dari backend, biarkan saja
        // karena data lokal sudah dihapus
      }
    }
  }

  /// Mencentang atau membatalkan centang sebuah task.
  ///
  /// PARAMETER:
  ///   [missionId]  → ID mission yang task-nya diubah
  ///   [dayIndex]   → Indeks hari (0 = Hari 1, 6 = Hari 7)
  ///   [taskIndex]  → Indeks task dalam hari tersebut
  ///   [authProvider] → Untuk mendapatkan token dan update progress
  ///
  /// ALUR LENGKAP:
  ///   1. Cari mission di daftar menggunakan missionId
  ///   2. Balik nilai isCompleted pada task yang dipilih
  ///   3. Buat salinan baru hari dan mission dengan data terupdate
  ///   4. Simpan ke _missions dan panggil notifyListeners()
  ///   5. Cek apakah SEMUA task di semua hari sudah selesai
  ///   6. Jika mission baru saja selesai → panggil onMissionCompleted()
  ///      → AuthProvider menerima callback → XP ditambahkan ke user
  ///   7. Jika user login, update progress ke backend
  ///
  /// MENGEMBALIKAN: true jika mission baru saja selesai, false jika belum.
  Future<bool> toggleTask(
    String missionId, 
    int dayIndex, 
    int taskIndex, 
    AuthProvider authProvider
  ) async {
    final idx = _missions.indexWhere((m) => m.id == missionId);
    if (idx == -1) return false; // Mission tidak ditemukan, hentikan

    final mission = _missions[idx];
    final sudahSelesaiSebelumnya = mission.isCompleted;

    // Buat salinan task dengan status dibalik
    final hari = mission.days[dayIndex];
    final task = hari.tasks[taskIndex];

    final taskTerupdate = List<TaskModel>.from(hari.tasks)
      ..[taskIndex] = task.copyWith(isCompleted: !task.isCompleted);

    final hariTerupdate = List<DayModel>.from(mission.days)
      ..[dayIndex] = hari.copyWith(tasks: taskTerupdate);

    // Cek apakah semua task di semua hari sudah selesai setelah update ini
    final semuaSelesai = hariTerupdate.every(
      (d) => d.tasks.isNotEmpty && d.tasks.every((t) => t.isCompleted),
    );

    // Buat salinan mission dengan data hari yang sudah diperbarui
    final missionTerupdate = mission.copyWith(
      days: hariTerupdate,
      // Catat waktu selesai hanya jika baru pertama kali selesai
      completedAt: (!sudahSelesaiSebelumnya && semuaSelesai)
          ? DateTime.now()
          : mission.completedAt,
    );

    _missions[idx] = missionTerupdate;
    notifyListeners(); // Perbarui semua widget yang menampilkan mission ini

    // Jika mission baru saja selesai (dari belum selesai menjadi selesai)
    if (!sudahSelesaiSebelumnya && missionTerupdate.isCompleted) {
      // Kirim XP ke AuthProvider lewat callback
      onMissionCompleted?.call(UserModel.xpPerMission);
      
      // Jika user login, update ke backend
      if (authProvider.token != null) {
        try {
          await _apiService.completeMission(authProvider.token!, missionId);
        } catch (e) {
          // Jika gagal update ke backend, biarkan saja
          // karena data lokal sudah diperbarui
        }
      }
      
      return true; // Beritahu pemanggil bahwa mission baru selesai
    }
    return false;
  }
}
