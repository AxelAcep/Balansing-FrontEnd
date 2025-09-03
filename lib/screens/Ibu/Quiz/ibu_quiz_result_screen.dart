import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/screens/Ibu/Quiz/ibu_quiz_managerI_screen.dart'; // Make sure this path is correct
import 'package:flutter_markdown/flutter_markdown.dart';

class IbuQuizResultScreen extends StatefulWidget {
  const IbuQuizResultScreen({super.key});

  @override
  State<IbuQuizResultScreen> createState() => _IbuQuizResultScreenState();
}

class _IbuQuizResultScreenState extends State<IbuQuizResultScreen> {
  final QuizScoreManager _scoreManager = QuizScoreManager();
  late int sanitasi;
  String _activeButton = 'Rekomendasi'; 

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
    sanitasi = _scoreManager.totalScore; // Gunakan .totalScore untuk mendapatkan nilai
    print(sanitasi);
  }

  Widget buildButton(String buttonText, String activeState) {
      double width = MediaQuery.of(context).size.width;
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

  // Widget _buildResultCard tetap sama, tidak perlu diubah
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
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
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

    // Variabel untuk menyimpan hasil berdasarkan skor sanitasi
    String statusResult;
    String descriptionResult;
    Color statusColorResult;
    String imagePathResult;

    if (sanitasi >= 9) {
      statusResult = "Baik";
      descriptionResult = "Kebiasaan sanitasi keluarga Bunda sudah sangat baik! Terus pertahankan agar kesehatan keluarga selalu terjaga.";
      statusColorResult = const Color(0xFF9FC86A); // Menggunakan warna hijau untuk 'Baik'
      imagePathResult = "assets/images/FineIcon.png";
    } else if (sanitasi >= 7 && sanitasi <= 8) {
      statusResult = "Waspada";
      descriptionResult = "Kebiasaan sanitasi keluarga Bunda perlu ditingkatkan. Ada beberapa aspek yang bisa diperbaiki untuk mencegah penyakit.";
      statusColorResult = const Color(0xFFFACC15);
      imagePathResult = "assets/images/WarningIcon.png";
    } else { // sanitasi < 7
      statusResult = "Buruk";
      descriptionResult = "Kebiasaan sanitasi keluarga Bunda sangat perlu perhatian. Segera terapkan kebiasaan baru untuk mencegah dampak buruk pada kesehatan.";
      statusColorResult = const Color(0xFFDC2626);
      imagePathResult = "assets/images/DangerIcon.png";
    }

    return Scaffold(
      body: SingleChildScrollView( child: Container(
        color: Colors.white,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              width: double.infinity,
              height: height * 0.18,
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(68, 158, 158, 158), // Warna bayangan (transparan)
                    spreadRadius: 2, // Sebaran bayangan
                    blurRadius: 5, // Kehalusan bayangan
                    offset: Offset(0, 3), // Posisi bayangan (x, y)
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hai Bunda!",
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.07,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF76A73B),
                    ),
                  ),
                  Text(
                    "Ini dia hasil dari rapor kebiasaan sehat untuk si Kecil.",
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.025,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hasil Penilaian",
                    style: GoogleFonts.poppins(
                        fontSize: width * 0.045, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: height * 0.01),
                  _buildResultCard(
                    title: "Kebersihan Sanitasi",
                    status: statusResult,
                    description: descriptionResult,
                    statusColor: statusColorResult,
                    imagePath: imagePathResult,
                    width: width,
                    height: height,
                  ),
                  SizedBox(height: height*0.02,),
                  Container(
  width: double.infinity,
  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildButton("Rekomendasi", "Rekomendasi"),
          buildButton("Artikel", "Artikel"),
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
            ? Container(
                child: MarkdownBody(
                  data: markdownRekomendasi,
                  styleSheet: MarkdownStyleSheet(
                    h2: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 18),
                    p: GoogleFonts.poppins(fontSize: 14),
                    listBullet: GoogleFonts.poppins(fontSize: 14),
                  ),
                ),
              )
            : Container(
                child: MarkdownBody(
                  data: markdownArtikel,
                  styleSheet: MarkdownStyleSheet(
                    h2: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 18),
                    p: GoogleFonts.poppins(fontSize: 14),
                    listBullet: GoogleFonts.poppins(fontSize: 14),
                  ),
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
      "Selanjutnya",
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: width * 0.035,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
),
SizedBox(height: height * 0.03),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}