import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16.0),
        child: SizedBox( // <-- Tambahkan SizedBox di sini
          width: double.infinity, // <-- Paksa SizedBox untuk mengambil lebar maksimum
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center, // Ini sekarang akan bekerja
            children: [
              SizedBox(height: height*0.05,),
              Container(
                width: width * 0.9,
                height: height * 0.15,
                color: Colors.blueGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}