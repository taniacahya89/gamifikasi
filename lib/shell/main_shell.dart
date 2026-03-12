// ============================================================
// FILE: main_shell.dart
// FUNGSI: Shell utama yang mengelola 3 tab bottom navigation.
//
// Menggunakan IndexedStack agar halaman tidak di-rebuild
// setiap kali tab berganti — state setiap halaman tetap terjaga.
// Contoh: scroll position di ProgressPage tidak hilang
// saat user berpindah ke tab Home lalu kembali.
//
// TAB YANG TERSEDIA:
//   Index 0 → HomePage    (ikon rumah)
//   Index 1 → ProgressPage (ikon grafik)
//   Index 2 → ProfilePage  (ikon orang)
// ============================================================

import 'package:flutter/material.dart';
import '../core/widgets/bottom_nav_bar.dart';
import '../features/home/pages/home_page.dart';
import '../features/progress/pages/progress_page.dart';
import '../features/profile/pages/profile_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.child});

  /// [child] dibutuhkan oleh ShellRoute dari GoRouter, tapi tidak digunakan
  /// karena kita mengelola halaman sendiri lewat IndexedStack.
  final Widget child;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  /// Index tab yang sedang aktif (0 = Home, 1 = Progress, 2 = Profile)
  int _indexAktif = 0;

  /// Daftar halaman untuk setiap tab.
  /// Urutan harus sama dengan urutan tab di AppBottomNavBar.
  static const List<Widget> _daftarHalaman = [
    HomePage(),     // Tab 0: Halaman beranda dengan kategori mission
    ProgressPage(), // Tab 1: Halaman statistik progress dan streak
    ProfilePage(),  // Tab 2: Halaman profil dan data akun user
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        // IndexedStack menampilkan satu halaman sekaligus berdasarkan index,
        // tapi semua halaman tetap "hidup" di memory (tidak rebuild ulang)
        index: _indexAktif,
        children: _daftarHalaman,
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _indexAktif,
        // Saat tab ditekan: update index → setState memicu rebuild → halaman berganti
        onTap: (index) => setState(() => _indexAktif = index),
      ),
    );
  }
}
