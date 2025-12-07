import 'package:balansing/screens/Ibu/Cek/ibu_cek_II_screen.dart';
import 'package:balansing/screens/Ibu/Cek/ibu_tutorial_I_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/card/CekAnakCard.dart';
import 'package:balansing/services/ibu_services.dart';
import 'package:provider/provider.dart';
import 'package:balansing/providers/IbuProvider.dart';
import 'package:balansing/models/user_model.dart';

class IbuCekIScreen extends StatefulWidget {
  final String id;

  const IbuCekIScreen({super.key, required this.id});

  @override
  State<IbuCekIScreen> createState() => _IbuCekIScreenState();
}

class _IbuCekIScreenState extends State<IbuCekIScreen> {
  // State untuk menyimpan data anak dan status loading
  Map<String, dynamic>? _childData;
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _selectedDate;
  bool? _konjungtivitaNormal; // true = Merah Segar, false = Pucat
  bool? _kukuBersih;          // true = Ya, false = Tidak
  bool? _tampakLemas;         // true = Ya, false = Tidak
  bool? _tampakPucat;         // true = Ya, false = Tidak
  bool? _riwayatAnemia;       // true = Ya, false = Tidak

  bool _isContohVisible = false;
  bool _isContohVisibleII = false;
  

  // Warna yang ditentukan
  final Color _colorLihat = const Color(0xFF76A73B); // Hijau
  final Color _colorSembunyikan = const Color(0xFFF87171); // Merah

  void _toggleContohVisibility() {
    setState(() {
      _isContohVisible = !_isContohVisible;
    });
  }

    void _toggleContohVisibilityII() {
    setState(() {
      _isContohVisibleII = !_isContohVisibleII;
    });
  }

  final TextEditingController _bbController = TextEditingController();
  final TextEditingController _tbController = TextEditingController();

  void _showSnackbar(String message, Color backgroundColor, Color textColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchChildData();
    _selectedDate = DateTime.now();
  }

  Future<void> _fetchChildData() async {
  setState(() {
    _isLoading = true;
  });

  try {
    final Map<String, dynamic> data = await IbuServices().getDetailAnak(widget.id);
    if (data.isEmpty) {
      // Jika data kosong, tampilkan data kosong (tapi tidak error secara total)
      setState(() {
        _childData = {}; // Kosongkan data anak
        _isLoading = false;
        _showSnackbar("Tidak ada data anak ditemukan.", Colors.red, Colors.white);
      });
    } else {
      // Jika data berhasil diambil, simpan datanya
      setState(() {
        _childData = data;
        _isLoading = false;
      });
    }
  } catch (e) {
    // Jika ada error, tetap tampilkan UI tetapi dengan data kosong atau ???
    setState(() {
      _childData = null; // Atur data menjadi null atau biarkan data sebelumnya
      _isLoading = false;
      _showSnackbar("Gagal memuat data: Periksa koneksi internet.", Colors.red, Colors.white);
    });
  }
}

  String _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int years = now.year - birthDate.year;
    int months = now.month - birthDate.month;

    if (months < 0 || (months == 0 && now.day < birthDate.day)) {
      years--;
      months += 12;
    }

