import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Import model dan service
import 'package:balansing/models/anakKader_model.dart';
import 'package:balansing/models/user_model.dart';
import 'package:balansing/services/kader_services.dart';
import 'package:balansing/providers/KaderProvider.dart'; // Asumsi RiwayatProvider ada di sini
import 'package:balansing/models/filter_model.dart';

// ************************************************
// REFACTORED CODE STARTS HERE
// ************************************************

class EditRecapII extends StatefulWidget {
  const EditRecapII({super.key});

  @override
  State<EditRecapII> createState() => _EditRecapIIState();
}

class _EditRecapIIState extends State<EditRecapII> {
  // 1. STATE UNTUK FORM (Gejala)
  bool? _isKonjungtivitaPucat; // true = Pucat, false = Merah Segar
  bool? _isKukuRapuh; // true = Rapuh/Pucat, false = Bersih
  bool? _isTampakLemas; // true = Ya, false = Tidak
  bool? _isTampakPucat; // true = Ya, false = Tidak
  bool? _hasRiwayatAnemia; // true = Ya, false = Tidak

  // 2. STATE UNTUK PROSES
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final AnakKaderDataManager _anakKaderDataManager = AnakKaderDataManager();
  late FilterModel _filterModel;

  // Nama properti disesuaikan agar lebih eksplisit dengan arti nilai 'true'
  // (e.g., konjungtivitaNormal: true -> Merah Segar/Normal. konjungtivitaNormal: false -> Pucat).
  // Saya menggunakan penamaan yang mencerminkan nilai boolean di model.

  @override
  void initState() {
    super.initState();
    // Inisialisasi Provider di initState dengan listen: false
    _filterModel = Provider.of<FilterModel>(context, listen: false);
    _loadInitialGejalaData();
  }

  // Mengubah nama fungsi dan properti state agar lebih jelas (Merah Segar = !Pucat)
  void _loadInitialGejalaData() {
    final AnakKader anakKaderData = _anakKaderDataManager.getData();
    
    // Memuat data dari model ke state lokal form
    _isKonjungtivitaPucat = anakKaderData.konjungtivitaNormal == null 
        ? null 
        : !anakKaderData.konjungtivitaNormal!;
        
    _isKukuRapuh = anakKaderData.kukuBersih == null 
        ? null 
        : !anakKaderData.kukuBersih!;
        
    _isTampakLemas = anakKaderData.tampakLemas;
    _isTampakPucat = anakKaderData.tampakPucat;
    _hasRiwayatAnemia = anakKaderData.riwayatAnemia;
  }

  // Mengubah fungsi pengumpulan data agar lebih ringkas
  AnakKader _collectGejalaDataForAnakKader(AnakKader current) {
    // Membuat objek AnakKader baru dengan properti lama (current)
    // dan hanya mengupdate properti gejala dari state lokal.
    return AnakKader(
      tanggalPemeriksaan: current.tanggalPemeriksaan,
      namaIbu: current.namaIbu,
      namaAnak: current.namaAnak,
      umurTahun: current.umurTahun,
      umurBulan: current.umurBulan,
      beratBadan: current.beratBadan,
      tinggiBadan: current.tinggiBadan,
      jenisKelamin: current.jenisKelamin,
      id: current.id, 
      
      // Update data gejala
      konjungtivitaNormal: _isKonjungtivitaPucat != null ? !_isKonjungtivitaPucat! : null,
      kukuBersih: _isKukuRapuh != null ? !_isKukuRapuh! : null,
      tampakLemas: _isTampakLemas,
      tampakPucat: _isTampakPucat,
      riwayatAnemia: _hasRiwayatAnemia,
    );
  }

  // Menggunakan getter untuk menentukan apakah tombol harus aktif
  bool get _isButtonActive {
    return _isKonjungtivitaPucat != null &&
           _isKukuRapuh != null &&
           _isTampakLemas != null &&
           _isTampakPucat != null &&
           _hasRiwayatAnemia != null &&
           !_isLoading;
  }

