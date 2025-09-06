import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/services/ibu_services.dart';
import 'package:balansing/card/ResultAnakCard.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class IbuCekIIScreen extends StatefulWidget {
  final String id;
  final String idAnak;

  const IbuCekIIScreen({super.key, required this.id, required this.idAnak});

  @override
  State<IbuCekIIScreen> createState() => _IbuCekIIScreenState();
}

class _IbuCekIIScreenState extends State<IbuCekIIScreen> {
  Map<String, dynamic>? _anakData;
  Map<String, dynamic>? _recapData;
  Map<String, dynamic>? _lastData;
  double? beratBadan;
  double? tinggiBadan;
  double? lastberatBadan;
  double? lasttinggiBadan;
  double? selisihBerat;
  double? selisihTinggi;
  bool _isLoading = true;
  String _activeButton = 'Rekomendasi'; 

String markdownRekomendasi = """
Test
""";

// Tambahkan variabel baru untuk konten "Artikel"
String markdownArtikel = """
## Pentingnya Gizi Seimbang untuk Anak
Gizi seimbang adalah kunci utama untuk memastikan anak tumbuh optimal. Kekurangan nutrisi bisa menyebabkan berbagai masalah kesehatan, termasuk stunting dan anemia.

1. **Karbohidrat**: Sumber energi utama bagi anak.
2. **Protein**: Penting untuk membangun dan memperbaiki jaringan tubuh.
3. **Zat Besi**: Mencegah anemia, yang dapat mengganggu konsentrasi dan energi anak.
4. **Vitamin dan Mineral**: Mendukung sistem kekebalan tubuh dan fungsi organ.

## Kenali Tanda-tanda Awal Stunting
Stunting sering kali sulit dideteksi tanpa pengukuran yang tepat. Namun, ada beberapa tanda awal yang bisa diperhatikan:
* Tinggi badan di bawah rata-rata.
* Perkembangan motorik yang lambat.
* Sering sakit.

Jika Anda melihat tanda-tanda ini, segera lakukan pengukuran dan konsultasikan dengan dokter.
""";

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final Map<String, dynamic> anakData = await IbuServices().getDetailAnak(widget.idAnak);
      final Map<String, dynamic> recapData = await IbuServices().getDetailRecap(widget.id);

