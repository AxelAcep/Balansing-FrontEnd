import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/card/DashboardCardI.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:balansing/card/DashboardZBarCard.dart';
import 'package:balansing/card/DashboardChart.dart';
import 'package:provider/provider.dart';
import 'package:balansing/providers/IbuProvider.dart';

// Import GrowthData model from DashboardChart.dart
import 'package:balansing/card/DashboardChart.dart' show GrowthData;

class IbuBerandaScreen extends StatefulWidget {

  const IbuBerandaScreen({super.key});

  @override
  State<IbuBerandaScreen> createState() => _IbuBerandaScreenState();
}

class _IbuBerandaScreenState extends State<IbuBerandaScreen> {
  String _activeButton = 'Rekomendasi';

  String anakId = "cmf1l1845000378icnr3r9vdi";

  String markdownRekomendasi = """
## Nutrisi Seimbang Harian
Menjaga kondisi tetap sehat dimulai dari asupan gizi yang lengkap dan rutin.
1. Sajikan makanan bergizi seimbang: karbohidrat, protein, lemak sehat, serat, vitamin, dan mineral.
2. Pastikan konsumsi makanan sumber zat besi (hati ayam, daging merah, bayam) dan kalsium (susu, keju, tahu).
3. Variasikan menu setiap hari agar anak tidak bosan dan mendapat beragam nutrisi.

## Pola Makan Teratur & Penuh Stimulasi
Bukan hanya "apa yang dimakan", tapi juga "bagaimana proses makannya".
1. Biasakan makan 3 kali sehari + 2 camilan sehat (buah, yogurt, kacang).
2. Libatkan anak dalam memilih atau menyiapkan makanan (menanam sayur, bantu cuci buah).
3. Gunakan momen makan sebagai waktu komunikasi dan edukasi (misal: cerita tentang manfaat wortel untuk mata).

## Tidur & Istirahat yang Cukup
Tidur yang cukup berpengaruh besar terhadap pertumbuhan fisik dan konsentrasi.
1. Pastikan anak tidur sesuai usia (balita: 10–13 jam/hari, usia sekolah: 9–11 jam).
2. Ciptakan rutinitas malam hari yang tenang (tidak layar, tidak makanan berat, suasana remang).
3. Bangunkan anak dengan lembut dan mulai hari dengan rutinitas positif.
""";

