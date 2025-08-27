import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/screens/Ibu/Profile/ibu_edit_anak_screen.dart';
import 'package:provider/provider.dart';
import 'package:balansing/providers/IbuProvider.dart'; // Import RiwayatProvider
import 'package:balansing/models/filter_model.dart'; // Import FilterModel
import 'package:balansing/models/user_model.dart';

// Helper for status data (can be defined globally or in a utilities file)
class ChildStatusData {
  final String title;
  final Color color;

  ChildStatusData(this.title, this.color);
}

class ChildCard extends StatefulWidget {
  // Properti disesuaikan dengan JSON
  final String nama;
  final int usia; // Asumsi usia dalam bulan
  final double beratBadan;
  final double tinggiBadan;
  final bool anemia;
  final String stunting;
  final String jenisKelamin;
  final String? id; // Tambahkan id jika diperlukan

  const ChildCard({
    super.key,
    required this.nama,
    required this.usia,
    required this.beratBadan,
    required this.tinggiBadan,
    required this.anemia,
    required this.stunting,
    required this.jenisKelamin,
    required this.id,
  });

  @override
  State<ChildCard> createState() => _ChildCardState();
}

class _ChildCardState extends State<ChildCard> {
  bool _showDetails = false;
  final filterModel = FilterModel(); // Instance dari FilterModel

  static final Map<String, ChildStatusData> _statusMap = {
    'Sehat': ChildStatusData('Sehat', const Color(0xFF9FC86A)),
    'Anemia': ChildStatusData('Anemia', const Color(0xFFFEF08A)),
    'Stunting': ChildStatusData('Stunting', const Color(0xFFFACC15)),
    'Keduanya': ChildStatusData('Keduanya', const Color(0xFFF43F5E)),
  };

  // Fungsi untuk menentukan status berdasarkan anemia dan stunting
  String _getStatusType() {
    if (widget.anemia && (widget.stunting == "SangatPendek" || widget.stunting == "Pendek")) {
      return 'Keduanya';
    } else if (widget.anemia) {
      return 'Anemia';
    } else if (widget.stunting == "SangatPendek" || widget.stunting == "Pendek") {
      return 'Stunting';
    } else {
      return 'Sehat';
    }
  }

  // Fungsi untuk menggabungkan berat dan tinggi
  String _getMeasurements() {
    return '${widget.beratBadan}kg / ${widget.tinggiBadan}cm';
  }

  // Fungsi untuk mengonversi usia dari bulan ke format tahun dan bulan
  String _getFormattedAge() {
    int years = widget.usia ~/ 12;
    int months = widget.usia % 12;
    return '$years tahun $months bulan';
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final String statusType = _getStatusType();
    final ChildStatusData? currentStatus = _statusMap[statusType];

    return GestureDetector(
      onTap: () async {
        print(this.widget.id);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IbuEditAnakScreen(id: widget.id),
          ),
        );
        Provider.of<ProfileProvider>(context, listen: false).fetchDaftarAnak(User.instance.email);
      },
      child: Container(
              width: width * 0.9,
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.nama,
                    style: GoogleFonts.poppins(
                      fontSize: height * 0.025,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: height * 0.01),

                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    crossFadeState: _showDetails ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    firstChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(context, Icons.calendar_today, _getFormattedAge()),
                        _buildInfoRow(context, Icons.person, widget.jenisKelamin),
                        _buildInfoRow(context, Icons.monitor_weight, _getMeasurements()),
                        SizedBox(height: height * 0.015),
                      ],
                    ),
                    secondChild: Container(),
                  ),

                  if (currentStatus != null)
                    Container(
                      width: width * 0.9,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
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
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: height * 0.005),

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showDetails = !_showDetails;
                      });
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _showDetails ? "Sembunyikan Informasi" : "Tampilkan Informasi",
                        style: GoogleFonts.poppins(
                          fontSize: height * 0.015,
                          fontWeight: FontWeight.w600,
                          color: _showDetails ? Colors.red : Colors.green,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    ));
  }
  
  // Fungsi pembantu untuk membuat baris informasi
  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(icon, size: height * 0.018, color: const Color(0xFF64748B)),
          SizedBox(width: width * 0.015),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: height * 0.018,
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}