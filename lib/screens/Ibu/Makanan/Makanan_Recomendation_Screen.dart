import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:balansing/services/ibu_services.dart'; // Pastikan path ini benar

class MakananRecomendationScreen extends StatefulWidget {
  final List<String> DDS;

  const MakananRecomendationScreen({super.key, required this.DDS});

  @override
  State<MakananRecomendationScreen> createState() => _MakananRecomendationScreenState();
}

class _MakananRecomendationScreenState extends State<MakananRecomendationScreen> {
  // Map untuk menyimpan nama tampilan dari setiap kategori
  final Map<String, String> _labelNames = {
    "makanan_berpati": "Sumber Karbohidrat",
    "kacang_legume": "Kacang legume",
    "produk_susu": "Produk susu",
    "daging": "Produk daging",
    "telur": "Telur",
    "buah_sayur_lainnya": "Buah dan sayur lainnya",
    "buah_sayur_vitA": "Buah dan sayur vitamin A",
  };

  String _activeButton = 'Rekomendasi';
  String _markdownRekomendasi = "Sedang memuat rekomendasi..."; // Teks awal sebelum loading
  bool _isLoading = true;
  final IbuServices _ibuServices = IbuServices();

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
    _loadRekomendasi();
  }

  Future<void> _loadRekomendasi() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _ibuServices.generateKeberagamanMakanan(widget.DDS);
      setState(() {
        _markdownRekomendasi = result["rekomendasi"] ?? "Gagal memuat rekomendasi.";
      });
    } catch (e) {
      setState(() {
        _markdownRekomendasi = "Terjadi kesalahan: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    String status;
    Color warnaStatus;
    String deskripsi;

    int ddsCount = widget.DDS.length;

    if (ddsCount == 7) {
      status = "Sangat Beragam";
      warnaStatus = const Color(0xFF9FC86A);
      deskripsi = "Sempurna, Bunda! Hari ini menu si Kecil sudah mencakup semua 7 kelompok pangan esensial. Pertahankan terus prestasi hebat ini untuk dukung tumbuh kembangnya!";
    }
    else if (ddsCount >= 5 && ddsCount < 7) {
      status = "Beragam";
      warnaStatus = const Color(0xFF9FC86A);
      deskripsi = "Bagus sekali, Bunda! Hari ini si Kecil sudah mencapai target keberagaman pangan dengan $ddsCount dari 7 kelompok. Ini adalah fondasi yang kuat, yuk besok kita coba tambahkan 1 jenis makanan lagi!";
    } else if (ddsCount >= 4 && ddsCount <= 4) {
      status = "Cukup Beragam";
      warnaStatus = const Color(0xFFFACC15);
      deskripsi = "Bagus sekali, Bunda! Hari ini si Kecil sudah mencapai target minimal keberagaman pangan dengan $ddsCount dari 7 kelompok. Ini adalah fondasi yang kuat, yuk besok kita coba tambahkan 1 jenis makanan lagi!";
    } else { // ddsCount <= 3
      status = "Kurang Beragam";
      warnaStatus = const Color(0xFFDC2626);
      deskripsi = "Semangat selalu ya, Bunda! Hari ini menu si Kecil mencakup $ddsCount dari 7 kelompok pangan. Mari kita mulai langkah pertama besok dengan mencoba menambahkan sepotong buah atau satu jenis sayuran hijau.";
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
          });
        },
        child: Container(
          width: width * 0.36,
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

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.05),
              Text(
                "Hasil",
                style: GoogleFonts.poppins(
                  fontSize: width * 0.07,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Mari simak informasi berikut ini",
                style: GoogleFonts.poppins(
                  color: const Color(0xFF64748B),
                  fontSize: width * 0.03,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: height * 0.02),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  border: Border.all(width: 1, color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dietary Diversity Score (DDS)",
                      style: GoogleFonts.poppins(
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              " $ddsCount",
                              style: GoogleFonts.poppins(
                                fontSize: width * 0.055,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "/7",
                              style: GoogleFonts.poppins(
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          status,
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.w500,
                            color: warnaStatus,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.01),
                    LinearProgressIndicator(
                      value: ddsCount / 7,
                      backgroundColor: const Color(0xFFF1F5F9),
                      valueColor: AlwaysStoppedAnimation<Color>(warnaStatus),
                      minHeight: height * 0.018,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    SizedBox(height: height * 0.02),
                    Text(
                      deskripsi,
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF64748B),
                        fontSize: width * 0.03,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  border: Border.all(width: 1, color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kelompok Makanan",
                      style: GoogleFonts.poppins(
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: height * 0.02),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _labelNames.length,
                      itemBuilder: (context, index) {
                        String key = _labelNames.keys.elementAt(index);
                        bool isPresent = widget.DDS.contains(key);
                        Color iconColor = isPresent ? const Color(0xFF9FC86A) : const Color(0xFFFACC15);
                        Color textColor = isPresent ? const Color(0xFF64748B) : const Color(0xFFFACC15);
                        IconData icon = isPresent ? Icons.check_circle_outline : Icons.info_outline;
                        return Container(
                          margin: EdgeInsets.only(bottom: height * 0.005),
                          child: Row(
                            children: [
                              Icon(
                                icon,
                                color: iconColor,
                                size: width * 0.05,
                              ),
                              SizedBox(width: width * 0.03),
                              Text(
                                _labelNames[key]!,
                                style: GoogleFonts.poppins(
                                  fontSize: width * 0.04,
                                  fontWeight: FontWeight.w400,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rekomendasi Khusus Bunda",
                      style: GoogleFonts.poppins(
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildButton("Informasi Nutrisi", "Rekomendasi"),
                        buildButton("Resep", "Artikel"),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: _activeButton == 'Rekomendasi'
                          ? _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : MarkdownBody(
                                  data: _markdownRekomendasi,
                                  styleSheet: MarkdownStyleSheet(
                                    h2: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
                                    p: GoogleFonts.poppins(fontSize: 14),
                                    listBullet: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                )
                          : MarkdownBody(
                              data: markdownArtikel,
                              styleSheet: MarkdownStyleSheet(
                                h2: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
                                p: GoogleFonts.poppins(fontSize: 14),
                                listBullet: GoogleFonts.poppins(fontSize: 14),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
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
                    "Kembali",
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
      ),
    );
  }
}