    if (years > 0) {
      return '$years tahun $months bulan';
    } else {
      return '$months bulan';
    }
  }

  int _calculateMonth(DateTime birthDate) {
    final now = DateTime.now();
    int totalMonths = (now.year - birthDate.year) * 12 + (now.month - birthDate.month);

    if (now.day < birthDate.day) {
      totalMonths--;
    }

    return totalMonths;
  }

  void _setLoading(bool loading) {
    if (mounted) {
      setState(() {
        _isLoading = loading;
      });
    }
  }

 Future<void> _submitRecapData(BuildContext context) async {
  _setLoading(true);
  final ibuProvider = Provider.of<RecapIbuProvider>(context, listen: false);
  final emailUser = User.instance.email;

  if (ibuProvider.isSubmitting) return;

  final Map<String, dynamic> dataAnak = {
    "anakId": widget.id,
    "tanggal": _selectedDate?.toUtc().toIso8601String(),
    "usia": _calculateMonth(DateTime.parse(_childData!['usia'])),
    "beratBadan": double.tryParse(_bbController.text) ?? 0.0,
    "tinggiBadan": double.tryParse(_tbController.text) ?? 0.0,
    "jenisKelamin": _childData?['jenisKelamin'],
    "konjungtivitaNormal": _konjungtivitaNormal,
    "kukuBersih": _kukuBersih,
    "tampakLemas": _tampakLemas,
    "tampakPucat": _tampakPucat,
    "riwayatAnemia": _riwayatAnemia,
    "email": emailUser,
  };

  print("Data yang akan dikirim: $dataAnak");

  _showSnackbar("Sedang memproses data...", const Color(0xFF64748B), Colors.white);

  try {
    final response = await ibuProvider.postRecapData(dataAnak: dataAnak);

    _showSnackbar("Data berhasil dikirim!", const Color(0xFF9FC86A), Colors.white);
    
    if (mounted) {
      // Just navigate - no need to refresh here
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IbuCekIIScreen(
            id: response['anakIbu']['kodeRecap'], 
            idAnak: widget.id
          ),
        ),
      );
      
      // After returning from IbuCekIIScreen, pop back to dashboard
      // The 'true' signals that data was changed
      Navigator.pop(context, true);
    }
  } catch (e) {
    if (mounted) {
      _showSnackbar("Gagal mengirim data: ${e.toString()}", Colors.red, Colors.white);
    }
  } finally {
    _setLoading(false);
  }
}

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

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

  bool get ButtonActive {
    // Mengembalikan true jika semua gejala sudah diisi
    return _konjungtivitaNormal != null &&
           _kukuBersih != null &&
           _tampakLemas != null &&
           _tampakPucat != null &&
           _riwayatAnemia != null;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    
    // Ambil data jika tidak null dan tidak sedang loading
    final String name = _childData?['nama'] ?? 'Memuat...';
    final String birthDate = _childData?['usia'] != null 
        ? _childData!['usia'].toString().split('T')[0] 
        : 'Memuat...';
    final String age = _childData?['usia'] != null 
        ? _calculateAge(DateTime.parse(_childData!['usia'])) 
        : 'Memuat...';
    final String gender = _childData?['jenisKelamin'] ?? 'Memuat...';

    return PopScope( 
      canPop: !_isLoading,
      child: Scaffold(
      body: Stack( children: [ 
      SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.05),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
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
                    GestureDetector(
                        onTap: () async {
                          print("Tutorial button tapped");
                          await Navigator.push( // Await the push so you can refresh
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TutorialFlowScreen(),
                            ),
                          );
                        },
                        child: Text("Tutorial",
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF76A73B),
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                            )),
                      ),
                ],
              ),
              SizedBox(height: height * 0.025),
              Text(
                "Masukan Data Kesehatan Anak",
                style: GoogleFonts.poppins(
                  color: const Color.fromARGB(255, 0, 1, 3),
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text("Yuk, lengkapi data kesehatan si kecil agar kami bisa bantu cek apakah ia berisiko stunting atau anemia.",
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF64748B),
                    fontSize: width * 0.03,
                    fontWeight: FontWeight.w400,
                  )),
              SizedBox(height: height * 0.02),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_errorMessage != null)
                Center(child: Text(_errorMessage!))
              else if (_childData != null)
                ProfileCard(
                  name: name,
                  birthDate: birthDate,
                  age: age,
                  gender: gender,
                  checkable: true,
                )
              else
                const Center(child: Text("Tidak ada data anak yang ditemukan.")),
            
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
                    SizedBox(height: height * 0.015),
                    Text(" Identitas", style: GoogleFonts.poppins(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w600
                    ),),
                    SizedBox(height: height * 0.015),
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
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.015),
                    Text(" Gejala", style: GoogleFonts.poppins(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w600
                    ),),
                    SizedBox(height: height * 0.015),

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
                              question: "Saat kelopak mata bawah anak ditarik perlahan, apakah warnanya merah segar?",
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

                            TextButton(
                              onPressed: _toggleContohVisibility,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero, // Hapus padding default
                                minimumSize: Size.zero,   // Minimum size nol
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Area tap lebih kecil
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min, // Agar Row hanya mengambil ruang yang dibutuhkan
                                children: [
                                  Text(
                                    // Mengubah teks berdasarkan status
                                    _isContohVisible ? 'Sembunyikan Contoh' : 'Lihat Contoh',
                                    style: TextStyle(
                                      // Mengubah warna teks berdasarkan status
                                      color: _isContohVisible ? _colorSembunyikan : _colorLihat,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4), // Jarak antara teks dan ikon
                                  Icon(
                                    // Mengubah ikon berdasarkan status
                                    _isContohVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                    // Mengubah warna ikon berdasarkan status
                                    color: _isContohVisible ? _colorSembunyikan : _colorLihat,
                                  ),
                                ],
                              ),
                            ),

                            if(_isContohVisible)
                              SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                                child: Row(
                                children: [
                                  SizedBox(
                                    height: height * 0.2,
                                    child: Image.asset('assets/images/konjungtivaI.png'),
                                  ),
                                  SizedBox(width: width * 0.05),
                                  SizedBox(
                                    height: height * 0.2,
                                    child: Image.asset('assets/images/konjungtivaII.jpg'),
                                  ),
                                ])),

                            SizedBox(height: height * 0.02),

                            // Kuku Bersih Section
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

                            TextButton(
                              onPressed: _toggleContohVisibilityII,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero, // Hapus padding default
                                minimumSize: Size.zero,   // Minimum size nol
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Area tap lebih kecil
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min, // Agar Row hanya mengambil ruang yang dibutuhkan
                                children: [
                                  Text(
                                    // Mengubah teks berdasarkan status
                                    _isContohVisible ? 'Sembunyikan Contoh' : 'Lihat Contoh',
                                    style: TextStyle(
                                      // Mengubah warna teks berdasarkan status
                                      color: _isContohVisible ? _colorSembunyikan : _colorLihat,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4), // Jarak antara teks dan ikon
                                  Icon(
                                    // Mengubah ikon berdasarkan status
                                    _isContohVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                    // Mengubah warna ikon berdasarkan status
                                    color: _isContohVisible ? _colorSembunyikan : _colorLihat,
                                  ),
                                ],
                              ),
                            ),

                            if(_isContohVisibleII)
                              SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                                child: Row(
                                children: [
                                  SizedBox(
                                    height: height * 0.2,
                                    child: Image.asset('assets/images/kukuI.png'),
                                  ),
                                  SizedBox(width: width * 0.05),
                                  SizedBox(
                                    height: height * 0.2,
                                    child: Image.asset('assets/images/kukunew.png'),
                                  ),
                                ])),

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
                      SizedBox(height: height * 0.02),
                      SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: ButtonActive
                                ? () async {
                                    print("Tombol Selanjutnya ditekan!");
                                    _submitRecapData(context);
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
                        SizedBox(height: height * 0.06),
            ],
          ),
        ),
      ),
      if (_isLoading)
          Material(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              // Your provided loading container layout
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

    )
    ));
  }
}