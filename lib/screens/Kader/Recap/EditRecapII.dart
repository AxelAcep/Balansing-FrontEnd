import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart'; // Tidak diperlukan lagi untuk tanggal pemeriksaan di sini

import 'package:balansing/models/anakKader_model.dart';
import 'package:balansing/models/user_model.dart';
import 'package:balansing/services/kader_services.dart';
import 'package:balansing/providers/KaderProvider.dart';
import 'package:provider/provider.dart';
import 'package:balansing/models/filter_model.dart';

class EditRecapII extends StatefulWidget {
  const EditRecapII({super.key});

  @override
  State<EditRecapII> createState() => _EditRecapIIState();
}

class _EditRecapIIState extends State<EditRecapII> {
  // Hanya variabel state untuk Radio Button (Boolean)
  bool? _konjungtivitaNormal; // true = Merah Segar, false = Pucat
  bool? _kukuBersih;          // true = Ya, false = Tidak
  bool? _tampakLemas;         // true = Ya, false = Tidak
  bool? _tampakPucat;         // true = Ya, false = Tidak
  bool? _riwayatAnemia;       // true = Ya, false = Tidak

  final _formKey = GlobalKey<FormState>();
  late FilterModel filterModel;

  // Ambil instance dari AnakKaderDataManager
  final AnakKaderDataManager _anakKaderDataManager = AnakKaderDataManager();

  @override
  void initState() {
    super.initState();
    // Inisialisasi filterModel di sini karena context sudah tersedia
    filterModel = Provider.of<FilterModel>(context, listen: false);
    _loadInitialGejalaData(); // Panggil fungsi untuk memuat data gejala awal
  }

  // Fungsi baru untuk memuat data gejala dari DataManager
  void _loadInitialGejalaData() {
    // Ambil data dari data manager (currentAnakKader dari singleton)
    final AnakKader anakKaderData = _anakKaderDataManager.getData();

    // Mengisi variabel state untuk Radio Button (Boolean)
    // Jika nilai dari model adalah null, maka variabel state akan tetap null,
    // yang berarti tidak ada radio button yang terpilih secara default.
    _konjungtivitaNormal = anakKaderData.konjungtivitaNormal;
    _kukuBersih = anakKaderData.kukuBersih;
    _tampakLemas = anakKaderData.tampakLemas;
    _tampakPucat = anakKaderData.tampakPucat;
    _riwayatAnemia = anakKaderData.riwayatAnemia;
  }

