import 'package:balansing/screens/AuthKader/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Pastikan jalur impor ini benar di proyek Anda
// Jika digunakan
// Jika digunakan untuk navigasi kembali
// import 'package:balansing/screens/AuthKader/DaftarScreenII.dart'; // Dihapus karena tidak digunakan di sini

class Confirmdaftar extends StatefulWidget {
  const Confirmdaftar({super.key});

  @override
  State<Confirmdaftar> createState() => _ConfirmdaftarState(); // Mengubah nama state class agar sesuai konvensi
}

class _ConfirmdaftarState extends State<Confirmdaftar> {
  bool _isVisible = false; // State untuk mengontrol visibilitas (opacity) animasi

  @override
  void initState() {
    super.initState();
    // Setelah widget dibangun, atur _isVisible menjadi true untuk memulai animasi fade-in
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _isVisible = true;
      });
    });

    // Setelah durasi animasi selesai, jalankan fungsi yang diinginkan
    // Durasi animasi (misal 1000ms) + sedikit penundaan tambahan jika diperlukan
    Future.delayed(const Duration(milliseconds: 2500), () {
      _onAnimationComplete();
    });
  }

  // Fungsi yang akan dijalankan setelah animasi selesai
  void _onAnimationComplete() {
    print("Animasi selesai!");
     Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => const LoginScreen()),
  (route) => route.isFirst
);}

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white, // Background screen putih
      body: Center(
        child: AnimatedOpacity( // Widget untuk animasi opacity
          opacity: _isVisible ? 1.0 : 0.0, // Opacity dari 0.0 (transparan) ke 1.0 (penuh)
          duration: const Duration(milliseconds: 1000), // Durasi animasi fade-in
          curve: Curves.easeIn, // Kurva animasi untuk efek yang lebih halus
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: width * 0.2,
                height: width * 0.2,
                child: Image.asset(
                  'assets/images/SuccessRegister.png', // Ganti dengan path gambar Anda
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: height * 0.02), // Jarak antara gambar dan teks
              Text(
                "Berhasil!",
                style: GoogleFonts.poppins(
                  fontSize: height * 0.04, // Ukuran font responsif
                  fontWeight: FontWeight.w700,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              Text(
                "Pendaftaran berhasil. Misi Anda dimulai!",
                style: GoogleFonts.poppins(
                  fontSize: height * 0.015, // Ukuran font responsif
                  fontWeight: FontWeight.w400,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}