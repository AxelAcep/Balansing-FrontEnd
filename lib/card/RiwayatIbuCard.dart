import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Enum untuk status stunting
enum StuntingStatus {
  normal,
  tall,
  short,
  veryShort,
}

// Kelas data untuk anak
class ChildData {
  final String name;
  final String age;
  final String gender;
  final double weight;
  final double height;
  final StuntingStatus stuntingStatus;
  final bool hasAnemia;
  final int childNumber;

  ChildData({
    required this.name,
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
    required this.stuntingStatus,
    required this.hasAnemia,
    required this.childNumber,
  });

  bool get isStunting {
    return stuntingStatus == StuntingStatus.short ||
        stuntingStatus == StuntingStatus.veryShort;
  }
}

// Widget card untuk menampilkan data anak
class ChildCard extends StatefulWidget {
  final ChildData child;

  const ChildCard({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<ChildCard> createState() => _ChildCardState();
}

class _ChildCardState extends State<ChildCard> {
  bool _isExpanded = false;

  Color get _statusColor {
    if (widget.child.isStunting && widget.child.hasAnemia) {
      return const Color(0xFFF96262); // Merah
    } else if (widget.child.isStunting || widget.child.hasAnemia) {
      return const Color(0xFFE9B958); // Kuning Pastel
    } else {
      return const Color(0xFF67B056); // Hijau
    }
  }

  String get _statusText {
    if (widget.child.isStunting && widget.child.hasAnemia) {
      return 'Stunting & Anemia';
    } else if (widget.child.isStunting) {
      return 'Stunting';
    } else if (widget.child.hasAnemia) {
      return 'Anemia';
    } else {
      return 'Sehat';
    }
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03, vertical: height * 0.015),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Anak ${widget.child.childNumber == 1 ? 'Pertama' : 'Kedua'}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.03, vertical: height * 0.005),
                    decoration: BoxDecoration(
                      color: _statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: width * 0.02),
                        Text(
                          _statusText,
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03, vertical: height * 0.015),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.child.name,
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    crossFadeState: _isExpanded
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_month,
                                size: width * 0.04, color: Colors.grey),
                            SizedBox(width: width * 0.02),
                            Text(widget.child.age, style: GoogleFonts.poppins()),
                          ],
                        ),
                        SizedBox(height: height * 0.005),
                        Row(
                          children: [
                            Icon(Icons.person_outline,
                                size: width * 0.04, color: Colors.grey),
                            SizedBox(width: width * 0.02),
                            Text(widget.child.gender, style: GoogleFonts.poppins()),
                          ],
                        ),
                        SizedBox(height: height * 0.005),
                        Row(
                          children: [
                            Icon(Icons.balance,
                                size: width * 0.04, color: Colors.grey),
                            SizedBox(width: width * 0.02),
                            Text(
                              '${widget.child.weight} kg/${widget.child.height} cm',
                              style: GoogleFonts.poppins(),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        Container(
                          height: height * 0.045,
                          width: width * 0.25,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F9EC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF76A73B)),
                          ),
                          child: TextButton(
                            onPressed: () {
                              print('Button "Lihat Hasil" pressed!');
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Lihat Hasil',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF76A73B),
                                fontSize: width * 0.032,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    secondChild: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03, vertical: height * 0.005),
                        decoration: BoxDecoration(
                          color: _statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: width * 0.02),
                            Text(
                              _statusText,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Center(
                    child: InkWell(
                      onTap: _toggleExpansion,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _isExpanded ? 'Sembunyikan informasi ^' : 'Tampilkan informasi v',
                          style: GoogleFonts.poppins(
                            color: _isExpanded
                                ? const Color(0xFFF96262)
                                : const Color(0xFF67B056),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}