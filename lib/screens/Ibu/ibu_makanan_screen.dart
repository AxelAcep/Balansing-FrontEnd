import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/screens/Ibu/Makanan/Makanan_Ibu_Screen.dart';
import 'package:balansing/screens/Ibu/Makanan/Makanan_Tutorial_Screen.dart';


class IbuMakananScreen extends StatefulWidget {
  const IbuMakananScreen({super.key});

  @override
  State<IbuMakananScreen> createState() => _IbuMakananScreenState();
}

class _IbuMakananScreenState extends State<IbuMakananScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(child:  Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.05),
            Text("Gizi Seimbang, Awal Anak Hebat", style: GoogleFonts.poppins(fontSize: width*0.05, fontWeight: FontWeight.w600),),
            SizedBox(height: height * 0.02),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Color(0xFFE2E8F0)),
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
              child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/images/Tutorial.jpg", width: double.infinity),
                SizedBox(height: height*0.02,),
                Text("Tutorial", style: GoogleFonts.poppins(fontSize: width*0.05, fontWeight: FontWeight.w600),),
                SizedBox(height: height*0.01,),
                Text("Panduan untuk menggunakan fitur Cek Variasi Makanan.", style: GoogleFonts.poppins(color: Color(0xFF64748B), fontSize: width*0.035, fontWeight: FontWeight.w400),),
                SizedBox(height: height*0.01,),
                Container(
                  width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                                  print("Tombol Selanjutnya ditekan!");
                                   await Navigator.push( // Await the push so you can refresh
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MakananTutorialScreen(),
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF4F9EC) ,
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(color: Color(0xFF9FC86A), width: 1.0), // Tambahkan baris ini
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            elevation: 0,
                          ),
                          child: Text(
                            "Tutorial",
                            style: GoogleFonts.poppins(
                              color: Color(0xFF9FC86A),
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
              ],
              ),
            ),
            SizedBox(height: height*0.01),
             Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Color(0xFFE2E8F0)),
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
              child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/images/Makanan2.jpg", width: double.infinity),
                SizedBox(height: height*0.02,),
                Text("Variasi Makanan", style: GoogleFonts.poppins(fontSize: width*0.05, fontWeight: FontWeight.w600),),
                SizedBox(height: height*0.01,),
                Text("Cari tahu skor keberagaman pangannya si Kecil.", style: GoogleFonts.poppins(color: Color(0xFF64748B), fontSize: width*0.035, fontWeight: FontWeight.w400),),
                SizedBox(height: height*0.01,),
                Container(
                  width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                                  await Navigator.push( // Await the push so you can refresh
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MakananIbuScreen(),
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9FC86A) ,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            elevation: 0,
                          ),
                          child: Text(
                            "Ambil Foto",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
              ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}