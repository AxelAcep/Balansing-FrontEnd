import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:balansing/models/user_model.dart';
//import 'package:balansing/models/kader_model.dart'; 


class IbuServices {
  //final String _baseUrl = 'http://10.0.2.2:5500/api/ibu';
  final String _baseUrl = 'http://localhost:5500/api/ibu'; 

  // Mengubah tipe kembalian menjadi Future<Map<String, dynamic>>
  Future<Map<String, dynamic>> getIbu(String email) async {
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

  Future<Map<String, dynamic>> updateIbu(String email, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/profile');
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