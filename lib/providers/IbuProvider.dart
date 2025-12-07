// lib/providers/IbuProvider.dart
import 'package:balansing/models/ibu_model.dart';
import 'package:flutter/foundation.dart';
import 'package:balansing/services/ibu_services.dart';
import 'package:balansing/card/RiwayatIbuCard.dart'; // Import StuntingStatus`
import 'package:balansing/models/dashboard_data.dart';

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


class DashboardIbuProvider with ChangeNotifier {
  final IbuServices _dashboardService = IbuServices();
  DashboardData? _data;
  bool _isLoading = false;
  String? _error;

  DashboardData? get data => _data;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setError(String message) {
    _error = message;
    _isLoading = false;
    notifyListeners();
  }

  void setData(DashboardData? newData) {
    _data = newData;
    notifyListeners();
  }

  Future<void> fetchDashboardData(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final responseData = await _dashboardService.getDataDashboard(id);
      _data = DashboardData.fromJson(responseData['data']);
      _error = null;
    } catch (e) {
      _error = e.toString();
      print("Error fetching dashboard data: $_error");
      _data = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class RecapIbuProvider with ChangeNotifier {
  // 1. State untuk Loading
  bool _isSubmitting = false;
  
  // 2. Getter untuk Loading State
  bool get isSubmitting => _isSubmitting;

  // Variabel untuk menyimpan hasil respons (Opsional, tapi baik untuk debugging/akses data)
  Map<String, dynamic>? _recapResponse;
  Map<String, dynamic>? get recapResponse => _recapResponse;

  // --- Fungsi untuk Post Recap Data ---
  Future<Map<String, dynamic>> postRecapData({
    required Map<String, dynamic> dataAnak,
  }) async {
    // A. Mulai Loading
    _isSubmitting = true;
    notifyListeners(); // Memberi tahu Widget untuk menampilkan loading

    try {
      // 1. Panggil Service Pertama (Post Recap)
      final response = await IbuServices().postRecapAnak(dataAnak);
      
      _recapResponse = response;
      
      print("Data berhasil dikirim: $response");

      // 2. Panggil Service Kedua (Generate Rekomendasi)
      final kodeRecap = response['anakIbu']['kodeRecap'];
      final response2 = await IbuServices().generateRekomendasi(kodeRecap);
      print("Data rekomendasi berhasil dikirim: $response2");

      // 3. Setelah proses selesai, hentikan loading
      _isSubmitting = false;
      notifyListeners();
      
      // Kembalikan response pertama (atau kode recap yang dibutuhkan)
      return response; 
      
    } catch (e) {
      // 4. Handle Error dan Hentikan Loading
      print("Gagal mengirim data di provider: $e");
      _isSubmitting = false;
      notifyListeners();
      // Lemparkan error agar Widget bisa menangkapnya dan menampilkan Snackbar error
      throw Exception(e.toString()); 
    }
  }
}