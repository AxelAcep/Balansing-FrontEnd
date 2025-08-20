import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:balansing/models/user_model.dart'; // Tidak perlu di sini lagi karena sudah di ProfilScreen
// import 'package:balansing/screens/onboarding_screen.dart'; // Tidak perlu di sini lagi karena sudah di ProfilScreen

// Import halaman-halaman yang baru dibuat
import 'package:balansing/screens/Kader/kader_riwayat_screen.dart';
import 'package:balansing/screens/Kader/kader_beranda_screen.dart';
import 'package:balansing/screens/Kader/kader_profile_screen.dart';

class KaderDashboardScreen extends StatefulWidget {
  const KaderDashboardScreen({super.key});

  @override
  State<KaderDashboardScreen> createState() => _KaderDashboardScreenState();
}

class _KaderDashboardScreenState extends State<KaderDashboardScreen> {
  int _selectedIndex = 1; // Default ke halaman Beranda (index 1)

  // Daftar halaman yang akan ditampilkan
  static const List<Widget> _pages = <Widget>[
    RiwayatScreen(), // Index 0
    BerandaScreen(), // Index 1
    ProfilScreen(),  // Index 2
  ];

  // Fungsi yang dipanggil saat item BottomNavigationBar ditekan
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    //double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: IndexedStack( // Menggunakan IndexedStack untuk menjaga state halaman
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: SizedBox( height: height*0.14,   child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.history, size: _selectedIndex == 0 ? height*0.037 : height*0.03), // Icon untuk Riwayat
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: _selectedIndex == 1 ? height*0.037 : height*0.03), // Icon untuk Beranda
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,  size: _selectedIndex == 2 ? height*0.037 : height*0.03), // Icon untuk Profil
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex, // Indeks item yang sedang aktif
        selectedItemColor: const Color(0xFF9FC86A), // Warna icon/teks yang dipilih
        unselectedItemColor: const Color(0xFF64748B), // Warna icon/teks yang tidak dipilih
        onTap: _onItemTapped, // Fungsi yang dipanggil saat item ditekan
        backgroundColor: Colors.white,
        selectedFontSize: height*0.02,
        unselectedFontSize: height*0.015,
        type: BottomNavigationBarType.fixed, // Agar semua item terlihat jelas
        selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w300),
      ),)
    );
  }
}