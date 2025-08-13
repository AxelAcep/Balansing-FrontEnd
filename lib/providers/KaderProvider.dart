// File: riwayat_provider.dart
import 'package:flutter/material.dart';
import 'package:balansing/services/kader_services.dart';
import 'package:balansing/models/user_model.dart';

class RiwayatProvider with ChangeNotifier {
  final KaderServices _kaderServices = KaderServices();
  List<Map<String, dynamic>> _childrenData = [];
  List<Map<String, dynamic>> _originalChildrenData = []; // Simpan data asli
  bool _isLoading = true;
  String? _errorMessage;

  List<Map<String, dynamic>> get childrenData => _childrenData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchChildrenData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final String email = User.instance.email;
      final List<Map<String, dynamic>> recapData = await _kaderServices.getRecap(email);
      _childrenData = recapData;
      _originalChildrenData = recapData; // Simpan data asli untuk pencarian
      _isLoading = false;
    } catch (e) {
      _errorMessage = 'Gagal memuat data: $e';
      _isLoading = false;
    }

    notifyListeners();
  }

  Future<void> filterChildrenByMonth(int month, int year, int count) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final String email = User.instance.email;
      final List<Map<String, dynamic>> filteredData = await _kaderServices.getRecapFilter(email, month, year, count);
      _childrenData = filteredData;
      _originalChildrenData = filteredData; // Simpan data asli untuk pencarian
      _isLoading = false;
    } catch (e) {
      _errorMessage = 'Gagal memuat data: $e';
      _isLoading = false;
    }

    notifyListeners();
  }

  void searchChildren(String query) {
    if (query.isEmpty) {
      _childrenData = _originalChildrenData; // Gunakan data asli jika query kosong
    } else {
      final filteredData = _originalChildrenData.where((childData) {
        final nama = (childData['nama'] as String?)?.toLowerCase() ?? '';
        final usia = (childData['usia'] as num?)?.toString() ?? '';
        return nama.contains(query.toLowerCase()) || usia.contains(query.toLowerCase());
      }).toList();
      _childrenData = filteredData;
    }
    notifyListeners();
  }
}