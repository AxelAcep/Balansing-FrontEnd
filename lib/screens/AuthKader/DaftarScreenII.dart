import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/screens/AuthKader/ConfirmDaftar.dart';
import 'package:balansing/models/kader_model.dart'; // Ensure this path is correct
import 'package:balansing/services/auth_services.dart'; // <-- IMPORT YOUR AUTH SERVICE HERE

class DaftarscreenII extends StatefulWidget {
  final String initialEmail;
  final String initialPassword;

  const DaftarscreenII({
    super.key,
    required this.initialEmail,
    required this.initialPassword,
  });

  @override
  State<DaftarscreenII> createState() => _DaftarScreenStateII();
}

class _DaftarScreenStateII extends State<DaftarscreenII> {
  final TextEditingController _puskesmasController = TextEditingController();
  final TextEditingController _posyanduController = TextEditingController(); // Added Posyandu Controller
  final TextEditingController _provinsiController = TextEditingController();
  final TextEditingController _kotaController = TextEditingController();
  final TextEditingController _kecamatanController = TextEditingController();
  final TextEditingController _kelurahanController = TextEditingController();
  final TextEditingController _rtController = TextEditingController();
  final TextEditingController _rwController = TextEditingController();

  final AuthService _authService = AuthService(); // <-- Instantiate your AuthService

  @override
  void initState() {
    super.initState();
    _puskesmasController.addListener(_updateButtonState);
    _posyanduController.addListener(_updateButtonState); // Add listener for posyandu
    _provinsiController.addListener(_updateButtonState);
    _kotaController.addListener(_updateButtonState);
    _kecamatanController.addListener(_updateButtonState);
    _kelurahanController.addListener(_updateButtonState);
    _rtController.addListener(_updateButtonState);
    _rwController.addListener(_updateButtonState);
    _updateButtonState();
  }

  @override
  void dispose() {
    _puskesmasController.dispose();
    _posyanduController.dispose(); // Dispose posyandu controller
    _provinsiController.dispose();
    _kotaController.dispose();
    _kecamatanController.dispose();
    _kelurahanController.dispose();
    _rtController.dispose();
    _rwController.dispose();
    super.dispose();
  }

  bool _buttonEnabled = false;

  void _updateButtonState() {
    setState(() {
      _buttonEnabled = _puskesmasController.text.isNotEmpty &&
          _provinsiController.text.isNotEmpty &&
          _kotaController.text.isNotEmpty &&
          _kecamatanController.text.isNotEmpty &&
          _kelurahanController.text.isNotEmpty &&
          _rtController.text.isNotEmpty &&
          _rwController.text.isNotEmpty &&
          _posyanduController.text.isNotEmpty; // Added posyandu to validation
    });
  }

