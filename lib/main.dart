// ============================================================
// FILE: main.dart
// FUNGSI: Titik masuk utama aplikasi HabitQuest.
//
// File ini melakukan 3 hal penting:
//   1. Mendaftarkan semua Provider (pengelola data global)
//   2. Menghubungkan MissionProvider dengan AuthProvider
//      agar XP otomatis bertambah saat mission selesai
//   3. Menyiapkan router navigasi dan tema visual aplikasi
//
// HIERARKI WIDGET:
//   HabitQuestApp (MultiProvider)
//     └── _RouterApp (MaterialApp.router)
//           └── Router (GoRouter) → menentukan halaman yang tampil
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/auth/providers/auth_provider.dart';
import 'features/mission/providers/mission_provider.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';

/// Titik masuk aplikasi Flutter.
/// Flutter memanggil fungsi ini pertama kali saat aplikasi dibuka.
void main() {
  runApp(const HabitQuestApp());
}

/// Widget root (paling atas) dalam pohon widget HabitQuest.
///
/// Menggunakan MultiProvider untuk menyediakan data global ke
/// seluruh widget di bawahnya. Semua halaman bisa mengakses
/// AuthProvider dan MissionProvider dari mana saja.
class HabitQuestApp extends StatelessWidget {
  const HabitQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider 1: AuthProvider
        // Mengelola data user (login, XP, level, streak, badge).
        // Dibuat pertama karena MissionProvider bergantung padanya.
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // Provider 2: MissionProvider (terhubung ke AuthProvider)
        // Menggunakan ChangeNotifierProxyProvider agar MissionProvider
        // bisa "berbicara" dengan AuthProvider saat mission selesai.
        //
        // Cara kerjanya:
        //   - [create]: buat MissionProvider baru saat pertama dibuat
        //   - [update]: setiap kali AuthProvider berubah, fungsi ini
        //     dijalankan ulang untuk memperbarui koneksi callback
        ChangeNotifierProxyProvider<AuthProvider, MissionProvider>(
          create: (_) => MissionProvider(),
          update: (_, authProvider, missionProvider) {
            // Pasang callback: saat mission selesai → beri XP ke user
            // Callback ini menghubungkan kedua provider tanpa coupling langsung
            missionProvider!.onMissionCompleted = (xpEarned) {
              // Langkah 1: Tambah XP, cek level-up, beri badge baru
              authProvider.onMissionCompleted(xpEarned);
              // Langkah 2: Perbarui streak harian user
              authProvider.recordActivity();
            };
            return missionProvider;
          },
        ),
      ],
      child: const _RouterApp(),
    );
  }
}

/// Widget aplikasi yang mengatur router navigasi.
///
/// Menggunakan StatefulWidget (bukan StatelessWidget) agar router
/// hanya dibuat satu kali saja menggunakan [late final].
/// Jika dibuat di StatelessWidget, router akan dibuat ulang setiap
/// rebuild yang menyebabkan masalah navigasi.
class _RouterApp extends StatefulWidget {
  const _RouterApp();

  @override
  State<_RouterApp> createState() => _RouterAppState();
}

class _RouterAppState extends State<_RouterApp> {
  /// Router dibuat satu kali dan disimpan (late final = tidak bisa diubah).
  /// context dibutuhkan untuk membaca AuthProvider dari router.
  late final _router = createRouter(context);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'HabitQuest',
      debugShowCheckedModeBanner: false, // Sembunyikan banner "Debug"
      theme: AppTheme.lightTheme,        // Tema visual (warna, font, dll)
      routerConfig: _router,             // Konfigurasi navigasi GoRouter
    );
  }
}
