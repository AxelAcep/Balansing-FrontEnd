import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Import model dan data manager yang baru kita buat
import 'package:balansing/models/anakKader_model.dart';
import 'package:balansing/models/user_model.dart';
import 'package:balansing/services/ibu_services.dart';
import 'package:provider/provider.dart';
import 'package:balansing/providers/IbuProvider.dart';

class IbuTambahAnak extends StatefulWidget {
  const IbuTambahAnak({super.key});

  @override
  State<IbuTambahAnak> createState() => _IbuTambahAnakState();
}

class _IbuTambahAnakState extends State<IbuTambahAnak> {
  // Ambil instance data placeholder dari Data Manager
  final AnakKader _anakKader = AnakKaderDataManager().getData();


  final TextEditingController _namaAnakController = TextEditingController();
  final TextEditingController _tahunController = TextEditingController();
  final TextEditingController _bulanController = TextEditingController();
  final TextEditingController _bbController = TextEditingController();
  final TextEditingController _tbController = TextEditingController();
  final TextEditingController _bblController = TextEditingController();
  final TextEditingController _tblController = TextEditingController();

  // _selectedDate dan _selectedGender akan diinisialisasi dari _anakKader di initState
  DateTime? _selectedDate;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dan state dari data yang ada di _anakKader
    _selectedDate = _anakKader.tanggalPemeriksaan ?? DateTime.now();
    _namaAnakController.text = _anakKader.namaAnak ?? '';
    _tahunController.text = _anakKader.umurTahun?.toString() ?? '';
    _bulanController.text = _anakKader.umurBulan?.toString() ?? '';
    _bbController.text = _anakKader.beratBadan?.toString() ?? '';
    _tbController.text = _anakKader.tinggiBadan?.toString() ?? '';
    _bblController.text = _anakKader.bbLahir?.toString() ?? '';
    _tblController.text = _anakKader.tbLahir?.toString() ?? '';
    _selectedGender = _anakKader.jenisKelamin;