  // Fungsi Submit disederhanakan dan dipastikan berada dalam blok try-catch-finally
  Future<void> _submitAnak() async {
    if (!_isButtonActive) return; // Tambahkan pengaman

    setState(() {
      _isLoading = true;
    });
    
    final AnakKader anakKaderData = _anakKaderDataManager.getData();
    // 1. Kumpulkan data terbaru
    AnakKader updatedAnakKader = _collectGejalaDataForAnakKader(anakKaderData);
    updatedAnakKader.email = User.instance.email; 
    
    // 2. Update DataManager sebelum dikirim (opsional, tapi mengikuti pola lama)
    _anakKaderDataManager.currentAnakKader = updatedAnakKader;

    try {
      // 3. Kirim ke API
      await KaderServices().editAnakKader(updatedAnakKader.toJson());

      // 4. Reset dan Update Provider (pastikan RiwayatProvider tersedia)
      anakKaderData.reset();
      final riwayatProvider = Provider.of<RiwayatProvider>(context, listen: false);

      if (_filterModel.filter) {
        riwayatProvider.filterChildrenByMonth(
          _filterModel.month,
          _filterModel.year,
          _filterModel.count,
        );
      } else {
        riwayatProvider.fetchChildrenData();
      }

      // 5. Tampilkan sukses
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil diubah!')),
        );
        // 6. Navigasi kembali (setelah sukses)
        Navigator.pop(context); 
        Navigator.pop(context);
      }
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengubah data: ${e.toString()}')),
        );
      }
    } finally {
      // 7. Hentikan loading
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Reusable Widget untuk Radio Button Row
  Widget _buildRadioRow({
    required String title,
    required String question,
    required String labelForTrue,
    required String labelForFalse,
    required bool? groupValue, 
    required ValueChanged<bool?> onChanged, 
    required double width,
    required double height,
  })
  {
    // Menggunakan groupValue langsung untuk menentukan warna
    const Color activeColor = Color(0xFF9FC86A);
    const Color activeBgColor = Color(0xFFF4F9EC);
    const Color inactiveColor = Color(0xFFE2E8F0);
    const Color textColor = Color(0xFF020617);
    const Color questionColor = Color(0xFF64748B);

    // Mematikan fungsi `onChanged` saat loading
    final ValueChanged<bool?> radioOnChanged = _isLoading ? (value) {} : onChanged;

    Widget buildOption({required bool value, required String label}) {
      final isActive = groupValue == value;
      return Expanded(
        child: InkWell(
          onTap: () => radioOnChanged(value),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: isActive ? activeBgColor : Colors.white,
              border: Border.all(
                color: isActive ? activeColor : inactiveColor,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  color: isActive ? activeColor : textColor,
                  fontSize: width * 0.035,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: width * 0.04,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: height * 0.01),
        Text(
          question,
          style: GoogleFonts.poppins(
            color: questionColor,
            fontSize: width * 0.035,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: height * 0.015),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildOption(value: true, label: labelForTrue),
            SizedBox(width: width * 0.04),
            buildOption(value: false, label: labelForFalse),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan variabel final lokal
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    const Color primaryColor = Color(0xFF9FC86A);
    
    // Menggunakan WillPopScope untuk memblokir navigasi saat loading
    return WillPopScope(
      onWillPop: () async => !_isLoading,
      child: Scaffold(
        // Menggunakan Stack untuk menampilkan loading overlay
        body: Stack(
          children: [
            // Konten Utama (Form)
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.03), // Padding disesuaikan
              child: Column(
                children: [
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        // Menggunakan padding top untuk menghindari status bar
                        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10),
                        children: [
                          // Header
                          _buildHeader(context, width, height),
                          
                          SizedBox(height: height * 0.02),
                          
                          // Judul Form
                          Text(
                            "Tambah Data",
                            style: GoogleFonts.poppins(fontSize: width * 0.06, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Data anak ke-1",
                            style: GoogleFonts.poppins(
                                fontSize: width * 0.035, fontWeight: FontWeight.w400, color: const Color(0xFF64748B)),
                          ),
                          
                          SizedBox(height: height * 0.03),

                          // Bagian Gejala
                          Text(
                            "Gejala",
                            style: GoogleFonts.poppins(fontSize: width * 0.04, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: height * 0.02),
                          
                          // Kotak Form Gejala
                          _buildGejalaFormContainer(width, height),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: height * 0.02),
                  
                  // Tombol Submit
                  _buildSubmitButton(width, primaryColor),
                  
                  SizedBox(height: height * 0.04),
                ],
              ),
            ),
            
            // Loading Overlay
            if (_isLoading)
              _buildLoadingOverlay(width),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double width, double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
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
    );
  }

  Widget _buildGejalaFormContainer(double width, double height) {
    return Container(
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
          // Catatan: Nilai Boolean di sini dibalik agar sesuai dengan penamaan state
          // Konjungtiva: Merah Segar (false) vs Pucat (true)
          _buildRadioRow(
            title: "Konjungtiva",
            question: "Saat kelopak mata bawah ditarik perlahan, apakah warnanya merah segar?",
            labelForTrue: "Merah Segar",
            labelForFalse: "Pucat",
            groupValue: _isKonjungtivitaPucat,
            onChanged: (value) => setState(() => _isKonjungtivitaPucat = value),
            width: width,
            height: height,
          ),
          SizedBox(height: height * 0.02),

          // Kuku: Rapuh/Pucat (true) vs Bersih (false)
          _buildRadioRow(
            title: "Kuku",
            question: "Apakah kuku anak bersih dan tidak rapuh?",
            labelForTrue: "Ya, Bersih",
            labelForFalse: "Merah Segar",
            groupValue: _isKukuRapuh,
            onChanged: (value) => setState(() => _isKukuRapuh = value),
            width: width,
            height: height,
          ),
          SizedBox(height: height * 0.02),

          // Tampak Lemas: Ya (true) vs Tidak (false)
          _buildRadioRow(
            title: "Lemas",
            question: "Anak terlihat Lemas?",
            labelForTrue: "Ya",
            labelForFalse: "Tidak",
            groupValue: _isTampakLemas,
            onChanged: (value) => setState(() => _isTampakLemas = value),
            width: width,
            height: height,
          ),
          SizedBox(height: height * 0.02),

          // Tampak Pucat: Ya (true) vs Tidak (false)
          _buildRadioRow(
            title: "Pucat",
            question: "Anak terlihat pucat?",
            labelForTrue: "Ya",
            labelForFalse: "Tidak",
            groupValue: _isTampakPucat,
            onChanged: (value) => setState(() => _isTampakPucat = value),
            width: width,
            height: height,
          ),
          SizedBox(height: height * 0.02),

          // Riwayat Anemia: Ya (true) vs Tidak (false)
          _buildRadioRow(
            title: "Riwayat Anemia",
            question: "Apakah anak memiliki riwayat anemia?",
            labelForTrue: "Ya",
            labelForFalse: "Tidak",
            groupValue: _hasRiwayatAnemia,
            onChanged: (value) => setState(() => _hasRiwayatAnemia = value),
            width: width,
            height: height,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
  
  Widget _buildSubmitButton(double width, Color primaryColor) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _isButtonActive ? _submitAnak : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isButtonActive ? primaryColor : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              elevation: 0,
            ),
            child: _isLoading 
              ? const SizedBox(
                  width: 20, 
                  height: 20, 
                  child: CircularProgressIndicator(
                    color: Colors.white, 
                    strokeWidth: 3,
                  )
                )
              : Text(
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
    );
  }

  Widget _buildLoadingOverlay(double width) {
    const Color loadingColor = Color(0xFF9FC86A);
    
    return Material(
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
                valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
              ),
              const SizedBox(height: 16),
              Text(
                "Mengunggah data...",
                style: GoogleFonts.poppins(
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}