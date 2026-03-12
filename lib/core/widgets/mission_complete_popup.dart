// ============================================================
// FILE: mission_complete_popup.dart
// FUNGSI: Popup reward yang muncul saat user menyelesaikan
//         mission 7 hari penuh (berbeda dari animasi level-up).
//
// Popup ini menampilkan badge khusus sesuai kategori mission
// yang baru diselesaikan, disertai pesan apresiasi untuk user.
//
// CARA KERJA:
//   MissionDetailPage memanggil showMissionCompletePopup()
//   saat toggleTask() mendeteksi mission baru saja selesai.
//   Popup ini tampil LEBIH DULU sebelum animasi level-up (jika ada).
//
// TAMPILAN:
//   - Latar putih bersih dengan aksen warna kategori
//   - Ikon badge besar yang berputar masuk (animasi rotate+scale)
//   - Nama mission dan kategori
//   - Pesan apresiasi personal
//   - Tombol "Klaim Badge!" untuk menutup popup
// ============================================================

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

// ──────────────────────────────────────────────────────────────
// FUNGSI UTAMA: Menampilkan popup badge mission selesai
// ──────────────────────────────────────────────────────────────

/// Menampilkan dialog popup badge reward saat mission selesai.
///
/// PARAMETER:
///   [context]       → BuildContext untuk menampilkan dialog
///   [missionTitle]  → Nama mission yang baru selesai
///   [category]      → Kategori mission (untuk memilih warna & badge)
///   [onDismiss]     → Fungsi yang dipanggil setelah popup ditutup
///
/// CARA MEMANGGIL dari MissionDetailPage:
///   showMissionCompletePopup(
///     context: context,
///     missionTitle: mission.title,
///     category: mission.category,
///     onDismiss: () { /* lanjutkan proses level-up jika ada */ },
///   );
Future<void> showMissionCompletePopup({
  required BuildContext context,
  required String missionTitle,
  required String category,
  required VoidCallback onDismiss,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,        // User harus tekan tombol untuk tutup
    barrierColor: const Color(0x88000000), // Latar belakang semi-transparan
    builder: (_) => MissionCompletePopup(
      missionTitle: missionTitle,
      category: category,
      onDismiss: onDismiss,
    ),
  );
}

// ──────────────────────────────────────────────────────────────
// WIDGET POPUP
// ──────────────────────────────────────────────────────────────

class MissionCompletePopup extends StatefulWidget {
  const MissionCompletePopup({
    super.key,
    required this.missionTitle,
    required this.category,
    required this.onDismiss,
  });

  final String missionTitle;  // Nama mission yang selesai
  final String category;      // Kategori untuk warna dan ikon badge
  final VoidCallback onDismiss;

  @override
  State<MissionCompletePopup> createState() => _MissionCompletePopupState();
}