  @override
  void initState() {
    super.initState();
    // Panggil provider untuk mengambil data saat widget diinisialisasi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardIbuProvider>(context, listen: false)
          .fetchDashboardData(anakId);
    });
  }

  String _formatAge(int totalBulan) {
    if (totalBulan >= 12) {
      int tahun = (totalBulan / 12).floor();
      int bulan = totalBulan % 12;
      if (bulan > 0) {
        return "$tahun tahun $bulan bulan";
      } else {
        return "$tahun tahun";
      }
    } else {
      return "$totalBulan bulan";
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

  Widget buildButton(String buttonText, String activeState, double width) {
    final bool isActive = _activeButton == activeState;
    final Color activeColor = const Color(0xFFF4F9EC);
    final Color inactiveColor = Colors.transparent;
    final Color activeTextColor = const Color(0xFF64748B);
    final Color inactiveTextColor = const Color(0xFF64748B);
    final Color activeBorderColor = const Color(0xFF76A73B);
    final Color inactiveBorderColor = const Color(0xFFE2E8F0);

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

  List<GrowthData> _mapToGrowthData(List<dynamic> data) {
    return List<GrowthData>.generate(
      data.length,
      (index) => GrowthData(
        month: index + 1,
        value: data[index].toDouble(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Consumer<DashboardIbuProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Gagal memuat data: ${provider.error}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: Colors.red),
                ),
              ),
            );
          }

          if (provider.data == null) {
            return const Center(child: Text("Data tidak ditemukan."));
          }

          final data = provider.data!;

          // Menyiapkan data untuk Stunting Card
          late String stuntingStatusText;
          late Color stuntingColor;
          late String stuntingImage;
          late Color StuntingHighlighColor;

          switch (data.statusStunting) {
            case 'Tinggi':
            case 'Normal':
              stuntingStatusText = "Sehat";
              stuntingImage = 'assets/images/FineIcon.png';
              StuntingHighlighColor = Color(0xFFF4F9EC);
              break;
            case 'Pendek':
              stuntingStatusText = "Waspada";
              stuntingColor = const Color(0xFFFACC15);
              stuntingImage = 'assets/images/WarningIcon.png';
              StuntingHighlighColor = Color(0xFFFEF9C3);
              break;
            case 'SangatPendek':
              stuntingStatusText = "Stunting";
              stuntingColor = const Color(0xFFDC2626);
              stuntingImage = 'assets/images/DangerIcon.png';
              StuntingHighlighColor = Color(0xFFFEE2E2);
              break;
            default:
              stuntingStatusText = "Kondisi Sehat";
              stuntingColor = const Color(0xFF9FC86A);
              stuntingImage = 'assets/images/FineIcon.png';
              StuntingHighlighColor = Color(0xFFF4F9EC);
              break;
          }

          // Menyiapkan data untuk Anemia Card
          late String anemiaStatusText;
          late Color anemiaColor;
          late String anemiaImage;
          late Color highlighAnemiaColor;

          if (data.statusAnemia) {
            anemiaStatusText = "Anemia";
            highlighAnemiaColor = Color(0xFFFEE2E2);
            anemiaImage = 'assets/images/DangerIcon.png';
          } else {
            anemiaStatusText = "Sehat";
            anemiaColor = Color(0xFF9FC86A);
            highlighAnemiaColor = Color(0xFFF4F9EC);
            anemiaImage = 'assets/images/FineIcon.png';
          }

          // Format tanggal
          final DateTime lastCheckDate =
              DateTime.parse(data.tanggalPeriksaTerakhir);
          final String formattedDate =
              "${lastCheckDate.day} ${_getMonthName(lastCheckDate.month)} ${lastCheckDate.year}";

          return SingleChildScrollView(
            child: Container(
              color: Colors.white,
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.04),
                  Text(
                    "Dashboard ${data.nama} ↓",
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  BabyInfoCard(
                    name: data.nama,
                    lastCheckUp: formattedDate,
                    weight: '${data.bb.toStringAsFixed(1)} kg',
                    height: '${data.tb.toStringAsFixed(1)} cm',
                    age: _formatAge(data.umur),
                    gender: 'laki-laki', // Jenis kelamin tidak ada di respons JSON
                  ),
                  SizedBox(height: height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildButton("Pertumbuhan", "Pertumbuhan", width),
                      buildButton("Rekomendasi", "Rekomendasi", width),
                    ],
                  ),
                  SizedBox(height: height * 0.02),
                  if (_activeButton == "Rekomendasi")
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: const Color(0xFFE2E8F0), width: 1),
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
                        data: markdownRekomendasi,
                        styleSheet: MarkdownStyleSheet(
                          h2: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          p: GoogleFonts.poppins(fontSize: 14),
                          listBullet: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                    ),
                  if (_activeButton != "Rekomendasi")
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        border:
                            Border.all(color: const Color(0xFFE2E8F0), width: 1),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                Row(
                                  children: [
                                    _buildResultCard(
                                      title: "Risiko Stunting",
                                      status: stuntingStatusText,
                                      statusColor: stuntingColor,
                                      imagePath: stuntingImage,
                                      width: width,
                                      height: height,
                                      highlighColor: StuntingHighlighColor,
                                    ),
                                    _buildResultCard(
                                      title: "Risiko Anemia",
                                      status: anemiaStatusText,
                                      statusColor: anemiaColor,
                                      imagePath: anemiaImage,
                                      highlighColor: highlighAnemiaColor,
                                      width: width,
                                      height: height,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_activeButton != "Rekomendasi")
                    SizedBox(height: height * 0.02),
                  if (_activeButton != "Rekomendasi")
                    GrowthIndicatorCard(
                      title: 'Berat Badan menurut Umur (WFA)',
                      value: '${data.bb.toStringAsFixed(2)} kg',
                      zScore: data.zScore.toStringAsFixed(2),
                      status: 'berat badan normal', // Data tidak ada di JSON
                      imagePath: 'assets/images/WeightIcon.png',
                      width: MediaQuery.of(context).size.width,
                      count: 1, // Data tidak ada di JSON
                    ),
                  if (_activeButton != "Rekomendasi")
                    SizedBox(height: height * 0.01),
                  if (_activeButton != "Rekomendasi")
                    GrowthChartCard(
                      title: 'Berat Badan',
                      data: _mapToGrowthData(data.dataBB12Bulan),
                      unit: 'kg',
                    ),
                  if (_activeButton != "Rekomendasi")
                    GrowthChartCard(
                      title: 'Tinggi Badan',
                      data: _mapToGrowthData(data.dataTB12Bulan),
                      unit: 'cm',
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

String _getMonthName(int month) {
  const months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];
  return months[month - 1];
}