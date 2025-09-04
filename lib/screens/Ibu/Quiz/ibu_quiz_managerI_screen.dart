import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/screens/Ibu/Quiz/ibu_quiz_managerII_screen.dart';


class QuizScoreManager {
  // Singleton instance
  static final QuizScoreManager _instance = QuizScoreManager._internal();

  factory QuizScoreManager() {
    return _instance;
  }

  QuizScoreManager._internal();

  // Variabel yang akan menyimpan total poin
  int _totalScore = 0;

  int get totalScore => _totalScore;

  // Metode untuk menambahkan poin
  void addScore(int score) {
    _totalScore += score;
    print("Skor bertambah: $score. Total skor saat ini: $_totalScore");
  }

  int ReturnScore(){
    return totalScore;
  }

  // Metode untuk mereset skor
  void resetScore() {
    _totalScore = 0;
    print("Skor telah direset. Total skor: $_totalScore");
  }
}

class IbuQuizManagerIScreen extends StatefulWidget {
  const IbuQuizManagerIScreen({super.key});

  @override
  State<IbuQuizManagerIScreen> createState() => _IbuQuizManagerIScreenState();
}

class _IbuQuizManagerIScreenState extends State<IbuQuizManagerIScreen> {
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
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: height*0.055,),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Sanitasi', style: GoogleFonts.poppins(fontSize: width*0.04, fontWeight: FontWeight.w600),),
              Text('Pertanyaan 1 dari 7', style: GoogleFonts.poppins(color: Color(0xFFA1A1AA) ,fontSize: width*0.035, fontWeight: FontWeight.w500),)
            ],),
            SizedBox(height: height*0.005,),
            LinearProgressIndicator(
              value: 1/9,
              backgroundColor: Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFB1D581)),
              minHeight: height*0.012,
              borderRadius: BorderRadius.circular(10), // Memberikan sudut melengkung
            ),
            SizedBox(height: height*0.02,),
            Image.asset('assets/images/Quiz1.png', width: double.infinity,),
            SizedBox(height: height * 0.02,),
            Text("Yuk, Kenali Pola Pangan Keluarga", style: GoogleFonts.poppins(fontSize: width*0.045, fontWeight: FontWeight.w600),),
            SizedBox(height: height * 0.01,),
            Text("Hai Bunda, agar kami bisa memberikan rekomendasi menu yang paling pas dan hemat, bantu kami memahami gambaran umum kebiasaan belanja pangan keluarga Bunda, ya.", style: GoogleFonts.poppins(color: Color(0xFF64748B), fontSize: width*0.035, fontWeight: FontWeight.w500),),
            Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround , crossAxisAlignment: CrossAxisAlignment.end, children: [
              TextButton(
                onPressed: () {
                  // Handle ketika tombol ditekan
                  print('Kembali');
                  _scoreManager.resetScore();
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  // Bentuk tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                      color: Color(0xFFE2E8F0), // Warna border
                      width: 2.0,
                    ),
                  ),
                  // Padding internal tombol
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  // Warna latar belakang transparan
                  backgroundColor: Colors.white,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Agar tombol menyesuaikan konten
                  children: [
                    const Icon(
                      Icons.arrow_left,
                      color: Color(0xFF454545), // Warna ikon
                    ),
                    SizedBox(width: width*0.01), // Jarak antara ikon dan teks
                    Text(
                      'Kembali',
                      style: GoogleFonts.poppins(
                        fontSize: width*0.035,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF454545), // Warna teks
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IbuQuizManagerIIScreen(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  // Bentuk tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // Padding internal tombol
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  // Warna latar belakang transparan
                  backgroundColor: Color(0xFF9FC86A),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Agar tombol menyesuaikan konten
                  children: [
                    Text(
                      'Selanjutnya',
                      style: GoogleFonts.poppins(
                        fontSize: width*0.035,
                        fontWeight: FontWeight.w600,
                        color: Colors.white, // Warna teks
                      ),
                    ),
                    SizedBox(width: width*0.01), 
                     const Icon(
                      Icons.arrow_right,
                      color: Colors.white, // Warna teks
                    ),
                  ],
                ),
              )
            ],)),
            SizedBox(height: height*0.05,)
          ],
          )
          ),
        );
  }
}