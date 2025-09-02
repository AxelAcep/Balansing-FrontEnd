// lib/providers/IbuProvider.dart
import 'package:balansing/models/ibu_model.dart';
import 'package:flutter/foundation.dart';
import 'package:balansing/services/ibu_services.dart';
import 'package:balansing/card/RiwayatIbuCard.dart'; // Import StuntingStatus`

class RecapProvider with ChangeNotifier {
  List<ChildData> _monthlyRecaps = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ChildData> get monthlyRecaps => _monthlyRecaps;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final IbuServices _ibuServices = IbuServices();

  Future<void> fetchMonthlyRecap(String ibuId, int month, int year) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Ambil data langsung sebagai List<dynamic>
      final List<dynamic> recapList = await _ibuServices.getMonthlyRecap(ibuId, month, year);

      // Ubah setiap item List menjadi ChildData
      _monthlyRecaps = recapList.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> data = entry.value as Map<String, dynamic>;
        
        // Sesuaikan dengan data JSON Anda
        // Karena JSON tidak memiliki 'namaAnak', 'tanggalLahir', atau 'jenisKelamin'
        // Anda perlu mengambilnya dari tempat lain atau mengisinya dengan dummy
        // Ini adalah asumsi jika Anda memiliki data ini di backend atau model
        // Contoh: Ambil nama anak dari profil ibu atau anak
        // Untuk contoh ini, kita asumsikan Anda akan mengambil nama, gender, dll. dari data lain
        // atau mengisinya sebagai placeholder.
        
        // Contoh penyesuaian:
        // Anda perlu mengambil data anak dari API lain
        // atau menyimpan data anak di RecapAnak model Anda.
        // Jika tidak, Anda bisa menggunakan data dummy seperti ini:
        // Misalkan ada endpoint lain untuk mendapatkan data anak berdasarkan ID
        
        return ChildData(
          name: data['nama'],
          age: data['usia'].toString(),
          gender: data['jenisKelamin'],
          weight: data['beratBadan']?.toDouble() ?? 0.0,
          height: data['tinggiBadan']?.toDouble() ?? 0.0,
          stuntingStatus: data['stunting'],
          hasAnemia: data['anemia'] as bool,
          id: data['kodeRecap'],
          childNumber: index + 1,
          anakId: data['id'],
        );
      }).toList();
      
    } catch (e) {
      _errorMessage = e.toString();
      _monthlyRecaps = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  StuntingStatus _mapStuntingStatus(String status) {
    switch (status.toLowerCase()) {
      case 'Normal':
        return StuntingStatus.normal;
      case 'Tinggi':
        return StuntingStatus.tall;
      case 'Pendek':
        return StuntingStatus.short;
      case 'SangatPendek':
        return StuntingStatus.veryShort;
      default:
        return StuntingStatus.normal;
    }
  }
}

extension on Object {
  asMap() {}
}

class ProfileProvider with ChangeNotifier {
  final IbuServices _ibuServices = IbuServices();
  
  List<Map<String, dynamic>> _daftarAnak = [];
  bool _isLoading = false;
  String? _errorMessage;

  Ibu? _ibuProfile;

  // Getter publik untuk properti privat
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Ibu? get ibuProfile => _ibuProfile;
  List<Map<String, dynamic>> get daftarAnak => _daftarAnak;

  Future<void> fetchDaftarAnak(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _ibuServices.getAllAnak(email);
      _daftarAnak = data;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProfile(String email) async {
    try {
      final Map<String, dynamic> profileData = await _ibuServices.getIbu(email);
      _ibuProfile = Ibu.fromJson(profileData);
      notifyListeners();
    } catch (e) {
      print('Gagal mengambil data profil: $e');
    }
  }
}