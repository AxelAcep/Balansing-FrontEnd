import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/screens/Kader/Beranda/kaderTambahII.dart';
import 'package:balansing/models/anakKader_model.dart';

class KaderTambahI extends StatefulWidget {
  const KaderTambahI({super.key});

  @override
  State<KaderTambahI> createState() => _KaderTambahIState();
}

class _KaderTambahIState extends State<KaderTambahI> {
  final AnakKader _anakKader = AnakKaderDataManager().getData();

  final TextEditingController _namaIbuController = TextEditingController();
  final TextEditingController _namaAnakController = TextEditingController();
  final TextEditingController _tahunController = TextEditingController();
  final TextEditingController _bulanController = TextEditingController();
  final TextEditingController _bbController = TextEditingController();
  final TextEditingController _tbController = TextEditingController();

  DateTime _selectedDate = DateTime.now(); // Tanggal pemeriksaan (hari ini)
  DateTime? _selectedBirthDate; // Tanggal lahir anak
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now(); // SELALU hari ini
    _selectedBirthDate = _anakKader.tanggalLahir;
    _namaIbuController.text = _anakKader.namaIbu ?? '';
    _namaAnakController.text = _anakKader.namaAnak ?? '';
    _bbController.text = _anakKader.beratBadan?.toString() ?? '';
    _tbController.text = _anakKader.tinggiBadan?.toString() ?? '';
    _selectedGender = _anakKader.jenisKelamin;
    
