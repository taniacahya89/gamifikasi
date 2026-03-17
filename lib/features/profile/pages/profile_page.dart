// ============================================================
// FILE: profile_page.dart
// FUNGSI: Halaman profil user yang menampilkan identitas,
//         statistik gamifikasi, koleksi badge, dan aksi akun.
//
// STRUKTUR HALAMAN (dari atas ke bawah):
//   1. Header  → Avatar netral + nama + email + label level
//   2. Stats   → XP, Mission, Streak, Level, Badge (5 kartu)
//   3. Badge   → Daftar badge yang sudah diraih
//   4. Aksi    → Tombol Edit Profile dan Logout
//
// FITUR YANG DISEDERHANAKAN:
//   - Avatar: ikon netral (tidak menggambarkan gender)
//   - Tidak ada "change photo" (tidak diperlukan)
//   - Hanya 2 aksi utama: Edit Profile dan Logout
//   - Edit Profile hanya bisa mengubah nama (email tetap)
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../routes/app_router.dart';
import '../../auth/models/user_model.dart';
import '../../auth/providers/auth_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // context.watch: rebuild otomatis saat data user berubah
    final user = context.watch<AuthProvider>().user;
    if (user == null) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Bagian 1: Header Profil ────────────────────────────
            _ProfileHeader(user: user),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Bagian 2: Statistik Gamifikasi ──────────────────
                  _StatsGrid(user: user),
                  const SizedBox(height: 24),

                  // ── Bagian 3: Koleksi Badge ──────────────────────────
                  const _SectionTitle('🎖️ Koleksi Badge'),
                  const SizedBox(height: 12),
                  _BadgeSection(user: user),
                  const SizedBox(height: 24),

                  // ── Bagian 4: Aksi Akun ──────────────────────────────
                  const _SectionTitle('⚙️ Akun'),
                  const SizedBox(height: 12),
                  _AccountActions(user: user),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// BAGIAN 1: HEADER PROFIL
// ══════════════════════════════════════════════════════════════

/// Widget header profil dengan latar biru ungu.
/// Menampilkan avatar netral, nama, email, dan label level.
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 36),
      child: Column(
        children: [
          // Avatar lingkaran dengan ikon netral (sama untuk semua user)
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.white.withOpacity(0.5),
                width: 2.5,
              ),
            ),
            child: const Center(
              // Ikon bintang — netral, tidak menggambarkan gender
              child: Text('⭐', style: TextStyle(fontSize: 38)),
            ),
          ),
          const SizedBox(height: 14),

          // Nama user (bisa diubah lewat Edit Profile)
          Text(
            user.fullName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 4),

          // Email (tidak bisa diubah — identitas akun)
          Text(
            user.email,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xCCFFFFFF),
            ),
          ),
          const SizedBox(height: 12),

          // Label level dengan warna coral
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.coral,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'Level ${user.level} · ${_getLevelTitle(user.level)}',
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Mengembalikan gelar/judul berdasarkan level user.
  /// Semakin tinggi level, semakin bergengsi gelarnya.
  String _getLevelTitle(int level) {
    if (level >= 10) return 'Legend';
    if (level >= 7) return 'Master';
    if (level >= 5) return 'Expert';
    if (level >= 3) return 'Adventurer';
    if (level >= 2) return 'Explorer';
    return 'Beginner';
  }
}

// ══════════════════════════════════════════════════════════════
// BAGIAN 2: STATISTIK GAMIFIKASI
// ══════════════════════════════════════════════════════════════

/// Grid 5 kartu statistik: XP, Mission, Streak, Level, Badge.
///
/// Disusun dalam dua baris:
///   Baris 1: XP · Mission · Streak  (3 kolom)
///   Baris 2: Level · Badge          (2 kolom, lebih lebar)
class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Baris pertama: 3 statistik
        Row(
          children: [
            _StatCard(
              icon: '⭐',
              label: 'XP Points',
              value: '${user.xp}',
              valueColor: AppColors.coral,
            ),
            const SizedBox(width: 10),
            _StatCard(
              icon: '🏆',
              label: 'Mission',
              value: '${user.completedMissionsCount}',
              valueColor: AppColors.primary,
            ),
            const SizedBox(width: 10),
            _StatCard(
              icon: '🔥',
              label: 'Streak',
              value: '${user.streak}d',
              valueColor: AppColors.coral,
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Baris kedua: Level dan Badge (2 kolom, lebih lebar)
        Row(
          children: [
            _StatCard(
              icon: '📈',
              label: 'Level',
              value: '${user.level}',
              valueColor: AppColors.primary,
            ),
            const SizedBox(width: 10),
            _StatCard(
              icon: '🎖️',
              label: 'Badge',
              value: '${user.badges.length}',
              valueColor: AppColors.successGreen,
            ),
          ],
        ),
      ],
    );
  }
}

