import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/card/AnakIbuCard.dart';

class IbuDataAnakScreen extends StatefulWidget {
  const IbuDataAnakScreen({super.key});

  @override
  State<IbuDataAnakScreen> createState() => _IbuDataAnakScreenState();
}

class _IbuDataAnakScreenState extends State<IbuDataAnakScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // --- Bagian atas yang dapat digulir (ListView) ---
            Expanded(
              child: ListView(
                children: [
                  Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Back Button
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
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(4.0), // Padding di dalam container input
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Data Anak",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: width * 0.055,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Kelola data anak Anda di sini",
                          style: GoogleFonts.poppins(
                            color: Color(0xFF64748B),
                            fontSize: width * 0.03,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: height*0.02,),
                        SingleChildScrollView(
                          child: Column(children: [
                            ChildCard(nama: "Caren", usia: 3, beratBadan: 22, tinggiBadan: 11, anemia: true, stunting: "tinggi", jenisKelamin: "Laki-laki", id: "123"),
                          ],),
                        )
                        
                        
                        
                        ,]))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}