class _MissionCompletePopupState extends State<MissionCompletePopup>
    with SingleTickerProviderStateMixin {

  // --- Kontroler animasi masuk popup ---
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..forward(); // Mulai animasi langsung saat popup tampil

  // Animasi scale: popup muncul dari kecil ke ukuran normal
  late final Animation<double> _scale = CurvedAnimation(
    parent: _ctrl,
    curve: Curves.elasticOut, // Efek "membal" saat muncul
  );

  // Animasi fade: popup muncul secara bertahap (transparan → terlihat)
  late final Animation<double> _fade = Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.5)),
  );

  // Animasi geser bintang: naik dari bawah ke posisi normal
  late final Animation<double> _slideUp = Tween<double>(begin: 40, end: 0)
      .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

  @override
  void dispose() {
    _ctrl.dispose(); // Selalu dispose controller untuk hindari memory leak
    super.dispose();
  }

  // ──────────────────────────────────────────────────────────
  // DATA BADGE PER KATEGORI
  // ──────────────────────────────────────────────────────────

  /// Mengembalikan data visual badge berdasarkan kategori mission.
  ///
  /// Setiap kategori punya:
  ///   - [emoji]: ikon utama badge
  ///   - [badgeLabel]: nama badge yang diraih
  ///   - [warna]: warna aksen popup
  ///   - [pesanApresiasi]: pesan motivasi personal
  _BadgeData _getBadgeData() {
    switch (widget.category) {
      case 'Mindset':
        return _BadgeData(
          emoji: '🧠',
          badgeLabel: 'Mindset Master',
          warna: const Color(0xFF7BB8D4),
          warnaLatar: const Color(0xFFEAF3FB),
          pesanApresiasi: 'Pikiran positifmu kini semakin kuat!\nTerus jaga mindset terbaikmu.',
        );
      case 'Health':
        return _BadgeData(
          emoji: '💚',
          badgeLabel: 'Wellness Champion',
          warna: AppColors.successGreen,
          warnaLatar: AppColors.cardGreen,
          pesanApresiasi: 'Tubuhmu berterima kasih kepadamu!\nKebiasaan sehatmu sudah terbentuk.',
        );
      case 'Productivity':
        return _BadgeData(
          emoji: '⚡',
          badgeLabel: 'Focus Hero',
          warna: AppColors.coral,
          warnaLatar: AppColors.cardPink,
          pesanApresiasi: 'Produktivitasmu meningkat pesat!\nKamu adalah mesin pencapaian sejati.',
        );
      case 'Finance':
        return _BadgeData(
          emoji: '💰',
          badgeLabel: 'Money Wise',
          warna: AppColors.iconTeal,
          warnaLatar: const Color(0xFFE8F4FB),
          pesanApresiasi: 'Kebiasaan finansialmu makin solid!\nMasa depanmu semakin cerah.',
        );
      case 'Self Growth':
        return _BadgeData(
          emoji: '🌸',
          badgeLabel: 'Growth Seeker',
          warna: AppColors.primary,
          warnaLatar: AppColors.primaryLight,
          pesanApresiasi: 'Kamu terus bertumbuh setiap harinya!\nVersi terbaikmu sedang berkembang.',
        );
      case 'Lifestyle':
        return _BadgeData(
          emoji: '🌿',
          badgeLabel: 'Life Balancer',
          warna: AppColors.iconGreen,
          warnaLatar: AppColors.cardMint,
          pesanApresiasi: 'Hidupmu semakin seimbang dan bermakna!\nNikmati setiap momen terbaikmu.',
        );
      default:
        return _BadgeData(
          emoji: '🏅',
          badgeLabel: 'Quest Finisher',
          warna: AppColors.primary,
          warnaLatar: AppColors.primaryLight,
          pesanApresiasi: 'Luar biasa! Kamu berhasil menyelesaikan\ntantangan 7 hari ini!',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final badge = _getBadgeData();

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: FadeTransition(
        opacity: _fade,
        child: ScaleTransition(
          scale: _scale,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 32,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Header berwarna sesuai kategori ──────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  decoration: BoxDecoration(
                    color: badge.warnaLatar,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: Column(
                    children: [
                      // Label "7 Day Challenge Completed!"
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: badge.warna.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                              color: badge.warna.withOpacity(0.4), width: 1),
                        ),
                        child: Text(
                          '✦  7 Day Challenge Completed!  ✦',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: badge.warna,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Ikon badge utama dengan efek geser naik
                      AnimatedBuilder(
                        animation: _slideUp,
                        builder: (_, child) => Transform.translate(
                          offset: Offset(0, _slideUp.value),
                          child: child,
                        ),
                        child: _BadgeCircle(
                          emoji: badge.emoji,
                          warna: badge.warna,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Nama badge
                      Text(
                        badge.badgeLabel,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: badge.warna,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Label "Badge Diraih"
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: badge.warna.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Badge Diraih! 🎖️',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: badge.warna,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Bagian bawah: info mission + pesan + tombol ──────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                  child: Column(
                    children: [
                      // Nama mission yang selesai
                      Text(
                        '"${widget.missionTitle}"',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.darkText,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),

                      // Pesan apresiasi untuk user
                      Text(
                        badge.pesanApresiasi,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.greyText,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // Info XP
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              '⭐  +166 XP ditambahkan!',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Tombol Klaim Badge
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: widget.onDismiss,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: badge.warna,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: const StadiumBorder(),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Klaim Badge! 🎉',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// WIDGET PEMBANTU: Lingkaran badge dengan animasi berputar
// ──────────────────────────────────────────────────────────────

/// Widget lingkaran dengan ikon emoji di tengah.
/// Ikon berputar perlahan (infinite rotation) untuk efek visual.
class _BadgeCircle extends StatefulWidget {
  const _BadgeCircle({required this.emoji, required this.warna});

  final String emoji;  // Emoji yang ditampilkan di tengah lingkaran
  final Color warna;   // Warna lingkaran luar

  @override
  State<_BadgeCircle> createState() => _BadgeCircleState();
}

class _BadgeCircleState extends State<_BadgeCircle>
    with SingleTickerProviderStateMixin {
  // Animasi rotasi yang berjalan terus (repeat = true)
  late final AnimationController _rotCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 8), // Satu putaran penuh dalam 8 detik
  )..repeat(); // Berputar terus tanpa henti

  @override
  void dispose() {
    _rotCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Lingkaran luar yang berputar (ring dekoratif)
        RotationTransition(
          turns: _rotCtrl,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.warna.withOpacity(0.3),
                width: 2,
              ),
              gradient: SweepGradient(
                colors: [
                  widget.warna.withOpacity(0),
                  widget.warna.withOpacity(0.2),
                  widget.warna.withOpacity(0.4),
                  widget.warna.withOpacity(0),
                ],
              ),
            ),
          ),
        ),
        // Lingkaran dalam (latar emoji)
        Container(
          width: 82,
          height: 82,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.warna.withOpacity(0.12),
            boxShadow: [
              BoxShadow(
                color: widget.warna.withOpacity(0.25),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(widget.emoji, style: const TextStyle(fontSize: 40)),
          ),
        ),
        // Bintang-bintang kecil dekoratif di sudut lingkaran
        ..._buildDecoStars(widget.warna),
      ],
    );
  }

  /// Membuat 4 bintang kecil di sekitar lingkaran badge.
  List<Widget> _buildDecoStars(Color warna) {
    const positions = [
      Offset(-42, -12),
      Offset(42, -12),
      Offset(-30, 36),
      Offset(30, 36),
    ];
    return positions.map((pos) {
      return Positioned(
        left: 50 + pos.dx,
        top: 50 + pos.dy,
        child: Text(
          '✦',
          style: TextStyle(
            fontSize: 10,
            color: warna.withOpacity(0.5),
          ),
        ),
      );
    }).toList();
  }
}

// ──────────────────────────────────────────────────────────────
// DATA CLASS: Menyimpan data visual badge per kategori
// ──────────────────────────────────────────────────────────────

/// Kelas pembantu untuk menyimpan data visual badge.
/// Dibuat sebagai private class karena hanya digunakan di file ini.
class _BadgeData {
  final String emoji;           // Ikon utama badge
  final String badgeLabel;      // Nama badge yang ditampilkan
  final Color warna;            // Warna utama (tombol, teks, aksen)
  final Color warnaLatar;       // Warna latar header popup
  final String pesanApresiasi;  // Pesan motivasi untuk user

  const _BadgeData({
    required this.emoji,
    required this.badgeLabel,
    required this.warna,
    required this.warnaLatar,
    required this.pesanApresiasi,
  });
}