/// Satu kartu statistik dengan ikon, nilai, dan label.
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String icon;
  final String label;
  final String value;
  final Color valueColor; // Warna angka nilai (beda tiap stat)

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Color(0x0A000000), blurRadius: 6),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: valueColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.greyText,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// BAGIAN 3: KOLEKSI BADGE
// ══════════════════════════════════════════════════════════════

/// Menampilkan semua badge yang sudah diraih user dalam bentuk chips.
/// Jika belum ada badge, tampilkan pesan ajakan.
class _BadgeSection extends StatelessWidget {
  const _BadgeSection({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    if (user.badges.isEmpty) {
      // Belum ada badge — tampilkan panduan cara mendapatkannya
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Column(
          children: [
            Text('🎯', style: TextStyle(fontSize: 32)),
            SizedBox(height: 8),
            Text(
              'Selesaikan mission untuk\nmendapatkan badge pertamamu!',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Tampilkan badge dalam bentuk chips yang bisa dibungkus (Wrap)
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: user.badges.map((badge) => _BadgeChip(label: badge)).toList(),
    );
  }
}

/// Chip badge dengan latar putih dan bayangan ringan.
class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.label});

  final String label; // Nama badge, misal "🌟 First Quest"

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), blurRadius: 6),
        ],
        border: Border.all(color: AppColors.primaryLight, width: 1.5),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.darkText,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// BAGIAN 4: AKSI AKUN
// ══════════════════════════════════════════════════════════════

/// Dua tombol aksi utama: Edit Profile dan Logout.
///
/// Edit Profile → navigasi ke EditProfilePage
/// Logout → hapus sesi user → router arahkan ke Login
class _AccountActions extends StatelessWidget {
  const _AccountActions({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tombol Edit Profile
        _ActionButton(
          icon: Icons.edit_rounded,
          label: 'Edit Profile',
          onTap: () => context.push(AppRoutes.editProfile),
        ),
        const SizedBox(height: 10),

        // Tombol Logout (warna merah sebagai peringatan)
        _ActionButton(
          icon: Icons.logout_rounded,
          label: 'Logout',
          isDestructive: true,
          onTap: () => _konfirmasiLogout(context),
        ),
      ],
    );
  }

  /// Menampilkan dialog konfirmasi sebelum logout.
  /// Mencegah user logout secara tidak sengaja.
  void _konfirmasiLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Keluar Akun?',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: const Text(
          'Kamu akan keluar dari akun ini.\nYakin ingin logout?',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          // Tombol batal
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Batal',
              style: TextStyle(
                color: AppColors.greyText,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          // Tombol logout (merah)
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // Tutup dialog dulu
              context.read<AuthProvider>().logout(); // Hapus sesi
              // Router otomatis ke Login karena isAuthenticated = false
              context.go(AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.coral,
              foregroundColor: AppColors.white,
              shape: const StadiumBorder(),
              elevation: 0,
            ),
            child: const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

/// Satu tombol aksi dengan ikon, label, dan warna yang bisa dikustomisasi.
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive; // true = tampilkan dengan warna merah/coral

  @override
  Widget build(BuildContext context) {
    // Warna teks dan ikon berdasarkan tipe tombol
    final color = isDestructive ? AppColors.coral : AppColors.darkText;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Color(0x08000000), blurRadius: 6),
          ],
        ),
        padding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            // Ikon dalam lingkaran kecil
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDestructive
                    ? AppColors.coral.withOpacity(0.1)
                    : AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 14),
            // Label tombol
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
            // Panah ke kanan
            Icon(
              Icons.chevron_right_rounded,
              color: isDestructive ? AppColors.coral : AppColors.lightGrey,
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// WIDGET PEMBANTU: Judul seksi
// ══════════════════════════════════════════════════════════════

/// Teks judul untuk setiap seksi di halaman profil.
class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: AppColors.primary,
      ),
    );
  }
}
