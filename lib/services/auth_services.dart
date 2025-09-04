// lib/services/auth_services.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:balansing/models/user_model.dart';
import 'package:balansing/models/kader_model.dart'; 
import 'package:balansing/models/ibu_model.dart';

/// Kelas [AuthService] ini menyediakan fungsi-fungsi untuk berinteraksi
/// dengan API autentikasi dan mengecek status pengguna.
class AuthService {
  //final String _baseUrl = 'http://10.0.2.2:5500/api/user'; 
  final String _baseUrl = 'http://localhost:5500/api/user'; 


Future<String> resetPassword(String email) async { // Nama fungsi lebih baik diawali huruf kecil
    final url = Uri.parse('$_baseUrl/forgetPass');
    print(url);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      // Periksa status kode respons
      if (response.statusCode == 200) { // Gunakan '==' untuk perbandingan, bukan '=' untuk assignment
        return response.body; 
      } else {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        throw Exception('Gagal reset password. Status: ${response.statusCode}, Pesan: ${errorBody['message'] ?? 'Tidak ada pesan error'}');
      }
    } catch (e) {
      // Tangani error jaringan atau error lainnya
      print('Terjadi kesalahan saat reset password: $e'); // Untuk debug
      throw Exception('Terjadi kesalahan jaringan atau server: $e'); // Lemparkan Exception
    }
}

  Future<String> loginKader(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final String token = responseBody['token'];
        final Map<String, dynamic> userData = responseBody['user'];

        // Pastikan jenis yang dikembalikan adalah 'KADER'
        // Jika backend sudah memvalidasi ini, langkah ini bisa opsional.
        // Namun, ini memberikan keamanan ekstra di sisi klien.
        if (userData['jenis'] != 'KADER') {
          throw Exception('Jenis akun bukan Kader. Silakan login melalui halaman yang sesuai.');
        }

        // Perbarui instance User singleton dengan data yang diterima dari server
        User.instance.email = userData['email'];
        User.instance.jenis = userData['jenis']; // Seharusnya 'KADER'
        User.instance.token = token;

        print('DEBUG: Login Kader berhasil! User: ${User.instance.email}, Jenis: ${User.instance.jenis}');
        return responseBody['message'] ?? 'Login Kader berhasil!';
      } else if (response.statusCode == 401) {
        final String errorMessage = responseBody['message'] ?? 'Email atau password salah untuk Kader.';
        print('ERROR: Login Kader gagal (401): $errorMessage');
        throw Exception(errorMessage);
      } else {
        final String errorMessage = responseBody['message'] ?? 'Terjadi kesalahan server saat login Kader.';
        print('ERROR: Login Kader gagal (Status ${response.statusCode}): $errorMessage');
        throw Exception(errorMessage);
      }
    } on http.ClientException catch (e) {
      print('ERROR: Network error during Kader login: $e');
      throw Exception('Tidak dapat terhubung ke server. Pastikan koneksi internet Anda aktif dan server berjalan.');
    } catch (e) {
      print('ERROR: An unexpected error occurred during Kader login: $e');
      throw Exception('Terjadi kesalahan tak terduga. Silakan coba lagi.');
    }
  }

  Future<String> loginIbu(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final String token = responseBody['token'];
        final Map<String, dynamic> userData = responseBody['user'];

        // Pastikan jenis yang dikembalikan adalah 'KADER'
        // Jika backend sudah memvalidasi ini, langkah ini bisa opsional.
        // Namun, ini memberikan keamanan ekstra di sisi klien.
        if (userData['jenis'] != 'IBU') {
          throw Exception('Jenis akun bukan Ibu. Silakan login melalui halaman yang sesuai.');
        }

        // Perbarui instance User singleton dengan data yang diterima dari server
        User.instance.email = userData['email'];
        User.instance.jenis = userData['jenis']; // Seharusnya 'KADER'
        User.instance.token = token;

        print('DEBUG: Login Kader berhasil! User: ${User.instance.email}, Jenis: ${User.instance.jenis}');
        return responseBody['message'] ?? 'Login Kader berhasil!';
      } else if (response.statusCode == 401) {
        final String errorMessage = responseBody['message'] ?? 'Email atau password salah untuk Kader.';
        print('ERROR: Login Kader gagal (401): $errorMessage');
        throw Exception(errorMessage);
      } else {
        final String errorMessage = responseBody['message'] ?? 'Terjadi kesalahan server saat login Kader.';
        print('ERROR: Login Kader gagal (Status ${response.statusCode}): $errorMessage');
        throw Exception(errorMessage);
      }
    } on http.ClientException catch (e) {
      print('ERROR: Network error during Kader login: $e');
      throw Exception('Tidak dapat terhubung ke server. Pastikan koneksi internet Anda aktif dan server berjalan.');
    } catch (e) {
      print('ERROR: An unexpected error occurred during Kader login: $e');
      throw Exception('Terjadi kesalahan tak terduga. Silakan coba lagi.');
    }
  }

  Future<String> registerKader(Kader registrationData) async {
    final url = Uri.parse('$_baseUrl/registerKader'); // Endpoint registrasi Kader

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(registrationData.toJson()), // Mengirim data dari model sebagai JSON
      );

      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // Registrasi BERHASIL (status 201 Created)
        print('DEBUG: Registrasi Kader berhasil: ${responseBody['message']}');
        return responseBody['message'] ?? 'Registrasi kader berhasil!';
      } else if (response.statusCode == 400) {
        // Bad Request (misal, field wajib tidak diisi)
        final String errorMessage = responseBody['message'] ?? 'Data registrasi tidak lengkap atau tidak valid.';
        print('ERROR: Registrasi gagal (400): $errorMessage');
        throw Exception(errorMessage);
      } else if (response.statusCode == 409) {
        // Conflict (misal, email sudah terdaftar)
        final String errorMessage = responseBody['message'] ?? 'Email sudah terdaftar.';
        print('ERROR: Registrasi gagal (409): $errorMessage');
        throw Exception(errorMessage);
      } else {
        // Error lainnya dari server (misal 500 Internal Server Error)
        final String errorMessage = responseBody['message'] ?? 'Terjadi kesalahan server saat registrasi.';
        print('ERROR: Registrasi gagal (Status ${response.statusCode}): $errorMessage');
        throw Exception(errorMessage);
      }
    } on http.ClientException catch (e) {
      // Error koneksi jaringan
      print('ERROR: Network error during Kader registration: $e');
      throw Exception('Tidak dapat terhubung ke server. Pastikan koneksi internet Anda aktif dan server berjalan.');
    } catch (e) {
      // Error tak terduga lainnya
      print('ERROR: An unexpected error occurred during Kader registration: $e');
      throw Exception('Terjadi kesalahan tak terduga. Silakan coba lagi.');
    }
  }

  Future<String> registerIbu(Ibu registrationData) async {
    final url = Uri.parse('$_baseUrl/registerIbu'); // Endpoint registrasi Kader

    print(registrationData);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(registrationData.toJson()), // Mengirim data dari model sebagai JSON
      );

      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // Registrasi BERHASIL (status 201 Created)
        print('DEBUG: Registrasi Kader berhasil: ${responseBody['message']}');
        return responseBody['message'] ?? 'Registrasi kader berhasil!';
      } else if (response.statusCode == 400) {
        // Bad Request (misal, field wajib tidak diisi)
        final String errorMessage = responseBody['message'] ?? 'Data registrasi tidak lengkap atau tidak valid.';
        print('ERROR: Registrasi gagal (400): $errorMessage');
        throw Exception(errorMessage);
      } else if (response.statusCode == 409) {
        // Conflict (misal, email sudah terdaftar)
        final String errorMessage = responseBody['message'] ?? 'Email sudah terdaftar.';
        print('ERROR: Registrasi gagal (409): $errorMessage');
        throw Exception(errorMessage);
      } else {
        // Error lainnya dari server (misal 500 Internal Server Error)
        final String errorMessage = responseBody['message'] ?? 'Terjadi kesalahan server saat registrasi.';
        print('ERROR: Registrasi gagal (Status ${response.statusCode}): $errorMessage');
        throw Exception(errorMessage);
      }
    } on http.ClientException catch (e) {
      // Error koneksi jaringan
      print('ERROR: Network error during Kader registration: $e');
      throw Exception('Tidak dapat terhubung ke server. Pastikan koneksi internet Anda aktif dan server berjalan.');
    } catch (e) {
      // Error tak terduga lainnya
      print('ERROR: An unexpected error occurred during Kader registration: $e');
      throw Exception('Terjadi kesalahan tak terduga. Silakan coba lagi.');
    }
  }

  // Fungsi pengecekan status token (tetap sama)
  bool isUserTokenNullOrEmpty() {
    return User.instance.token.isEmpty;
  }

  // Fungsi untuk mendapatkan jenis user (tetap sama)
  String? getUserType() {
    if (User.instance.jenis.isEmpty) {
      return null;
    }
    return User.instance.jenis;
  }
}