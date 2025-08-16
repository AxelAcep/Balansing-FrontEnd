// RiwayatScreen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:balansing/card/RiwayatCard.dart';
import 'package:balansing/providers/KaderProvider.dart'; // Ubah 'KaderProvider' menjadi 'RiwayatProvider' jika nama file Anda berbeda.
import 'package:balansing/models/filter_model.dart';
import 'package:balansing/card/filterModal.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _showFilterModal() {
    showDialog(
      context: context,
      builder: (context) {
        return FilterModalContent(); 
      },
    );
  }

  @override
  void initState() {
    super.initState();
    final riwayatProvider = Provider.of<RiwayatProvider>(context, listen: false);
    final filterModel = Provider.of<FilterModel>(context, listen: false);

    if (!filterModel.filter) {
      riwayatProvider.fetchChildrenData();
    } else {
      riwayatProvider.filterChildrenByMonth(
        filterModel.month,
        filterModel.year,
        filterModel.count,
      );
    }
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final riwayatProvider = Provider.of<RiwayatProvider>(context, listen: false);
    final filterModel = Provider.of<FilterModel>(context, listen: false);

    if (_searchController.text.isEmpty) {
      if (!filterModel.filter) {
        riwayatProvider.fetchChildrenData();
      } else {
        riwayatProvider.filterChildrenByMonth(
          filterModel.month,
          filterModel.year,
          filterModel.count,
        );
      }
    } else {
      riwayatProvider.searchChildren(_searchController.text);
    }
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.05),
              SizedBox(
                width: width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Riwayat Data",
                      style: GoogleFonts.poppins(
                        fontSize: height * 0.03,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Panggil fungsi untuk menampilkan modal
                        _showFilterModal();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.02,
                          vertical: height * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.filter_list,
                              color: const Color(0xFF64748B),
                              size: height * 0.012,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Filter',
                              style: TextStyle(
                                color: const Color(0xFF64748B),
                                fontWeight: FontWeight.w600,
                                fontSize: height * 0.01,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.01),
              _buildInfoRow(width, height, "RT/RW", "04/01"),
              SizedBox(height: height * 0.01),
              Consumer<FilterModel>(
                builder: (context, filterModel, child) {
                  return _buildInfoRow(
                    width,
                    height,
                    "Tanggal Input",
                    "${filterModel.year}/${filterModel.month.toString().padLeft(2, '0')} - ${filterModel.count} Bulan",
                  );
                },
              ),
              SizedBox(height: height * 0.01),
              Consumer<RiwayatProvider>(
                builder: (context, riwayatProvider, child) {
                  return _buildInfoRow(
                    width,
                    height,
                    "Jumlah Anak",
                    "${riwayatProvider.childrenData.length}",
                  );
                },
              ),
              SizedBox(height: height * 0.01),
              Container(
                width: width * 0.9,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.grey[600],
                      size: height * 0.025,
                    ),
                    SizedBox(width: width * 0.02),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari Data',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: width * 0.035,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: width * 0.035,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Kondisi untuk menampilkan loading, error, atau data
              Consumer<RiwayatProvider>(
                builder: (context, riwayatProvider, child) {
                  if (riwayatProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (riwayatProvider.errorMessage != null) {
                    return Center(
                      child: Text(
                        riwayatProvider.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (riwayatProvider.childrenData.isEmpty) {
                    return const Center(
                        child: Text('Tidak ada data anak ditemukan.'));
                  } else {
                    return ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: height * 0.63),
                      child: Container(
                        width: width * 0.9,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Scrollbar(
                          thumbVisibility: false,
                          child: SingleChildScrollView(
                            child: Column(
                              children: riwayatProvider.childrenData
                                  .map((childData) {
                                return ChildCard(
                                  nama:
                                      childData['nama'] ?? 'Nama Tidak Diketahui',
                                  usia: childData['usia'] ?? 0,
                                  beratBadan:
                                      (childData['beratBadan'] as num).toDouble(),
                                  tinggiBadan: (childData['tinggiBadan'] as num)
                                      .toDouble(),
                                  anemia: childData['anemia'] ?? false,
                                  stunting: childData['stunting'] ?? false,
                                  jenisKelamin:
                                      childData['jenisKelamin'] ?? 'Tidak Diketahui',
                                  id: childData['id'] ?? 'Tidak Diketahui',
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
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

  Widget _buildInfoRow(double width, double height, String label, String value) {
    return SizedBox(
      width: width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: width * 0.035,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF60646C),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: width * 0.035,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}