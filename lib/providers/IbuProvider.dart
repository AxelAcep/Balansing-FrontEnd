// RiwayatProvider
import 'package:balansing/models/ibu_model.dart'; // Pastikan Anda mengimpor IbuModel
import 'package:flutter/foundation.dart';
import 'package:balansing/services/ibu_services.dart';

class ProfileProvider with ChangeNotifier {
  final IbuServices _ibuServices = IbuServices(); // Service untuk mengambil data ibu
  Ibu? _ibuProfile; // Menyimpan data profil ibu

  Ibu? get ibuProfile => _ibuProfile;

  Future<void> fetchProfile(String email) async {
    try {
      // Memanggil service untuk mendapatkan data profil
      final Map<String, dynamic> profileData = await _ibuServices.getIbu(email);

      // Mengonversi Map menjadi objek Ibu menggunakan factory constructor
      _ibuProfile = Ibu.fromJson(profileData);

      // Memberi tahu widget yang mendengarkan bahwa data telah berubah
      notifyListeners();
    } catch (e) {
      print('Gagal mengambil data profil: $e');
      // Tambahkan logika penanganan error di sini
    }
  }
}
