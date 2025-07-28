import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/card/RiwayatCard.dart'; // Import the ChildCard widget

// Import the ChildCard (assuming you put it in a separate file like 'widgets/child_card.dart')
// import 'package:balansing/widgets/child_card.dart'; // Adjust path as needed

// If ChildCard and ChildStatusData are in the same file as RiwayatScreen for now, no import needed.
// Otherwise, define ChildStatusData if not already global.
class ChildStatusData {
  final String title;
  final Color color;

  ChildStatusData(this.title, this.color);
}

// Your ChildCard definition (copy/paste the updated one from above here if not in a separate file)
// ... (ChildCard and _ChildCardState code as provided above) ...


class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Dummy list of child data to demonstrate multiple cards
  // Now includes full details for each child
  final List<Map<String, String>> _dummyChildren = [
    {
      'name': 'Alexander Graham',
      'age': '1 tahun 3 bulan',
      'gender': 'Laki-laki',
      'measurements': '10kg / 75cm',
      'status': 'Stunting', // This will be the only tag shown
    },
    {
      'name': 'Budi Santoso',
      'age': '2 tahun 0 bulan',
      'gender': 'Laki-laki',
      'measurements': '12kg / 85cm',
      'status': 'Sehat',
    },
    {
      'name': 'Citra Dewi',
      'age': '0 tahun 6 bulan',
      'gender': 'Perempuan',
      'measurements': '6kg / 60cm',
      'status': 'Anemia',
    },
    {
      'name': 'Dewi Lestari',
      'age': '1 tahun 9 bulan',
      'gender': 'Perempuan',
      'measurements': '9.5kg / 70cm',
      'status': 'Keduanya',
    },
    {
      'name': 'Eko Prasetyo',
      'age': '2 tahun 6 bulan',
      'gender': 'Laki-laki',
      'measurements': '14kg / 90cm',
      'status': 'Sehat',
    },
  ];


  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    debugPrint('Real-time Search Query: ${_searchController.text}');
    // Implement actual filtering here if needed
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

              // Header row
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
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.025,
                        vertical: height * 0.013,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.filter_list,
                            color: const Color(0xFF64748B),
                            size: height * 0.015,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Filter',
                            style: TextStyle(
                              color: const Color(0xFF64748B),
                              fontWeight: FontWeight.w600,
                              fontSize: height * 0.012,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: height * 0.01),

              _buildInfoRow(width, height, "RT/RW", "04/01"),
              SizedBox(height: height * 0.01),

              _buildInfoRow(width, height, "Tanggal Input", "27 Juli 2025"),
              SizedBox(height: height * 0.01),

              _buildInfoRow(width, height, "Jumlah Anak", "3"),
              SizedBox(height: height * 0.01),

              // Search bar
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

              SizedBox(height: height * 0.015),

              // Scrollable container with max height for child cards
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: height * 0.63,
                ),
                child: Container(
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05), // Lighter background for the list area
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Scrollbar(
                    thumbVisibility: false,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _dummyChildren.length, // Use the new dummy data
                      itemBuilder: (context, index) {
                        final childData = _dummyChildren[index];
                        return ChildCard(
                          name: childData['name']!,
                          age: childData['age']!,
                          gender: childData['gender']!,
                          measurements: childData['measurements']!,
                          statusType: childData['status']!, // Pass the status type
                        );
                      },
                    ),
                  ),
                ),
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