import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:balansing/models/user_model.dart';
//import 'package:balansing/models/kader_model.dart'; 


class IbuServices {
  final String _baseUrl = 'http://10.0.2.2:5500/api/ibu';
  //inal String _baseUrl = 'http://localhost:5500/api/ibu'; 

// lib/api_service.dart

Future<List<dynamic>> getMonthlyRecap(String id, int month, int year) async {
  final url = Uri.parse('$_baseUrl/recapMonthly');
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${User.instance.token}',
      },
      body: jsonEncode({'ibuId': id, 'month': month, 'year': year}),
    );

    if (response.statusCode == 200) {
      // Dekode body sebagai List<dynamic> karena API mengembalikan array
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData;
    } else {
      final Map<String, dynamic> errorBody = jsonDecode(response.body);
      throw Exception('Gagal mendapatkan data anak. Status: ${response.statusCode}, Pesan: ${errorBody['message'] ?? 'Tidak ada pesan error'}');
    }
  } catch (e) {
    print('Terjadi kesalahan saat mendapatkan data anak: $e');
    throw Exception('Terjadi kesalahan jaringan atau server: $e');
  }
}

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

  Future<List<Map<String, dynamic>>> getAllAnak(String email) async {
    final url = Uri.parse('$_baseUrl/anak/$email');
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

  Future<Map<String, dynamic>> getDetailAnak(String id) async {
  final url = Uri.parse('$_baseUrl/anakDetail/$id');
  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${User.instance.token}',
      },
    );

    if (response.statusCode == 200) {
      // Decode body sebagai Map<String, dynamic> karena API mengembalikan objek tunggal
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;
    } else {
      final Map<String, dynamic> errorBody = jsonDecode(response.body);
      throw Exception('Gagal mendapatkan data anak. Status: ${response.statusCode}, Pesan: ${errorBody['message'] ?? 'Tidak ada pesan error'}');
    }
  } catch (e) {
    print('Terjadi kesalahan saat mendapatkan data anak: $e');
    throw Exception('Terjadi kesalahan jaringan atau server: $e');
  }
}

Future<Map<String, dynamic>> getDataDashboard(String id) async {
  final url = Uri.parse('$_baseUrl/dashboard/$id');
  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${User.instance.token}',
      },
    );

    if (response.statusCode == 200) {
      // Decode body sebagai Map<String, dynamic> karena API mengembalikan objek tunggal
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;
    } else {
      final Map<String, dynamic> errorBody = jsonDecode(response.body);
      throw Exception('Gagal mendapatkan data anak. Status: ${response.statusCode}, Pesan: ${errorBody['message'] ?? 'Tidak ada pesan error'}');
    }
  } catch (e) {
    print('Terjadi kesalahan saat mendapatkan data anak: $e');
    throw Exception('Terjadi kesalahan jaringan atau server: $e');
  }
}

Future<Map<String, dynamic>> getDashboardAnak(String id) async {
  final url = Uri.parse('$_baseUrl/allRecapAnak/$id');
  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${User.instance.token}',
      },
    );

    if (response.statusCode == 200) {
      // Decode body sebagai Map<String, dynamic> karena API mengembalikan objek tunggal
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;
    } else {
      final Map<String, dynamic> errorBody = jsonDecode(response.body);
      throw Exception('Gagal mendapatkan data anak. Status: ${response.statusCode}, Pesan: ${errorBody['message'] ?? 'Tidak ada pesan error'}');
    }
  } catch (e) {
    print('Terjadi kesalahan saat mendapatkan data anak: $e');
    throw Exception('Terjadi kesalahan jaringan atau server: $e');
  }
}

Future<Map<String, dynamic>> getDetailRecap(String id) async {
  final url = Uri.parse('$_baseUrl/recap/$id');
  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${User.instance.token}',
      },
    );

    if (response.statusCode == 200) {
      // Decode body sebagai Map<String, dynamic> karena API mengembalikan objek tunggal
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;
    } else {
      final Map<String, dynamic> errorBody = jsonDecode(response.body);
      throw Exception('Gagal mendapatkan data anak. Status: ${response.statusCode}, Pesan: ${errorBody['message'] ?? 'Tidak ada pesan error'}');
    }
  } catch (e) {
    print('Terjadi kesalahan saat mendapatkan data anak: $e');
    throw Exception('Terjadi kesalahan jaringan atau server: $e');
  }
}

  Future<Map<String, dynamic>> postAnakIbu(Map<String, dynamic> data) async {
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

  Future<Map<String, dynamic>> postRecapAnak(Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/recap');
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
        throw Exception('Gagal mengupload anak Ibu. Status: ${response.statusCode}, Pesan: ${errorBody['message'] ?? 'Tidak ada pesan error'}');
      }}catch (e) {
      print('Terjadi kesalahan saat memperbarui profil kader: $e');
      throw Exception('Terjadi kesalahan jaringan atau server: $e');
    }
  }

  Future<Map<String, dynamic>> deleteAnak(String id) async {
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
      // Decode body sebagai Map<String, dynamic> karena API mengembalikan objek tunggal
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;
    } else {
      final Map<String, dynamic> errorBody = jsonDecode(response.body);
      throw Exception('Gagal mendapatkan data anak. Status: ${response.statusCode}, Pesan: ${errorBody['message'] ?? 'Tidak ada pesan error'}');
    }
  } catch (e) {
    print('Terjadi kesalahan saat mendapatkan data anak: $e');
    throw Exception('Terjadi kesalahan jaringan atau server: $e');
  }
}

  Future<Map<String, dynamic>> editAnakIbu(Map<String, dynamic> data) async {
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