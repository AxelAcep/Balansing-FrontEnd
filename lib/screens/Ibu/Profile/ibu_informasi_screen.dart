import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/services/ibu_services.dart';
import 'package:balansing/models/user_model.dart';
import 'package:balansing/providers/IbuProvider.dart';
import 'package:provider/provider.dart';

class IbuInformasiScreen extends StatefulWidget {
  const IbuInformasiScreen({super.key});

  @override
  State<IbuInformasiScreen> createState() => _IbuInformasiScreenState();
}

class _IbuInformasiScreenState extends State<IbuInformasiScreen> {
  // --- Deklarasi TextEditingController untuk setiap TextField ---
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _usiaController = TextEditingController();
  final TextEditingController _noHandphoneController = TextEditingController();
  final TextEditingController _provinsiController = TextEditingController();
  final TextEditingController _kotaController = TextEditingController();
  final TextEditingController _kecamatanController = TextEditingController();
  final TextEditingController _kelurahanController = TextEditingController();
  final TextEditingController _rtController = TextEditingController();
  final TextEditingController _rwController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  final IbuServices _kaderServices = IbuServices();
  String _kaderProfileRawData = "Loading..."; // Tetap bisa digunakan untuk debugging

  // --- State untuk mengontrol status tombol (jika diperlukan, misal untuk validasi) ---
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // Tambahkan listener ke setiap controller
    // Ini akan memanggil _updateButtonState setiap kali teks berubah di salah satu TextField.
    _namaController.addListener(_updateButtonState);
    _usiaController.addListener(_updateButtonState);
    _noHandphoneController.addListener(_updateButtonState);
    _provinsiController.addListener(_updateButtonState);
    _kotaController.addListener(_updateButtonState);
    _kecamatanController.addListener(_updateButtonState);
    _kelurahanController.addListener(_updateButtonState);
    _rtController.addListener(_updateButtonState);
    _rwController.addListener(_updateButtonState);
    _alamatController.addListener(_updateButtonState);

