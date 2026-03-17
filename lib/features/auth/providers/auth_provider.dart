// ============================================================
// FILE: auth_provider.dart
// FUNGSI: Mengelola autentikasi user dan sistem gamifikasi.
//
// Provider ini adalah "pusat data" untuk semua informasi user.
// Ketika ada perubahan (XP naik, streak bertambah, dll),
// provider akan memanggil notifyListeners() agar semua widget
// yang mendengarkan data ini otomatis diperbarui tampilannya.
//
// ALUR UTAMA:
//   Login/SignUp → Buat data user baru
//   onMissionCompleted() → Tambah XP, cek level-up, beri badge
//   recordActivity() → Perbarui streak harian
//   logout() → Hapus data sesi
// ============================================================

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import '../models/user_model.dart';
import '../../../core/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  // ──────────────────────────────────────────────────────────
  // STATE INTERNAL (Data yang dikelola provider ini)
  // ──────────────────────────────────────────────────────────

  UserModel? _user;        // Data user yang sedang login (null = belum login)
  bool _isLoading = false; // Status loading saat proses autentikasi berjalan
  String? _errorMessage;   // Pesan error jika login/signup gagal
  String? _token;          // Token autentikasi dari backend

  // --- State Notifikasi Level-Up ---
  // Dua variabel ini digunakan untuk memberi tahu MissionDetailPage
  // bahwa user baru saja naik level dan perlu menampilkan animasi.
  bool _justLeveledUp = false; // true = animasi level-up harus ditampilkan
  int _newLevel = 1;           // Level baru setelah naik

  // ──────────────────────────────────────────────────────────
  // GETTERS (Data yang bisa dibaca dari widget/halaman lain)
  // ──────────────────────────────────────────────────────────

  UserModel? get user => _user;

  /// true jika proses login/signup sedang berjalan (tampilkan loading spinner)
  bool get isLoading => _isLoading;

  /// true jika user sudah login (ada data _user yang tersimpan)
  bool get isAuthenticated => _user != null;

  /// Pesan error terakhir (null jika tidak ada error)
  String? get errorMessage => _errorMessage;

  /// Token autentikasi (null jika belum login)
  String? get token => _token;

  /// true jika user baru saja naik level (digunakan MissionDetailPage)
  bool get justLeveledUp => _justLeveledUp;

  /// Level baru user setelah naik level
  int get newLevel => _newLevel;

  // ──────────────────────────────────────────────────────────
  // AUTENTIKASI
  // ──────────────────────────────────────────────────────────

  /// Masuk ke akun dengan email dan password.
  ///
  /// Menghubungi backend API untuk autentikasi.
  /// Jika berhasil: menyimpan token dan data user → router otomatis
  ///   mengarahkan ke halaman Home karena isAuthenticated menjadi true.
  /// Jika gagal: _errorMessage diisi dengan pesan error.
  ///
  /// Mengembalikan true jika login berhasil, false jika gagal.
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final apiService = ApiService();
      final result = await apiService.login(email, password);
      
      if (result['success']) {
        final userData = result['data']['data']['user'];
        _token = result['data']['data']['token'];
        _user = UserModel.fromJson(userData);
        
        // Simpan token dan data user ke SharedPreferences
        await _saveAuthData(_token!, userData);
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['error'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e is TimeoutException
          ? 'Koneksi ke server timeout. Periksa koneksi internet Anda.'
          : 'Gagal terhubung ke server';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Mendaftarkan akun baru dengan nama, email, dan password.
  ///
  /// Menghubungi backend API untuk registrasi.
  /// Jika berhasil: user langsung masuk ke sesi login.
  /// Mengembalikan true jika signup berhasil, false jika gagal.
  Future<bool> signUp(String fullName, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final apiService = ApiService();
      final result = await apiService.register(fullName, email, password);
      
      if (result['success']) {
        final userData = result['data']['data']['user'];
        _token = result['data']['data']['token'];
        _user = UserModel.fromJson(userData);
        
        // Simpan token dan data user ke SharedPreferences
        await _saveAuthData(_token!, userData);
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['error'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e is TimeoutException
          ? 'Koneksi ke server timeout. Periksa koneksi internet Anda.'
          : 'Gagal terhubung ke server';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Memperbarui data user secara langsung.
  /// Digunakan dari EditProfilePage saat user mengubah nama.
  ///
  /// Menghubungi backend API untuk update data user.
  /// Setelah dipanggil, semua widget yang menampilkan data user
  /// akan otomatis diperbarui oleh notifyListeners().
  Future<bool> updateUser(UserModel updated) async {
    if (_token == null) return false;

    try {
      final apiService = ApiService();
      final result = await apiService.updateProfile(_token!, updated.toJson());
      
      if (result['success']) {
        _user = UserModel.fromJson(result['data']);
        // Update data di SharedPreferences
        await _saveAuthData(_token!, result['data']);
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['error'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Gagal memperbarui profil';
      notifyListeners();
      return false;
    }
  }

  /// Keluar dari akun (logout).
  ///
  /// Menghapus semua data sesi user dari memory dan SharedPreferences.
  /// Setelah ini: isAuthenticated = false → router otomatis ke halaman Login.
  Future<void> logout() async {
    _user = null;
    _token = null;
    _justLeveledUp = false;
    
    // Hapus data dari SharedPreferences
    await _clearAuthData();
    
    notifyListeners();
  }

  /// Load auth data dari SharedPreferences saat aplikasi dibuka
  Future<void> loadAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userData = prefs.getString('user_data');
      
      if (token != null && userData != null) {
        _token = token;
        _user = UserModel.fromJson(jsonDecode(userData));
        notifyListeners();
      }
    } catch (e) {
      print('Error loading auth data: $e');
    }
  }

  /// Simpan auth data ke SharedPreferences
  Future<void> _saveAuthData(String token, Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('user_data', jsonEncode(userData));
    } catch (e) {
      print('Error saving auth data: $e');
    }
  }

  /// Hapus auth data dari SharedPreferences
  Future<void> _clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
    } catch (e) {
      print('Error clearing auth data: $e');
    }
  }

  // ──────────────────────────────────────────────────────────
  // SISTEM GAMIFIKASI: XP, LEVEL, BADGE
  // ──────────────────────────────────────────────────────────

  /// Dipanggil oleh MissionProvider ketika sebuah mission selesai 100%.
  ///
  /// ALUR LENGKAP fungsi ini:
  ///   1. Tambahkan [xpEarned] ke total XP user
  ///   2. Hitung level baru: level = (totalXP ÷ 1000) + 1
  ///   3. Jika level naik → set _justLeveledUp = true
  ///      (MissionDetailPage akan menampilkan animasi api)
  ///   4. Cek badge baru yang berhak diraih user
  ///   5. Simpan semua perubahan → notifyListeners() memperbarui UI
  ///
  /// Parameter [xpEarned]: jumlah XP yang didapat (biasanya 166 XP)
  void onMissionCompleted(int xpEarned) {
    if (_user == null) return;

    final levelLama = _user!.level;

    // Hitung XP dan level baru
    final xpBaru = _user!.xp + xpEarned;
    final levelBaru = (xpBaru ~/ UserModel.xpPerLevel) + 1;

    // --- Pengecekan Badge ---
    // Setiap badge hanya bisa diraih satu kali (cek dengan contains)
    final badgeBaru = List<String>.from(_user!.badges);

    // Badge "First Quest": diraih saat menyelesaikan mission pertama
    if (_user!.completedMissionsCount == 0 &&
        !badgeBaru.contains('🌟 First Quest')) {
      badgeBaru.add('🌟 First Quest');
    }

    // Badge "On Fire": diraih saat pertama kali naik ke Level 2
    if (levelBaru >= 2 && !badgeBaru.contains('🔥 On Fire')) {
      badgeBaru.add('🔥 On Fire');
    }

    // Badge "Consistent": diraih setelah menyelesaikan 5 mission
    if (_user!.completedMissionsCount >= 4 &&
        !badgeBaru.contains('💪 Consistent')) {
      badgeBaru.add('💪 Consistent');
    }

    // Simpan semua perubahan ke data user
    _user = _user!.copyWith(
      xp: xpBaru,
      level: levelBaru,
      completedMissionsCount: _user!.completedMissionsCount + 1,
      badges: badgeBaru,
    );

    // Tandai level-up agar MissionDetailPage bisa menampilkan animasi
    if (levelBaru > levelLama) {
      _justLeveledUp = true;
      _newLevel = levelBaru;
    }

    notifyListeners();
  }

  /// Mereset flag level-up setelah animasi selesai ditampilkan.
  ///
  /// Dipanggil dari MissionDetailPage setelah dialog level-up ditutup user.
  /// Ini mencegah animasi muncul berulang saat widget di-rebuild.
  void clearLevelUp() {
    _justLeveledUp = false;
    notifyListeners();
  }

  // ──────────────────────────────────────────────────────────
  // SISTEM STREAK
  // ──────────────────────────────────────────────────────────

  /// Mencatat bahwa user aktif hari ini (untuk memperbarui streak).
  ///
  /// LOGIKA STREAK:
  ///   • Belum pernah aktif sebelumnya → streak = 1
  ///   • Aktif hari ini DAN kemarin (selisih 1 hari) → streak + 1
  ///   • Melewatkan 1 hari atau lebih → streak kembali ke 1
  ///   • Sudah tercatat hari ini → tidak ada perubahan (return awal)
  ///
  /// Dipanggil setiap kali user mencentang task di MissionDetailPage.
  /// Hasilnya langsung terlihat di HomeHeader dan ProfilePage.
  void recordActivity() {
    if (_user == null) return;

    final sekarang = DateTime.now();
    // Ambil tanggal saja (tanpa jam/menit/detik) agar perbandingan akurat
    final hariIni = DateTime(sekarang.year, sekarang.month, sekarang.day);
    final aktivitasTerakhir = _user!.lastActivityDate;

    int streakBaru = _user!.streak;

    if (aktivitasTerakhir == null) {
      // Pertama kali user aktif
      streakBaru = 1;
    } else {
      final hariTerakhir = DateTime(
        aktivitasTerakhir.year,
        aktivitasTerakhir.month,
        aktivitasTerakhir.day,
      );
      final selisihHari = hariIni.difference(hariTerakhir).inDays;

      if (selisihHari == 0) {
        // Sudah dicatat hari ini — tidak perlu update streak
        return;
      } else if (selisihHari == 1) {
        // Hari berturut-turut → streak bertambah 1
        streakBaru = _user!.streak + 1;
      } else {
        // Melewatkan hari → streak direset ke 1
        streakBaru = 1;
      }
    }

    _user = _user!.copyWith(
      streak: streakBaru,
      lastActivityDate: hariIni,
    );
    notifyListeners();
  }
}
