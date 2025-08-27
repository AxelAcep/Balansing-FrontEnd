// lib/providers/IbuProvider.dart
import 'package:balansing/models/ibu_model.dart';
import 'package:flutter/foundation.dart';
import 'package:balansing/services/ibu_services.dart';

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