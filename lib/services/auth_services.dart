// lib/services/auth_services.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:balansing/models/user_model.dart';
import 'package:balansing/models/kader_model.dart'; 
import 'package:balansing/models/ibu_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import paket
import 'dart:io';
import 'dart:async';
/// Kelas [AuthService] ini menyediakan fungsi-fungsi untuk berinteraksi
/// dengan API autentikasi dan mengecek status pengguna.
class AuthService {
  final String _baseUrl = '${dotenv.env['API_USER_URL']}/api/user';


Future<String> resetPassword(String email) async {
  final url = Uri.parse('$_baseUrl/forgetPass');
  print('DEBUG: Reset password URL: $url');

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

    // --- Inisialisasi Fallback Pesan Error ---
    String errorMessage = 'Terjadi kesalahan tak terduga di sisi aplikasi. Silakan coba lagi.';
    Map<String, dynamic> responseBody = {};
    final int statusCode = response.statusCode;

    // --- Coba Decode JSON Body dengan Aman ---
    try {
      if (response.body.isNotEmpty) {
        responseBody = jsonDecode(response.body);
        errorMessage = responseBody['message'] ?? response.reasonPhrase ?? errorMessage;
      } else {
        errorMessage = response.reasonPhrase ?? errorMessage;
      }
    } catch (e) {
      errorMessage = response.reasonPhrase ?? 'Gagal memproses respons server. Status: $statusCode';
      print('WARNING: Failed to decode response body: $e');
    }

    // --- Cek Status Code ---
    if (statusCode == 200) {
      final String successMessage = responseBody['message'] ?? 'Link reset password telah dikirim ke email Anda.';
      print('DEBUG: Reset password berhasil untuk email: $email');
      return successMessage;
      
    } else if (statusCode == 404) {
      // Email tidak ditemukan
      print('ERROR: Email tidak terdaftar (404): $errorMessage');
      throw Exception(errorMessage.isEmpty ? 'Email tidak terdaftar dalam sistem.' : errorMessage);
      
    } else if (statusCode == 400) {
      // Bad request - mungkin email tidak valid atau field kosong
      print('ERROR: Bad request (400): $errorMessage');
      throw Exception(errorMessage.isEmpty ? 'Email tidak valid.' : errorMessage);
      
    } else if (statusCode >= 400 && statusCode < 500) {
      // Client error lainnya
      print('ERROR: Reset password gagal (Status $statusCode): $errorMessage');
      throw Exception(errorMessage);
      
    } else if (statusCode >= 500) {
      // Server error (500, 502, 503, dll)
      print('ERROR: Server bermasalah (Status $statusCode): $errorMessage');
      throw Exception('Server sedang bermasalah. Silakan coba lagi nanti.');
      
    } else {
      // Status code tak terduga lainnya
      print('ERROR: Status tidak dikenali ($statusCode): $errorMessage');
      throw Exception(errorMessage);
    }
    
  } on SocketException catch (e) {
    // Tidak ada koneksi internet atau server tidak dapat dijangkau
    print('ERROR: No internet connection: $e');
    throw Exception('Tidak ada koneksi internet. Periksa koneksi Anda dan coba lagi.');
    
  } on TimeoutException catch (e) {
    // Request timeout
    print('ERROR: Connection timeout: $e');
    throw Exception('Koneksi timeout. Server tidak merespons.');
    
  } on http.ClientException catch (e) {
    // Error jaringan lainnya (server tidak dapat dihubungi)
    print('ERROR: Network error: $e');
    throw Exception('Tidak dapat terhubung ke server. Pastikan server berjalan.');
    
  } on FormatException catch (e) {
    // Error parsing data
    print('ERROR: Data format error: $e');
    throw Exception('Format data tidak valid. Hubungi administrator.');
    
  } catch (e) {
    // Exception yang sudah di-throw dari blok if-else di atas akan sampai ke sini
    // Tapi kita RETHROW supaya pesan aslinya tidak hilang
    if (e is Exception) {
      rethrow; // <-- Re-throw exception yang sudah kita buat
    }
    
    // Hanya exception benar-benar tak terduga yang sampai sini
    print('ERROR: Unexpected error during reset password: $e');
    throw Exception('Terjadi kesalahan tak terduga. Silakan coba lagi.');
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

    // --- Inisialisasi Fallback Pesan Error ---
    String errorMessage = 'Terjadi kesalahan tak terduga di sisi aplikasi. Silakan coba lagi.';
    Map<String, dynamic> responseBody = {};
    final int statusCode = response.statusCode;

    // --- Coba Decode JSON Body dengan Aman ---
    try {
      if (response.body.isNotEmpty) {
        responseBody = jsonDecode(response.body);
        errorMessage = responseBody['message'] ?? response.reasonPhrase ?? errorMessage;
      } else {
        errorMessage = response.reasonPhrase ?? errorMessage;
      }
    } catch (e) {
      errorMessage = response.reasonPhrase ?? 'Gagal memproses respons server. Status: $statusCode';
      print('WARNING: Failed to decode response body: $e');
    }

    // --- Cek Status Code ---
    if (statusCode == 200) {
      final String token = responseBody['token'];
      final Map<String, dynamic> userData = responseBody['user'];

      if (userData['jenis'] != 'KADER') {
        throw Exception('Jenis akun bukan Kader. Silakan login melalui halaman yang sesuai.');
      }

      User.instance.email = userData['email'];
      User.instance.jenis = userData['jenis'];
      User.instance.token = token;

      print('DEBUG: Login Kader berhasil! User: ${User.instance.email}, Jenis: ${User.instance.jenis}');
      return responseBody['message'] ?? 'Login Kader berhasil!';
      
    } else if (statusCode == 401) {
      // Khusus untuk 401 - Email/Password Salah
      print('ERROR: Login gagal - Email atau password salah (401): $errorMessage');
      throw Exception(errorMessage);
      
    } else if (statusCode >= 400 && statusCode < 500) {
      // Client error lainnya (400, 404, dll)
      print('ERROR: Login Kader gagal (Status $statusCode): $errorMessage');
      throw Exception(errorMessage);
      
    } else if (statusCode >= 500) {
      // Server error (500, 502, 503, dll)
      print('ERROR: Server bermasalah (Status $statusCode): $errorMessage');
      throw Exception('Server sedang bermasalah. Silakan coba lagi nanti.');
      
    } else {
      // Status code tak terduga lainnya
      print('ERROR: Status tidak dikenali ($statusCode): $errorMessage');
      throw Exception(errorMessage);
    }
    
  } on SocketException catch (e) {
    // Tidak ada koneksi internet atau server tidak dapat dijangkau
    print('ERROR: No internet connection: $e');
    throw Exception('Tidak ada koneksi internet. Periksa koneksi Anda dan coba lagi.');
    
  } on TimeoutException catch (e) {
    // Request timeout
    print('ERROR: Connection timeout: $e');
    throw Exception('Koneksi timeout. Server tidak merespons.');
    
  } on http.ClientException catch (e) {
    // Error jaringan lainnya (server tidak dapat dihubungi)
    print('ERROR: Network error: $e');
    throw Exception('Tidak dapat terhubung ke server. Pastikan server berjalan.');
    
  } on FormatException catch (e) {
    // Error parsing data
    print('ERROR: Data format error: $e');
    throw Exception('Format data tidak valid. Hubungi administrator.');
    
  } catch (e) {
    // Exception yang sudah di-throw dari blok if-else di atas akan sampai ke sini
    // Tapi kita RETHROW supaya pesan aslinya tidak hilang
    if (e is Exception) {
      rethrow; // <-- INI KUNCINYA! Re-throw exception yang sudah kita buat
    }
    
    // Hanya exception benar-benar tak terduga yang sampai sini
    print('ERROR: Unexpected error: $e');
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

    // --- Inisialisasi Fallback Pesan Error ---
    String errorMessage = 'Terjadi kesalahan tak terduga di sisi aplikasi. Silakan coba lagi.';
    Map<String, dynamic> responseBody = {};
    final int statusCode = response.statusCode;

    // --- Coba Decode JSON Body dengan Aman ---
    try {
      if (response.body.isNotEmpty) {
        responseBody = jsonDecode(response.body);
        errorMessage = responseBody['message'] ?? response.reasonPhrase ?? errorMessage;
      } else {
        errorMessage = response.reasonPhrase ?? errorMessage;
      }
    } catch (e) {
      errorMessage = response.reasonPhrase ?? 'Gagal memproses respons server. Status: $statusCode';
      print('WARNING: Failed to decode response body: $e');
    }

    // --- Cek Status Code ---
    if (statusCode == 200) {
      final String token = responseBody['token'];
      final Map<String, dynamic> userData = responseBody['user'];

      if (userData['jenis'] != 'IBU') {
        throw Exception('Jenis akun bukan Ibu. Silakan login melalui halaman yang sesuai.');
      }

      User.instance.email = userData['email'];
      User.instance.jenis = userData['jenis'];
      User.instance.token = token;

      print('DEBUG: Login Ibu berhasil! User: ${User.instance.email}, Jenis: ${User.instance.jenis}');
      return responseBody['message'] ?? 'Login Ibu berhasil!';
      
    } else if (statusCode == 401) {
      // Khusus untuk 401 - Email/Password Salah
      print('ERROR: Login gagal - Email atau password salah (401): $errorMessage');
      throw Exception(errorMessage);
      
    } else if (statusCode >= 400 && statusCode < 500) {
      // Client error lainnya (400, 404, dll)
      print('ERROR: Login Ibu gagal (Status $statusCode): $errorMessage');
      throw Exception(errorMessage);
      
    } else if (statusCode >= 500) {
      // Server error (500, 502, 503, dll)
      print('ERROR: Server bermasalah (Status $statusCode): $errorMessage');
      throw Exception('Server sedang bermasalah. Silakan coba lagi nanti.');
      
    } else {
      // Status code tak terduga lainnya
      print('ERROR: Status tidak dikenali ($statusCode): $errorMessage');
      throw Exception(errorMessage);
    }
    
  } on SocketException catch (e) {
    // Tidak ada koneksi internet atau server tidak dapat dijangkau
    print('ERROR: No internet connection: $e');
    throw Exception('Tidak ada koneksi internet. Periksa koneksi Anda dan coba lagi.');
    
  } on TimeoutException catch (e) {
    // Request timeout
    print('ERROR: Connection timeout: $e');
    throw Exception('Koneksi timeout. Server tidak merespons.');
    
  } on http.ClientException catch (e) {
    // Error jaringan lainnya (server tidak dapat dihubungi)
    print('ERROR: Network error: $e');
    throw Exception('Tidak dapat terhubung ke server. Pastikan server berjalan.');
    
  } on FormatException catch (e) {
    // Error parsing data
    print('ERROR: Data format error: $e');
    throw Exception('Format data tidak valid. Hubungi administrator.');
    
  } catch (e) {
    // Exception yang sudah di-throw dari blok if-else di atas akan sampai ke sini
    // Tapi kita RETHROW supaya pesan aslinya tidak hilang
    if (e is Exception) {
      rethrow; // <-- Re-throw exception yang sudah kita buat
    }
    
    // Hanya exception benar-benar tak terduga yang sampai sini
    print('ERROR: Unexpected error: $e');
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
      throw Exception('Terjadi kesalahan. $e');
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