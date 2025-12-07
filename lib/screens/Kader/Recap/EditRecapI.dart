import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/screens/Kader/Recap/EditRecapII.dart';
// Import model dan data manager yang baru kita buat
import 'package:balansing/models/anakKader_model.dart';
import 'package:balansing/services/kader_services.dart';
import "package:balansing/providers/KaderProvider.dart";
import 'package:provider/provider.dart';


class EditRecapI extends StatefulWidget {
    final String? id;
  
  const EditRecapI({super.key, required this.id});

  @override
  State<EditRecapI> createState() => _EditRecapStateI();
}

class _EditRecapStateI extends State<EditRecapI> {
  // Ambil instance data placeholder dari Data Manager
  final AnakKader _anakKader = AnakKaderDataManager().getData();

  final TextEditingController _namaIbuController = TextEditingController();
  final TextEditingController _namaAnakController = TextEditingController();
  final TextEditingController _tahunController = TextEditingController();
  final TextEditingController _bulanController = TextEditingController();
  final TextEditingController _bbController = TextEditingController();
  final TextEditingController _tbController = TextEditingController();

  // _selectedDate dan _selectedGender akan diinisialisasi dari _anakKader di initState
  DateTime _selectedDate = DateTime.now(); // Tanggal pemeriksaan (hari ini)
  String? _selectedGender;
  DateTime? _selectedBirthDate; // Tanggal lahir anak



  @override
  void initState() {
    super.initState();
    _fetchData(); 
  }

  void _saveDataToModel() {
    _anakKader.tanggalPemeriksaan = _selectedDate;
    _anakKader.namaIbu = _namaIbuController.text;
    _anakKader.namaAnak = _namaAnakController.text;
    _anakKader.umurTahun = int.tryParse(_tahunController.text);
    _anakKader.umurBulan = int.tryParse(_bulanController.text);
    _anakKader.beratBadan = double.tryParse(_bbController.text);
    _anakKader.tinggiBadan = double.tryParse(_tbController.text);
    _anakKader.jenisKelamin = _selectedGender;
    _anakKader.id = widget.id;

    // Anda bisa menambahkan debugPrint untuk melihat data yang tersimpan
    debugPrint('Data AnakKader yang disimpan:');
    debugPrint('Tanggal: ${_anakKader.tanggalPemeriksaan}');
    debugPrint('Nama Ibu: ${_anakKader.namaIbu}');
    debugPrint('Nama Anak: ${_anakKader.namaAnak}');
    debugPrint('Umur Tahun: ${_anakKader.umurTahun}');
    debugPrint('Umur Bulan: ${_anakKader.umurBulan}');
    debugPrint('BB: ${_anakKader.beratBadan}');
    debugPrint('TB: ${_anakKader.tinggiBadan}');
    debugPrint('Jenis Kelamin: ${_anakKader.jenisKelamin}');
    debugPrint('id: ${widget.id}');
    debugPrint('Konjungtivitas: ${_anakKader.konjungtivitaNormal}');
    debugPrint('Kuku: ${_anakKader.kukuBersih}');
    debugPrint('Lemas: ${_anakKader.tampakLemas}');
    debugPrint('Pucat: ${_anakKader.tampakPucat}');
  }

  void _resetDatatoModel() {
    _selectedDate = DateTime.now();
    _namaIbuController.clear();
    _namaAnakController.clear();
    _tahunController.clear();
    _bulanController.clear();
    _bbController.clear();
    _tbController.clear();
    _selectedGender = null;

    _anakKader.reset();
  }

 Future<void> _DeleteAnak(String id) async{
    try {
      final response = await KaderServices().deleteAnakKader(id);
      print('Data anak berhasil disimpan: ${response}');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berhasil Dihapus!')),
        );
      Navigator.pop(context); // Kembali ke halaman sebelumnya atau halaman yang sesuai
      Navigator.pop(context); // Kembali ke halaman sebelumnya atau halaman yang sesuai
      Provider.of<RiwayatProvider>(context, listen: false).fetchChildrenData();

      // Tampilkan pesan sukses atau navigasi ke halaman lain jika diperlukan
    } catch (e) {
      print('Gagal menyimpan data anak: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error Mengakses Jaringan Server. Data gagal dihapus: Cek Internet Anda atau Coba lagi'),
            backgroundColor: Colors.red,
          ),
        );
      }

      // Tampilkan pesan error kepada pengguna
    }
  }

