import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/card/DashboardCardI.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class IbuBerandaScreen extends StatefulWidget {
  const IbuBerandaScreen({super.key});

  @override
  State<IbuBerandaScreen> createState() => _IbuBerandaScreenState();
}

class _IbuBerandaScreenState extends State<IbuBerandaScreen> {
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    Widget buildButton(String buttonText, String activeState) {
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

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.04),
              Text(
                "Dashboard Alexander ↓",
                style: GoogleFonts.poppins(
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const BabyInfoCard(
                name: 'Alexander Christoper',
                lastCheckUp: '17 Juni 2025',
                weight: '11.2 g',
                height: '80.6 cm',
                age: '1 tahun, 3 bulan',
                gender: 'laki-laki',
              ),
              SizedBox(height: height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildButton("Pertumbuhan", "Pertumbuhan"),
                  buildButton("Rekomendasi", "Rekomendasi"),
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
                    data: markdownRekomendasi,
                    styleSheet: MarkdownStyleSheet(
                      h2: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
                      p: GoogleFonts.poppins(fontSize: 14),
                      listBullet: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ),
                ),
              if (_activeButton != "Rekomendasi")
                const Center(child: Text("Mulai"))
            ],
          ),
        ),
      ),
    );
  }
}