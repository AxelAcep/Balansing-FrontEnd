import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/card/DashboardCardI.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:balansing/card/DashboardZBarCard.dart';
import 'package:balansing/card/DashboardChart.dart';
import 'package:provider/provider.dart';
import 'package:balansing/providers/IbuProvider.dart';
import 'package:balansing/services/ibu_services.dart';
import 'package:balansing/models/user_model.dart';

// Pastikan GrowthData diimpor dengan benar
import 'package:balansing/card/DashboardChart.dart' show GrowthData;

class IbuBerandaScreen extends StatefulWidget {
  const IbuBerandaScreen({super.key});

  @override
  State<IbuBerandaScreen> createState() => _IbuBerandaScreenState();
}

class _IbuBerandaScreenState extends State<IbuBerandaScreen> {
  String _activeButton = 'Pertumbuhan';
  String? _selectedAnakId;
  late final IbuServices _ibuServices;

  @override
  void initState() {
    super.initState();
    _ibuServices = IbuServices();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<DashboardIbuProvider>(context, listen: false);
      try {
        final email = User.instance.email;

        final anakList = await _ibuServices.getAllAnak(email);
        if (anakList.isNotEmpty) {
          _selectedAnakId = anakList.first['id'];
          await provider.fetchDashboardData(_selectedAnakId!);
        } else {
          provider.setError('Tidak ada data anak ditemukan.');
        }
      } catch (e) {
        provider.setError('Gagal memuat data: $e');
      }
    });
  }

  Future<void> _showAnakSelectionModal() async {
    try {
      final email = User.instance.email;

      final anakList = await _ibuServices.getAllAnak(email);

      if (anakList.isEmpty) {
        _showErrorDialog("Tidak ada data anak yang bisa dipilih.");
        return;
      }

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pilih Anak",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: anakList.length,
                    itemBuilder: (context, index) {
                      final anak = anakList[index];
                      return ListTile(
                        title: Text(anak['nama']),
                        onTap: () {
                          setState(() {
                            _selectedAnakId = anak['id'];
                          });
                          Navigator.pop(context);
                          Provider.of<DashboardIbuProvider>(context, listen: false)
                              .fetchDashboardData(_selectedAnakId!);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      _showErrorDialog("Gagal memuat daftar anak: $e");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  String _formatAge(int totalBulan) {
    if (totalBulan >= 12) {
      int tahun = (totalBulan / 12).floor();
      int bulan = totalBulan % 12;
      return "$tahun tahun ${bulan > 0 ? '$bulan bulan' : ''}".trim();
    } else {
      return "$totalBulan bulan";
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return months[month - 1];
  }

  List<GrowthData> _mapToGrowthData(List<dynamic> data) {
    return data.asMap().entries.map((entry) =>
      GrowthData(
        month: entry.key + 1,
        value: (entry.value as num).toDouble(),
      )).toList();
  }

  Map<String, dynamic> _getStuntingStatus(String status) {
    switch (status) {
      case 'Tinggi':
      case 'Normal':
        return {
          'text': "Sehat",
          'color': const Color(0xFF9FC86A),
          'image': 'assets/images/FineIcon.png',
          'highlightColor': const Color(0xFFF4F9EC),
        };
      case 'Pendek':
        return {
          'text': "Waspada",
          'color': const Color(0xFFFACC15),
          'image': 'assets/images/WarningIcon.png',
          'highlightColor': const Color(0xFFFEF9C3),
        };
      case 'SangatPendek':
        return {
          'text': "Stunting",
          'color': const Color(0xFFDC2626),
          'image': 'assets/images/DangerIcon.png',
          'highlightColor': const Color(0xFFFEE2E2),
        };
      default:
        return {
          'text': "Kondisi Sehat",
          'color': const Color(0xFF9FC86A),
          'image': 'assets/images/FineIcon.png',
          'highlightColor': const Color(0xFFF4F9EC),
        };
    }
  }

  Map<String, dynamic> _getAnemiaStatus(bool isAnemic) {
    return isAnemic
      ? {
          'text': "Anemia",
          'color': const Color(0xFFDC2626),
          'image': 'assets/images/DangerIcon.png',
          'highlightColor': const Color(0xFFFEE2E2),
        }
      : {
          'text': "Sehat",
          'color': const Color(0xFF9FC86A),
          'image': 'assets/images/FineIcon.png',
          'highlightColor': const Color(0xFFF4F9EC),
        };
  }

   Map<String, dynamic> _getLahirStatus(String status) {
    switch (status) {
      case 'lebih':
      case 'normal':
        return {
          'text': "Sehat",
          'color': const Color(0xFF9FC86A),
          'image': 'assets/images/FineIcon.png',
          'highlightColor': const Color(0xFFF4F9EC),
        };
      case 'kurang':
        return {
          'text': "Waspada",
          'color': const Color(0xFFFACC15),
          'image': 'assets/images/WarningIcon.png',
          'highlightColor': const Color(0xFFFEF9C3),
        };
      default:
        return {
          'text': "Kondisi Sehat",
          'color': const Color(0xFF9FC86A),
          'image': 'assets/images/FineIcon.png',
          'highlightColor': const Color(0xFFF4F9EC),
        };
    }
  }

  Widget _buildResultCard({
    required String title,
    required String status,
    required Color statusColor,
    required Color highlighColor,
    required String imagePath,
    required double width,
    required double height,
  }) {
    return Container(
      width: width * 0.45,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      margin: EdgeInsets.symmetric(horizontal: width * 0.025),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imagePath,
            width: width * 0.08,
            height: width * 0.08,
          ),
          SizedBox(width: width * 0.01),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.03,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                SizedBox(height: height * 0.005),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.01, vertical: height * 0.006),
                  decoration: BoxDecoration(
                    color: highlighColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: width * 0.025,
                        height: width * 0.025,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: statusColor,
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                      Text(
                        status,
                        style: GoogleFonts.poppins(
                          fontSize: width * 0.03,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusView(DashboardIbuProvider provider) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Recap Data Anak Tidak Ditemukan! Mungkin si Kecil belum pernah melakukan pengecekan.", textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: width*0.04, fontWeight: FontWeight.w600)),
            SizedBox(height: height*0.02,),
            Text(
            provider.error!,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.red),
          ),
          SizedBox(height: height*0.02,),

          GestureDetector(
              onTap: _showAnakSelectionModal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Pilih Anak ",
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Color(0xFF454545)),
                ]))
                


          ]) 
        ),
      );
    }
    
    if (provider.data == null) {
      return const Center(child: Text("Tidak ada data dashboard yang tersedia."));
    }

    // Jika data tidak null, tampilkan konten utama
    final data = provider.data!;
    return _buildContent(data);
  }

  Widget _buildContent(data) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    // Menyiapkan data untuk Stunting Card
    _getStuntingStatus(data.statusStunting);

    // Menyiapkan data untuk Anemia Card
    _getAnemiaStatus(data.statusAnemia);

    _getLahirStatus(data.kategoriL);

    // Format tanggal
    final DateTime lastCheckDate = DateTime.parse(data.tanggalPeriksaTerakhir);
    final String formattedDate =
        "${lastCheckDate.day} ${_getMonthName(lastCheckDate.month)} ${lastCheckDate.year}";

    final markdownRekomendasi = data.rekomendasi;

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.04),
            GestureDetector(
            onTap: _showAnakSelectionModal,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    "Dashboard ${data.nama}",
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis, // Tambahkan ini jika mau ...
                    maxLines: 1, // dan ini
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Color(0xFF454545)),
              ],
            ),
          ),
            BabyInfoCard(
              name: data.nama,
              lastCheckUp: formattedDate,
              weight: '${data.bb.toStringAsFixed(1)} kg',
              height: '${data.tb.toStringAsFixed(1)} cm',
              age: _formatAge(data.umur),
              gender: '${data.jenisKelamin}',
            ),
            SizedBox(height: height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildButton("Pertumbuhan", "Pertumbuhan", width),
                _buildButton("Rekomendasi", "Rekomendasi", width),
              ],
            ),
            SizedBox(height: height * 0.02),
            if (_activeButton == "Rekomendasi")
              _buildRekomendasiSection(markdownRekomendasi),
            if (_activeButton == "Pertumbuhan")
              _buildGrowthSection(data, width, height),
          ],
        ),
      ),
    );
  }

  Widget _buildRekomendasiSection(String markdown) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: MarkdownBody(
        data: markdown,
        styleSheet: MarkdownStyleSheet(
          h2: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
          p: GoogleFonts.poppins(fontSize: 14),
          listBullet: GoogleFonts.poppins(fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildGrowthSection(data, double width, double height) {
    final stuntingStatus = _getStuntingStatus(data.statusStunting);
    final anemiaStatus = _getAnemiaStatus(data.statusAnemia);
    final lahirStatus = _getLahirStatus(data.kategoriL);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Status Kesehatan",
                style: GoogleFonts.poppins(
                  fontSize: width * 0.035,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: height * 0.01),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildResultCard(
                      title: "Risiko Stunting",
                      status: stuntingStatus['text'],
                      statusColor: stuntingStatus['color'],
                      imagePath: stuntingStatus['image'],
                      width: width,
                      height: height,
                      highlighColor: stuntingStatus['highlightColor'],
                    ),
                    _buildResultCard(
                      title: "Risiko Anemia",
                      status: anemiaStatus['text'],
                      statusColor: anemiaStatus['color'],
                      imagePath: anemiaStatus['image'],
                      highlighColor: anemiaStatus['highlightColor'],
                      width: width,
                      height: height,
                    ),
                    _buildResultCard(
                      title: "Risiko Lahir",
                      status: lahirStatus['text'],
                      statusColor: lahirStatus['color'],
                      imagePath: lahirStatus['image'],
                      highlighColor: lahirStatus['highlightColor'],
                      width: width,
                      height: height,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: height * 0.02),
        GrowthIndicatorCard(
          title: 'Berat Badan menurut Umur (WFA)',
          value: '${data.bb.toStringAsFixed(2)} kg',
          zScore: data.zScore.toStringAsFixed(2),
          status: 'berat badan normal',
          imagePath: 'assets/images/WeightIcon.png',
          width: width,
          count: 1,
        ),
        SizedBox(height: height * 0.01),
        GrowthChartCard(
          title: 'Berat Badan',
          data: _mapToGrowthData(data.dataBB12Bulan),
          unit: 'kg',
          datasebelum: data.bbSebelumnya,
          title2: 'Berat Lahir',
          status2: data.kategoriL,
          beratLahir: data.bbl,
          unit2: 'gram',
        ),
        GrowthChartCard(
          title: 'Tinggi Badan',
          data: _mapToGrowthData(data.dataTB12Bulan),
          unit: 'cm',
          datasebelum: data.tbSebelumnya,
          title2: 'Tinggi Lahir',
          status2: data.kategoriL,
          beratLahir: data.tbl,
          unit2: 'cm',
        ),
      ],
    );
  }

  Widget _buildButton(String buttonText, String activeState, double width) {
    final bool isActive = _activeButton == activeState;
    const Color activeColor = Color(0xFFF4F9EC);
    const Color inactiveColor = Colors.transparent;
    const Color activeTextColor = Color(0xFF64748B);
    const Color inactiveTextColor = Color(0xFF64748B);
    const Color activeBorderColor = Color(0xFF76A73B);
    const Color inactiveBorderColor = Color(0xFFE2E8F0);

    return GestureDetector(
      onTap: () {
        setState(() {
          _activeButton = activeState;
        });
      },
      child: Container(
        width: width * 0.43,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? activeColor : inactiveColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? activeBorderColor : inactiveBorderColor,
            width: 1.0,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          buttonText,
          style: GoogleFonts.poppins(
            color: isActive ? activeTextColor : inactiveTextColor,
            fontWeight: FontWeight.bold,
            fontSize: width * 0.03,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DashboardIbuProvider>(
        builder: (context, provider, child) {
          return _buildStatusView(provider);
        },
      ),
    );
  }
}