Future<void> _fetchData() async {
  try {
    final List<Map<String, dynamic>> data = await KaderServices().getDetailAnakKader(widget.id!);


    if (data.isNotEmpty) {
      final anakData = data.first;
      print(anakData);

      setState(() {
        _selectedDate = DateTime.tryParse(anakData['tanggalPemeriksaan'] ?? '') ?? DateTime.now();
        _namaIbuController.text = anakData['namaIbu'] ?? '';
        _namaAnakController.text = anakData['nama'] ?? '';
        _tahunController.text = anakData['umurTahun']?.toString() ?? '';
        _bulanController.text = anakData['umurBulan']?.toString() ?? '';
        _bbController.text = anakData['beratBadan']?.toString() ?? '';
        _tbController.text = anakData['tinggiBadan']?.toString() ?? '';
        _selectedGender = anakData['jenisKelamin'] ?? '';

        _anakKader.konjungtivitaNormal = anakData['konjungtivitaNormal'] ?? null;
        _anakKader.kukuBersih = anakData['kukuBersih'] ?? null;  
        _anakKader.tampakLemas = anakData['tampakLemas'] ?? null;
        _anakKader.tampakPucat = anakData['tampakPucat'] ?? null;
        _anakKader.riwayatAnemia = anakData['riwayatAnemia'] ?? null;
      });
    } else {
      print('Tidak ada data anak ditemukan untuk ID ini.');
      // Jika ingin menampilkan ke pengguna, gunakan dialog/snackbar di sini
    }
  } catch (e) {
    print('Error fetching data: $e');
    // Jika ingin menampilkan ke pengguna, gunakan dialog/snackbar di sini juga
  }
}


  @override
  void dispose() {
    // Panggil _saveDataToModel di dispose() agar data tersimpan saat widget dilepas dari tree
    _saveDataToModel();

    _namaIbuController.dispose();
    _namaAnakController.dispose();
    _tahunController.dispose();
    _bulanController.dispose();
    _bbController.dispose();
    _tbController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
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
      });
    }
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

  bool get ButtonActive =>
      _namaIbuController.text.isNotEmpty &&
      _namaAnakController.text.isNotEmpty &&
      _tahunController.text.isNotEmpty &&
      _bulanController.text.isNotEmpty &&
      _bbController.text.isNotEmpty &&
      _tbController.text.isNotEmpty &&
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
                              _resetDatatoModel();
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
                    "Edit Data",
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
                  SizedBox(height: height * 0.02,),
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
                            contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          ),
                        ),
                        SizedBox(height: height * 0.02,),
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
                      showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Apakah Anda yakin?',
                                      style: TextStyle(color: Colors.red), // Judul merah
                                    ),
                                    content: const Text(
                                      'Aksi ini akan menghapus data Anak. Tindakan ini tidak dapat dikembalikan lagi.',
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
                                          String? id = widget.id;
                                          _DeleteAnak(id!);
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
                    } : null, // Tombol tidak bisa ditekan saat `onPressed` adalah `null`
                    style: ElevatedButton.styleFrom(
                      // Properti `backgroundColor` juga bisa diatur secara dinamis
                      backgroundColor: ButtonActive ? const Color.fromARGB(255, 244, 2, 2) : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      elevation: 0,
                    ),
                    child: Text(
                      "Hapus Data",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: width * 0.035,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ),
                SizedBox(width: width * 0.02,), // Space between buttons
                Expanded(
                  child:ElevatedButton(
                    onPressed: ButtonActive ? () {
                      _saveDataToModel();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditRecapII()),
                      );
                      print('Lanjut ke halaman berikutnya dengan data tersimpan.');
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