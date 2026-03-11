import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    // Mock authentication
    if (email.isNotEmpty && password.length >= 6) {
      _user = UserModel(
        id: '1',
        fullName: 'Rahma',
        email: email,
        xp: 166,
        level: 1,
        badges: ['🌟 First Quest'],
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

  void addXp(int amount) {
    if (_user == null) return;
    final newXp = _user!.xp + amount;
    final newLevel = (newXp / 1000).floor() + 1;
    _user = _user!.copyWith(xp: newXp, level: newLevel);
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
