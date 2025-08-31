import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String gender;
  final String age;
  final double width;
  final double height;

  const UserCard({
    super.key,
    required this.name,
    required this.gender,
    required this.age,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the correct image path based on gender
    final String imagePath = gender.toLowerCase() == 'laki-laki'
        ? 'assets/images/MaleIcon.png'
        : 'assets/images/FemaleIcon.png';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 16.0),
      width: width,
      height: height * 0.28,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: width * 0.18,
                height: width * 0.18,
              ),
              SizedBox(width: width * 0.04),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.035,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7F2D5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          gender,
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.025,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ),
                      SizedBox(width: width * 0.02),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7F2D5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          age,
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.025,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          SizedBox(height: height * 0.02),
          Text(
            "Hai Bunda!",
            style: GoogleFonts.poppins(
              fontSize: width * 0.05,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF76A73B),
            ),
          ),
          SizedBox(height: height * 0.005),
          Text(
            "Bunda sudah melakukan langkah penting untuk kesehatan $name. Ini dia hasilnya:",
            style: GoogleFonts.poppins(
              fontSize: width * 0.03,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
