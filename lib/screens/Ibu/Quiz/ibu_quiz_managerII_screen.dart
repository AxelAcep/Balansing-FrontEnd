import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/screens/Ibu/Quiz/ibu_quiz_managerI_screen.dart';
import 'package:balansing/screens/Ibu/Quiz/ibu_quiz_managerIII_screen.dart';

class IbuQuizManagerIIScreen extends StatefulWidget {
  const IbuQuizManagerIIScreen({super.key});

  @override
  State<IbuQuizManagerIIScreen> createState() => _IbuQuizManagerIIScreenState();
}

class _IbuQuizManagerIIScreenState extends State<IbuQuizManagerIIScreen> {
  // Variabel untuk menyimpan pilihan pengguna
  int? _selectedOption; // Variabel ini akan menyimpan 0 (A), 1 (B), atau 2 (C)
  final QuizScoreManager _scoreManager = QuizScoreManager();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.055),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Sanitasi',
                  style: GoogleFonts.poppins(
                      fontSize: width * 0.04, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Pertanyaan 1 dari 8',
                  style: GoogleFonts.poppins(
                      color: const Color(0xFFA1A1AA),
                      fontSize: width * 0.035,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
            SizedBox(height: height * 0.005),
            LinearProgressIndicator(
              value: 2 / 9,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFB1D581)),
              minHeight: height * 0.012,
              borderRadius: BorderRadius.circular(10),
            ),
            SizedBox(height: height * 0.02),
            Text(
              "Manakah gambaran di bawah ini yang paling mendekati kebiasaan keluarga Bunda dalam sebulan?",
              style: GoogleFonts.poppins(
                  fontSize: width * 0.045, fontWeight: FontWeight.w600),
            ),
            
            // --- Bagian Opsi Tombol ---
            
            SizedBox(height: height * 0.02),
            QuizOptionButton(
              label: '(A) 0 - 2 Juta Rupiah',
              description:
                  'Kami sangat cermat dalam mengatur pengeluaran. Lauk utama kami sehari-hari adalah protein nabati (seperti tahu dan tempe) dan telur, dengan sesekali lauk ikan atau ayam.',
              isSelected: _selectedOption == 0,
              onTap: () {
                setState(() {
                  _selectedOption = 0;
                  print('Pilihan A terpilih, nilai variabel: $_selectedOption');
                });
              },
            ),
            SizedBox(height: height * 0.02),
            QuizOptionButton(
              label: '(B) 2 - 9 Juta Rupiah',
              description:
                  'Kami bisa rutin menyediakan lauk hewani seperti ayam dan beragam jenis ikan setiap minggunya, dan cukup leluasa memilih jenis sayur dan buah di pasar.',
              isSelected: _selectedOption == 1,
              onTap: () {
                setState(() {
                  _selectedOption = 1;
                  print('Pilihan B terpilih, nilai variabel: $_selectedOption');
                });
              },
            ),
            SizedBox(height: height * 0.02),
            QuizOptionButton(
              label: '(C) > 9 Juta Rupiah',
              description:
                  'Kami sangat leluasa dalam memilih bahan makanan, bisa membeli berbagai jenis lauk termasuk daging sapi secara rutin, dan sering berbelanja di supermarket.',
              isSelected: _selectedOption == 2,
              onTap: () {
                setState(() {
                  _selectedOption = 2;
                  print('Pilihan C terpilih, nilai variabel: $_selectedOption');
                });
              },
            ),

            // --- Akhir Bagian Opsi Tombol ---

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      print('Kembali');
                      _scoreManager.resetScore();
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Color(0xFFE2E8F0),
                          width: 2.0,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      backgroundColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_left,
                          color: Color(0xFF454545),
                        ),
                        SizedBox(width: width * 0.01),
                        Text(
                          'Kembali',
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF454545),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _selectedOption == null
                        ? null // Tombol dinonaktifkan jika belum ada pilihan
                        : () {
                            print('Selanjutnya');
                            _scoreManager.addScore(_selectedOption ?? 0);
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const IbuQuizManagerIIIScreen()),
                            );
                          },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      backgroundColor: _selectedOption == null
                          ? Colors.grey // Warna abu-abu jika dinonaktifkan
                          : const Color(0xFF9FC86A), // Warna hijau jika aktif
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Selanjutnya',
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: width * 0.01),
                        const Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.05)
          ],
        ),
      ),
    );
  }
}

// Widget kustom untuk tombol pilihan
class QuizOptionButton extends StatelessWidget {
  final String label;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const QuizOptionButton({
    super.key,
    required this.label,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF4F9EC) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFFB1D581) : const Color(0xFFE2E8F0),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF454545),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF454545),
              ),
            ),
          ],
        ),
      ),
    );
  }
}