  Future<void> _SubmitAnak() async{
    final AnakKader anakKaderData = _anakKaderDataManager.getData();
    // Kumpulkan data gejala dari form
    AnakKader updatedAnakKader = _collectGejalaDataForAnakKader();
    updatedAnakKader.email = User.instance.email; // Pastikan email diisi

    try {
      print(updatedAnakKader.toJson());
      final response = await KaderServices().editAnakKader(updatedAnakKader.toJson());
      print('Data anak berhasil disimpan: ${response}');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil diubah!')),
        );

      anakKaderData.reset();
      final riwayatProvider = Provider.of<RiwayatProvider>(context, listen: false);

      if(!filterModel.filter){
        riwayatProvider.fetchChildrenData();
      } else{
         riwayatProvider.filterChildrenByMonth(
          filterModel.month,
          filterModel.year,
          filterModel.count,
        );
      }
      Navigator.pop(context); // Kembali ke halaman sebelumnya atau halaman yang sesuai
      Navigator.pop(context); // Menutup halaman sebelumnya

      // Tampilkan pesan sukses atau navigasi ke halaman lain jika diperlukan
    } catch (e) {
      print('Gagal menyimpan data anak: $e');
      // Tampilkan pesan error kepada pengguna
    }
  }

  // Fungsi untuk mengumpulkan data gejala dari form ke objek AnakKader
  // Hanya memperbarui properti gejala, sisanya tetap dari DataManager
  AnakKader _collectGejalaDataForAnakKader() {
    // Ambil data AnakKader yang sudah ada dari DataManager
    // Ini penting agar data non-gejala tidak hilang
    AnakKader currentAnakKader = _anakKaderDataManager.getData();

    // Buat objek AnakKader baru dengan mengupdate hanya properti gejala
    return AnakKader(
      tanggalPemeriksaan: currentAnakKader.tanggalPemeriksaan,
      namaIbu: currentAnakKader.namaIbu,
      namaAnak: currentAnakKader.namaAnak,
      umurTahun: currentAnakKader.umurTahun,
      umurBulan: currentAnakKader.umurBulan,
      beratBadan: currentAnakKader.beratBadan,
      tinggiBadan: currentAnakKader.tinggiBadan,
      jenisKelamin: currentAnakKader.jenisKelamin,
      konjungtivitaNormal: _konjungtivitaNormal,
      kukuBersih: _kukuBersih,
      tampakLemas: _tampakLemas,
      tampakPucat: _tampakPucat,
      riwayatAnemia: _riwayatAnemia,
      id: currentAnakKader.id, // Pastikan ID tetap sama
    );
  }

  bool get ButtonActive {
    // Mengembalikan true jika semua gejala sudah diisi
    return _konjungtivitaNormal != null &&
           _kukuBersih != null &&
           _tampakLemas != null &&
           _tampakPucat != null &&
           _riwayatAnemia != null;
  }

  // Metode dispose tidak lagi diperlukan untuk TextEditingController
  // karena sudah dihapus.
  @override
  void dispose() {
    super.dispose();
  }

  // Modifikasi _buildRadioRow untuk menerima bool? sebagai groupValue
  Widget _buildRadioRow({
    required String title,
    required String question,
    required bool valueForYes, // Nilai boolean untuk opsi 'Ya' (atau 'Merah Segar')
    required String labelForYes,
    required bool valueForNo,  // Nilai boolean untuk opsi 'Tidak' (atau 'Pucat')
    required String labelForNo,
    required bool? groupValue, // Sekarang menerima bool?
    required ValueChanged<bool?> onChanged, // Mengubah nilai boolean
    required double width,
    required double height,
  })
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: width * 0.04,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: height * 0.01),
        Text(
          question,
          style: GoogleFonts.poppins(
            color: const Color(0xFF64748B),
            fontSize: width * 0.035,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: height * 0.015),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: InkWell(
                onTap: () => onChanged(valueForYes), // Mengirim true
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: groupValue == valueForYes ? const Color(0xFFF4F9EC) : Colors.white,
                    border: Border.all(
                      color: groupValue == valueForYes ? const Color(0xFF9FC86A) : const Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      labelForYes,
                      style: GoogleFonts.poppins(
                        color: groupValue == valueForYes ? const Color(0xFF9FC86A) : Colors.black,
                        fontSize: width * 0.035,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: width * 0.04),
            Expanded(
              child: InkWell(
                onTap: () => onChanged(valueForNo), // Mengirim false
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: groupValue == valueForNo ? const Color(0xFFF4F9EC) : Colors.white,
                    border: Border.all(
                      color: groupValue == valueForNo ? const Color(0xFF9FC86A) : const Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      labelForNo,
                      style: GoogleFonts.poppins(
                        color: groupValue == valueForNo ? const Color(0xFF9FC86A) : Colors.black,
                        fontSize: width * 0.035,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
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
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
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
                          Text(
                            "Langkah 2 dari 2",
                            style: GoogleFonts.poppins(
                              color: const Color(0xFFA1A1AA),
                              fontSize: width * 0.03,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Text(
                      "Tambah Data",
                      style: GoogleFonts.poppins(fontSize: width * 0.06, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Data anak ke-1",
                      style: GoogleFonts.poppins(
                          fontSize: width * 0.035, fontWeight: FontWeight.w400, color: const Color(0xFF64748B)),
                    ),
                    SizedBox(height: height * 0.02),

                    Text(
                      "Gejala",
                      style: GoogleFonts.poppins(fontSize: width * 0.04, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: height * 0.02),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Konjungtivita Normal Section
                          _buildRadioRow(
                            title: "Konjungtiva",
                            question: "Kecil dan Abu-abu. Saat kelopak mata bawah anak ditarik perlahan, apakah warnanya merah segar?",
                            valueForYes: true,
                            labelForYes: "Merah Segar",
                            valueForNo: false,
                            labelForNo: "Pucat",
                            groupValue: _konjungtivitaNormal,
                            onChanged: (value) {
                              setState(() {
                                _konjungtivitaNormal = value;
                              });
                            },
                            width: width,
                            height: height,
                          ),
                          SizedBox(height: height * 0.02),

                          // Kuku Bersih Section
                          _buildRadioRow(
                            title: "Kuku",
                            question: "Apakah kuku anak bersih dan tidak rapuh?",
                            valueForYes: true,
                            labelForYes: "Ya, bersih",
                            valueForNo: false,
                            labelForNo: "Rapuh/Pucat",
                            groupValue: _kukuBersih,
                            onChanged: (value) {
                              setState(() {
                                _kukuBersih = value;
                              });
                            },
                            width: width,
                            height: height,
                          ),
                          SizedBox(height: height * 0.02),

                          // Tampak Lemas Section
                          _buildRadioRow(
                            title: "Lemas",
                            question: "Anak terlihat Lemas?",
                            valueForYes: true,
                            labelForYes: "Ya",
                            valueForNo: false,
                            labelForNo: "Tidak",
                            groupValue: _tampakLemas,
                            onChanged: (value) {
                              setState(() {
                                _tampakLemas = value;
                              });
                            },
                            width: width,
                            height: height,
                          ),
                          SizedBox(height: height * 0.02),

                          // Tampak Pucat Section
                          _buildRadioRow(
                            title: "Pucat",
                            question: "Anak terlihat pucat?",
                            valueForYes: true,
                            labelForYes: "Ya",
                            valueForNo: false,
                            labelForNo: "Tidak",
                            groupValue: _tampakPucat,
                            onChanged: (value) {
                              setState(() {
                                _tampakPucat = value;
                              });
                            },
                            width: width,
                            height: height,
                          ),
                          SizedBox(height: height * 0.02),

                          // Riwayat Anemia Section
                          _buildRadioRow(
                            title: "Riwayat Anemia",
                            question: "Apakah anak memiliki riwayat anemia?",
                            valueForYes: true,
                            labelForYes: "Ya",
                            valueForNo: false,
                            labelForNo: "Tidak",
                            groupValue: _riwayatAnemia,
                            onChanged: (value) {
                              setState(() {
                                _riwayatAnemia = value;
                              });
                            },
                            width: width,
                            height: height,
                          ),
                          SizedBox(height: height * 0.01),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: ButtonActive ? () {
                      AnakKader updatedAnakKader = _collectGejalaDataForAnakKader();
                      updatedAnakKader.email = User.instance.email; // Pastikan email diisi
                      // Simpan data ke DataManager (ini akan memperbarui objek currentAnakKader)
                      _anakKaderDataManager.currentAnakKader = updatedAnakKader;
                      print('Data gejala saat ini (Tombol Selanjutnya) dan disimpan ke DataManager:');
                      print(updatedAnakKader.toJson());
                      _SubmitAnak(); // Panggil fungsi untuk mengirim data ke backend
                      // Lanjutkan ke halaman berikutnya
                    } : null, // Tombol tidak bisa ditekan saat ButtonActive adalah false
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ButtonActive ? const Color(0xFF9FC86A) : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      elevation: 0,
                    ),
                    child: Text(
                      "Update Data",
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
            SizedBox(height: height * 0.06),
          ],
        ),
      ),
    );
  }
}