import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/card/RiwayatCard.dart';
import 'package:balansing/services/kader_services.dart';
import 'package:balansing/models/user_model.dart';
import 'dart:convert'; // Tambahkan ini untuk jsonEncode/Decode

// Asumsi: RiwayatCard adalah ChildCard yang sudah kamu sediakan.
// Asumsi: ChildStatusData adalah class yang relevan jika digunakan.
class ChildStatusData {
  final String title;
  final Color color;

  ChildStatusData(this.title, this.color);
}

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  final TextEditingController _searchController = TextEditingController();
  final KaderServices _kaderServices = KaderServices();

  // 1. Ubah _dummyChildren menjadi list kosong
  // Ini akan menyimpan data dari API setelah berhasil di-fetch
  List<Map<String, dynamic>> _childrenData = [];

  // 2. Tambahkan variabel untuk status loading dan error
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    // 3. Panggil fungsi untuk mengambil data
    _fetchChildrenData();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    debugPrint('Real-time Search Query: ${_searchController.text}');
    // Logika filtering data bisa ditambahkan di sini
  }

  // 4. Buat fungsi baru untuk mengambil data dari API dan memperbarui state
  Future<void> _fetchChildrenData() async {
    setState(() {
      _isLoading = true; // Set loading state to true
      _errorMessage = null; // Reset error message
    });

    try {
      final String email = User.instance.email;
      // Memanggil service untuk mendapatkan data dari API
      final List<Map<String, dynamic>> recapData = await _kaderServices.getRecap(email);
      
      // 5. Perbarui state dengan data yang baru
      setState(() {
        _childrenData = recapData;
        _isLoading = false; // Matikan status loading
      });

      debugPrint('Data berhasil diambil: $_childrenData');
    } catch (e) {
      // 6. Jika terjadi error, perbarui state dengan pesan error
      setState(() {
        _errorMessage = 'Gagal memuat data: $e';
        _isLoading = false; // Matikan status loading
      });
      debugPrint('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.05),

              // ... Bagian header, info RT/RW, Tanggal, dan Jumlah Anak tetap sama ...

              SizedBox(
                width: width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Riwayat Data",
                      style: GoogleFonts.poppins(
                        fontSize: height * 0.03,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      // ... kode filter button ...
                    ),
                  ],
                ),
              ),

              SizedBox(height: height * 0.01),
              _buildInfoRow(width, height, "RT/RW", "04/01"),
              SizedBox(height: height * 0.01),
              _buildInfoRow(width, height, "Tanggal Input", "27 Juli 2025"),
              SizedBox(height: height * 0.01),
              // Gunakan data dari state untuk jumlah anak
              _buildInfoRow(width, height, "Jumlah Anak", "${_childrenData.length}"),
              SizedBox(height: height * 0.01),

              // ... Bagian search bar tetap sama ...

              // 7. Tambahkan kondisi untuk menampilkan status loading, error, atau data
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else if (_errorMessage != null)
                Center(
                  child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                )
              else if (_childrenData.isEmpty)
                const Center(
                  child: Text('Tidak ada data anak ditemukan.'),
                )
              else
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: height * 0.63,
                  ),
                  child: Container(
                    width: width * 0.9,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Scrollbar(
                      thumbVisibility: false,
child: SingleChildScrollView(
  child: Column(
    children: _childrenData.map((childData) {
      return ChildCard(
        nama: childData['nama'] ?? 'Nama Tidak Diketahui',
        usia: childData['usia'] ?? 0,
        // Konversi int ke double
        beratBadan: (childData['beratBadan'] as num).toDouble(),
        tinggiBadan: (childData['tinggiBadan'] as num).toDouble(),
        anemia: childData['anemia'] ?? false,
        stunting: childData['stunting'] ?? false,
        jenisKelamin: childData['jenisKelamin'] ?? 'Tidak Diketahui',
      );
    }).toList(),
  ),
),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(double width, double height, String label, String value) {
    return SizedBox(
      width: width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: width * 0.035,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF60646C),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: width * 0.035,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}