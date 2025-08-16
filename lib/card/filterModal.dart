// FilterModal.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:balansing/providers/KaderProvider.dart'; 
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

class FilterModalContent extends StatefulWidget {
  @override
  _FilterModalContentState createState() => _FilterModalContentState();
}

class _FilterModalContentState extends State<FilterModalContent> {
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
                    final dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);

                    filterModel.setFilter(false);
                    filterModel.setMonth(DateTime.now().month);
                    filterModel.setYear(DateTime.now().year);
                    filterModel.setCount(1);

                    riwayatProvider.fetchChildrenData();
                    dashboardProvider.fetchDashboardData();

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
                    final dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);

                    filterModel.setFilter(true);
                    filterModel.setMonth(_selectedMonth);
                    filterModel.setYear(_selectedYear);
                    filterModel.setCount(_selectedCount);

                    riwayatProvider.filterChildrenByMonth(
                      _selectedMonth,
                      _selectedYear,
                      _selectedCount,
                    );
                    
                    dashboardProvider.filterDashboardData(filterModel);

                    

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