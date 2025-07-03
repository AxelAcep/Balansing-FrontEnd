import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/screens/AuthKader/ConfirmDaftar.dart'; // Pastikan jalur impor ini benar di proyek Anda
// Pastikan jalur impor ini benar di proyek Anda
// Jika digunakan
// Jika digunakan untuk navigasi kembali


class DaftarscreenII extends StatefulWidget {
  const DaftarscreenII({super.key});

  @override
  State<DaftarscreenII> createState() => _DaftarScreenStateII();
}

class _DaftarScreenStateII extends State<DaftarscreenII> {

  final TextEditingController _puskesmasController = TextEditingController();
  final TextEditingController _posyanduController = TextEditingController();
  final TextEditingController _provinsiController = TextEditingController();
  final TextEditingController _kotaController = TextEditingController();
  final TextEditingController _kecamatanController = TextEditingController();
  final TextEditingController _kelurahanController = TextEditingController();
  final TextEditingController _rtController = TextEditingController();
  final TextEditingController _rwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    // Menambahkan validasi email dan panjang password ke kondisi buttonEnabled
    bool buttonEnabled = true;

    buttonEnabled = _puskesmasController.text.isNotEmpty &&
        _posyanduController.text.isNotEmpty &&
        _provinsiController.text.isNotEmpty &&
        _kotaController.text.isNotEmpty &&
        _kecamatanController.text.isNotEmpty &&
        _kelurahanController.text.isNotEmpty &&
        _rtController.text.isNotEmpty &&
        _rwController.text.isNotEmpty;

    final Color buttonColor = buttonEnabled ? const Color(0xFF9FC86A) : const Color(0xFF878b94);

    return Scaffold(
      backgroundColor: Colors.white, // Background screen putih
      body: Stack(
        // Gunakan Stack untuk menempatkan tombol kembali di atas konten scrollable
        children: [
          // Row untuk tombol Kembali dan teks Langkah 1 dari 2
          Positioned(
            top: height * 0.07, // Sesuaikan jarak dari atas
            left: width * 0.05, // Sesuaikan jarak dari kiri
            right: width * 0.07, // Sesuaikan jarak dari kanan untuk lebar 0.9
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Sejajarkan ke kiri dan kanan
              crossAxisAlignment: CrossAxisAlignment.center, // Pusatkan secara vertikal
              children: [
                // Tombol Kembali
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Fungsi kembali
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
                          size: 20.0, // Ukuran ikon
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
                // Teks Langkah 1 dari 2
                Text(
                  "Langkah 2 dari 2",
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFA1A1AA),
                    fontSize: width * 0.03, // Sesuaikan ukuran font jika perlu
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Konten utama yang bisa di-scroll
          Positioned(
            top: height * 0.13, // Sesuaikan posisi awal konten utama di bawah header baru
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                        Column(
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
                              "Hampir selesai. Tetap semangat bergabung menjadi Garda Terdepan.",
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

                        Container(
                          height: height * 0.025,
                          width: width * 1,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFFE2E8F0),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),

                        // Container untuk semua input fields (dengan scrollability)
                        Container(
                          constraints: BoxConstraints(maxHeight: height * 0.6, minHeight: height * 0.6),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: height * 0.015),
                                Text(
                                  "Nama puskesmas",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                // Input Email
                                TextField(
                                  controller: _puskesmasController, // Pastikan controller ini didefinisikan
                                  decoration: InputDecoration(
                                    hintText: "Masukan nama puskesmas",
                                    hintStyle: GoogleFonts.poppins(
                                      color: const Color(0xFF64748B),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                  ),
                                ),           

                                SizedBox(height: height * 0.02),

                                Text(
                                  "Nama posyandu",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                // Input Email
                                TextField(
                                  controller: _posyanduController, // Pastikan controller ini didefinisikan
                                  decoration: InputDecoration(
                                    hintText: "Masukan nama posyandu",
                                    hintStyle: GoogleFonts.poppins(
                                      color: const Color(0xFF64748B),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                  ),
                                ),           

                                SizedBox(height: height * 0.02),

                                Text(
                                  "Provinsi",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                // Input Email
                                TextField(
                                  controller: _provinsiController, // Pastikan controller ini didefinisikan
                                  decoration: InputDecoration(
                                    hintText: "Masukan nama Provinsi",
                                    hintStyle: GoogleFonts.poppins(
                                      color: const Color(0xFF64748B),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                  ),
                                ),           

                                SizedBox(height: height * 0.02),

                                Text(
                                  "Kota",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                // Input Email
                                TextField(
                                  controller: _kotaController, // Pastikan controller ini didefinisikan
                                  decoration: InputDecoration(
                                    hintText: "Masukan nama kota",
                                    hintStyle: GoogleFonts.poppins(
                                      color: const Color(0xFF64748B),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                  ),
                                ),           

                                SizedBox(height: height * 0.02),

                                Text(
                                  "Kecamatan",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                // Input Email
                                TextField(
                                  controller: _kecamatanController, // Pastikan controller ini didefinisikan
                                  decoration: InputDecoration(
                                    hintText: "Masukan nama kecamatan",
                                    hintStyle: GoogleFonts.poppins(
                                      color: const Color(0xFF64748B),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                  ),
                                ),           

                                SizedBox(height: height * 0.02),

                                Text(
                                  "Kelurahan",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                // Input Email
                                TextField(
                                  controller: _kelurahanController, // Pastikan controller ini didefinisikan
                                  decoration: InputDecoration(
                                    hintText: "Masukan nama kelurahan",
                                    hintStyle: GoogleFonts.poppins(
                                      color: const Color(0xFF64748B),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                  ),
                                ),           

                                SizedBox(height: height * 0.02),

                                Text(
                                  "RT",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                // Input Email
                                TextField(
                                  controller: _rtController, // Pastikan controller ini didefinisikan
                                  decoration: InputDecoration(
                                    hintText: "Masukan RT",
                                    hintStyle: GoogleFonts.poppins(
                                      color: const Color(0xFF64748B),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                  ),
                                ),           

                                SizedBox(height: height * 0.02),

                                Text(
                                  "RW",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                // Input Email
                                TextField(
                                  controller: _rwController, // Pastikan controller ini didefinisikan
                                  decoration: InputDecoration(
                                    hintText: "Masukan RW",
                                    hintStyle: GoogleFonts.poppins(
                                      color: const Color(0xFF64748B),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                  ),
                                ),           

                                SizedBox(height: height * 0.02),

                                
              
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.045), // Jarak sebelum tombol Lanjut

                        // Container untuk tombol Lanjut
                        SizedBox(
                          width: double.infinity,
                          height: height * 0.04,
                          child: ElevatedButton(
                            onPressed:(){
                                  print("Lanjut button pressed");
                                  print("Puskesmas: ${_puskesmasController.text}");
                                  print("Posyandu: ${_posyanduController.text}");
                                  print("Provinsi: ${_provinsiController.text}");
                                  print("Kota: ${_kotaController.text}");
                                  print("Kecamatan: ${_kecamatanController.text}");
                                  print("Kelurahan: ${_kelurahanController.text}");
                                  print("RT: ${_rtController.text}");
                                  print("RW: ${_rwController.text}");
                                  
                                  if(buttonEnabled) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Confirmdaftar()),
                                    );
                                  }
                                    
                                },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor, // Warna tombol #878b94
                              minimumSize: Size(width * 0.9, height * 0.05),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(
                              "Lanjut",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: width * 0.03,
                                fontWeight: FontWeight.w500,
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
      ),
    );
  }
}