import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Pastikan jalur impor ini benar di proyek Anda
import 'package:balansing/screens/AuthKader/LoginScreen.dart'; 
import 'package:balansing/screens/AuthIbu/LoginScreenIbu.dart'; // 

class PathScreen extends StatefulWidget {

  const PathScreen({super.key});

  @override
  State<PathScreen> createState() => _PathScreen();
}

class _PathScreen extends State<PathScreen> {
  bool _KaderisSelected = false;
  bool _IbuisSelected = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final Color containerColor = _KaderisSelected ? const Color(0xFFF4F9EC) : Colors.white;
    final Color borderColor = _KaderisSelected ? const Color(0xFF9FC86A) : const Color(0xFFE2E8F0);

    final Color containerColor1 = _IbuisSelected ? const Color(0xFFF4F9EC) : Colors.white;
    final Color borderColor1 = _IbuisSelected ? const Color(0xFF9FC86A) : const Color(0xFFE2E8F0);

    final Color buttonColor = (_KaderisSelected || _IbuisSelected) ? const Color(0xFF9FC86A) : const Color(0xFF878B94);

    return Scaffold(
      backgroundColor: Colors.white, 
        body: Center(child: (Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: height*0.0,),
            Container(
                width: width * 1, 
                height: height * 0.35, 
                color: Colors.transparent, 
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.transparent,               
                        Colors.white.withOpacity(0.5),    
                        Colors.white,                  
                      ],
                      stops: const [0.0, 0.4, 1.0], 
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn, 
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/PatthIllust.png'), 
                        fit: BoxFit.cover, 
                      ),
                    ),
                  ),
                ),
              ),
            Container(
              width: width * 0.9,
              height: height * 0.45,
              child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Pilih Role Anda", style: GoogleFonts.poppins(
                    fontSize: height*0.03,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF76A73B),
                  ),),
                  Text("Mulai perjalananmu sesuai peran. Pilih sebagai Ibu atau Kader dan nikmati fitur yang dibuat khusus buat Anda", style: GoogleFonts.poppins(
                    fontSize: height*0.013,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF64748B),
                  ),),
                  SizedBox(height: height * 0.02,),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _KaderisSelected = !_KaderisSelected;
                        if(_IbuisSelected) {
                          _IbuisSelected = false; // Pastikan hanya satu yang bisa dipilih
                        }
                      });
                    },
                    child: Container(
                      height: height * 0.12,
                      width:  width * 0.9,
                      decoration: BoxDecoration(
                        color: containerColor, // Gunakan warna yang berubah
                        border: Border.all(
                          color: borderColor, // Gunakan warna border yang berubah
                          width: 1.0,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 6.0,
                            spreadRadius: 0.0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8.0), // Opsional: tambahkan sedikit border radius
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Role Kader",
                                    style: GoogleFonts.poppins(
                                      fontSize: height*0.018,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF020617),
                                    ),
                                  ),
                                  Text(
                                    "Akses data ibu & anak, catat kunjungan, dan bantu mereka tumbuh sehat",
                                    style: GoogleFonts.poppins(
                                      fontSize: height*0.012,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: height * 0.08,
                              width: height * 0.08, // Lebar sama dengan tinggi untuk bentuk kotak
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/KaderIcon.png'), // Pastikan path benar
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.01,),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _IbuisSelected = !_IbuisSelected; 
                        if(_KaderisSelected) {
                          _KaderisSelected = false; // Pastikan hanya satu yang bisa dipilih
                        }
                      });
                    },
                    child: Container(
                      height: height * 0.12,
                      width:  width * 0.9,
                      decoration: BoxDecoration(
                        color: containerColor1, // Gunakan warna yang berubah
                        border: Border.all(
                          color: borderColor1, // Gunakan warna border yang berubah
                          width: 1.0,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 6.0,
                            spreadRadius: 0.0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8.0), // Opsional: tambahkan sedikit border radius
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Role Ibu",
                                    style: GoogleFonts.poppins(
                                      fontSize: height*0.018,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF020617),
                                    ),
                                  ),
                                  Text(
                                    "Satu klik buat bantu Anda menjadi “Pahlawan Anak” di dunia nyata",
                                    style: GoogleFonts.poppins(
                                      fontSize: height*0.012,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: height * 0.08,
                              width: height * 0.08, // Lebar sama dengan tinggi untuk bentuk kotak
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/IbuIcon.png'), // Pastikan path benar
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(child:
           Container(
              width: width * 0.9,
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- Tombol "Konfirmasi" ditambahkan di sini ---
                  ElevatedButton(
                    onPressed: () {
                      if((_KaderisSelected || _IbuisSelected)){
                        print("Test aja dulu"); 
                        if(_KaderisSelected) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        }
                        if(_IbuisSelected) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreenIbu()),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor, // Warna latar belakang tombol dari hex #0F172A
                      minimumSize: Size(width * 0.9, height * 0.05), // Atur lebar tombol agar sesuai dengan container induk (width * 0.9) dan tinggi 50px
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Opsional: border radius untuk tombol
                      ),
                      padding: EdgeInsets.zero, // Menghapus padding default jika ingin kontrol penuh pada child
                    ),
                    child: Text(
                      "Konfirmasi",
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // --- SizedBox yang sudah ada sebelumnya ---
                  SizedBox(height: height * 0.02),
                ],
              ),
            ),)
            ]
          )
        )
      )
    );
  }
}     