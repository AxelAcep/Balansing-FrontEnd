// File: riwayat_provider.dart
import 'package:flutter/material.dart';
import 'package:balansing/services/kader_services.dart';
import 'package:balansing/models/user_model.dart';
import 'package:balansing/models/filter_model.dart';

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
      //_errorMessage = 'Gagal memuat data: $e';
      _childrenData = []; // Set to empty list on error
      _originalChildrenData = []; // Set original to empty list as well
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
       //_errorMessage = 'Gagal memuat data: $e';
      _childrenData = []; // Set to empty list on error
      _originalChildrenData = []; // Set original to empty list as well
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

// File: dashboard_provider.dart

// Kelas-kelas model untuk data chart
class PieData {
  final String title;
  final int value;
  final Color color;
  const PieData(this.title, this.value, this.color);
}

class MonthlyData {
  final String month;
  final double value;
  const MonthlyData(this.month, this.value);
}

class AgeGroupData {
  final String group;
  final int males;
  final int females;
  const AgeGroupData(this.group, this.males, this.females);
}

// Di atas class DashboardProvider
class StuntingMonthlyData {
  final String month;
  final Map<String, int> counts;
  const StuntingMonthlyData(this.month, this.counts);
}

class AnemiaMonthlyData {
  final String month;
  final int count;
  const AnemiaMonthlyData(this.month, this.count);
}

class DashboardProvider with ChangeNotifier {
  final KaderServices _kaderServices = KaderServices();
  
  List<PieData> _pieChartData = [];
  List<PieData> _stuntingPieChartData = [];
  List<MonthlyData> _monthlyAnemiaStuntingData = []; // Ini yang baru
  List<AgeGroupData> _ageDistributionData = [];
  int _maleCount = 0;
  int _femaleCount = 0;
  bool _isLoading = false;
  String? _errorMessage;

  List<PieData> get pieChartData => _pieChartData;
  List<MonthlyData> get monthlyAnemiaStuntingData => _monthlyAnemiaStuntingData; // Getter yang baru
  List<AgeGroupData> get ageDistributionData => _ageDistributionData;
  int get maleCount => _maleCount;
  int get femaleCount => _femaleCount;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<AnemiaMonthlyData> _monthlyAnemiaData = [];
  List<AnemiaMonthlyData> get monthlyAnemiaData => _monthlyAnemiaData;
  List<PieData> get stuntingPieChartData => _stuntingPieChartData;

  // Di dalam class DashboardProvider
  List<StuntingMonthlyData> _monthlyStuntingData = [];

  List<StuntingMonthlyData> get monthlyStuntingData => _monthlyStuntingData;

  String _posyandu = "Tidak Tersedia";
  String _rt = "Tidak Tersedia";
  String _rw = "Tidak Tersedia";

  // Getters publik untuk mengakses data
  String get posyandu => _posyandu;
  String get rt => _rt;
  String get rw => _rw;

  Future<void> fetchKaderProfile() async {
    // Set loading state jika diperlukan
    _posyandu = "Memuat...";
    _rt = "Memuat...";
    _rw = "Memuat...";
    notifyListeners();

    try {
      final String email = User.instance.email;
      if (email.isEmpty) {
        _posyandu = "Email tidak tersedia";
        _rt = "Email tidak tersedia";
        _rw = "Email tidak tersedia";
        notifyListeners();
        return;
      }

      Map<String, dynamic> data = await _kaderServices.getKader(email);

      // Perbarui variabel dengan data yang diterima
      _posyandu = data['namaPosyandu'] ?? 'Tidak Tersedia';
      _rt = data['rt'] ?? 'Tidak Tersedia';
      _rw = data['rw'] ?? 'Tidak Tersedia';
      
      _errorMessage = null; // Reset error jika berhasil
    } catch (e) {
      // Tangani kesalahan jika terjadi
      _posyandu = "Gagal memuat";
      _rt = "Gagal memuat";
      _rw = "Gagal memuat";
      _errorMessage = 'Gagal memuat profil kader: $e';
    }

    notifyListeners(); // Beritahu widget bahwa data telah diperbarui
  }

