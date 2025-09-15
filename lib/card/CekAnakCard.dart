import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String birthDate;
  final String age;
  final String gender;
  final bool isSelected;
  final bool checkable;

  const ProfileCard({
    Key? key,
    required this.name,
    required this.birthDate,
    required this.age,
    required this.gender,
    this.isSelected = false,
    this.checkable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final double imageSize = screenWidth * 0.23;
    final double horizontalSpacing = screenWidth * 0.04;
    final double iconSize = screenWidth * 0.04;
    final double titleFontSize = screenWidth * 0.045;
    final double subTextFontSize = screenWidth * 0.035;

    final String imageAsset = gender.toLowerCase() == 'laki-laki'
        ? "assets/images/MaleIcon.png"
        : "assets/images/FemaleIcon.png";

    // Menentukan warna background berdasarkan status 'checkable'
    final Color cardColor = checkable
        ? (isSelected ? const Color(0xFFE7F2D5) : Colors.white)
        : Colors.grey.shade200;

    return Container(
      width: screenWidth * 0.9,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F7F0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Image.asset(imageAsset),
            ),
          ),
          SizedBox(width: horizontalSpacing),
          // Wrap the Column with Expanded to give it flexible space
          Expanded( // <-- Perubahan di sini
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis, // <-- Perubahan di sini
                  maxLines: 1, // <-- Pastikan hanya satu baris
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.cake, size: iconSize, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded( // <-- Perubahan di sini
                      child: Text(
                        birthDate,
                        style: TextStyle(fontSize: subTextFontSize, color: Colors.grey),
                        overflow: TextOverflow.ellipsis, // <-- Perubahan di sini
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: iconSize, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded( // <-- Perubahan di sini
                      child: Text(
                        age,
                        style: TextStyle(fontSize: subTextFontSize, color: Colors.grey),
                        overflow: TextOverflow.ellipsis, // <-- Perubahan di sini
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.male, size: iconSize, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded( // <-- Perubahan di sini
                      child: Text(
                        gender,
                        style: TextStyle(fontSize: subTextFontSize, color: Colors.grey),
                        overflow: TextOverflow.ellipsis, // <-- Perubahan di sini
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}