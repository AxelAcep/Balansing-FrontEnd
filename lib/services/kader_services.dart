import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:balansing/models/user_model.dart';
//import 'package:balansing/models/kader_model.dart'; 


class KaderServices {
  final String _baseUrl = 'http://10.0.2.2:5500/api/kader';

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
}