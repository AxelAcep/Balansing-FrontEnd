import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/screens/Ibu/Quiz/ibu_quiz_managerI_screen.dart';
import 'package:balansing/screens/Ibu/Quiz/ibu_quiz_managerIV_screen.dart';

class IbuQuizManagerIIIScreen extends StatefulWidget {
  const IbuQuizManagerIIIScreen({super.key});

  @override
  State<IbuQuizManagerIIIScreen> createState() => _IbuQuizManagerIIIScreenState();
}

class _IbuQuizManagerIIIScreenState extends State<IbuQuizManagerIIIScreen> {
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
              Text('Pertanyaan 2 dari 7', style: GoogleFonts.poppins(color: Color(0xFFA1A1AA) ,fontSize: width*0.035, fontWeight: FontWeight.w500),)
            ],),
            SizedBox(height: height*0.005,),
            LinearProgressIndicator(
              value: 3/9,
              backgroundColor: Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFB1D581)),
              minHeight: height*0.012,
              borderRadius: BorderRadius.circular(10), // Memberikan sudut melengkung
            ),
            SizedBox(height: height*0.02,),
            Image.asset('assets/images/Quiz2.png', width: double.infinity,),
            SizedBox(height: height * 0.02,),
            Text("Yuk, Ciptakan Perisai Sehat untuk si Kecil!", style: GoogleFonts.poppins(fontSize: width*0.045, fontWeight: FontWeight.w600),),
            SizedBox(height: height * 0.01,),
            Text("Hai Bunda, gizi hebat dari makanan perlu `teman` agar manfaatnya maksimal, yaitu lingkungan rumah yang bersih dan sehat. Yuk, bantu kami memahami beberapa kebiasaan di rumah agar kami bisa memberi tips terbaik untuk melindungi si Kecil dari kuman penyakit.", style: GoogleFonts.poppins(color: Color(0xFF64748B), fontSize: width*0.035, fontWeight: FontWeight.w500),),
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
                      builder: (context) => IbuQuizManagerIVScreen(),
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
            SizedBox(height: height*0.02,)
          ],
          )
          ),
        );
  }
}