      setState(() {
        _anakData = anakData;
        _recapData = recapData['currentRecap'];
        _lastData = recapData['previousRecap'];
        
        beratBadan = (_recapData?['beratBadan'] as num?)?.toDouble() ?? 0.0;
        tinggiBadan = (_recapData?['tinggiBadan'] as num?)?.toDouble() ?? 0.0;
        
        // Cek jika _lastData tidak null, baru ambil nilainya. Jika null, tetap null.
        if (_lastData != null) {
          lastberatBadan = (_lastData?['beratBadan'] as num?)?.toDouble() ?? 0.0;
          lasttinggiBadan = (_lastData?['tinggiBadan'] as num?)?.toDouble() ?? 0.0;
        }
        
        // Lakukan perhitungan hanya jika _lastData tidak null
        if (_lastData != null) {
          selisihBerat = (beratBadan ?? 0) - (lastberatBadan ?? 0);
          selisihTinggi = (tinggiBadan ?? 0) - (lasttinggiBadan ?? 0);
        } else {
          selisihBerat = 0; // Atau biarkan null jika Anda ingin menanganinya di UI
          selisihTinggi = 0; // Atau biarkan null jika Anda ingin menanganinya di UI
        }

        print(_recapData?['rekomendasi']);
        markdownRekomendasi = (_recapData?['rekomendasi'] ?? "").toString();


        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildResultCard({
    required String title,
    required String status,
    required String description,
    required Color statusColor,
    required String imagePath,
    required double width,
    required double height,
  }) {
    return Container(
      width: width * 0.75,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      margin: EdgeInsets.symmetric(horizontal: width * 0.025),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1), // Warna bayangan (transparan)
                              spreadRadius: 1, // Sebaran bayangan
                              blurRadius: 5, // Kehalusan bayangan
                              offset: const Offset(0, 3), // Posisi bayangan (x, y)
                            ),
                          ],
      ),
      
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imagePath,
            width: width * 0.1,
            height: width * 0.1,
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
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                SizedBox(height: height * 0.005),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.03,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.005),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.03,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final String statusStunting = _recapData?['stunting'] ?? 'Normal';
    final bool statusAnemia = _recapData?['anemia'] ?? false;

    // Menyiapkan data untuk Stunting Card
    late String stuntingStatusText;
    late String stuntingDesc;
    late Color stuntingColor;
    late String stuntingImage;

    switch (statusStunting) {
      case 'Tinggi':
      case 'Normal':
        stuntingStatusText = "Kondisi Sehat";
        stuntingDesc = "Pertumbuhan Anak saat ini tergolong baik dan sesuai usianya. Tetap jaga asupan gizi, pola makan, dan stimulasi agar pertumbuhannya optimal di masa depan.";
        stuntingColor = const Color(0xFF9FC86A);
        stuntingImage = 'assets/images/FineIcon.png';
        break;
      case 'Pendek':
        stuntingStatusText = "Waspada";
        stuntingDesc = "Anak menunjukkan tanda-tanda pertumbuhan yang sedikit di bawah rata-rata. Ini belum masuk kategori stunting, tapi perlu perhatian lebih pada pola makan bergizi dan pemantauan tinggi badan secara rutin.";
        stuntingColor = const Color(0xFFFACC15);
        stuntingImage = 'assets/images/WarningIcon.png';
        break;
      case 'SangatPendek':
        stuntingStatusText = "Risiko Tinggi";
        stuntingDesc = "Berdasarkan data tinggi badan dan usia, Anak masuk kategori stunting. Ini berarti pertumbuhannya telah terhambat. Konsultasikan dengan tenaga medis dan pastikan mendapat asupan nutrisi seimbang dan pemantauan lanjutan.";
        stuntingColor = const Color(0xFFDC2626);
        stuntingImage = 'assets/images/DangerIcon.png';
        break;
      default:
        stuntingStatusText = "Kondisi Sehat";
        stuntingDesc = "Data pertumbuhan belum tersedia. Mohon lakukan pengukuran untuk mendapatkan hasil.";
        stuntingColor = const Color(0xFF9FC86A);
        stuntingImage = 'assets/images/FineIcon.png';
        break;
    }

    // Menyiapkan data untuk Anemia Card
    late String anemiaStatusText;
    late String anemiaDesc;
    late Color anemiaColor;
    late String anemiaImage;

    if (statusAnemia) {
      anemiaStatusText = "Risiko Tinggi";
      anemiaDesc = "Hasil menunjukkan Anak kemungkinan mengalami anemia. Kondisi ini dapat memengaruhi konsentrasi, energi, dan tumbuh kembangnya. Disarankan untuk segera konsultasi ke fasilitas kesehatan dan mulai perbaikan gizi.";
      anemiaColor = const Color(0xFFDC2626);
      anemiaImage = 'assets/images/DangerIcon.png';
    } else {
      anemiaStatusText = "Kondisi Sehat";
      anemiaDesc = "Hasil menunjukkan Anak tidak memiliki tanda-tanda anemia. Terus penuhi kebutuhan zat besi melalui makanan bergizi agar tubuh dan otaknya berkembang optimal.";
      anemiaColor = const Color(0xFF9FC86A);
      anemiaImage = 'assets/images/FineIcon.png';
    }
    
    final String userName = _anakData?['nama'] ?? "-";
    final String userGender = _anakData?['jenisKelamin'] ?? "-";

    String userAge;
    int totalBulan = _recapData?['usia'] ?? 0;

    if (totalBulan >= 12) {
      int tahun = (totalBulan / 12).floor();
      int bulan = totalBulan % 12;
      if (bulan > 0) {
        userAge = "$tahun tahun $bulan bulan";
      } else {
        userAge = "$tahun tahun";
      }
    } else {
      userAge = "$totalBulan bulan";
    }

     Widget buildButton(String buttonText, String activeState) {
      final bool isActive = _activeButton == activeState;
      final Color activeColor = const Color(0xFFF4F9EC);
      final Color inactiveColor = const Color.fromARGB(0, 226, 232, 240);
      final Color activeTextColor = const Color(0xFF64748B);
      final Color inactiveTextColor = const Color(0xFF64748B);
      final Color activeBorderColor = const Color(0xFF76A73B);
      final Color inactiveBorderColor = const Color(0xFFE2E8F0);

      return GestureDetector(
        onTap: () {
          setState(() {
            _activeButton = activeState;
            // Tambahkan logika untuk mengganti konten di sini
            // misalnya: _showRekomendasiContent() atau _showArtikelContent()
          });
        },
        child: Container(
          width: width*0.36, // Atur lebar sesuai kebutuhan
          padding: const EdgeInsets.symmetric(vertical: 8),
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
            style: TextStyle(
              color: isActive ? activeTextColor : inactiveTextColor,
              fontWeight: FontWeight.bold,
              fontSize: width * 0.03,
            ),
          ),
        ),
      );
    }


    Widget _buildProgressCard(double? now, double? late, double? selisih, String title, String unit) {
      String lateText = late != null ? "$late $unit" : "-";
      String selisihText = selisih != null ? "${selisih < 0 ? '' : '+'}${selisih} $unit" : "-";
      Color selisihColor = selisih != null
          ? (selisih < 0 ? const Color(0xFFF87171) : const Color(0xFF76A73B))
          : const Color(0xFF64748B);

      return Container(
        width: width * 0.75,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        margin: EdgeInsets.symmetric(horizontal: width * 0.025),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1), // Warna bayangan (transparan)
                              spreadRadius: 1, // Sebaran bayangan
                              blurRadius: 5, // Kehalusan bayangan
                              offset: const Offset(0, 3), // Posisi bayangan (x, y)
                            ),
                          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 0, 0, 0),
                )),
                SizedBox(height: height * 0.01),
                Text("Sekarang : $now $unit", style: GoogleFonts.poppins(
                  fontSize: width * 0.03,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromARGB(255, 0, 0, 0),
                )),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  selisihText,
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w600,
                    color: selisihColor,
                  ),
                ),
                SizedBox(height: height * 0.01),
                Text("Sebelumnya : $lateText", style: GoogleFonts.poppins(
                  fontSize: width * 0.03,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                )),
              ],
            )
          ],
        ),
      );
    }

    return Scaffold(
      body: Container(color: const Color.fromARGB(255, 255, 255, 255), child : SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserCard(
              name: userName,
              gender: userGender,
              age: userAge,
              width: width,
              height: height,
            ),
            Container(
              color: Colors.transparent,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Text(
                      "Hasil Penilaian",
                      style: GoogleFonts.poppins(
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  SizedBox(height: height * 0.01),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildResultCard(
                            title: "Risiko Stunting",
                            status: stuntingStatusText,
                            description: stuntingDesc,
                            statusColor: stuntingColor,
                            imagePath: stuntingImage,
                            width: width,
                            height: height,
                          ),
                          _buildResultCard(
                            title: "Risiko Anemia",
                            status: anemiaStatusText,
                            description: anemiaDesc,
                            statusColor: anemiaColor,
                            imagePath: anemiaImage,
                            width: width,
                            height: height,
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Text(
                      "Laporan Pertumbuhan",
                      style: GoogleFonts.poppins(
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  SizedBox(height: height * 0.02),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildProgressCard(beratBadan ?? 0, lastberatBadan, selisihBerat, "Berat Badan", "Kg"),
                        _buildProgressCard(tinggiBadan ?? 0, lasttinggiBadan, selisihTinggi, "Tinggi Badan", "cm"),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Text(
                      "Rekomendasi Khusus Bunda",
                      style: GoogleFonts.poppins(
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16), 
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildButton("Rekomendasi", "Rekomendasi"),
                        buildButton("Artikel", "Artikel"),
                        ],
                      ),
                      SizedBox(height: height*0.02),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1), // Warna bayangan (transparan)
                              spreadRadius: 1, // Sebaran bayangan
                              blurRadius: 5, // Kehalusan bayangan
                              offset: const Offset(0, 3), // Posisi bayangan (x, y)
                            ),
                          ],
                        ),
                        child: _activeButton == 'Rekomendasi'
                        ? Container(
                            child: MarkdownBody(
                              data: markdownRekomendasi,
                              styleSheet: MarkdownStyleSheet(
                                h2: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
                                p: GoogleFonts.poppins(fontSize: 14),
                                listBullet: GoogleFonts.poppins(fontSize: 14),
                              ),
                            ),
                          )
                        : Container(
                            child: MarkdownBody(
                              data: markdownArtikel,
                              styleSheet: MarkdownStyleSheet(
                                h2: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
                                p: GoogleFonts.poppins(fontSize: 14),
                                listBullet: GoogleFonts.poppins(fontSize: 14),
                              ),
                            )),
                      ),
                    ],
                    )
                  ),
                  SizedBox(height: height * 0.02),
                   Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Navigate to the next screen and wait for it to return
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9FC86A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            elevation: 0,
                          ),
                          child: Text(
                            "Selanjutnya",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.05),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}