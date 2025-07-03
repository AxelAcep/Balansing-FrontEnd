import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/models/user_model.dart'; // Import User model
import 'package:balansing/screens/onboarding_screen.dart'; // Import OnboardingScreen

class KaderDashboardScreen extends StatefulWidget {
  const KaderDashboardScreen({super.key});

  @override
  State<KaderDashboardScreen> createState() => _KaderDashboardScreenState();
}

class _KaderDashboardScreenState extends State<KaderDashboardScreen> {

  // Fungsi untuk menangani proses logout
  void _handleLogout() async {
    // 1. Reset data User.instance
    // Setting email, token, dan jenis ke string kosong akan secara otomatis
    // memicu penyimpanan ke SharedPreferences karena setter di User model.
    User.instance.email = '';
    User.instance.token = '';
    User.instance.jenis = '';

    print('DEBUG: User data reset. Navigating to OnboardingScreen.');

    // 2. Navigasi kembali ke OnboardingScreen
    // pushAndRemoveUntil memastikan user tidak bisa kembali ke dashboard setelah logout
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        (Route<dynamic> route) => false, // Ini menghapus semua route sebelumnya dari stack
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Selamat Datang, Kader!",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _handleLogout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}