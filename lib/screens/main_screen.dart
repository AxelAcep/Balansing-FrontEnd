import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:balansing/colors.dart';
import 'package:balansing/models/customer.dart';
import 'package:balansing/screens/barang/barang_home_screen.dart';
import 'package:balansing/screens/bookmark/bookmark_home_screen.dart';
import 'package:balansing/screens/keranjang/keranjang_home_screen.dart';
import 'package:balansing/screens/pendaftaran/pendaftaran_home_screen.dart';
import 'package:balansing/services/auth_services.dart';

class MainScreen extends StatefulWidget {
  final pageIndex;
  const MainScreen({super.key, required this.pageIndex});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPageIndex = 0;
  late Future<Customer?> _future;
  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.pageIndex;
    final authService = Provider.of<AuthService>(context, listen: false);
    //final latihanService = Provider.of<LatihanService>(context, listen: false);
    _future = authService.getCustomer();
    //latihanService.getLatihan();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return snapshot.data!.name == null || snapshot.data!.username == null
                ? const PendaftaranHomeScreen()
                : Scaffold(
                    bottomNavigationBar: NavigationBar(
                      onDestinationSelected: (int index) {
                        setState(() {
                          currentPageIndex = index;
                        });
                      },
                      indicatorColor: Colors.white,
                      backgroundColor: Colors.white,
                      selectedIndex: currentPageIndex,
                      destinations: <Widget>[
                        NavigationDestination(
                          selectedIcon: Image.asset(
                            'assets/images/materi_ic.png',
                          ),
                          icon: Image.asset('assets/images/materi_ic.png',
                              color: Colors.grey),
                          label: 'Materi Dasar',
                        ),
                        NavigationDestination(
                          selectedIcon:
                              Image.asset('assets/images/latihan_ic.png'),
                          icon: Image.asset('assets/images/latihan_ic.png',
                              color: Colors.grey),
                          label: 'Latihan',
                        ),
                        NavigationDestination(
                          selectedIcon:
                              Image.asset('assets/images/progress_ic.png'),
                          icon: Image.asset('assets/images/progress_ic.png',
                              color: Colors.grey),
                          label: 'Progress',
                        ),
                      ],
                    ),
                    body: <Widget>[
                      const BarangHomeScreen(),
                      const BookmarkHomeScreen(),
                      const KeranjangHomeScreen(),
                    ][currentPageIndex],
                  );
          } else {
            // Jika tidak ada data (future selesai dengan null)
            return Text('No data');
          }
        });
  }
}
