import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Tambahkan dependensi intl di pubspec.yaml

// Pastikan file-file ini ada di direktori yang sama
import 'package:balansing/card/CekAnakCard.dart'; 
import 'package:balansing/providers/IbuProvider.dart';
import 'package:balansing/models/user_model.dart';


// ====================================================================

class IbuCekScreen extends StatefulWidget {
  const IbuCekScreen({super.key});

  @override
  State<IbuCekScreen> createState() => _IbuCekScreenState();
}

class _IbuCekScreenState extends State<IbuCekScreen> {
  // Variabel state untuk melacak indeks card yang sedang terpilih
  int _selectedIndex = -1; // -1 berarti tidak ada yang terpilih
  bool ButtonActive = false;

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
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: height * 0.4,
                  maxHeight: height * 0.4,
                ),
                child: Container(
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
                      // Tampilkan indikator loading atau pesan error
                      if (profileProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (profileProvider.errorMessage != null) {
                        return Center(child: Text(profileProvider.errorMessage!));
                      }
                      if (profileProvider.daftarAnak.isEmpty) {
                        return const Center(child: Text("Tidak ada data anak ditemukan."));
                      }

                      // Membangun daftar card secara dinamis
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
                                      // Ubah _selectedIndex menjadi indeks yang baru
                                      _selectedIndex = index;
                                    });
                                  },
                                  child: ProfileCard(
                                    name: anak['nama'],
                                    // Mengubah format tanggal
                                    birthDate: DateFormat('d MMMM yyyy', 'id').format(DateTime.parse(anak['usia'])),
                                    // Menghitung umur
                                    age: _calculateAge(DateTime.parse(anak['usia'])),
                                    gender: anak['jenisKelamin'],
                                    // Meneruskan status selected
                                    isSelected: _selectedIndex == index,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            
              SizedBox(height: height * 0.02),

              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child:ElevatedButton(
                    onPressed: ButtonActive ? () {
                      print("Tombol Selanjutnya ditekan!");

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
                
            ],
          ),
        ),
      ),
    );
  }
}