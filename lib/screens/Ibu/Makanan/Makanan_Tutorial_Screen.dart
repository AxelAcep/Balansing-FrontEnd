import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MakananTutorialScreen extends StatefulWidget {
  const MakananTutorialScreen({super.key});

  @override
  State<MakananTutorialScreen> createState() => _MakananConfirmScreenState();
}

class _MakananConfirmScreenState extends State<MakananTutorialScreen> {

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

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
              SizedBox(height: height * 0.02),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.centerLeft,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: height * 0.035,
                      height: height * 0.035,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1.0,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF020617),
                        size: 20.0,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      "Kembali",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF020617),
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),
              Text(
                "Cara Cek Keberagaman Makanan",
                style: GoogleFonts.poppins(
                  fontSize: width * 0.07,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: height*0.02),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1, color: Color(0xFFD1D5DB)),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                    boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1), // Warna bayangan (transparan)
                      spreadRadius: 1, // Sebaran bayangan
                      blurRadius: 5, // Kehalusan bayangan
                      offset: const Offset(0, 3), // Posisi bayangan (x, y)
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "1. Pastikan foto diambil dari atas makanan, seperti contoh gambar di bawah",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF64748B),
                        fontSize: width * 0.03,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: height*0.01,),
                    Image.asset("assets/images/Tutorial1.jpg"),
                    SizedBox(height: height*0.01,),
                    Text(
                      "2.Konfirmasi gambar yang telah diambil",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF64748B),
                        fontSize: width * 0.03,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "3. Konfirmasi makanan yang terdeteksi oleh sistem. Lihat gambar di bawah ini",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF64748B),
                        fontSize: width * 0.03,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: height*0.01),
                    Image.asset('assets/images/Tutorial2.png'),
                    SizedBox(height: height*0.02),
                    Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Color(0xFF9FC86A),
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Gunakan fitur “cari disini” untuk menambahkan makanan yang tidak terdeteksi oleh sistem",
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF64748B),
                          fontSize: width * 0.025,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height*0.02),
                Text(
                      "4. Eksplorasi halaman hasil termasuk “Rekomendasi” dan “Artikel”",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF64748B),
                        fontSize: width * 0.03,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height*0.1,)
            ],
          ),
        ),
      ),
    );
  }
}