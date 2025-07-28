import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KaderTambahII extends StatefulWidget {
  const KaderTambahII({super.key});

  @override
  State<KaderTambahII> createState() => _KaderTambahIIState();
}

class _KaderTambahIIState extends State<KaderTambahII> {
  // Corrected: Initialize TextEditingController properly
  final TextEditingController _namaIbuController = TextEditingController();
  final TextEditingController _namaAnakController = TextEditingController();
  final TextEditingController _tahunController = TextEditingController();
  final TextEditingController _bulanController = TextEditingController();
  final TextEditingController _bbController = TextEditingController(); // Controller for BB
  final TextEditingController _tbController = TextEditingController(); // Controller for TB

  DateTime? _selectedDate;
  String? _selectedGender; // State variable for selected gender

  // State variables for new selections
  String? _selectedKonjungtiva;
  String? _selectedKuku;
  String? _selectedLemas;
  String? _selectedPucat;
  String? _selectedRiwayatAnemia;


  @override
  void dispose() {
    _namaIbuController.dispose();
    _namaAnakController.dispose();
    _tahunController.dispose();
    _bulanController.dispose();
    _bbController.dispose(); // Dispose BB controller
    _tbController.dispose(); // Dispose TB controller
    super.dispose();
  }

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(), // Use selected date or current date
      firstDate: DateTime(2000), // Start date for the picker
      lastDate: DateTime(2101), // End date for the picker
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF64748B), // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Color(0xFF020617), // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF64748B), // Button text color
              ),
            ),
            // Style for the selected date text/hover (similar to "Tanggal" text)
            textTheme: TextTheme(
              titleLarge: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.035,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF64748B),
              ),
              bodyLarge: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.035,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF64748B),
              ),
              bodyMedium: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.035,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Helper widget for radio button rows
  Widget _buildRadioRow({
    required String title,
    required String question,
    required String value1,
    required String label1,
    required String value2,
    required String label2,
    required String? groupValue,
    required ValueChanged<String?> onChanged,
    required double width,
    required double height,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: width * 0.04,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: height * 0.01),
        Text(
          question,
          style: GoogleFonts.poppins(
            color: const Color(0xFF64748B),
            fontSize: width * 0.035,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: height * 0.015),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: InkWell(
                onTap: () => onChanged(value1),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: groupValue == value1 ? const Color(0xFFF4F9EC) : Colors.white,
                    border: Border.all(
                      color: groupValue == value1 ? const Color(0xFF9FC86A) : const Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      label1,
                      style: GoogleFonts.poppins(
                        color: groupValue == value1 ? const Color(0xFF9FC86A) : Colors.black,
                        fontSize: width * 0.035,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: width * 0.04),
            Expanded(
              child: InkWell(
                onTap: () => onChanged(value2),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: groupValue == value2 ? const Color(0xFFF4F9EC) : Colors.white,
                    border: Border.all(
                      color: groupValue == value2 ? const Color(0xFF9FC86A) : const Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      label2,
                      style: GoogleFonts.poppins(
                        color: groupValue == value2 ? const Color(0xFF9FC86A) : Colors.black,
                        fontSize: width * 0.035,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Back Button
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
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
                        // Text Langkah 1 dari 2
                        Text(
                          "Langkah 2 dari 2",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFA1A1AA),
                            fontSize: width * 0.03,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Text(
                    "Tambah Data",
                    style: GoogleFonts.poppins(fontSize: width * 0.06, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Data anak ke-1",
                    style: GoogleFonts.poppins(
                        fontSize: width * 0.035, fontWeight: FontWeight.w400, color: const Color(0xFF64748B)),
                  ),
                  SizedBox(height: height * 0.02),
                  Text("Gejala", style: GoogleFonts.poppins(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.w600
                  ),),
                  SizedBox(height: height * 0.02,),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Konjungtiva Section
                        _buildRadioRow(
                          title: "Konjungtiva",
                          question: "Kecil dan Abu-abu. Saat kelopak mata bawah anak ditarik perlahan, bagaimana warnanya?",
                          value1: "Merah Segar",
                          label1: "Merah Segar",
                          value2: "Pucat",
                          label2: "Pucat",
                          groupValue: _selectedKonjungtiva,
                          onChanged: (value) {
                            setState(() {
                              _selectedKonjungtiva = value;
                            });
                          },
                          width: width,
                          height: height,
                        ),
                        SizedBox(height: height * 0.02),

                        // Kuku Section
                        _buildRadioRow(
                          title: "Kuku",
                          question: "Apakah ada masalah yang terlihat? Sangat pucat, rapuh/mudah patah.",
                          value1: "Ya",
                          label1: "Ya, ada",
                          value2: "Tidak",
                          label2: "Tidak",
                          groupValue: _selectedKuku,
                          onChanged: (value) {
                            setState(() {
                              _selectedKuku = value;
                            });
                          },
                          width: width,
                          height: height,
                        ),
                        SizedBox(height: height * 0.02),

                        // Lemas Section
                        _buildRadioRow(
                          title: "Lemas",
                          question: "Anak terlihat Lemas?",
                          value1: "Ya",
                          label1: "Ya",
                          value2: "Tidak",
                          label2: "Tidak",
                          groupValue: _selectedLemas,
                          onChanged: (value) {
                            setState(() {
                              _selectedLemas = value;
                            });
                          },
                          width: width,
                          height: height,
                        ),
                        SizedBox(height: height * 0.02),

                        // Pucat Section
                        _buildRadioRow(
                          title: "Pucat",
                          question: "Anak terlihat pucat?",
                          value1: "Ya",
                          label1: "Ya",
                          value2: "Tidak",
                          label2: "Tidak",
                          groupValue: _selectedPucat,
                          onChanged: (value) {
                            setState(() {
                              _selectedPucat = value;
                            });
                          },
                          width: width,
                          height: height,
                        ),
                        SizedBox(height: height * 0.02),

                        // Riwayat Anemia Section
                        _buildRadioRow(
                          title: "Riwayat Anemia",
                          question: "Apakah anak memiliki riwayat anemia?",
                          value1: "Ya",
                          label1: "Ya",
                          value2: "Tidak",
                          label2: "Tidak",
                          groupValue: _selectedRiwayatAnemia,
                          onChanged: (value) {
                            setState(() {
                              _selectedRiwayatAnemia = value;
                            });
                          },
                          width: width,
                          height: height,
                        ),
                        SizedBox(height: height * 0.01), // Add a small space at the end
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height*0.02,), // Space above the buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Button 1: Simpan & keluar
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      print('Simpan & keluar pressed');
                      // You can access selected values here:
                      print('Konjungtiva: $_selectedKonjungtiva');
                      print('Kuku: $_selectedKuku');
                      print('Lemas: $_selectedLemas');
                      print('Pucat: $_selectedPucat');
                      print('Riwayat Anemia: $_selectedRiwayatAnemia');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF4F9EC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Color(0xFF9FC86A)),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    child: Text(
                      "Simpan & keluar",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF9FC86A),
                        fontSize: width * 0.035,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: width * 0.04),
                // Button 2: Selanjutnya
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      print('Selanjutnya pressed');
                      // You can access selected values here:
                      print('Konjungtiva: $_selectedKonjungtiva');
                      print('Kuku: $_selectedKuku');
                      print('Lemas: $_selectedLemas');
                      print('Pucat: $_selectedPucat');
                      print('Riwayat Anemia: $_selectedRiwayatAnemia');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9FC86A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      elevation: 0,
                    ),
                    child: Text(
                      "Selanjutnya",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: width * 0.035,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: height*0.01,), // Space above the buttons
          ],
        ),
      ),
    );
  }
}