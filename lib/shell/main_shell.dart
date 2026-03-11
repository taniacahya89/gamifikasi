import 'package:flutter/material.dart';
import '../core/widgets/bottom_nav_bar.dart';
import '../features/home/pages/home_page.dart';
import '../features/progress/pages/progress_page.dart';
import '../features/profile/pages/profile_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.child});

  // child is required by ShellRoute but we ignore it since we
  // manage our own tab pages internally
  final Widget child;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const List<Widget> _pages = [
    HomePage(),
    ProgressPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
