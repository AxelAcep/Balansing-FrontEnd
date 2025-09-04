import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import halaman-halaman
import 'package:balansing/screens/Ibu/ibu_artikel_screen.dart';
import 'package:balansing/screens/Ibu/ibu_beranda_screen.dart';
import 'package:balansing/screens/Ibu/ibu_cek_screen.dart';
import 'package:balansing/screens/Ibu/ibu_profil_screen.dart';
import 'package:balansing/screens/Ibu/ibu_makanan_screen.dart';


class IbuDashboardScreen extends StatefulWidget {
  const IbuDashboardScreen({super.key});

  @override
  State<IbuDashboardScreen> createState() => _IbuDashboardScreenState();
}

class _IbuDashboardScreenState extends State<IbuDashboardScreen> {
  int _selectedIndex = 2; // Default ke halaman Beranda (index 2)

  // Daftar halaman yang akan ditampilkan
  static const List<Widget> _pages = <Widget>[
    IbuCekScreen(),
    IbuMakananScreen(),
    IbuBerandaScreen(),
    IbuArtikelScreen(),
    IbuProfilScreen(),
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

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: SizedBox(
        height: height * 0.14,
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.health_and_safety_outlined, // Icon untuk Cek Kesehatan
                size: _selectedIndex == 0 ? height * 0.037 : height * 0.03,
              ),
              label: 'Cek',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.restaurant_menu, // Icon untuk Resep Makanan
                size: _selectedIndex == 1 ? height * 0.037 : height * 0.03,
              ),
              label: 'Makanan',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined, // Icon untuk Beranda
                size: _selectedIndex == 2 ? height * 0.037 : height * 0.03,
              ),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.article_outlined, // Icon untuk Artikel
                size: _selectedIndex == 3 ? height * 0.037 : height * 0.03,
              ),
              label: 'Artikel',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outlined, // Icon untuk Profil
                size: _selectedIndex == 4 ? height * 0.037 : height * 0.03,
              ),
              label: 'Profil',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF9FC86A),
          unselectedItemColor: const Color(0xFF64748B),
          onTap: _onItemTapped,
          backgroundColor: Colors.white,
          selectedFontSize: height * 0.016,
          unselectedFontSize: height * 0.014,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}