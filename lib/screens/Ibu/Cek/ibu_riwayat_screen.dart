// lib/screens/IbuRiwayatScreen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


import 'package:balansing/card/RiwayatIbuCard.dart';
import 'package:balansing/models/user_model.dart'; // Asumsikan Anda memiliki model User
import 'package:balansing/providers/IbuProvider.dart'; // Sesuaikan path jika berbeda

class IbuRiwayatScreen extends StatefulWidget {
  const IbuRiwayatScreen({super.key});

  @override
  State<IbuRiwayatScreen> createState() => _IbuRiwayatScreenState();
}

class _IbuRiwayatScreenState extends State<IbuRiwayatScreen> {
  // Simpan bulan dan tahun yang sedang aktif
  late int _selectedMonth;
  late int _selectedYear;

  // Nama bulan dalam bahasa Indonesia
  final List<String> _monthNames = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli',
    'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  @override
  void initState() {
    super.initState();
    // 1. Ambil bulan dan tahun saat ini secara otomatis
    final now = DateTime.now();
    _selectedMonth = now.month;
    _selectedYear = now.year;
    // Panggil fungsi untuk mengambil data
    _fetchData();
  }

  // Fungsi untuk memanggil provider mengambil data
  void _fetchData() {
    Provider.of<RecapProvider>(context, listen: false).fetchMonthlyRecap(
      User.instance.email,
      _selectedMonth,
      _selectedYear,
    );
  }

  // Fungsi untuk menampilkan modal filter
  void _showFilterModal() {
  final height = MediaQuery.of(context).size.height;
  final width = MediaQuery.of(context).size.width;
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: height * 0.03),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilih Bulan & Tahun',
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: height * 0.02),
                // Dropdown untuk Bulan
                DropdownButtonFormField<int>(
                  value: _selectedMonth,
                  style: GoogleFonts.poppins(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Bulan',
                    labelStyle: GoogleFonts.poppins(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.02),
                      borderSide: const BorderSide(color: Color(0xFF9FC86A)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.02),
                      borderSide: const BorderSide(color: Color(0xFF9FC86A), width: 2.0),
                    ),
                  ),
                  dropdownColor: const Color(0xFFF4F9EC),
                  items: List.generate(12, (index) {
                    return DropdownMenuItem(
                      value: index + 1,
                      child: Text(
                        _monthNames[index],
                        style: GoogleFonts.poppins(),
                      ),
                    );
                  }),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedMonth = value;
                      });
                    }
                  },
                ),
                SizedBox(height: height * 0.02),
                // Dropdown untuk Tahun
                DropdownButtonFormField<int>(
                  value: _selectedYear,
                  style: GoogleFonts.poppins(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Tahun',
                    labelStyle: GoogleFonts.poppins(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.02),
                      borderSide: const BorderSide(color: Color(0xFF9FC86A)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.02),
                      borderSide: const BorderSide(color: Color(0xFF9FC86A), width: 2.0),
                    ),
                  ),
                  dropdownColor: const Color(0xFFF4F9EC),
                  items: List.generate(5, (index) {
                    final year = DateTime.now().year - index;
                    return DropdownMenuItem(
                      value: year,
                      child: Text(
                        year.toString(),
                        style: GoogleFonts.poppins(),
                      ),
                    );
                  }),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedYear = value;
                      });
                    }
                  },
                ),
                SizedBox(height: height * 0.03),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _fetchData();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF4F9EC),
                      side: const BorderSide(color: Color(0xFF9FC86A), width: 1.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(width * 0.02),
                      ),
                      padding: EdgeInsets.symmetric(vertical: height * 0.015),
                    ),
                    child: Text(
                      'Terapkan',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF9FC86A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.04),
              Row(
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
              SizedBox(height: height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Riwayat Data",
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.06,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: _showFilterModal, // Panggil fungsi modal di sini
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.02,
                        vertical: height * 0.01,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.filter_list,
                            color: const Color(0xFF64748B),
                            size: width * 0.04,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Filter',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF64748B),
                              fontWeight: FontWeight.w700,
                              fontSize: width * 0.03,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tanggal Pengecekan",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF020617),
                      fontSize: width * 0.03,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    // 2. Tampilkan tanggal yang dipilih
                    '${_monthNames[_selectedMonth - 1]} $_selectedYear',
                    style: GoogleFonts.poppins(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: width * 0.035,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              // Mengganti dummy data dengan Consumer dan perulangan
              Consumer<RecapProvider>(
                builder: (context, recapProvider, child) {
                  if (recapProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (recapProvider.errorMessage != null) {
                    return Center(child: Text('Error: ${recapProvider.errorMessage}'));
                  } else if (recapProvider.monthlyRecaps.isEmpty) {
                    // 3. Menangani jika data kosong
                    return Column(
                      children: [
                        SizedBox(height: height * 0.2),
                        Text(
                          'Tidak ada data riwayat untuk bulan ini.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: height * 0.2),
                      ],
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: recapProvider.monthlyRecaps.map((childData) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: ChildCard(child: childData),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}