    _hitungDanIsiUmur();
  }

  void postDataAnak() async {
  // Tampilkan indikator loading atau semacamnya jika diperlukan
  // showLoadingIndicator();

  // 1. Kumpulkan data dari controllers dan state
  final Map<String, dynamic> dataAnak = {
    "email": User.instance.email,
    "nama": _namaAnakController.text,
    "usia": _selectedDate?.toUtc().toIso8601String(),
    "jenisKelamin": _selectedGender,
    "beratBadan": double.tryParse(_bbController.text) ?? 0.0,
    "tinggiBadan": double.tryParse(_tbController.text) ?? 0.0,
    "bbLahir": double.tryParse(_bblController.text) ?? 0.0,
    "tbLahir": double.tryParse(_tblController.text) ?? 0.0
    // Tambahkan data lain sesuai kebutuhan backend, misalnya 'kaderId'
    // "kaderId": User.instance.kaderId,
  };

  try {
    // 2. Memanggil fungsi postAnakIbu yang telah Anda buat
    final responseData = await IbuServices().postAnakIbu(dataAnak);
    print('Data berhasil diunggah: $responseData');
    
    // 3. Jika berhasil, tampilkan SnackBar sukses
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Data anak berhasil ditambahkan!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF9FC86A),
        behavior: SnackBarBehavior.floating,
      ),
    );
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.fetchProfile(User.instance.email);
    Navigator.pop(context);

    // Lanjutkan ke halaman berikutnya jika diperlukan
    // Navigator.push(...);
    
  } catch (e) {
    // 4. Jika gagal, tangani error dan tampilkan SnackBar error
    print('Gagal mengunggah data: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Gagal menambahkan data: ${e.toString()}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  } finally {
    // Sembunyikan indikator loading
    // hideLoadingIndicator();
  }
}


  void _resetDatatoModel() {
    _selectedDate = DateTime.now();
    _namaAnakController.clear();
    _tahunController.clear();
    _bulanController.clear();
    _bbController.clear();
    _tbController.clear();
    _bblController.clear();
    _tblController.clear();
    _selectedGender = null;

    _anakKader.reset();
    _hitungDanIsiUmur();
  }

  @override
  void dispose() {
    _namaAnakController.dispose();
    _tahunController.dispose();
    _bulanController.dispose();
    _bbController.dispose();
    _tbController.dispose();
    _bblController.dispose();
    _tblController.dispose();
    super.dispose();
  }

  void _hitungDanIsiUmur() {
  if (_selectedDate != null) {
    final now = DateTime.now();

    // Menghitung total bulan
    int totalBulan = (now.year - _selectedDate!.year) * 12 + (now.month - _selectedDate!.month);
    
    // Sesuaikan jika hari ini kurang dari hari tanggal lahir
    if (now.day < _selectedDate!.day) {
      totalBulan--;
    }

    // Menghitung tahun dan sisa bulan
    int tahun = (totalBulan / 12).floor();
    int bulan = totalBulan % 12;

    // Mengupdate controller
    _tahunController.text = tahun.toString();
    _bulanController.text = bulan.toString();
  }
}

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _hitungDanIsiUmur();
      });
    }
  }

  bool get ButtonActive =>
      _namaAnakController.text.isNotEmpty &&
      _tahunController.text.isNotEmpty &&
      _bulanController.text.isNotEmpty &&
      _bbController.text.isNotEmpty &&
      _tbController.text.isNotEmpty &&
      _bblController.text.isNotEmpty &&
      _tblController.text.isNotEmpty &&
      _selectedDate != null &&
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
                                      style: TextStyle(color: Colors.red), // Judul merah
                                    ),
                                    content: const Text(
                                      'Aksi Anda tidak akan disimpan. Tindakan ini tidak dapat dikembalikan lagi.',
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Tutup dialog
                                        },
                                        child: Text(
                                                  "Tidak",
                                                  style: GoogleFonts.poppins(
                                                    color: const Color(0xFF020617),
                                                    fontSize: width * 0.035,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ), // "Kembali" biru,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Panggil fungsi reset data
                                          _resetDatatoModel();
                                          // Tutup dialog
                                          Navigator.of(context).pop();
                                          // Kembali ke halaman sebelumnya
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Ya, Kembali',
                                          style: GoogleFonts.poppins(color: Colors.red, fontSize: width*0.035, fontWeight: FontWeight.w500 ), // "Ya" merah
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
                    "Data anak",
                    style: GoogleFonts.poppins(
                        fontSize: width * 0.035, fontWeight: FontWeight.w400, color: const Color(0xFF64748B)),
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
                          "Tanggal Lahir",
                          style: GoogleFonts.poppins(
                              fontSize: width * 0.035, fontWeight: FontWeight.w500, color: const Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 8.0),
                        InkWell(
                          onTap: () => _selectDate(context),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_month, size: height * 0.02, color: const Color.fromARGB(255, 148, 152, 158),),
                                SizedBox(width: width * 0.02,),
                                Text(
                                  _selectedDate == null
                                      ? "Pilih Tanggal"
                                      : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                                  style: GoogleFonts.poppins(
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.w400,
                                    color: _selectedDate == null ? const Color.fromARGB(255, 148, 152, 158) : const Color.fromARGB(255, 148, 152, 158),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.02,),
                  Text("Identitas", style: GoogleFonts.poppins(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.w600
                  ),),
                  SizedBox(height: height * 0.02,),
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
                            contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          ),
                        ),
                        SizedBox(height: height * 0.02,),
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
                                enabled: false,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "Tahun",
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
                                  contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
                                enabled : false,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "Bulan",
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
                                  contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.01,),
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
                                  contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
                                  contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height* 0.02,),
                        Text(
                          "BB/TB (Saat Lahir)",
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
                                controller: _bblController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "(gram)",
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
                                  contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
                                controller: _tblController,
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
                                  contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
                            // Laki-laki Checkbox
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
                                      color: _selectedGender == 'Laki-laki'
                                          ? const Color(0xFF76A73B)
                                          : Colors.white,
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
                            // Perempuan Checkbox
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
                                      color: _selectedGender == 'Perempuan'
                                          ? const Color(0xFF76A73B)
                                          : Colors.white,
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
            SizedBox(height: height * 0.02,), // Space above the buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child:ElevatedButton(
                    onPressed: ButtonActive ? () {
                      postDataAnak();

                    } : null, // Tombol tidak bisa ditekan saat `onPressed` adalah `null`
                    style: ElevatedButton.styleFrom(
                      // Properti `backgroundColor` juga bisa diatur secara dinamis
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
                  )
                ),
              ],
            ),
            SizedBox(height: height * 0.06,),
          ],
        ),
      ),
    );
  }
}