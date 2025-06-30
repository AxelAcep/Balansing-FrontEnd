import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Pastikan jalur impor ini benar di proyek Anda
// Jika digunakan
// Jika digunakan untuk navigasi kembali
import 'package:balansing/screens/AuthKader/DaftarScreenII.dart';

class Daftarscreen extends StatefulWidget {

  const Daftarscreen({super.key});

  @override
  State<Daftarscreen> createState() => _DaftarScreenState();
}

class _DaftarScreenState extends State<Daftarscreen> {
  // States untuk visibilitas password dan controllers untuk input teks
  bool _isPasswordVisible = false;
  final TextEditingController _namaLengkapController = TextEditingController();
  final TextEditingController _nomorTeleponController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Pastikan untuk membuang controller saat widget dihapus
    _namaLengkapController.dispose();
    _nomorTeleponController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white, // Background screen putih
      body: Stack( // Gunakan Stack untuk menempatkan tombol kembali di atas konten scrollable
              children: [
                // Tombol Kembali di pojok kiri atas
                Positioned(
                  top: 40.0, // Sesuaikan jarak dari atas
                  left: 24.0, // Sesuaikan jarak dari kiri
                  // Menggunakan TextButton untuk membuat area yang bisa diklik lebih besar dan responsif
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Fungsi kembali
                    },
                    style: TextButton.styleFrom(
                      // Memastikan padding dan min size diatur agar tidak mengganggu tata letak
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Membuat area tap sekecil mungkin agar sesuai konten
                      alignment: Alignment.centerLeft, // Rata kiri konten button
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Membuat Row hanya selebar kontennya
                      children: [
                        Container(
                          width: 40, // Ukuran lingkaran
                          height: 40, // Ukuran lingkaran
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFFE2E8F0), // Border abu-abu tipis
                              width: 1.0,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Color(0xFF020617), // Warna icon panah
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8.0), // Jarak antara lingkaran dan teks
                        Text(
                          "Kembali",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF020617), // Warna teks Kembali
                            fontSize: width * 0.04, // Ukuran teks Kembali
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Konten utama yang bisa di-scroll
                Positioned( // Memposisikan SingleChildScrollView di bawah tombol kembali
                  top: height * 0.12, // Mulai konten di bawah tombol kembali
                  left: 0,
                  right: 0,
                  bottom: 0, // Memenuhi sisa ruang vertikal
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0.0), // Hapus padding top di sini
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start, // Atur ke start agar konten dimulai dari atas
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo
                        Image.asset(
                          'assets/images/Balansing-Logo.png', // Menggunakan logo dari LoginScreen
                          height: height * 0.1,
                          fit: BoxFit.contain,
                        ),

                        SizedBox(height: height * 0.025, ), // Jarak antara logo dan container form

                        // CONTAINER BESAR UNTUK SEMUA ELEMEN FORM
                        Container(
                          width: width * 0.9,
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Container untuk teks "Daftar" dan "Satu Langkah Anda..."
                              Container(
                                // Tidak ada border
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Daftar",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: width * 0.06,
                                        fontWeight: FontWeight.w600,
                                        height: 1.0,
                                      ),
                                    ),
                                    SizedBox(height: height * 0.01),
                                    Text(
                                      "Satu Langkah Anda, Sejuta Terima Kasih.",
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF64748B),
                                        fontSize: width * 0.030,
                                        fontWeight: FontWeight.normal,
                                        height: 1.25,
                                        letterSpacing: 0.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                height: height * 0.025, // Tetapkan tinggi yang sama dengan SizedBox sebelumnya
                                width: width * 1,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color(0xFFE2E8F0), // Warna abu-abu tipis Anda
                                      width: 1.5, // Ketebalan border
                                    ),
                                  ),
                                ),
                              ),

                              // Container untuk semua input fields (dengan scrollability)
                              Container(
                                // Tidak ada border
                                constraints: BoxConstraints(maxHeight: height * 0.4), // Batasi tinggi container input
                                child: SingleChildScrollView( // Memungkinkan scroll jika konten melebihi maxHeight
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Label Nama Lengkap
                                      Text(
                                        "Nama Lengkap",
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: width * 0.035,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: height * 0.01),
                                      // Input Nama Lengkap
                                      TextField(
                                        controller: _namaLengkapController,
                                        decoration: InputDecoration(
                                          hintText: "Input nama lengkap",
                                          hintStyle: GoogleFonts.poppins(
                                            color: const Color(0xFF64748B),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: const BorderSide(color: Color(0xFF0F172A)),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                        ),
                                      ),

                                      SizedBox(height: height * 0.02),

                                      // Label Nomor Telepon
                                      Text(
                                        "Nomor Telepon",
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: width * 0.035,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: height * 0.01),
                                      // Input Nomor Telepon
                                      TextField(
                                        controller: _nomorTeleponController,
                                        keyboardType: TextInputType.phone, // Keyboard khusus nomor telepon
                                        decoration: InputDecoration(
                                          hintText: "Input nomor telepon",
                                          hintStyle: GoogleFonts.poppins(
                                            color: const Color(0xFF64748B),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: const BorderSide(color: Color(0xFF0F172A)),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                        ),
                                      ),

                                      SizedBox(height: height * 0.02),

                                      // Label Email
                                      Text(
                                        "Email",
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: width * 0.035,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: height * 0.01),
                                      // Input Email
                                      TextField(
                                        controller: _emailController,
                                        keyboardType: TextInputType.emailAddress, // Keyboard khusus email
                                        decoration: InputDecoration(
                                          hintText: "Input email",
                                          hintStyle: GoogleFonts.poppins(
                                            color: const Color(0xFF64748B),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: const BorderSide(color: Color(0xFF0F172A)),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                        ),
                                      ),

                                      SizedBox(height: height * 0.02),

                                      // Label Password
                                      Text(
                                        "Password",
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: width * 0.035,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: height * 0.01),
                                      // Input Password
                                      TextField(
                                        controller: _passwordController,
                                        obscureText: !_isPasswordVisible,
                                        decoration: InputDecoration(
                                          hintText: "Input password",
                                          hintStyle: GoogleFonts.poppins(
                                            color: const Color(0xFF64748B),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: const BorderSide(color: Color(0xFF0F172A)),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                              color: const Color(0xFF64748B),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isPasswordVisible = !_isPasswordVisible;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: height * 0.025), // Jarak sebelum tombol Lanjut

                              // Container untuk tombol Lanjut
                              Container(
                                // Tidak ada border
                                child: SizedBox(
                                  width: double.infinity,
                                  height: height * 0.04, // Tinggi sama seperti tombol Login
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Logika print data dan jenis
                                      print("Nama Lengkap: ${_namaLengkapController.text}");
                                      print("Nomor Telepon: ${_nomorTeleponController.text}");
                                      print("Email: ${_emailController.text}");
                                      print("Password: ${_passwordController.text}");

                                       Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => DaftarscreenII()),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF878b94), // Warna tombol #878b94
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: Text(
                                      "Lanjut",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: width * 0.03, // Ukuran teks sama seperti tombol Login
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
    );
  }
}