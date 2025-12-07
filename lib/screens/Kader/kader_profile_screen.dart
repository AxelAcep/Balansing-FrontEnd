import 'dart:convert';
import 'package:balansing/services/kader_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/models/user_model.dart';
import 'package:balansing/screens/onboarding_screen.dart';
import 'package:balansing/screens/Kader/Profile/kader_informasi_screen.dart';
import 'package:balansing/screens/Kader/Profile/kader_password_screen.dart';
import 'package:balansing/screens/AboutUsPage.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final KaderServices _kaderServices = KaderServices();
  String _kaderProfileRawData = "Loading...";
  String _namaPuskesmas = "Tidak Tersedia";
  String _posyandu = "Tidak Tersedia";
  String _rt = "Tidak Tersedia";
  String _rw = "Tidak Tersedia";

  @override
  void initState() {
    super.initState();
    _fetchKaderProfile(); // Fetch data once when the screen is initialized
  }

  Future<void> _fetchKaderProfile() async {
    // Add a check to prevent fetching if email is already empty or data is already being fetched
    if (User.instance.email.isEmpty) {
      setState(() {
        _kaderProfileRawData = "Email pengguna tidak tersedia.";
        _namaPuskesmas = "Email tidak tersedia";
        _posyandu = "Email tidak tersedia";
        _rt = "Email tidak tersedia";
        _rw = "Email tidak tersedia";
      });
      print("DEBUG: User email is empty, cannot fetch kader profile.");
      return;
    }

    // Set initial loading state
    setState(() {
      _kaderProfileRawData = "Memuat...";
      _namaPuskesmas = "Memuat...";
      _posyandu = "Memuat...";
      _rt = "Memuat...";
      _rw = "Memuat...";
    });

    try {
      Map<String, dynamic> data = await _kaderServices.getKader(User.instance.email);

      setState(() {
        _kaderProfileRawData = jsonEncode(data);
        _namaPuskesmas = data['namaPuskesmas'] ?? 'Tidak Tersedia';
        _posyandu = data['namaPosyandu'] ?? 'Tidak Tersedia';
        _rt = data['rt'] ?? 'Tidak Tersedia';
        _rw = data['rw'] ?? 'Tidak Tersedia';
      });
      print("Kader Profile Data: $data");
    } catch (e) {
      setState(() {
        _kaderProfileRawData = "Gagal memuat profil: $e";
        _namaPuskesmas = "Gagal memuat";
        _posyandu = "Gagal memuat";
        _rt = "Gagal memuat";
        _rw = "Gagal memuat";
      });
      print('Error fetching kader profile: $e');
      print(_kaderProfileRawData);
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
                          'https://fqpalkzlylkiqmnsizji.supabase.co/storage/v1/object/public/Video/Images/Kader.png',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Text(
                    _namaPuskesmas,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: height * 0.027,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    _posyandu,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: height * 0.018,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  Text(
                    "RT. ${_rt} / RW. ${_rw}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: height * 0.018,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
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
                      print("Informasi Dasar Page");
                      await Navigator.push( // Await the push so you can refresh
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KaderInformasiScreen(),
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
                      print("Tentang Kami");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutUsPage(), // Replace with actual
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
                          "Tentang Kami",
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