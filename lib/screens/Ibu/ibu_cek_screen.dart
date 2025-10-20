import 'package:balansing/screens/Ibu/Cek/ibu_cek_I_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Pastikan file-file ini ada di direktori yang sama
import 'package:balansing/card/CekAnakCard.dart';
import 'package:balansing/providers/IbuProvider.dart';
import 'package:balansing/models/user_model.dart';
import 'package:balansing/screens/Ibu/Cek/ibu_riwayat_screen.dart';
import 'package:balansing/screens/Ibu/Quiz/ibu_quiz_managerI_screen.dart';

class IbuCekScreen extends StatefulWidget {
  const IbuCekScreen({super.key});

  @override
  State<IbuCekScreen> createState() => _IbuCekScreenState();
}

class _IbuCekScreenState extends State<IbuCekScreen> {
  // Variabel state untuk melacak indeks card yang sedang terpilih
  int _selectedIndex = -1; // -1 berarti tidak ada yang terpilih
  bool cekDate = false;
  bool quizDone = true;
  final QuizScoreManager _scoreManager = QuizScoreManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).fetchDaftarAnak(User.instance.email);
    });
  }

  // Fungsi untuk menghitung umur
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

  // Fungsi untuk mendapatkan ID anak yang dipilih
  String? getSelectedAnakId(ProfileProvider provider) {
    if (_selectedIndex != -1 && _selectedIndex < provider.daftarAnak.length) {
      return provider.daftarAnak[_selectedIndex]['id'];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.08),
              // Peringatan akan ditampilkan jika belum ada anak yang dipilih
              cekDate
                  ? Container(
                      width: double.infinity,
                      height: height * 0.08,
                      color: const Color(0xFFFEF9C3),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info, size: width * 0.05, color: const Color(0xFFEAB308)),
                              SizedBox(width: width * 0.02),
                              Text(
                                "Peringatan",
                                style: GoogleFonts.poppins(
                                  fontSize: width * 0.04,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFEAB308),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(width: width * 0.07), // Untuk perataan
                              Text(
                                "Pemeriksaan selanjutnya: 4 Juli 2025",
                                style: GoogleFonts.poppins(
                                  fontSize: width * 0.03,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFFEAB308),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : SizedBox(height: height * 0.0),
              
              cekDate
                  ? SizedBox(height: height * 0.02)
                  : SizedBox(height: height * 0.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Cek Kesehatan",
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      print("Tombol Riwayat ditekan!");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const IbuRiwayatScreen()),
                      );
                    },
                    icon: const Icon(Icons.history),
                    label: Text(
                      "Riwayat",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE2E8F0),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.01),
              Text(
                "Untuk mulai cek risiko stunting & anemia, pilih anak yang ingin kamu pantau kesehatannya. Karena tumbuh kembang mereka, berawal dari perhatianmu hari ini.",
                style: GoogleFonts.poppins(
                  fontSize: width * 0.03,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                ),
              ),
              SizedBox(height: height * 0.02),
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 2,
                    ),
                  ),
                  child: Consumer<ProfileProvider>(
                    builder: (context, profileProvider, child) {
                      if (profileProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (profileProvider.errorMessage != null) {
                        return Center(child: Text(profileProvider.errorMessage!));
                      }
                      if (profileProvider.daftarAnak.isEmpty) {
                        return const Center(child: Text("Tidak ada data anak ditemukan."));
                      }

                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ...List.generate(profileProvider.daftarAnak.length, (index) {
                              final anak = profileProvider.daftarAnak[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedIndex = index;
                                    });
                                  },
                                  child: ProfileCard(
                                    name: anak['nama'],
                                    birthDate: DateFormat('d MMMM yyyy', 'id').format(DateTime.parse(anak['usia'])),
                                    age: _calculateAge(DateTime.parse(anak['usia'])),
                                    gender: anak['jenisKelamin'],
                                    checkable: anak['cekMingguan'],
                                    isSelected: _selectedIndex == index,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  ),),

              
              SizedBox(height: height * 0.02),

              quizDone
                  ?Container(
                    width: double.infinity,
                    height: height * 0.3,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column( mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/FoodIcon.png",
                          height: height * 0.07,
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          "Gizi & Kebersihan si kecil",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          "Jawab kuis singkat ini untuk dapatkan tips lengkap seputar menu dan keluarga sehat.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.03,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        SizedBox(
                          width: double.infinity, // Ini akan membuat widget memenuhi lebar parent
                          height: MediaQuery.of(context).size.height * 0.04, // Mengatur tinggi sesuai permintaan Anda
                          child: ElevatedButton(
                            onPressed: () async {
                              print("Page Quiz");

                                _scoreManager.resetScore();

                               await Navigator.push( // Await the push so you can refresh
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => IbuQuizManagerIScreen(),
                                      ),
                                    );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9FC86A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              "Mulai Quiz!",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width * 0.035,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.005),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Sedang sibuk? ",
                                style: GoogleFonts.poppins(
                                  fontSize: width * 0.03,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF64748B),
                                )),
                            GestureDetector(
                              onTap: () {
                                print("Lewati Quiz");
                                setState(() {
                                  //quizDone = false;
                                });
                              },
                              child: Text("Ingatkan Kembali",
                                  style: GoogleFonts.poppins(
                                    fontSize: width * 0.03,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF9FC86A),
                                  )),)
                          ],
                        )
                      
                      ],
                    ),
                  ):SizedBox(height: height * 0.0),

              quizDone? SizedBox(height: height * 0.02) : SizedBox(height: height * 0.0),
              
              Consumer<ProfileProvider>(
                builder: (context, profileProvider, child) {
                  final bool isButtonActive = _selectedIndex != -1 && !cekDate;
                  final String? selectedAnakId = getSelectedAnakId(profileProvider);

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isButtonActive
                              ? () async {
                                  print("Tombol Selanjutnya ditekan!");
                                  if (selectedAnakId != null) {
                                    print("ID anak yang dipilih: $selectedAnakId");
                                    await Navigator.push( // Await the push so you can refresh
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => IbuCekIScreen(id: selectedAnakId),
                                      ),
                                    );
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isButtonActive ? const Color(0xFF9FC86A) : Colors.grey,
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
                  );
                },
              ),
              SizedBox(height: height * 0.005),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_month, size: width * 0.04, color: Colors.grey),
                  SizedBox(width: width * 0.02),
                  Text(
                    "Pengecekan sebelumnya: 4 Juni 2025",
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.03,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height*0.04,)
            ],
          ),
        ),
      ),
    );
  }
}