// lib/models/user_model.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // Dibutuhkan untuk ChangeNotifier

/// Kunci yang digunakan untuk menyimpan data user di SharedPreferences.
const String _userPrefsKey = 'user_data_object_v2'; // Menggunakan kunci berbeda untuk menghindari konflik

/// Kelas [User] ini adalah singleton yang menyimpan data user (email, jenis, token)
/// dan secara otomatis mengelola persistensinya ke SharedPreferences.
/// Anda bisa mengakses instance ini kapan saja dari mana saja.
class User with ChangeNotifier {
  // Properti data user yang bisa diubah.
  // Mereka diinisialisasi dengan nilai kosong saat instance dibuat.
  String _email;
  String _jenis;
  String _token;

  // Getter untuk mengakses nilai properti.
  String get email => _email;
  String get jenis => _jenis;
  String get token => _token;

  // Setter untuk mengubah nilai properti.
  // Setiap kali nilai diubah, perubahan akan otomatis disimpan ke SharedPreferences.
  set email(String value) {
    if (_email != value) { // Hanya update dan simpan jika ada perubahan
      _email = value;
      _saveToPrefs();
      notifyListeners();
    }
  }

  set jenis(String value) {
    if (_jenis != value) {
      _jenis = value;
      _saveToPrefs();
      notifyListeners();
    }
  }

  set token(String value) {
    if (_token != value) {
      _token = value;
      _saveToPrefs();
      notifyListeners();
    }
  }

  // --- Singleton Instance ---
  // Instance tunggal dari kelas User ini, siap diakses di seluruh aplikasi.
  // Properti diinisialisasi sebagai kosong secara default.
  static final User _instance = User._internal(
    email: '', // Nilai awal saat aplikasi pertama kali berjalan
    jenis: '',
    token: '',
  );

  // Konstruktor internal/private untuk membuat instance singleton.
  User._internal({
    required String email,
    required String jenis,
    required String token,
  })  : _email = email,
        _jenis = jenis,
        _token = token;

  /// Getter publik untuk mendapatkan instance [User] singleton.
  /// Ini adalah "instance siap pakai" yang Anda maksud.
  static User get instance => _instance;

  // --- Metode Persistensi Internal ---

  /// Metode internal untuk menyimpan status [User] saat ini ke SharedPreferences.
  /// Dipanggil otomatis oleh setter ketika ada perubahan.
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> userDataMap = {
      'email': _email,
      'jenis': _jenis,
      'token': _token,
    };
    final String userDataString = jsonEncode(userDataMap);
    await prefs.setString(_userPrefsKey, userDataString);
    print('DEBUG: User data saved to SharedPreferences: $_email');
  }

  /// Metode statis untuk memuat data [User] dari SharedPreferences
  /// ke dalam instance singleton saat aplikasi dimulai.
  /// **Panggil ini SATU KALI di awal aplikasi (misal di `main.dart`).**
  static Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userDataString = prefs.getString(_userPrefsKey);

    if (userDataString != null && userDataString.isNotEmpty) {
      try {
        final Map<String, dynamic> userDataJson = jsonDecode(userDataString);
        // Memperbarui properti instance singleton dengan data yang dimuat.
        _instance._email = userDataJson['email'] as String? ?? '';
        _instance._jenis = userDataJson['jenis'] as String? ?? '';
        _instance._token = userDataJson['token'] as String? ?? '';
        print('DEBUG: User data loaded from SharedPreferences: ${_instance.email}');
      } catch (e) {
        print('ERROR: Failed to load/decode user data from SharedPreferences: $e');
        // Jika data korup, bersihkan untuk mencegah error berulang.
        await _instance.clearAllData();
      }
    } else {
      print('DEBUG: No user data found in SharedPreferences during load.');
    }
    // Beri tahu listener bahwa data mungkin sudah diupdate (penting untuk UI)
    _instance.notifyListeners();
  }

  /// Metode untuk menghapus semua data user dari SharedPreferences
  /// dan mereset properti di instance [User] menjadi kosong.
  /// Panggil ini saat logout.
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userPrefsKey); // Hapus data dari penyimpanan persisten
    
    // Setel ulang properti di memori ke nilai kosong
    _email = '';
    _jenis = '';
    _token = '';
    notifyListeners(); // Beri tahu listener
    print('DEBUG: All user data cleared from SharedPreferences and memory.');
  }

  // --- Fungsi Pengecekan Status (Sesuai Permintaan Sebelumnya) ---

  /// Memeriksa apakah token pengguna yang sedang aktif adalah null atau kosong.
  /// Mengacu pada properti token dari instance User saat ini.
  bool isTokenNullOrEmpty() {
    return _token.isEmpty;
  }

  /// Mengembalikan jenis pengguna yang sedang aktif.
  /// Mengacu pada properti jenis dari instance User saat ini.
  String? getJenisUser() {
    // Mengembalikan jenis, atau null jika kosong (bisa terjadi jika belum diset)
    return _jenis.isEmpty ? null : _jenis;
  }

  /// Getter untuk mendapatkan status login user secara keseluruhan.
  /// Mengacu pada properti email dan jenis dari instance User saat ini.
  UserTypeStatus getLoginStatus() {
    if (_email.isEmpty && _token.isEmpty) {
      return UserTypeStatus.notLoggedIn;
    } else if (_jenis.toUpperCase() == 'KADER') {
      return UserTypeStatus.loggedInKader;
    } else if (_jenis.toUpperCase() == 'IBU') { // Asumsi 'IBU' atau 'IBU_RUMAH'
      return UserTypeStatus.loggedInIbuRumah;
    }
    return UserTypeStatus.loggedInOther; // Jenis lain yang terautentikasi
  }

  @override
  String toString() {
    if (_token.isEmpty) {
      return 'User(email: $_email, jenis: $_jenis, token: (empty))';
    }
    return 'User(email: $_email, jenis: $_jenis, token: ${_token.substring(0, 5)}...)';
  }
}

/// Enum untuk mengidentifikasi status dan jenis pengguna saat login.
enum UserTypeStatus {
  loggedInKader,
  loggedInIbuRumah,
  loggedInOther,
  notLoggedIn,
  error, // Opsional, untuk menandakan error saat memuat data misalnya
}