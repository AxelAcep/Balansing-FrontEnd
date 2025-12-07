import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:balansing/models/anakKader_model.dart';
import 'package:balansing/models/user_model.dart';
import 'package:balansing/services/kader_services.dart';
import 'package:balansing/providers/KaderProvider.dart';
import 'package:provider/provider.dart';
import 'package:balansing/models/filter_model.dart';

class KaderTambahII extends StatefulWidget {
  const KaderTambahII({super.key});

  @override
  State<KaderTambahII> createState() => _KaderTambahIIState();
}

class _KaderTambahIIState extends State<KaderTambahII> {
  bool? _konjungtivitaNormal;
  bool? _kukuBersih;
  bool? _tampakLemas;
  bool? _tampakPucat;
  bool? _riwayatAnemia;

  // STATE UNTUK LOADING
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  late FilterModel filterModel;

  final AnakKaderDataManager _anakKaderDataManager = AnakKaderDataManager();

  @override
  void initState() {
    super.initState();
    filterModel = Provider.of<FilterModel>(context, listen: false);
    _loadInitialGejalaData();
  }

  void _loadInitialGejalaData() {
    final AnakKader anakKaderData = _anakKaderDataManager.getData();
    _konjungtivitaNormal = anakKaderData.konjungtivitaNormal;
    _kukuBersih = anakKaderData.kukuBersih;
    _tampakLemas = anakKaderData.tampakLemas;
    _tampakPucat = anakKaderData.tampakPucat;
    _riwayatAnemia = anakKaderData.riwayatAnemia;
  }

  Future<void> _SubmitAnak() async {
    // AKTIFKAN LOADING STATE
    setState(() {
      _isLoading = true;
    });

    final AnakKader anakKaderData = _anakKaderDataManager.getData();
    AnakKader updatedAnakKader = _collectGejalaDataForAnakKader();
    updatedAnakKader.email = User.instance.email;

    try {
      final response = await KaderServices().postAnakKader(updatedAnakKader.toJson());
      print('Data anak berhasil disimpan: ${response}');

      anakKaderData.reset();

      if (!filterModel.filter) {
        await Provider.of<RiwayatProvider>(context, listen: false).fetchChildrenData();
      } else {
        await Provider.of<RiwayatProvider>(context, listen: false).filterChildrenByMonth(
          filterModel.month,
          filterModel.year,
          filterModel.count,
        );
      }

      // MATIKAN LOADING STATE
      setState(() {
        _isLoading = false;
      });

      // Tampilkan SnackBar sukses
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data berhasil diunggah!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Pop 2 kali untuk kembali ke halaman awal
      if (mounted) {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } catch (e) {
      print('Gagal menyimpan data anak: $e');

      // MATIKAN LOADING STATE
      setState(() {
        _isLoading = false;
      });

      // Tampilkan error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengunggah data: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  AnakKader _collectGejalaDataForAnakKader() {
    AnakKader currentAnakKader = _anakKaderDataManager.getData();
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
    );
  }

  bool get ButtonActive {
    return _konjungtivitaNormal != null &&
        _kukuBersih != null &&
        _tampakLemas != null &&
        _tampakPucat != null &&
        _riwayatAnemia != null &&
        !_isLoading; // TAMBAHAN: Tombol tidak aktif saat loading
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildRadioRow({
    required String title,
    required String question,
    required bool valueForYes,
    required String labelForYes,
    required bool valueForNo,
    required String labelForNo,
    required bool? groupValue,
    required ValueChanged<bool?> onChanged,
    required double width,
    required double height,
  }) {
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
                onTap: _isLoading ? null : () => onChanged(valueForYes), // DISABLE saat loading
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
                onTap: _isLoading ? null : () => onChanged(valueForNo), // DISABLE saat loading
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
    return WillPopScope(
      // PREVENT BACK BUTTON saat loading
      onWillPop: () async => !_isLoading,
      child: Stack(
        children: [
          Scaffold(
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
                        physics: _isLoading ? const NeverScrollableScrollPhysics() : null, // DISABLE scroll saat loading
                        children: [
                          Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: _isLoading ? null : () => Navigator.pop(context), // DISABLE saat loading
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
                                _buildRadioRow(
                                  title: "Konjungtiva",
                                  question: "Kecil dan Abu-abu. Saat kelopak mata bawah anak ditarik perlahan, apakah warnanya merah segar?",
                                  valueForYes: false,
                                  labelForYes: "Merah Segar",
                                  valueForNo: true,
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
                                _buildRadioRow(
                                  title: "Kuku",
                                  question: "Apakah kuku anak bersih dan tidak rapuh?",
                                  valueForYes: false,
                                  labelForYes: "Ya, bersih",
                                  valueForNo: true,
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
                          onPressed: _isLoading
                              ? null
                              : () {
                                  AnakKader updatedAnakKader = _collectGejalaDataForAnakKader();
                                  _anakKaderDataManager.currentAnakKader = updatedAnakKader;
                                  print('Data gejala disimpan ke DataManager:');
                                  print(updatedAnakKader.toJson());
                                  Navigator.pop(context);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isLoading ? Colors.grey : const Color(0xFFF4F9EC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: _isLoading ? Colors.grey : const Color(0xFF9FC86A)),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                          ),
                          child: Text(
                            "Simpan & keluar",
                            style: GoogleFonts.poppins(
                              color: _isLoading ? Colors.white : const Color(0xFF9FC86A),
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: width * 0.04),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: ButtonActive
                              ? () {
                                  AnakKader updatedAnakKader = _collectGejalaDataForAnakKader();
                                  updatedAnakKader.email = User.instance.email;
                                  _anakKaderDataManager.currentAnakKader = updatedAnakKader;
                                  print('Data gejala saat ini (Tombol Selanjutnya) dan disimpan ke DataManager:');
                                  print(updatedAnakKader.toJson());
                                  _SubmitAnak();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ButtonActive ? const Color(0xFF9FC86A) : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: width * 0.05,
                                  height: width * 0.05,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  "Unggah",
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
          ),
          // LOADING OVERLAY
          if (_isLoading)
            Material(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9FC86A)),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Mengunggah data...",
                        style: GoogleFonts.poppins(
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}