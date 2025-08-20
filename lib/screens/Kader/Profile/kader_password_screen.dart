import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/services/kader_services.dart';
import 'package:balansing/models/user_model.dart';
import 'package:balansing/screens/ForgotScreen.dart';

class KaderPasswordScreen extends StatefulWidget {
  const KaderPasswordScreen({super.key});

  @override
  State<KaderPasswordScreen> createState() => _KaderPasswordScreenState();
}

class _KaderPasswordScreenState extends State<KaderPasswordScreen> {
  final TextEditingController _passLamaController = TextEditingController();
  final TextEditingController _passBaruController = TextEditingController();
  final TextEditingController _konfirmasiPassBaruController =
      TextEditingController();

  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _passLamaController.addListener(_checkIfButtonShouldBeEnabled);
    _passBaruController.addListener(_checkIfButtonShouldBeEnabled);
    _konfirmasiPassBaruController.addListener(_checkIfButtonShouldBeEnabled);
  }

  @override
  void dispose() {
    _passLamaController.dispose();
    _passBaruController.dispose();
    _konfirmasiPassBaruController.dispose();
    super.dispose();
  }

  void _checkIfButtonShouldBeEnabled() {
    setState(() {
      _isButtonEnabled = _passLamaController.text.isNotEmpty &&
          _passBaruController.text.isNotEmpty &&
          _konfirmasiPassBaruController.text.isNotEmpty && _passBaruController.text == _konfirmasiPassBaruController.text;
    });
  }

  void _handleLupaPassword() {
    print("Lupa Password? (Forgot Password?) button pressed!");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Forgotscreen(), // Replace with actual forgot password screen
      ),
    );
  }

  void _handleSimpanPerubahan() {
    print("Simpan Perubahan (Save Changes) button pressed!");
    _ubahPassword(); // Call the function to change password
  }

  Future<void> _ubahPassword() async {
    try {
      final response = await KaderServices().ubahPassword(
        User.instance.email,
        _passLamaController.text,
        _passBaruController.text,
      );

      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password berhasil diubah!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengubah password: ${response['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // --- Bagian atas yang dapat digulir (ListView) ---
            Expanded(
              child: ListView(
                children: [
                  Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Back Button
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
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Text("Ubah Password",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF020617),
                        fontSize: width * 0.055,
                        fontWeight: FontWeight.w600,
                      )),
                  SizedBox(height: height * 0.003),
                  Text("Password harus terdiri dari minimal 8 karakter",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF6B7280),
                        fontSize: width * 0.03,
                        fontWeight: FontWeight.w400,
                      )),
                  SizedBox(height: height * 0.02),
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      minHeight: height * 0.65,
                    ),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Input for Password Saat Ini
                        Text(
                          "Password Saat Ini",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        TextField(
                          controller: _passLamaController,
                          obscureText: true, // Hide password
                          decoration: InputDecoration(
                            hintText: "Masukan Password Saat Ini",
                            hintStyle: GoogleFonts.poppins(
                              color: const Color(0xFF64748B),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  const BorderSide(color: Color(0xFF9FC86A), width: 2.0),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        // Input for Password Baru
                        Text(
                          "Password Baru",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        TextField(
                          controller: _passBaruController,
                          obscureText: true, // Hide password
                          decoration: InputDecoration(
                            hintText: "Masukan Password Baru",
                            hintStyle: GoogleFonts.poppins(
                              color: const Color(0xFF64748B),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  const BorderSide(color: Color(0xFF9FC86A), width: 2.0),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        // Input for Konfirmasi Password Baru
                        Text(
                          "Konfirmasi Password Baru",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        TextField(
                          controller: _konfirmasiPassBaruController,
                          obscureText: true, // Hide password
                          decoration: InputDecoration(
                            hintText: "Konfirmasi Password Baru",
                            hintStyle: GoogleFonts.poppins(
                              color: const Color(0xFF64748B),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  const BorderSide(color: Color(0xFF9FC86A), width: 2.0),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        // Lupa Password? text button
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: _handleLupaPassword,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              "Lupa Password?",
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF64748B),
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
            // Simpan Perubahan button
            SizedBox(height: height * 0.02),
            ElevatedButton(
              onPressed: _isButtonEnabled ? _handleSimpanPerubahan : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9FC86A),
                foregroundColor: Colors.white,
                minimumSize: Size(width * 0.87, height * 0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: GoogleFonts.poppins(
                  fontSize: height * 0.017,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text("Simpan Perubahan"),
            ),
            SizedBox(height: height * 0.06), // Add some spacing at the bottom
          ],
        ),
      ),
    );
  }
}