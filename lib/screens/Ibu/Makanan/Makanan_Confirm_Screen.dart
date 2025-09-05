import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/screens/Ibu/Makanan/Makanan_Recomendation_Screen.dart';

class MakananConfirmScreen extends StatefulWidget {
  final List<dynamic> detectedLabels;

  const MakananConfirmScreen({super.key, required this.detectedLabels});

  @override
  State<MakananConfirmScreen> createState() => _MakananConfirmScreenState();
}

class _MakananConfirmScreenState extends State<MakananConfirmScreen> {
  // A map to hold the Indonesian display names for each label.
  final Map<String, String> _labelNames = {
    "makanan_berpati": "Makanan berpati",
    "daging": "Daging",
    "telur": "Telur",
    "produk_susu": "Produk susu",
    "kacang_legume": "Kacang legume",
    "buah_sayur_vitA": "Sayur dan buah vitamin A",
    "buah_sayur_lainnya": "Sayur dan buah lainnya",
  };

  // State variables to manage the two lists of food items.
  late List<String> _foundItems;
  late List<String> _otherItems;

  @override
  void initState() {
    super.initState();
    // Initialize _foundItems with the labels from the detectedLabels list.
    _foundItems = List<String>.from(widget.detectedLabels);
    // Initialize _otherItems by finding which of all possible labels are not in the detectedLabels list.
    _otherItems = _labelNames.keys
        .where((label) => !_foundItems.contains(label))
        .toList();
  }

  // This function handles moving an item from the "Other" list to the "Found" list.
  void _addItem(String item) {
    setState(() {
      _otherItems.remove(item);
      _foundItems.add(item);
    });
  }

  // This function handles removing an item from the "Found" list and moving it to the "Other" list.
  void _removeItem(String item) {
    setState(() {
      _foundItems.remove(item);
      _otherItems.add(item);
    });
  }

  // A reusable widget for displaying a single food item with a checkbox.
  Widget _buildItemCheckbox({
    required String label,
    required bool isChecked,
    required Function(bool?) onChanged,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(bottom: height*0.015),
      decoration: BoxDecoration(
        color: isChecked ? Color(0xFFF1F5F9) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isChecked ? const Color(0xFF9FC86A) : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: CheckboxListTile(
        title: Text(
          _labelNames[label]!, // Use the mapped Indonesian name.
          style: GoogleFonts.poppins(
            color: const Color(0xFF475569),
            fontSize: width*0.04,
            fontWeight: FontWeight.w400,
          ),
        ),
        value: isChecked,
        onChanged: onChanged,
        activeColor: const Color(0xFF9FC86A),
        checkColor: Colors.white,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        dense: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.02),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.centerLeft,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: height * 0.035,
                      height: height * 0.035,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1.0,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF020617),
                        size: 20.0,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      "Kembali",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF020617),
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),
              Text(
                "Konfirmasi Makanan",
                style: GoogleFonts.poppins(
                  fontSize: width * 0.07,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Pastikan informasi yang diberikan benar ya Bunda",
                style: GoogleFonts.poppins(
                  color: const Color(0xFF64748B),
                  fontSize: width * 0.03,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: height * 0.02),
              const Divider(
                color: Color(0xFFD1D5DB),
                height: 0,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ),
              SizedBox(height: height * 0.02),
              Text(
                "Ditemukan di Piring",
                style: GoogleFonts.poppins(
                  fontSize: width * 0.035,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: height * 0.02),
              // Display the "Found" items list.
              Column(
                children: _foundItems.map((item) {
                  return _buildItemCheckbox(
                    label: item,
                    isChecked: true,
                    onChanged: (value) {
                      if (value == false) {
                        _removeItem(item);
                      }
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: height * 0.02),
              const Divider(
                color: Color(0xFFD1D5DB),
                height: 0,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ),
              SizedBox(height: height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tambahkan Kategori Lain",
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.035,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    child: Text(
                      "Cari disini",
                      style: GoogleFonts.poppins(
                        fontSize: width * 0.035,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF9FC86A),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: () {
                      print("Test Boy");
                    },
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              // Display the "Other" items list.
              Column(
                children: _otherItems.map((item) {
                  return _buildItemCheckbox(
                    label: item,
                    isChecked: false,
                    onChanged: (value) {
                      if (value == true) {
                        _addItem(item);
                      }
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: height * 0.01),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle the "Selanjutnya" (Next) button press.
                    // The final list of selected items is in _foundItems.
                    print("Final selected items: $_foundItems");
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MakananRecomendationScreen(DDS: _foundItems,)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9FC86A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Selanjutnya",
                    style: GoogleFonts.poppins(
                      fontSize: width*0.04,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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
}