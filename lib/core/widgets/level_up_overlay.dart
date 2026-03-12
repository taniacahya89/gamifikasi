// ============================================================
// FILE: level_up_overlay.dart
// FUNGSI: Animasi popup yang muncul saat user naik level.
//
// Popup ini tampil SETELAH badge popup mission selesai ditutup.
// Menampilkan ikon api 🔥 yang berdenyut, nama level baru,
// dan pesan motivasi untuk mendorong user terus aktif.
//
// CARA KERJA:
//   MissionDetailPage memanggil _showLevelUpDialog() setelah
//   badge popup ditutup, jika AuthProvider.justLeveledUp = true.
// ============================================================

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class LevelUpOverlay extends StatefulWidget {
  const LevelUpOverlay({
    super.key,
    required this.newLevel,
    required this.onDismiss,
  });

  final int newLevel;           // Level baru yang baru dicapai user
  final VoidCallback onDismiss; // Dipanggil saat user menekan tombol

  @override
  State<LevelUpOverlay> createState() => _LevelUpOverlayState();
}

class _LevelUpOverlayState extends State<LevelUpOverlay>
    with SingleTickerProviderStateMixin {

  /// Kontroler animasi masuk popup (scale + fade)
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..forward();

  // Animasi scale: popup membesar dari kecil dengan efek membal
  late final Animation<double> _scale = CurvedAnimation(
    parent: _ctrl,
    curve: Curves.elasticOut,
  );

  // Animasi fade: popup muncul dari transparan ke terlihat
  late final Animation<double> _fade = Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(parent: _ctrl, curve: Curves.easeIn),
  );

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: FadeTransition(
        opacity: _fade,
        child: ScaleTransition(
          scale: _scale,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              // Latar gradien ungu gelap → ungu utama
              gradient: const LinearGradient(
                colors: [Color(0xFF4A3396), AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x55000000),
                  blurRadius: 32,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ikon api yang berdenyut (animasi pulse)
                _PulsingFireIcon(),
                const SizedBox(height: 20),

                // Teks "LEVEL UP!"
                const Text(
                  'LEVEL UP!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: AppColors.white,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 8),

                // Nomor level baru
                Text(
                  'Kamu mencapai Level ${widget.newLevel}!',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xCCFFFFFF),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Kotak pesan motivasi
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0x33FFFFFF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    '🌟 Kebiasaan baikmu terus tumbuh!\nKamu tidak bisa dihentikan.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.white,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),

                // Tombol tutup popup
                GestureDetector(
                  onTap: widget.onDismiss,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'KEREN BANGET! 🎉',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                        letterSpacing: 1,
                      ),
                    ),
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
// WIDGET PEMBANTU: Ikon api yang berdenyut
// ──────────────────────────────────────────────────────────────

/// Ikon 🔥 di dalam lingkaran yang berdenyut naik-turun (pulse effect).
/// Animasi repeat + reverse membuat ikon terlihat hidup.
class _PulsingFireIcon extends StatefulWidget {
  @override
  State<_PulsingFireIcon> createState() => _PulsingFireIconState();
}

class _PulsingFireIconState extends State<_PulsingFireIcon>
    with SingleTickerProviderStateMixin {

  /// Kontroler animasi denyut: scale naik ke 1.15 lalu turun kembali
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
    lowerBound: 0.88,
    upperBound: 1.12,
  )..repeat(reverse: true); // Bolak-balik (naik → turun → naik → ...)

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulse,
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: const Color(0x33FFFFFF),
          shape: BoxShape.circle,
          // Efek cahaya ungu di sekitar lingkaran
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.6),
              blurRadius: 30,
              spreadRadius: 6,
            ),
          ],
        ),
        child: const Center(
          child: Text('🔥', style: TextStyle(fontSize: 46)),
        ),
      ),
    );
  }
}