  Future<void> fetchDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final String email = User.instance.email;
      final List<Map<String, dynamic>> recapData = await _kaderServices.getRecap(email);
      _processRecapData(recapData);
      _isLoading = false;
    } catch (e) {
      //_errorMessage = 'Gagal memuat data dashboard: $e';
      _processRecapData([]); // Process an empty list on error
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> filterDashboardData(FilterModel filter) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final String email = User.instance.email;
      final List<Map<String, dynamic>> filteredData = await _kaderServices.getRecapFilter(
        email, 
        filter.month, 
        filter.year, 
        filter.count
      );
      _processRecapData(filteredData);
      _isLoading = false;
    } catch (e) {
       //_errorMessage = 'Gagal memuat data dashboard yang difilter: $e';
      _processRecapData([]); // Process an empty list on error
      _isLoading = false;
    }
    notifyListeners();
  }
  
  void _processRecapData(List<Map<String, dynamic>> data) {
    _calculatePieChartData(data);
    _calculateMonthlyData(data);
    _calculateAgeDistribution(data);
    _calculateGenderCount(data);
    _calculateMonthlyDataStunting(data); // Panggil fungsi baru
    _calculateMonthlyDataAnemia(data);
    _calculateStuntingPieChartData(data);

  }

  void _calculateStuntingPieChartData(List<Map<String, dynamic>> data) {
    int sangatPendekCount = 0;
    int pendekCount = 0;
    int normalCount = 0;
    int tinggiCount = 0;

    for (var child in data) {
      String stuntingStatus = child['stunting'] as String? ?? '';
      
      switch (stuntingStatus) {
        case 'SangatPendek':
          sangatPendekCount++;
          break;
        case 'Pendek':
          pendekCount++;
          break;
        case 'Normal':
          normalCount++;
          break;
        case 'Tinggi':
          tinggiCount++;
          break;
      }
    }

    _stuntingPieChartData = [
      PieData('Sangat Pendek', sangatPendekCount, const Color(0xFFF43F5E)),
      PieData('Pendek', pendekCount, const Color.fromARGB(255, 253, 114, 137)),
      PieData('Normal', normalCount, const Color(0xFF9FC86A)),
      PieData('Tinggi', tinggiCount, const Color(0xFF1B5E20)),
    ];
  }

  void _calculateMonthlyDataAnemia(List<Map<String, dynamic>> data) {
    // Peta untuk menyimpan hitungan Anemia per bulan
    Map<int, int> anemiaCountPerMonth = {};

    for (var child in data) {
      final tanggalString = child['tanggal'] as String? ?? '';
      if (tanggalString.isEmpty) continue;

      DateTime tanggal = DateTime.parse(tanggalString);
      int bulan = tanggal.month;
      bool isAnemia = child['anemia'] as bool? ?? false;

      // Hanya hitung jika isAnemia adalah true
      if (isAnemia) {
        anemiaCountPerMonth[bulan] = (anemiaCountPerMonth[bulan] ?? 0) + 1;
      }
    }

    // List nama bulan
    const List<String> monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];

    // Buat list AnemiaMonthlyData baru
    List<AnemiaMonthlyData> newMonthlyAnemiaData = [];
    anemiaCountPerMonth.forEach((month, count) {
      newMonthlyAnemiaData.add(AnemiaMonthlyData(monthNames[month - 1], count));
    });

    // Urutkan data berdasarkan bulan
    newMonthlyAnemiaData.sort((a, b) {
      return monthNames.indexOf(a.month).compareTo(monthNames.indexOf(b.month));
    });

    _monthlyAnemiaData = newMonthlyAnemiaData;
  }

  // Di dalam class DashboardProvider
  void _calculateMonthlyDataStunting(List<Map<String, dynamic>> data) {
      // Peta untuk menyimpan data stunting per bulan dan jenis
      Map<int, Map<String, int>> stuntingDataPerMonth = {};

      for (var child in data) {
        final tanggalString = child['tanggal'] as String? ?? '';
        if (tanggalString.isEmpty) continue;

        DateTime tanggal = DateTime.parse(tanggalString);
        int bulan = tanggal.month;
        String stuntingStatus = child['stunting'] as String? ?? '';

        // Inisialisasi peta untuk bulan jika belum ada
        stuntingDataPerMonth.putIfAbsent(bulan, () => {
          'SangatPendek': 0,
          'Pendek': 0,
          'Normal': 0,
          'Tinggi': 0,
        });

        // Tambahkan hitungan untuk status stunting yang sesuai
        if (stuntingDataPerMonth[bulan]!.containsKey(stuntingStatus)) {
          stuntingDataPerMonth[bulan]![stuntingStatus] = stuntingDataPerMonth[bulan]![stuntingStatus]! + 1;
        }
      }

      // List bulan dalam string
      const List<String> monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];

      // Buat list StuntingMonthlyData baru
      List<StuntingMonthlyData> newMonthlyStuntingData = [];
      stuntingDataPerMonth.forEach((month, counts) {
        newMonthlyStuntingData.add(StuntingMonthlyData(monthNames[month - 1], counts));
      });

      // Urutkan data berdasarkan bulan
      newMonthlyStuntingData.sort((a, b) {
        return monthNames.indexOf(a.month).compareTo(monthNames.indexOf(b.month));
      });

      _monthlyStuntingData = newMonthlyStuntingData;
    }

  void _calculatePieChartData(List<Map<String, dynamic>> data) {
    int sehatCount = 0;
    int anemiaCount = 0;
    int stuntingCount = 0;
    int keduanyaCount = 0;

    for (var child in data) {
      bool isAnemia = child['anemia'] as bool? ?? false;
      String stuntingStatus = child['stunting'] as String? ?? '';
      bool isStunting = !(stuntingStatus == 'Tinggi' || stuntingStatus == 'Normal');

      if (!isAnemia && !isStunting) {
        sehatCount++;
      } else if (isAnemia && isStunting) {
        keduanyaCount++;
      } else if (isAnemia) {
        anemiaCount++;
      } else if (isStunting) {
        stuntingCount++;
      }
    }
    
    _pieChartData = [
      PieData('Sehat', sehatCount, const Color(0xFF9FC86A)),
      PieData('Anemia', anemiaCount, const Color.fromARGB(255, 253, 114, 137)),
      PieData('Stunting', stuntingCount, const Color(0xFFFACC15)),
      PieData('Keduanya', keduanyaCount, const Color(0xFFF43F5E)),
    ];
  }

  void _calculateMonthlyData(List<Map<String, dynamic>> data) {
    // Peta untuk menghitung total stunting/anemia per bulan
    Map<int, int> anemiaStuntingCountPerMonth = {};

    for (var child in data) {
      final tanggalString = child['tanggal'] as String? ?? '';
      if (tanggalString.isEmpty) continue;

      DateTime tanggal = DateTime.parse(tanggalString);
      int bulan = tanggal.month;
      bool isAnemia = child['anemia'] as bool? ?? false;
      String stuntingStatus = child['stunting'] as String? ?? '';
      bool isStunting = !(stuntingStatus == 'Tinggi' || stuntingStatus == 'Normal');

      // Hanya hitung jika salah satu atau keduanya true
      if (isAnemia || isStunting) {
        anemiaStuntingCountPerMonth[bulan] = (anemiaStuntingCountPerMonth[bulan] ?? 0) + 1;
      }
    }

    // List bulan dalam string
    const List<String> monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    
    // Buat list MonthlyData baru, hanya untuk bulan yang memiliki data
    List<MonthlyData> newMonthlyData = [];
    anemiaStuntingCountPerMonth.forEach((month, count) {
      newMonthlyData.add(MonthlyData(monthNames[month - 1], count.toDouble()));
    });

    // Urutkan data berdasarkan bulan
    newMonthlyData.sort((a, b) {
      return monthNames.indexOf(a.month).compareTo(monthNames.indexOf(b.month));
    });

    _monthlyAnemiaStuntingData = newMonthlyData;
  }

  void _calculateAgeDistribution(List<Map<String, dynamic>> data) {
    Map<String, int> ageMale = {'0-6': 0, '7-12': 0, '12-24': 0, '25-36': 0, '37-48': 0, '49-60': 0};
    Map<String, int> ageFemale = {'0-6': 0, '7-12': 0, '12-24': 0, '25-36': 0, '37-48': 0, '49-60': 0};
    
    for (var child in data) {
      final int usia = child['usia'] as int? ?? 0;
      final String jenisKelamin = child['jenisKelamin'] as String? ?? 'Tidak Diketahui';
      String group = '';

      if (usia >= 0 && usia <= 6) {
        group = '0-6';
      } else if (usia > 6 && usia <= 12) {
        group = '7-12';
      } else if (usia > 12 && usia <= 24) {
        group = '12-24';
      } else if (usia > 24 && usia <= 36) {
        group = '25-36';
      } else if (usia > 36 && usia <= 48) {
        group = '37-48';
      } else if (usia > 48 && usia <= 60) {
        group = '49-60';
      }

      if (group.isNotEmpty) {
        if (jenisKelamin.toLowerCase() == 'laki-laki') {
          ageMale[group] = (ageMale[group] ?? 0) + 1;
        } else if (jenisKelamin.toLowerCase() == 'perempuan') {
          ageFemale[group] = (ageFemale[group] ?? 0) + 1;
        }
      }
    }

    _ageDistributionData = [
      AgeGroupData('0-6', ageMale['0-6']!, ageFemale['0-6']!),
      AgeGroupData('7-12', ageMale['7-12']!, ageFemale['7-12']!),
      AgeGroupData('12-24', ageMale['12-24']!, ageFemale['12-24']!),
      AgeGroupData('25-36', ageMale['25-36']!, ageFemale['25-36']!),
      AgeGroupData('37-48', ageMale['37-48']!, ageFemale['37-48']!),
      AgeGroupData('49-60', ageMale['49-60']!, ageFemale['49-60']!),
    ];
  }

  void _calculateGenderCount(List<Map<String, dynamic>> data) {
    _maleCount = 0;
    _femaleCount = 0;
    for (var child in data) {
      final String jenisKelamin = child['jenisKelamin'] as String? ?? 'Tidak Diketahui';
      if (jenisKelamin.toLowerCase() == 'laki-laki') {
        _maleCount++;
      } else if (jenisKelamin.toLowerCase() == 'perempuan') {
        _femaleCount++;
      }
    }
  }
}