    // Hitung umur jika tanggal lahir sudah ada
    if (_selectedBirthDate != null) {
      _calculateAge();
    }
  }

  // Fungsi untuk menghitung umur berdasarkan tanggal lahir
  void _calculateAge() {
    if (_selectedBirthDate == null) return;

    final now = _selectedDate; // Gunakan tanggal pemeriksaan (hari ini)
    int years = now.year - _selectedBirthDate!.year;
    int months = now.month - _selectedBirthDate!.month;

    // Jika bulan negatif, kurangi 1 tahun dan tambah 12 bulan
    if (months < 0) {
      years--;
      months += 12;
    }

    // Jika hari lahir belum lewat di bulan ini, kurangi 1 bulan
    if (now.day < _selectedBirthDate!.day) {
      months--;
      if (months < 0) {
        years--;
        months += 12;
      }
    }

    setState(() {
      _tahunController.text = years.toString();
      _bulanController.text = months.toString();
      _anakKader.umurTahun = years;
      _anakKader.umurBulan = months;
    });
  }

  void _saveDataToModel() {
    _anakKader.tanggalPemeriksaan = _selectedDate;
    _anakKader.tanggalLahir = _selectedBirthDate;
    _anakKader.namaIbu = _namaIbuController.text;
    _anakKader.namaAnak = _namaAnakController.text;
    _anakKader.umurTahun = int.tryParse(_tahunController.text);
    _anakKader.umurBulan = int.tryParse(_bulanController.text);
    _anakKader.beratBadan = double.tryParse(_bbController.text);
    _anakKader.tinggiBadan = double.tryParse(_tbController.text);
    _anakKader.jenisKelamin = _selectedGender;

    debugPrint('Data AnakKader yang disimpan:');
    debugPrint('Tanggal Pemeriksaan: ${_anakKader.tanggalPemeriksaan}');
    debugPrint('Tanggal Lahir: ${_anakKader.tanggalLahir}');
    debugPrint('Nama Ibu: ${_anakKader.namaIbu}');
    debugPrint('Nama Anak: ${_anakKader.namaAnak}');
    debugPrint('Umur Tahun: ${_anakKader.umurTahun}');
    debugPrint('Umur Bulan: ${_anakKader.umurBulan}');
    debugPrint('BB: ${_anakKader.beratBadan}');
    debugPrint('TB: ${_anakKader.tinggiBadan}');
    debugPrint('Jenis Kelamin: ${_anakKader.jenisKelamin}');
  }

  void _resetDatatoModel() {
    _selectedDate = DateTime.now();
    _selectedBirthDate = null;
    _namaIbuController.clear();
    _namaAnakController.clear();
    _tahunController.clear();
    _bulanController.clear();
    _bbController.clear();
    _tbController.clear();
    _selectedGender = null;
    _anakKader.reset();
  }

  @override
  void dispose() {
    _saveDataToModel();
    _namaIbuController.dispose();
    _namaAnakController.dispose();
    _tahunController.dispose();
    _bulanController.dispose();
    _bbController.dispose();
    _tbController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now().subtract(const Duration(days: 365)),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF64748B),
              onPrimary: Colors.white,
              onSurface: Color(0xFF020617),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF64748B),
              ),
            ),
            textTheme: TextTheme(
              titleLarge: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.035,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF64748B),
              ),
              bodyLarge: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.035,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF64748B),
              ),
              bodyMedium: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.035,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
        _calculateAge(); // Hitung umur otomatis
      });
    }
  }

  bool get ButtonActive =>
      _namaIbuController.text.isNotEmpty &&
      _namaAnakController.text.isNotEmpty &&
      _tahunController.text.isNotEmpty &&
      _bulanController.text.isNotEmpty &&
      _bbController.text.isNotEmpty &&
      _tbController.text.isNotEmpty &&
      _selectedBirthDate != null &&
      _selectedGender != null;

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
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                    'Apakah Anda yakin?',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  content: const Text(
                                    'Aksi Anda tidak akan disimpan. Tindakan ini tidak dapat dikembalikan lagi.',
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Tidak",
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF020617),
                                          fontSize: width * 0.035,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _resetDatatoModel();
                                        Navigator.of(context).pop();
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Ya, Kembali',
                                        style: GoogleFonts.poppins(
                                          color: Colors.red,
                                          fontSize: width * 0.035,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
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
                          "Langkah 1 dari 2",
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
                  // Tanggal Pemeriksaan (HARI INI - READ ONLY)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tanggal Pemeriksaan",
                          style: GoogleFonts.poppins(
                              fontSize: width * 0.035, fontWeight: FontWeight.w500, color: const Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC), // Background abu-abu muda untuk read-only
                            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_month, size: height * 0.02, color: const Color(0xFF64748B)),
                              SizedBox(width: width * 0.02),
                              Text(
                                "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                                style: GoogleFonts.poppins(
                                  fontSize: width * 0.035,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF64748B),
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
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tanggal Lahir Anak",
                          style: GoogleFonts.poppins(
                              fontSize: width * 0.035, fontWeight: FontWeight.w500, color: const Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 8.0),
                        InkWell(
                          onTap: () => _selectBirthDate(context),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today, size: height * 0.02, color: const Color(0xFF64748B)),
                                SizedBox(width: width * 0.02),
                                Text(
                                  _selectedBirthDate == null
                                      ? "Pilih Tanggal Lahir"
                                      : "${_selectedBirthDate!.day}/${_selectedBirthDate!.month}/${_selectedBirthDate!.year}",
                                  style: GoogleFonts.poppins(
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.w400,
                                    color: _selectedBirthDate == null
                                        ? const Color(0xFFA1A1AA)
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Text(
                    "Identitas",
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
                        Text(
                          "Nama Ibu",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        TextField(
                          controller: _namaIbuController,
                          decoration: InputDecoration(
                            hintText: "Masukan nama Ibu",
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
                              borderSide: const BorderSide(color: Color(0xFF64748B), width: 1.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Text(
                          "Nama Anak",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        TextField(
                          controller: _namaAnakController,
                          decoration: InputDecoration(
                            hintText: "Masukan nama Anak",
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
                              borderSide: const BorderSide(color: Color(0xFF64748B), width: 1.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        // UMUR (READ ONLY - AUTO CALCULATED)
                        Text(
                          "Umur",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: height * 0.015),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Tahun",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: width * 0.035,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: width * 0.02),
                            Expanded(
                              child: TextField(
                                controller: _tahunController,
                                enabled: false, // READ ONLY
                                decoration: InputDecoration(
                                  hintText: "Tahun",
                                  hintStyle: GoogleFonts.poppins(
                                    color: const Color(0xFFA1A1AA),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                ),
                              ),
                            ),
                            SizedBox(width: width * 0.04),
                            Text(
                              "Bulan",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: width * 0.035,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: width * 0.02),
                            Expanded(
                              child: TextField(
                                controller: _bulanController,
                                enabled: false, // READ ONLY
                                decoration: InputDecoration(
                                  hintText: "Bulan",
                                  hintStyle: GoogleFonts.poppins(
                                    color: const Color(0xFFA1A1AA),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          "BB/TB",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: height * 0.015),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "BB",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: width * 0.035,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: width * 0.02),
                            Expanded(
                              child: TextField(
                                controller: _bbController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "(kg)",
                                  hintStyle: GoogleFonts.poppins(
                                    color: const Color(0xFFA1A1AA),
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
                                    borderSide: const BorderSide(color: Color(0xFF64748B), width: 1.0),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                ),
                              ),
                            ),
                            SizedBox(width: width * 0.04),
                            Text(
                              "TB",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: width * 0.035,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: width * 0.02),
                            Expanded(
                              child: TextField(
                                controller: _tbController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "(cm)",
                                  hintStyle: GoogleFonts.poppins(
                                    color: const Color(0xFFA1A1AA),
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
                                    borderSide: const BorderSide(color: Color(0xFF64748B), width: 1.0),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        Text(
                          "Kelamin",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: height * 0.015),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedGender = 'Laki-laki';
                                });
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: _selectedGender == 'Laki-laki' ? const Color(0xFF76A73B) : Colors.white,
                                      border: Border.all(
                                        color: _selectedGender == 'Laki-laki'
                                            ? const Color(0xFF76A73B)
                                            : const Color(0xFFE2E8F0),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: _selectedGender == 'Laki-laki'
                                        ? const Icon(Icons.check, size: 18, color: Colors.white)
                                        : null,
                                  ),
                                  SizedBox(width: width * 0.02),
                                  Text(
                                    "Laki-laki",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: width * 0.035,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: width * 0.08),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedGender = 'Perempuan';
                                });
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: _selectedGender == 'Perempuan' ? const Color(0xFF76A73B) : Colors.white,
                                      border: Border.all(
                                        color: _selectedGender == 'Perempuan'
                                            ? const Color(0xFF76A73B)
                                            : const Color(0xFFE2E8F0),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: _selectedGender == 'Perempuan'
                                        ? const Icon(Icons.check, size: 18, color: Colors.white)
                                        : null,
                                  ),
                                  SizedBox(width: width * 0.02),
                                  Text(
                                    "Perempuan",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: width * 0.035,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _saveDataToModel();
                      Navigator.pop(context);
                      print('Data disimpan dan keluar');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF4F9EC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Color(0xFF9FC86A)),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    child: Text(
                      "Simpan & keluar",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF9FC86A),
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
                            _saveDataToModel();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => KaderTambahII()),
                            );
                            print('Lanjut ke halaman berikutnya dengan data tersimpan.');
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
                    child: Text(
                      "Selanjutnya",
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