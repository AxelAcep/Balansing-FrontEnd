import 'package:flutter/material.dart';

class BabyInfoCard extends StatelessWidget {
  final String name;
  final String lastCheckUp;
  final String weight;
  final String height;
  final String age;
  final String gender;

  const BabyInfoCard({
    Key? key,
    required this.name,
    required this.lastCheckUp,
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Determine the image path based on gender
    final String imagePath = gender.toLowerCase() == 'laki-laki'
        ? 'assets/images/MaleIcon.png'
        : 'assets/images/FemaleIcon.png';

    return Container(
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
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Section: Baby icon
              Container(
                width: screenWidth * 0.2, // Responsive width
                height: screenWidth * 0.2, // Responsive height
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F1E5), // Lighter greenish background
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Image.asset(
                    imagePath,
                    width: screenWidth * 0.2, // Responsive image size
                    height: screenWidth * 0.2,
                  ),
                ),
              ),

              SizedBox(width: screenWidth * 0.04), // Responsive spacing

              // Right Section: Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Last Check-up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02,
                            vertical: screenWidth * 0.01,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: screenWidth * 0.035,
                                color: const Color(0xFF5A665A),
                              ),
                              Text(
                                'Pemeriksaan terakhir: $lastCheckUp',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.025,
                                  color: const Color(0xFF5A665A),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenWidth * 0.01),

                    // Baby Name
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1B1B1B),
                      ),
                    ),

                    SizedBox(height: screenWidth * 0.01),

                    // Bottom Row: Weight, Height, Age
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoColumn(context, 'Berat badan', weight),
                        _buildInfoColumn(context, 'Tinggi badan', height),
                        _buildInfoColumn(context, 'Umur', age),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )));
  }

  Widget _buildInfoColumn(BuildContext context, String label, String value) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.025,
            color: Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: screenWidth * 0.01),
        Text(
          value,
          style: TextStyle(
            fontSize: screenWidth * 0.025,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B1B1B),
          ),
        ),
      ],
    );
  }
}