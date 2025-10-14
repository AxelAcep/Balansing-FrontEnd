import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:balansing/models/user_model.dart';
import 'package:path/path.dart' as p;
//import 'package:balansing/models/kader_model.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import paket

class IbuServices {
  final String _baseUrl = '${dotenv.env['API_USER_URL']}/api/ibu';


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

Future<List<Map<String, dynamic>>> getArticle() async {
  final url = Uri.parse('$_baseUrl/artikel');
  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${User.instance.token}',
      }
    );

    if (response.statusCode == 200) {
      // Mengonversi response.body ke List<Map<String, dynamic>>
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.cast<Map<String, dynamic>>();
    } else {
      final Map<String, dynamic> errorBody = jsonDecode(response.body);
      throw Exception('Gagal mendapatkan data artikel. Status: ${response.statusCode}, Pesan: ${errorBody['message'] ?? 'Tidak ada pesan error'}');
    }
  } catch (e) {
    print('Terjadi kesalahan saat mendapatkan data artikel: $e');
    throw Exception('Terjadi kesalahan jaringan atau server: $e');
  }
}

Future<Map<String, dynamic>> getDetailArticle(String id) async {
    final url = Uri.parse('$_baseUrl/artikel/$id');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${User.instance.token}',
        }
      );

      if (response.statusCode == 200) {
        // Mengonversi response.body ke satu Map
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        throw Exception('Gagal mendapatkan data artikel. Status: ${response.statusCode}, Pesan: ${errorBody['message'] ?? 'Tidak ada pesan error'}');
      }
    } catch (e) {
      print('Terjadi kesalahan saat mendapatkan data artikel: $e');
      throw Exception('Terjadi kesalahan jaringan atau server: $e');
    }
  }

Future<List<dynamic>> cekMakanan(String filePath) async {
  // Ganti nama method agar lebih sesuai dengan fungsinya
  final url = Uri.parse('$_baseUrl/makanan');

  try {
    // 1. Buat request multipart
    final request = http.MultipartRequest('POST', url);

    // 2. Tambahkan header otentikasi
    request.headers.addAll({
      'Authorization': 'Bearer ${User.instance.token}',
    });

    // 3. Tambahkan file ke request
    final file = await http.MultipartFile.fromPath(
      'file', // Nama field harus "file" sesuai dengan upload.single('file') di backend
      filePath,
      contentType: MediaType('image', p.extension(filePath).substring(1)),
    );
    request.files.add(file);

    // 4. Kirim request dan tunggu respons
    final response = await request.send();

    // 5. Baca respons dari stream
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      // Dekode respons body
      final List<dynamic> responseData = jsonDecode(responseBody);
      return responseData;
    } else {
      final Map<String, dynamic> errorBody = jsonDecode(responseBody);
      throw Exception('Gagal memproses gambar. Status: ${response.statusCode}, Pesan: ${errorBody['error'] ?? 'Tidak ada pesan error'}');
    }
  } catch (e) {
    print('Terjadi kesalahan saat mengunggah file: $e');
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

   Future<Map<String, dynamic>> generateKeberagamanMakanan(List<String> dds) async {
    final url = Uri.parse('$_baseUrl/analisis-makanan'); // Ubah endpoint agar lebih spesifik
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${User.instance.token}',
        },
        body: jsonEncode({
          "DDS": dds, 
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        throw Exception(
            'Gagal melakukan analisis makanan. Status: ${response.statusCode}, Pesan: ${errorBody['message'] ?? 'Tidak ada pesan error'}');
      }
    } catch (e) {
      print('Terjadi kesalahan saat melakukan analisis makanan: $e');
      throw Exception('Terjadi kesalahan jaringan atau server: $e');
    }
  }

  Future<Map<String, dynamic>> generateSanitasi(List<Map<String, dynamic>> quizHistory) async {
    final url = Uri.parse('$_baseUrl/analisis-sanitasi');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${User.instance.token}',
        },
        body: jsonEncode({
          "quizResult": quizHistory, // <- ini penting!
        }),
      );

      print(jsonEncode({
          "quizResult": quizHistory, // <- ini penting!
        }),);

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        throw Exception(
            'Gagal melakukan analisis sanitasi. Status: ${response.statusCode}, Pesan: ${errorBody['message'] ?? 'Tidak ada pesan error'}');
      }
    } catch (e) {
      print('Terjadi kesalahan saat melakukan analisis sanitasi: $e');
      throw Exception('Terjadi kesalahan jaringan atau server: $e');
    }
  }


    Future<Map<String, dynamic>> generateRekomendasi(String id) async {
    final url = Uri.parse('$_baseUrl/analisis-gizi/$id');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${User.instance.token}',
        },
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