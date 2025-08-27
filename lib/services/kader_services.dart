import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:balansing/models/user_model.dart';
//import 'package:balansing/models/kader_model.dart'; 


class KaderServices {
  final String _baseUrl = 'http://10.0.2.2:5500/api/kader';
  //final String _baseUrl = 'http://localhost:5500/api/kader'; 

  // Mengubah tipe kembalian menjadi Future<Map<String, dynamic>>
  Future<Map<String, dynamic>> getKader(String email) async {
    final url = Uri.parse('$_baseUrl/profile/$email');
    print(url);
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${User.instance.token}',
        },
      );

      if (response.statusCode == 200) {
        // Melakukan jsonDecode di sini
        return jsonDecode(response.body);
      } else {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        throw Exception('Gagal mendapatkan profil kader. Status: ${response.statusCode}, Pesan: ${errorBody['message'] ?? 'Tidak ada pesan error'}');
      }
    } catch (e) {
      print('Terjadi kesalahan saat mendapatkan profil kader: $e');
      throw Exception('Terjadi kesalahan jaringan atau server: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getDetailAnakKader(String id) async {
  final url = Uri.parse('$_baseUrl/detailRecap/$id');
  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${User.instance.token}',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return [responseData]; // ✅ Bungkus ke dalam List
    } else {
      final Map<String, dynamic> errorBody = jsonDecode(response.body);
      throw Exception('Gagal mendapatkan detail anak kader. Status: ${response.statusCode}, Pesan: ${errorBody['message'] ?? 'Tidak ada pesan error'}');
    }
  } catch (e) {
    print('Terjadi kesalahan saat mendapatkan detail anak kader: $e');
    throw Exception('Terjadi kesalahan jaringan atau server: $e');
  }
}

Future<List<Map<String, dynamic>>> deleteAnakKader(String id) async {
  final url = Uri.parse('$_baseUrl/anak/$id');
  try {
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${User.instance.token}',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return [responseData]; // ✅ Bungkus ke dalam List
    } else {
      final Map<String, dynamic> errorBody = jsonDecode(response.body);
      throw Exception('Gagal mendapatkan detail anak kader. Status: ${response.statusCode}, Pesan: ${errorBody['message'] ?? 'Tidak ada pesan error'}');
    }
  } catch (e) {
    print('Terjadi kesalahan saat mendapatkan detail anak kader: $e');
    throw Exception('Terjadi kesalahan jaringan atau server: $e');
  }
}




  Future<List<Map<String, dynamic>>> getRecap(String email) async {
    final url = Uri.parse('$_baseUrl/recap/$email');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${User.instance.token}',
        },
      );

      if (response.statusCode == 200) {
        // Ubah tipe data dari `Map` menjadi `List<dynamic>`
        final List<dynamic> responseData = jsonDecode(response.body);
        // Konversi setiap item dalam list menjadi Map<String, dynamic>
        return responseData.cast<Map<String, dynamic>>();
      } else {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        throw Exception('Gagal mendapatkan recap kader. Status: ${response.statusCode}, Pesan: ${errorBody['message'] ?? 'Tidak ada pesan error'}');
      }
    } catch (e) {
      print('Terjadi kesalahan saat mendapatkan recap kader: $e');
      throw Exception('Terjadi kesalahan jaringan atau server: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getRecapFilter(String email, int month, int year, int count) async {
    final url = Uri.parse('$_baseUrl/filterAnak');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${User.instance.token}'
        },
        body: jsonEncode({ // <--- BODY diletakkan di sini, di luar headers
        'email': email,
        'month': month,
        'year': year,
        'count': count,
      }),
      );
      
      print(response); 

      if (response.statusCode == 200) {
        // Ubah tipe data dari `Map` menjadi `List<dynamic>`
        final List<dynamic> responseData = jsonDecode(response.body);
        // Konversi setiap item dalam list menjadi Map<String, dynamic>
        return responseData.cast<Map<String, dynamic>>();
      } else {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        throw Exception('Gagal mendapatkan recap kader. Status: ${response.statusCode}, Pesan: ${errorBody['message'] ?? 'Tidak ada pesan error'}');
      }
    } catch (e) {
      print('Terjadi kesalahan saat mendapatkan recap kader: $e');
      throw Exception('Terjadi kesalahan jaringan atau server: $e');
    }
  }

  Future<Map<String, dynamic>> ubahPassword(String email, String oldPassword, String newPassword) async {
    final url = Uri.parse('$_baseUrl/password');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${User.instance.token}',
        },
        body: jsonEncode({
          'email': email,
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        throw Exception('Gagal mengubah password. Status: ${response.statusCode}, Pesan: ${errorBody['message'] ?? 'Tidak ada pesan error'}');
      }
    } catch (e) {
      print('Terjadi kesalahan saat mengubah password: $e');
      throw Exception('Terjadi kesalahan jaringan atau server: $e');
    }
  }

  Future<Map<String, dynamic>> postAnakKader(Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/anak');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${User.instance.token}',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        throw Exception('Gagal mengupload anak kader. Status: ${response.statusCode}, Pesan: ${errorBody['message'] ?? 'Tidak ada pesan error'}');
      }}catch (e) {
      print('Terjadi kesalahan saat memperbarui profil kader: $e');
      throw Exception('Terjadi kesalahan jaringan atau server: $e');
    }
  }
  

  Future<Map<String, dynamic>> editAnakKader(Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/anak');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${User.instance.token}',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        throw Exception('Gagal mengupload anak kader. Status: ${response.statusCode}, Pesan: ${errorBody['message'] ?? 'Tidak ada pesan error'}');
      }}catch (e) {
      print('Terjadi kesalahan saat memperbarui profil kader: $e');
      throw Exception('Terjadi kesalahan jaringan atau server: $e');
    }
  }

  Future<Map<String, dynamic>> updateKader(String email, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/profile/edit');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${User.instance.token}',
        },
        body: jsonEncode(data),
      );

      print(jsonEncode(data)); // Debugging: cetak data yang dikirim

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        throw Exception('Gagal memperbarui profil kader. Status: ${response.statusCode}, Pesan: ${errorBody['message'] ?? 'Tidak ada pesan error'}');
      }
    } catch (e) {
      print('Terjadi kesalahan saat memperbarui profil kader: $e');
      throw Exception('Terjadi kesalahan jaringan atau server: $e');
    }
  }
}