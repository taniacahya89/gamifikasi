// ============================================================
// FILE: app_router.dart
// FUNGSI: Mendefinisikan semua rute (halaman) dalam aplikasi.
//
// Menggunakan package go_router untuk navigasi deklaratif.
// Semua path URL dan widget halaman didefinisikan di sini.
//
// STRUKTUR NAVIGASI:
//   /               → SplashScreen (loading awal)
//   /login          → LoginPage
//   /signup         → SignUpPage
//   /home           → HomePage (dalam ShellRoute/bottom nav)
//   /progress-tab   → ProgressPage (dalam ShellRoute)
//   /profile-tab    → ProfilePage (dalam ShellRoute)
//   /mission-list/:category → MissionListPage
//   /mission/:id    → MissionDetailPage
//   /create-mission → CreateMissionPage
//   /mission-progress/:id → MissionProgressDetailPage
//   /edit-profile   → EditProfilePage
//
// SISTEM REDIRECT OTOMATIS:
//   Jika user belum login dan mencoba buka halaman yang butuh login,
//   router otomatis mengarahkan ke /login.
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../features/auth/pages/login_page.dart';
import '../features/auth/pages/signup_page.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/mission/pages/mission_list_page.dart';
import '../features/mission/pages/mission_detail_page.dart';
import '../features/mission/pages/create_mission_page.dart';
import '../features/mission/pages/mission_progress_detail_page.dart';
import '../features/profile/pages/edit_profile_page.dart';
import '../shell/main_shell.dart';
import '../splash/splash_screen.dart';

/// Kelas berisi konstanta semua path rute.
/// Gunakan konstanta ini (bukan string langsung) agar tidak typo.
class AppRoutes {
  AppRoutes._(); // Konstruktor private: kelas tidak bisa di-instansiasi

  // Path halaman statis (tidak berubah)
  static const String splash = '/';
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String createMission = '/create-mission';
  static const String editProfile = '/edit-profile';

  // Path dinamis (menyertakan parameter)
  /// Path daftar mission berdasarkan kategori.
  /// Kategori di-encode agar aman untuk URL (misal "Self Growth" → "Self%20Growth")
  static String missionListPath(String category) =>
      '/mission-list/${Uri.encodeComponent(category)}';

  /// Path halaman detail mission berdasarkan ID
  static String missionDetailPath(String id) => '/mission/$id';

  /// Path halaman progress detail mission berdasarkan ID
  static String missionProgressPath(String id) => '/mission-progress/$id';
}

/// Membuat dan mengembalikan objek GoRouter yang dikonfigurasi penuh.
///
/// [context] dibutuhkan untuk membaca AuthProvider
/// yang digunakan sebagai penjaga (guard) navigasi.
GoRouter createRouter(BuildContext context) {
  final authProvider = context.read<AuthProvider>();

  return GoRouter(
    initialLocation: AppRoutes.splash, // Halaman pertama saat aplikasi dibuka

    // refreshListenable: router akan mengevaluasi ulang redirect
    // setiap kali AuthProvider memanggil notifyListeners().
    // Ini memastikan user otomatis ke Login saat logout.
    refreshListenable: authProvider,

    // Fungsi redirect: dijalankan sebelum setiap navigasi
    redirect: (context, state) {
      final sudahLogin = authProvider.isAuthenticated;
      final halamanSekarang = state.matchedLocation;

      // Halaman yang boleh diakses tanpa login
      final halamanPublik = halamanSekarang == AppRoutes.splash ||
          halamanSekarang == AppRoutes.login ||
          halamanSekarang == AppRoutes.signUp;

      // Jika belum login dan halaman bukan halaman publik → paksa ke Login
      if (!sudahLogin && !halamanPublik) return AppRoutes.login;

      return null; // null = biarkan navigasi berjalan normal
    },

    routes: [
      // ── Halaman Publik ────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (_, __) => const SignUpPage(),
      ),

      // ── Shell Route (Bottom Navigation) ──────────────────────
      // ShellRoute membungkus 3 tab: Home, Progress, Profile.
      // MainShell mengelola tampilan bottom navigation bar-nya.
      ShellRoute(
        builder: (_, __, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (_, __) => const SizedBox.shrink(),
          ),
          GoRoute(
            path: '/progress-tab',
            builder: (_, __) => const SizedBox.shrink(),
          ),
          GoRoute(
            path: '/profile-tab',
            builder: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),

      // ── Daftar Mission per Kategori ────────────────────────────
      // :category adalah parameter dinamis yang diekstrak dari URL
      GoRoute(
        path: '/mission-list/:category',
        builder: (context, state) {
          // Decode kembali kategori dari URL (misal "Self%20Growth" → "Self Growth")
          final kategori = Uri.decodeComponent(
              state.pathParameters['category'] ?? '');
          return MissionListPage(category: kategori);
        },
      ),

      // ── Detail Mission (checklist task harian) ─────────────────
      GoRoute(
        path: '/mission/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return MissionDetailPage(missionId: id);
        },
      ),

      // ── Buat Mission Baru ──────────────────────────────────────
      // [extra] adalah kategori yang sudah dipilih sebelumnya (opsional)
      GoRoute(
        path: AppRoutes.createMission,
        builder: (context, state) {
          final kategoriTerpilih = state.extra as String?;
          return CreateMissionPage(preselectedCategory: kategoriTerpilih);
        },
      ),

      // ── Progress Detail Mission ────────────────────────────────
      GoRoute(
        path: '/mission-progress/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return MissionProgressDetailPage(missionId: id);
        },
      ),

      // ── Edit Profil ────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (_, __) => const EditProfilePage(),
      ),
    ],
  );
}
