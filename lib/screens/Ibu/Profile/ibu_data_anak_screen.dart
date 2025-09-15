import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:balansing/card/AnakIbuCard.dart';
import 'package:balansing/providers/IbuProvider.dart';
import 'package:balansing/models/user_model.dart';
import 'package:balansing/screens/Ibu/Profile/ibu_tambah_anak_screen.dart';

class IbuDataAnakScreen extends StatefulWidget {
  const IbuDataAnakScreen({super.key});

  @override
  State<IbuDataAnakScreen> createState() => _IbuDataAnakScreenState();
}

class _IbuDataAnakScreenState extends State<IbuDataAnakScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).fetchDaftarAnak(User.instance.email);
    });
  }

  void _reloadData() {
    Provider.of<ProfileProvider>(context, listen: false).fetchDaftarAnak(User.instance.email);
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
            // Tambah jarak di atas row tombol "Kembali"
            SizedBox(height: height * 0.05), // <-- Penambahan jarak di sini

            // Header
            Container(
              color: Colors.transparent,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
            SizedBox(height: height * 0.01),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Data Anak",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: width * 0.055,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Kelola data anak Anda di sini",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF64748B),
                      fontSize: width * 0.03,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: height * 0.02), // <-- Jarak ini dipertahankan karena sudah cukup baik
                ],
              ),
            ),

            // Bagian daftar anak
            Expanded(
              child: Consumer<ProfileProvider>(
                builder: (context, profileProvider, child) {
                  if (profileProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (profileProvider.errorMessage != null) {
                    return Center(child: Text(profileProvider.errorMessage!));
                  }

                  if (profileProvider.daftarAnak.isEmpty) {
                    return const Center(child: Text('Belum ada data anak.'));
                  }

                  return ListView.builder(
                    padding: EdgeInsets.zero, // <-- Menghilangkan padding default ListView
                    itemCount: profileProvider.daftarAnak.length,
                    itemBuilder: (context, index) {
                      final anak = profileProvider.daftarAnak[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: ChildCard(
                          id: anak['id'],
                          nama: anak['nama'],
                          usia: _hitungUsia(anak['usia']),
                          beratBadan: (anak['beratBadan'] as num).toDouble(), 
                          tinggiBadan: (anak['tinggiBadan'] as num).toDouble(),
                          anemia: anak['anemia'],
                          stunting: anak['stunting'],
                          jenisKelamin: anak['jenisKelamin'],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Tombol "Tambah data baru"
            SizedBox(height: height * 0.01), // <-- Mengurangi jarak agar lebih dekat ke list
            SizedBox(
              width: double.infinity,
              height: height * 0.06,
              child: TextButton(
                onPressed: () async {
                  await Navigator.push( // Await the push so you can refresh
                        context,
                        MaterialPageRoute(
                          builder: (context) => const IbuTambahAnak(),
                        ),
                      );
                  _reloadData();
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF9FC86A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  "Tambah data baru +",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: width * 0.04,
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.06),
          ],
        ),
      ),
    );
  }

  int _hitungUsia(String tanggalLahir) {
    try {
      final dob = DateTime.parse(tanggalLahir);
      final today = DateTime.now();
      int months = (today.year - dob.year) * 12 + today.month - dob.month;
      if (today.day < dob.day) {
        months--;
      }
      return months;
    } catch (e) {
      print('Error parsing date: $e');
      return 0;
    }
  }
}