  Future<void> _performRegistration() async {
    if (!_buttonEnabled) {
      return;
    }

    final Kader completeKaderData = Kader(
      email: widget.initialEmail,
      password: widget.initialPassword,
      namaPuskesmas: _puskesmasController.text,
      namaPosyandu: _posyanduController.text, // Pass posyandu text
      provinsi: _provinsiController.text,
      kota: _kotaController.text,
      kecamatan: _kecamatanController.text,
      kelurahan: _kelurahanController.text,
      rt: _rtController.text,
      rw: _rwController.text,
    );

    // Debugging: Print all data from the complete Kader object
    print("Complete Kader Data for Registration (from Kader model):");
    print("Email: ${completeKaderData.email}");
    // print("Password: ${completeKaderData.password}"); // Be cautious with logging sensitive data in production
    print("Nama Puskesmas: ${completeKaderData.namaPuskesmas}");
    print("Nama Posyandu: ${completeKaderData.namaPosyandu}"); // Print namaPosyandu
    print("Provinsi: ${completeKaderData.provinsi}");
    print("Kota: ${completeKaderData.kota}");
    print("Kecamatan: ${completeKaderData.kecamatan}");
    print("Kelurahan: ${completeKaderData.kelurahan}");
    print("RT: ${completeKaderData.rt}");
    print("RW: ${completeKaderData.rw}");

    // You can also print the JSON representation
    print("Kader JSON: ${completeKaderData.toJson()}");

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Mendaftarkan akun..."),
              ],
            ),
          );
        },
      );

      // --- Call your actual registration service here ---
      final String registrationMessage = await _authService.registerKader(completeKaderData);

      Navigator.pop(context); // Close loading dialog

      // If registration successful, show a success message and navigate to ConfirmDaftar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(registrationMessage),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Confirmdaftar()),
      );
    } catch (e) {
      Navigator.pop(context); // Close loading dialog on error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')), // Clean up "Exception: " prefix
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final Color buttonColor = _buttonEnabled ? const Color(0xFF9FC86A) : const Color(0xFF878b94);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: height * 0.07,
            left: width * 0.05,
            right: width * 0.07,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
          Positioned(
            top: height * 0.12,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: width * 0.9,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Daftar",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: width * 0.06,
                                fontWeight: FontWeight.w600,
                                height: 1.0,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Text(
                              "Hampir selesai. Tetap semangat bergabung menjadi Garda Terdepan.",
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF64748B),
                                fontSize: width * 0.030,
                                fontWeight: FontWeight.normal,
                                height: 1.25,
                                letterSpacing: 0.0,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: height * 0.025,
                          width: width * 1,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFFE2E8F0),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(maxHeight: height * 0.6, minHeight: height * 0.6),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: height * 0.015),
                                Text(
                                  "Nama puskesmas",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                TextField(
                                  controller: _puskesmasController,
                                  onChanged: (_) => _updateButtonState(),
                                  decoration: InputDecoration(
                                    hintText: "Masukan nama puskesmas",
                                    hintStyle: GoogleFonts.poppins(
                                      color: const Color(0xFF64748B),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                  ),
                                ),
                                SizedBox(height: height * 0.02),
                                // --- Input for Nama Posyandu ---
                                Text(
                                  "Nama Posyandu",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                TextField(
                                  controller: _posyanduController,
                                  onChanged: (_) => _updateButtonState(),
                                  decoration: InputDecoration(
                                    hintText: "Masukan nama Posyandu",
                                    hintStyle: GoogleFonts.poppins(
                                      color: const Color(0xFF64748B),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                  ),
                                ),
                                SizedBox(height: height * 0.02),
                                // --- End of Input for Nama Posyandu ---
                                Text(
                                  "Provinsi",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                TextField(
                                  controller: _provinsiController,
                                  onChanged: (_) => _updateButtonState(),
                                  decoration: InputDecoration(
                                    hintText: "Masukan nama Provinsi",
                                    hintStyle: GoogleFonts.poppins(
                                      color: const Color(0xFF64748B),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                  ),
                                ),
                                SizedBox(height: height * 0.02),
                                Text(
                                  "Kota",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                TextField(
                                  controller: _kotaController,
                                  onChanged: (_) => _updateButtonState(),
                                  decoration: InputDecoration(
                                    hintText: "Masukan nama kota",
                                    hintStyle: GoogleFonts.poppins(
                                      color: const Color(0xFF64748B),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                  ),
                                ),
                                SizedBox(height: height * 0.02),
                                Text(
                                  "Kecamatan",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                TextField(
                                  controller: _kecamatanController,
                                  onChanged: (_) => _updateButtonState(),
                                  decoration: InputDecoration(
                                    hintText: "Masukan nama kecamatan",
                                    hintStyle: GoogleFonts.poppins(
                                      color: const Color(0xFF64748B),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                  ),
                                ),
                                SizedBox(height: height * 0.02),
                                Text(
                                  "Kelurahan",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                TextField(
                                  controller: _kelurahanController,
                                  onChanged: (_) => _updateButtonState(),
                                  decoration: InputDecoration(
                                    hintText: "Masukan nama kelurahan",
                                    hintStyle: GoogleFonts.poppins(
                                      color: const Color(0xFF64748B),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                  ),
                                ),
                                SizedBox(height: height * 0.02),
                                Text(
                                  "RT",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                TextField(
                                  controller: _rtController,
                                  onChanged: (_) => _updateButtonState(),
                                  decoration: InputDecoration(
                                    hintText: "Masukan RT",
                                    hintStyle: GoogleFonts.poppins(
                                      color: const Color(0xFF64748B),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                  ),
                                ),
                                SizedBox(height: height * 0.02),
                                Text(
                                  "RW",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                TextField(
                                  controller: _rwController,
                                  onChanged: (_) => _updateButtonState(),
                                  decoration: InputDecoration(
                                    hintText: "Masukan RW",
                                    hintStyle: GoogleFonts.poppins(
                                      color: const Color(0xFF64748B),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                  ),
                                ),
                                SizedBox(height: height * 0.02),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                        SizedBox(
                          width: double.infinity,
                          height: height * 0.04,
                          child: ElevatedButton(
                            onPressed: _buttonEnabled ? _performRegistration : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                              minimumSize: Size(width * 0.9, height * 0.05),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(
                              "Lanjut",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: width * 0.03,
                                fontWeight: FontWeight.w500,
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
          ),
        ],
      ),
    );
  }
}