import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Level-up notification
  bool _justLeveledUp = false;
  int _newLevel = 1;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get errorMessage => _errorMessage;
  bool get justLeveledUp => _justLeveledUp;
  int get newLevel => _newLevel;

  void clearLevelUp() {
    _justLeveledUp = false;
    notifyListeners();
  }

  // ─── Auth ─────────────────────────────────────────────────────────────────

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (email.isNotEmpty && password.length >= 6) {
      _user = UserModel(
        id: '1',
        fullName: 'Rahma',
        email: email,
        xp: 0,
        level: 1,
        streak: 0,
        completedMissionsCount: 0,
        badges: [],
      );
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _errorMessage = 'Invalid email or password';
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> signUp(String fullName, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (fullName.isNotEmpty && email.isNotEmpty && password.length >= 6) {
      _user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fullName: fullName,
        email: email,
        xp: 0,
        level: 1,
        streak: 0,
        completedMissionsCount: 0,
        badges: [],
      );
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _errorMessage = 'Please fill in all fields correctly';
    _isLoading = false;
    notifyListeners();
    return false;
  }

  void updateUser(UserModel updated) {
    _user = updated;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _justLeveledUp = false;
    notifyListeners();
  }

  // ─── Gamification ─────────────────────────────────────────────────────────

  /// Called when a mission is completed. Awards XP and checks level-up.
  void onMissionCompleted(int xpEarned) {
    if (_user == null) return;

    final oldLevel = _user!.level;
    final newXp = _user!.xp + xpEarned;
    final newLevel = (newXp ~/ UserModel.xpPerLevel) + 1;

    // Build updated badges list
    final newBadges = List<String>.from(_user!.badges);
    if (_user!.completedMissionsCount == 0 &&
        !newBadges.contains('🌟 First Quest')) {
      newBadges.add('🌟 First Quest');
    }
    if (newLevel >= 2 && !newBadges.contains('🔥 On Fire')) {
      newBadges.add('🔥 On Fire');
    }
    if (_user!.completedMissionsCount >= 4 &&
        !newBadges.contains('💪 Consistent')) {
      newBadges.add('💪 Consistent');
    }

    _user = _user!.copyWith(
      xp: newXp,
      level: newLevel,
      completedMissionsCount: _user!.completedMissionsCount + 1,
      badges: newBadges,
    );

    if (newLevel > oldLevel) {
      _justLeveledUp = true;
      _newLevel = newLevel;
    }

    notifyListeners();
  }

  /// Call whenever user completes any daily activity to update streak.
  void recordActivity() {
    if (_user == null) return;

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final last = _user!.lastActivityDate;

    int newStreak = _user!.streak;

    if (last == null) {
      newStreak = 1;
    } else {
      final lastDate = DateTime(last.year, last.month, last.day);
      final diff = todayDate.difference(lastDate).inDays;
      if (diff == 0) {
        // Already recorded today — no change
        return;
      } else if (diff == 1) {
        newStreak = _user!.streak + 1;
      } else {
        // Missed a day — reset
        newStreak = 1;
      }
    }

    _user = _user!.copyWith(
      streak: newStreak,
      lastActivityDate: todayDate,
    );
    notifyListeners();
  }
}
