import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Helper for status data (can be defined globally or in a utilities file)
class ChildStatusData {
  final String title;
  final Color color;

  ChildStatusData(this.title, this.color);
}

class ChildCard extends StatefulWidget {
  final String name;
  final String age;
  final String gender;
  final String measurements;
  final String statusType; // e.g., 'Sehat', 'Anemia', 'Stunting', 'Keduanya'

  const ChildCard({
    super.key,
    required this.name,
    required this.age,
    required this.gender,
    required this.measurements,
    required this.statusType,
  });

  @override
  State<ChildCard> createState() => _ChildCardState();
}

class _ChildCardState extends State<ChildCard> {
  // 2. Defaultnya tertutup
  bool _showDetails = false;

  // Map to get the correct display data for the status type
  static final Map<String, ChildStatusData> _statusMap = {
    'Sehat': ChildStatusData('Sehat', const Color(0xFF9FC86A)),
    'Anemia': ChildStatusData('Anemia', const Color(0xFFFEF08A)), // Merah (FEF08A is yellow, check if you meant a red like F43F5E)
    'Stunting': ChildStatusData('Stunting', const Color(0xFFFACC15)), // Kuning
    'Keduanya': ChildStatusData('Keduanya', const Color(0xFFF43F5E)), // Biru (F43F5E is red, check if you meant a blue)
  };

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    // Get the status data based on the provided statusType
    final ChildStatusData? currentStatus = _statusMap[widget.statusType];

    return Container(
      width: width * 0.9,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0), // Added vertical margin for spacing
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Child Name
          Text(
            widget.name,
            style: GoogleFonts.poppins(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: height * 0.01),

          // Collapsible Information Section
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _showDetails
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Age
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: height * 0.018, color: const Color(0xFF64748B)),
                    SizedBox(width: width * 0.015),
                    Text(
                      widget.age,
                      style: GoogleFonts.poppins(
                        fontSize: height * 0.018,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.005),

                // Gender
                Row(
                  children: [
                    Icon(Icons.person,
                        size: height * 0.018, color: const Color(0xFF64748B)),
                    SizedBox(width: width * 0.015),
                    Text(
                      widget.gender,
                      style: GoogleFonts.poppins(
                        fontSize: height * 0.018,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.005),

                // Measurements
                Row(
                  children: [
                    Icon(Icons.monitor_weight,
                        size: height * 0.018, color: const Color(0xFF64748B)),
                    SizedBox(width: width * 0.015),
                    Text(
                      widget.measurements,
                      style: GoogleFonts.poppins(
                        fontSize: height * 0.018,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.015), // Spacing before the status box
              ],
            ),
            secondChild: Container(), // Empty container when details are hidden
          ),

          // Status Box (showing only one tag)
          if (currentStatus != null) // Only display if a valid status type is provided
            Container(
              width: width * 0.9, // This will match the card width
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.7), // Pastel/transparent color
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min, // Make row only as wide as its children
                children: [
                  Container(
                    width: width * 0.025,
                    height: width * 0.025,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentStatus.color,
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                  Text(
                    currentStatus.title,
                    style: GoogleFonts.poppins(
                      fontSize: height * 0.016,
                      fontWeight: FontWeight.w500, // Slightly bolder for the status text
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: height * 0.005),

          // Sembunyikan/Tampilkan Informasi Button
          GestureDetector(
            onTap: () {
              setState(() {
                _showDetails = !_showDetails;
              });
            },
            child: Align( // Align the button to the right
              alignment: Alignment.centerRight,
              child: Text(
                _showDetails ? "Sembunyikan Informasi" : "Tampilkan Informasi",
                style: GoogleFonts.poppins(
                  fontSize: height * 0.015,
                  fontWeight: FontWeight.w600,
                  color: _showDetails ? Colors.red : Colors.green, // Red for hide, Green for show
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}