    // Panggil _fetchKaderProfile di initState agar data diambil saat layar pertama kali dibuat
    _fetchKaderProfile();
  }

  Future<void> _fetchKaderProfile() async {
    try {
      if (User.instance.email.isNotEmpty) {
        Map<String, dynamic> data = await _kaderServices.getIbu(User.instance.email);
        print(data);

        setState(() {
          _kaderProfileRawData = jsonEncode(data);
          // Setel nilai controller langsung di sini untuk autofill
          _namaController.text = data['nama'] ?? '';
          _usiaController.text = data['usia']?.toString() ?? '';
          _noHandphoneController.text = data['noTelp'] ?? '';
          _provinsiController.text = data['provinsi'] ?? '';
          _kotaController.text = data['kota'] ?? '';
          _kecamatanController.text = data['kecamatan'] ?? '';
          _kelurahanController.text = data['kelurahan'] ?? '';
          _rtController.text = data['rt']?.toString() ?? ''; // Pastikan RT/RW dalam string
          _rwController.text = data['rw']?.toString() ?? ''; // Pastikan RT/RW dalam string
          _alamatController.text = data['alamat'] ?? '';
        });
        print("Kader Profile Data: $data");
      } else {
        setState(() {
          _kaderProfileRawData = "Email pengguna tidak tersedia.";
          // Kosongkan controller jika email tidak tersedia
          _namaController.text = '';
          _usiaController.text = '';
          _noHandphoneController.text = '';
          _provinsiController.text = '';
          _kotaController.text = '';
          _kecamatanController.text = '';
          _kelurahanController.text = '';
          _rtController.text = '';
          _rwController.text = '';
          _alamatController.text = '';
        });
        print("DEBUG: User email is empty, cannot fetch kader profile.");
      }
    } catch (e) {
      setState(() {
        _kaderProfileRawData = "Gagal memuat profil: $e";
        // Atur controller ke nilai error jika gagal memuat
        _namaController.text = 'Gagal memuat';
        _usiaController.text = 'Gagal memuat';
        _noHandphoneController.text = 'Gagal memuat';
        _provinsiController.text = 'Gagal memuat';
        _kotaController.text = 'Gagal memuat';
        _kecamatanController.text = 'Gagal memuat';
        _kelurahanController.text = 'Gagal memuat';
        _rtController.text = 'Gagal memuat';
        _rwController.text = 'Gagal memuat';
        _alamatController.text = 'Gagal memuat';
      });
      print('Error fetching kader profile: $e');
      print(_kaderProfileRawData); 
    }
  }

  Future<void> _updateKaderProfile() async {
    try {
      Map<String, dynamic> data = {
        'email': User.instance.email,
        'nama': _namaController.text,
        'usia': int.tryParse(_usiaController.text) ?? 0,
        'noTelp' : _noHandphoneController.text,
        'provinsi': _provinsiController.text,
        'kota': _kotaController.text,
        'kecamatan': _kecamatanController.text,
        'kelurahan': _kelurahanController.text,
        'rt': _rtController.text.isNotEmpty ? (_rtController.text) : null, // Pastikan RT/RW adalah integer
        'rw': _rwController.text.isNotEmpty ? (_rwController.text) : null, // Pastikan RT/RW adalah integer
        'alamat': _alamatController.text
      };

      print(data);
      Map<String, dynamic> response = await _kaderServices.updateIbu(User.instance.email, data);
      Provider.of<ProfileProvider>(context, listen: false).fetchProfile(User.instance.email);
      print("Update Response: $response");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil Ibu berhasil diperbarui!')),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui profil: $e')),
      );
      print('Error updating kader profile: $e');
    }
  }

  // --- Fungsi untuk memperbarui status tombol "Simpan Perubahan" ---
  void _updateButtonState() {
    setState(() {
      // Tombol akan aktif jika semua TextField tidak kosong
      _isButtonEnabled = _namaController.text.isNotEmpty &&
          _usiaController.text.isNotEmpty &&
          _noHandphoneController.text.isNotEmpty &&
          _kotaController.text.isNotEmpty &&
          _kecamatanController.text.isNotEmpty &&
          _kelurahanController.text.isNotEmpty &&
          _rtController.text.isNotEmpty &&
          _rwController.text.isNotEmpty &&
          _alamatController.text.isNotEmpty;
    });
  }

  // --- Fungsi handle untuk tombol "Simpan Perubahan" ---
  void _handleSimpanPerubahan() {
    print("--- Data Informasi Kader ---");
    print("Nama Bunda: ${_namaController.text}");
    print("Usia Bunda: ${_usiaController.text}");
    print("Provinsi: ${_provinsiController.text}");
    print("Kota: ${_kotaController.text}");
    print("Kecamatan: ${_kecamatanController.text}");
    print("Kelurahan: ${_kelurahanController.text}");
    print("RT: ${_rtController.text}");
    print("RW: ${_rwController.text}");
    print("Alamat: ${_alamatController} ");
    print("--------------------------");

     _updateKaderProfile(); // Panggil update profil setiap kali ada perubahan

    // Di sini Anda bisa menambahkan logika untuk menyimpan data ke database atau API
    // Misalnya:
    // SomeApiService().saveKaderInfo({
    //   'puskesmas': _puskesmasController.text,
    //   'posyandu': _posyanduController.text,
    //   // ... data lainnya
    // });

    // Tampilkan notifikasi atau navigasi setelah menyimpan
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perubahan Diproses!')),
    );
  }

  @override
  void dispose() {
    // --- Pastikan untuk membuang controller saat State dihapus ---
    _namaController.dispose();
    _usiaController.dispose();
    _noHandphoneController.dispose();
    _provinsiController.dispose();
    _kotaController.dispose();
    _kecamatanController.dispose();
    _kelurahanController.dispose();
    _rtController.dispose();
    _rwController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

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
                    color: Colors.white,
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
                  SizedBox(height: height * 0.02),
                   Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0), // Padding di dalam container input
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nama Lengkap",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        TextField(
                          controller: _namaController,
                          decoration: InputDecoration(
                            hintText: "Masukan nama lengkap bunda",
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
                              borderSide: const BorderSide(color: Color(0xFF9FC86A), width: 2.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        // Input for Kota
                        Text(
                          "Usia",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        TextField(
                          controller: _usiaController,
                          decoration: InputDecoration(
                            hintText: "Masukan usia bunda",
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
                              borderSide: const BorderSide(color: Color(0xFF9FC86A), width: 2.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        // Input for Kecamatan
                        Text(
                          "No Handphone",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        TextField(
                          controller: _noHandphoneController,
                          decoration: InputDecoration(
                            hintText: "Masukan Nomor Handphone Bunda",
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
                              borderSide: const BorderSide(color: Color(0xFF9FC86A), width: 2.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          ),
                        ),
                        SizedBox(height: height * 0.015), // Akhir dari padding di dalam container input
                      ],
                    ),
                  ),
                  
                  SizedBox(height: height * 0.02,),
                  
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0), // Padding di dalam container input
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Provinsi",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        TextField(
                          controller: _provinsiController,
                          decoration: InputDecoration(
                            hintText: "Masukan nama Provinsi",
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
                              borderSide: const BorderSide(color: Color(0xFF9FC86A), width: 2.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        // Input for Kota
                        Text(
                          "Kota",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        TextField(
                          controller: _kotaController,
                          decoration: InputDecoration(
                            hintText: "Masukan nama kota",
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
                              borderSide: const BorderSide(color: Color(0xFF9FC86A), width: 2.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        // Input for Kecamatan
                        Text(
                          "Kecamatan",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        TextField(
                          controller: _kecamatanController,
                          decoration: InputDecoration(
                            hintText: "Masukan nama kecamatan",
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
                              borderSide: const BorderSide(color: Color(0xFF9FC86A), width: 2.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        // Input for Kelurahan
                        Text(
                          "Kelurahan",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        TextField(
                          controller: _kelurahanController,
                          decoration: InputDecoration(
                            hintText: "Masukan nama kelurahan",
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
                              borderSide: const BorderSide(color: Color(0xFF9FC86A), width: 2.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        // Input for RT
                        Text(
                          "RT",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        TextField(
                          controller: _rtController,
                          keyboardType: TextInputType.number, // Hanya angka
                          decoration: InputDecoration(
                            hintText: "Masukan RT",
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
                              borderSide: const BorderSide(color: Color(0xFF9FC86A), width: 2.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        // Input for RW
                        Text(
                          "RW",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        TextField(
                          controller: _rwController,
                          keyboardType: TextInputType.number, // Hanya angka
                          decoration: InputDecoration(
                            hintText: "Masukan RW",
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
                              borderSide: const BorderSide(color: Color(0xFF9FC86A), width: 2.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          ),
                        ),
                         SizedBox(height: height * 0.02),
                        Text(
                          "Alamat",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        TextField(
                          controller: _alamatController,
                          keyboardType: TextInputType.number, // Hanya angka
                          decoration: InputDecoration(
                            hintText: "Masukan Alamat",
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
                              borderSide: const BorderSide(color: Color(0xFF9FC86A), width: 2.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          ),
                        ),
                        SizedBox(height: height * 0.015), // Akhir dari padding di dalam container input
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // --- Tombol Simpan Perubahan (fixed di bagian bawah) ---
            SizedBox(height: height * 0.03), // Spasi antara ListView dan tombol
            ElevatedButton(
              onPressed: _isButtonEnabled ? _handleSimpanPerubahan : null, // Tombol aktif jika _isButtonEnabled true
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9FC86A), // Warna hijau #9FC86A
                foregroundColor: Colors.white, // Warna tulisan putih
                minimumSize: Size(width * 0.87, height * 0.05), // Lebar 90% dan tinggi 6% dari layar
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Ujung melengkung
                ),
                textStyle: GoogleFonts.poppins(
                  fontSize: height * 0.017,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text("Simpan Perubahan"),
            ),
            SizedBox(height: height * 0.06), // Padding di bawah tombol
          ],
        ),
      ),
    );
  }
}