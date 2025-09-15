import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GrowthIndicatorCard extends StatelessWidget {
  final String title;
  final String value;
  final String zScore;
  final String status;
  final String imagePath;
  final double width;
  final int count;

  const GrowthIndicatorCard({
    Key? key,
    required this.title,
    required this.value,
    required this.zScore,
    required this.status,
    required this.imagePath,
    required this.width,
    required this.count,
  }) : super(key: key);

  Color _getBarColor(double zScoreValue) {
    if (zScoreValue > -2) {
      return Color(0xFF9FC86A);
    } else if (zScoreValue <= -3) {
      return Color(0xFFDC2626);
    } else if (zScoreValue <= -2) {
      return Color(0xFFFACC15);
      }else{
      return Colors.grey;
    }
  }

  double _getFillPercentage(double zScoreValue) {
    if (zScoreValue >= 5) return 1.0;
    if (zScoreValue <= -5) return 0.0;
    
    // Normalize z-score from -3 to 3 to a 0-1 range
    return (zScoreValue + 5) / 10;
  }

  @override
  Widget build(BuildContext context) {
    double zScoreValue = double.tryParse(zScore) ?? 0.0;
    Color barColor = _getBarColor(zScoreValue);
    double fillPercentage = _getFillPercentage(zScoreValue);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: width * 0.04,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column( mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: width * 0.033,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: width * 0.01),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: width * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
                ],
              ),
              Image.asset(
                imagePath,
                width: width * 0.13,
                height: width * 0.13,
              ),
            ],
          ),
          SizedBox(height: width * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Z-Score',
                style: GoogleFonts.poppins(
                  fontSize: width * 0.035,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
              Text(
                '$zScore ($status)',
                style: GoogleFonts.poppins(
                  fontSize: width * 0.035,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          SizedBox(height: width * 0.01),
          // Z-Score Bar
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: width * 0.03,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: constraints.maxWidth * fillPercentage,
                    height: width * 0.03,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: width * 0.01),
          Text(
            'Data Anak',
            style: GoogleFonts.poppins(
              fontSize: width * 0.035,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}