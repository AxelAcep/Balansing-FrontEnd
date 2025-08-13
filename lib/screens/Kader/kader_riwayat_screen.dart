import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:balansing/card/RiwayatCard.dart';
import 'package:balansing/providers/KaderProvider.dart'; // Ubah 'KaderProvider' menjadi 'RiwayatProvider' jika nama file Anda berbeda.
import 'package:balansing/models/filter_model.dart';

// Daftar nama bulan dalam bahasa Indonesia
const List<String> _monthNames = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
];

class ChildStatusData {
  final String title;
  final Color color;
  ChildStatusData(this.title, this.color);
}

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  final TextEditingController _searchController = TextEditingController();

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

  // Fungsi untuk menampilkan modal filter (sekarang menggunakan showDialog)
  void _showFilterModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return _FilterModalContent();
      },
    );
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
                        // Panggil fungsi untuk menampilkan modal di sini
                        _showFilterModal(context);
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
              // Menggunakan Consumer untuk memperbarui tanggal secara otomatis
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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

// Widget modal filter yang baru
class _FilterModalContent extends StatefulWidget {
  @override
  __FilterModalContentState createState() => __FilterModalContentState();
}

class __FilterModalContentState extends State<_FilterModalContent> {
  late int _selectedMonth;
  late int _selectedYear;
  late int _selectedCount;

  @override
  void initState() {
    super.initState();
    final filterModel = Provider.of<FilterModel>(context, listen: false);
    _selectedMonth = filterModel.month;
    _selectedYear = filterModel.year;
    _selectedCount = filterModel.count;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Data',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildDropdown(
              'Bulan',
              _selectedMonth,
              (newValue) {
                setState(() {
                  _selectedMonth = newValue!;
                });
              },
              List.generate(12, (index) => index + 1),
              isMonth: true,
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              'Tahun',
              _selectedYear,
              (newValue) {
                setState(() {
                  _selectedYear = newValue!;
                });
              },
              List.generate(5, (index) => DateTime.now().year - index),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              'Jumlah',
              _selectedCount,
              (newValue) {
                setState(() {
                  _selectedCount = newValue!;
                });
              },
              [1, 3, 6, 12],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    final filterModel = Provider.of<FilterModel>(context, listen: false);
                    final riwayatProvider = Provider.of<RiwayatProvider>(context, listen: false);

                    filterModel.setFilter(false);
                    filterModel.setMonth(DateTime.now().month);
                    filterModel.setYear(DateTime.now().year);
                    filterModel.setCount(1);

                    riwayatProvider.fetchChildrenData();
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF60646C),
                  ),
                  child: Text('Tampilkan Semua', style: GoogleFonts.poppins()),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    final filterModel = Provider.of<FilterModel>(context, listen: false);
                    final riwayatProvider = Provider.of<RiwayatProvider>(context, listen: false);

                    filterModel.setFilter(true);
                    filterModel.setMonth(_selectedMonth);
                    filterModel.setYear(_selectedYear);
                    filterModel.setCount(_selectedCount);

                    riwayatProvider.filterChildrenByMonth(
                      _selectedMonth,
                      _selectedYear,
                      _selectedCount,
                    );

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9FC86A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text('Filter', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, int value,
      Function(int?) onChanged, List<int> items, {bool isMonth = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: value,
          onChanged: onChanged,
          dropdownColor: Colors.white,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF9FC86A), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          items: items.map<DropdownMenuItem<int>>((int item) {
            final displayText = isMonth ? _monthNames[item - 1] : item.toString();
            return DropdownMenuItem<int>(
              value: item,
              child: Text(
                displayText,
                style: GoogleFonts.poppins(color: Colors.black),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}