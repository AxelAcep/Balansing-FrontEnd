import 'dart:convert';
import 'package:balansing/providers/IbuProvider.dart';
import 'package:balansing/screens/Ibu/Profile/ibu_data_anak_screen.dart';
import 'package:balansing/services/ibu_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/models/user_model.dart';
import 'package:balansing/screens/onboarding_screen.dart';
import 'package:balansing/screens/Ibu/Profile/ibu_informasi_screen.dart';
import 'package:balansing/screens/Kader/Profile/kader_password_screen.dart';
import 'package:provider/provider.dart';


class IbuProfilScreen extends StatefulWidget {
  const IbuProfilScreen({super.key});

  @override
  State<IbuProfilScreen> createState() => _IbuProfilScreenState();
}

class _IbuProfilScreenState extends State<IbuProfilScreen> {
  final IbuServices _ibuServices = IbuServices();
  String _ibuProfileRawData = "Loading";
  String _namaIbu = "Tidak Tersedia";
  String _jumlahAnak = "??";

  @override
  void initState() {
    super.initState();
    _fetchKaderProfile(); // Fetch data once when the screen is initialized
  }

  Future<void> _fetchKaderProfile() async {
    // Add a check to prevent fetching if email is already empty or data is already being fetched
    if (User.instance.email.isEmpty) {
      setState(() {
        _namaIbu = "Email pengguna tidak tersedia.";
        _jumlahAnak = "??";
      });
      print("DEBUG: User email is empty, cannot fetch kader profile.");
      return;
    }

    // Set initial loading state
    setState(() {
      _namaIbu = "Memuat...";
      _jumlahAnak = "Memuat...";
    });

    try {
      Map<String, dynamic> data = await _ibuServices.getIbu(User.instance.email);

      setState(() {
        _ibuProfileRawData = jsonEncode(data);
        _namaIbu = data['nama'] ?? 'Tidak Tersedia';
        _jumlahAnak = data['jumlah'] ?? '??';
        _jumlahAnak = data['_count']['anakAnak'].toString();
      });
      print("Kader Profile Data: $data");
    } catch (e) {
      setState(() {
        _ibuProfileRawData = "Gagal memuat profil: $e";
        _namaIbu = "Gagal memuat";
        _jumlahAnak = "-";
      });
      print('Error fetching kader profile: $e');
      print(_ibuProfileRawData);
    }
  }

  void _handleLogout() async {
    User.instance.email = '';
    User.instance.token = '';
    User.instance.jenis = '';

    print('DEBUG: User data reset. Navigating to OnboardingScreen.');

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: height * 0.1),
            Container(
              width: width * 0.9,
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: width * 0.35,
                    height: width * 0.35,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          'https://fqpalkzlylkiqmnsizji.supabase.co/storage/v1/object/public/Video/Images/Ibu.png',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Text(
                    _namaIbu,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: height * 0.027,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Ibu dari ${_jumlahAnak} Anak",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: height * 0.018,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  SizedBox(height: height * 0.05),
                ],
              ),
            ),
            Container(
              width: width * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Detail Pribadi",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: height * 0.017,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton(
                    onPressed: () async { // Make it async to await the push
                      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
                      profileProvider.fetchProfile(User.instance.email);
                      print("Informasi Dasar Page");
                      await Navigator.push( // Await the push so you can refresh
                        context,
                        MaterialPageRoute(
                          builder: (context) => const IbuInformasiScreen(),
                        ),
                      );
                      // After returning from KaderInformasiScreen, refresh the profile data
                      _fetchKaderProfile();
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size(width * 0.9, height * 0.06),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(width: 1.5, color: Color(0xFFE2E8F0)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Informasi dasar",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: height * 0.017,
                            color: Colors.black,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black,
                          size: height * 0.023,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.01,),
                  TextButton(
                    onPressed: () async { // Make it async to await the push
                      print("Anak Page");
                      await Navigator.push( // Await the push so you can refresh
                        context,
                        MaterialPageRoute(
                          builder: (context) => const IbuDataAnakScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size(width * 0.9, height * 0.06),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(width: 1.5, color: Color(0xFFE2E8F0)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Data anak",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: height * 0.017,
                            color: Colors.black,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black,
                          size: height * 0.023,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Text(
                    "Keamanan dan Privasi",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: height * 0.017,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      print("Ubah password Page");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KaderPasswordScreen(), // Replace with actual email change screen
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size(width * 0.9, height * 0.06),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(width: 1.5, color: Color(0xFFE2E8F0)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ubah password",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: height * 0.017,
                            color: Colors.black,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black,
                          size: height * 0.023,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  TextButton(
                    onPressed: () {
                      print("Ubah email Page");
                      // Implement navigation to change email screen
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size(width * 0.9, height * 0.06),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(width: 1.5, color: Color(0xFFE2E8F0)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ubah email",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: height * 0.017,
                            color: Colors.black,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black,
                          size: height * 0.023,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.02),
            ElevatedButton(
              onPressed: _handleLogout,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 229, 229),
                foregroundColor: const Color.fromARGB(172, 255, 132, 132),
                minimumSize: Size(width * 0.9, height * 0.05),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                    color: Color.fromARGB(255, 221, 102, 102),
                    width: 1.0,
                  ),
                ),
                textStyle: GoogleFonts.poppins(
                  fontSize: height * 0.02,
                  fontWeight: FontWeight.w400,
                ),
              ),
              child: const Text("Keluar"),
            ),
          ],
        ),
      ),
    );
  }
}