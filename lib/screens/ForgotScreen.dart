import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import file auth_services.dart Anda
import 'package:balansing/services/auth_services.dart'; // Ganti dengan path yang benar

// Import halaman ConfirmEmailPassword Anda
import 'package:balansing/screens/ConfirmEmailPassword.dart'; 

class Forgotscreen extends StatefulWidget {
  const Forgotscreen({super.key});

  @override
  State<Forgotscreen> createState() => _ForgotscreenState();
}

class _ForgotscreenState extends State<Forgotscreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailValid = true;
  bool _isLoading = false;

  // Inisialisasi AuthService
  final AuthService _authService = AuthService(); // Buat instance AuthService

  void _validateEmail(String email) {
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    setState(() {
      _isEmailValid = emailValid;
    });
  }

  Future<void> _handleResetPassword() async {
    setState(() {
      _isLoading = true; // Set loading true saat memulai proses
    });

    try {
      // Panggil fungsi resetPassword dari AuthService
      await _authService.resetPassword(_emailController.text);

      // Jika berhasil (tidak melempar exception)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link reset password telah dikirim ke email Anda.'),
          backgroundColor: Colors.green,
        ),
      );

      // Tambahkan jeda waktu 2 detik
      await Future.delayed(const Duration(seconds: 2));

      // Navigasi ke halaman ConfirmEmailPassword()
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ConfirmEmailPassword(),
        ),
      );
    } on Exception catch (e) { // Tangkap Exception dari AuthService
      String errorMessage = e.toString().replaceFirst('Exception: ', ''); // Hapus 'Exception: '
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $errorMessage'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // Set loading false setelah proses selesai
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    bool emailInsert = _emailController.text.isNotEmpty;
    bool buttonEnabled = _isEmailValid && emailInsert && !_isLoading;
    final Color buttonColor =
        buttonEnabled ? const Color(0xFF9FC86A) : const Color(0xFF878b94);

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset(
                  "assets/images/Balansing-Logo.png",
                  height: height * 0.15,
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                height: height * 0.33,
                width: width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Lupa Password",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: height * 0.025,
                            fontWeight: FontWeight.w600,
                          )),
                      Text(
                          "Untuk Pahlawan Gizi yang sudah berjasa, Kami siap bantu Anda kembali beraksi",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF64748B),
                            fontSize: height * 0.013,
                            fontWeight: FontWeight.w400,
                          )),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Text(
                        "Email",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: width * 0.035,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (text) {
                          _validateEmail(text);
                        },
                        decoration: InputDecoration(
                          hintText: "Masukan email",
                          hintStyle: GoogleFonts.poppins(
                            color: const Color(0xFF64748B),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: _isEmailValid
                                  ? const Color(0xFFE2E8F0)
                                  : Colors.red,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: _isEmailValid
                                  ? const Color(0xFF0F172A)
                                  : Colors.red,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 10.0),
                        ),
                      ),
                      if (!_isEmailValid && _emailController.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                          child: Text(
                            "Format email tidak valid.",
                            style: GoogleFonts.poppins(
                              color: Colors.red,
                              fontSize: width * 0.028,
                            ),
                          ),
                        ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: height * 0.04,
                        child: ElevatedButton(
                          onPressed: buttonEnabled
                              ? _handleResetPassword // Panggil fungsi handler
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            minimumSize: Size(width * 0.9, height * 0.05),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                              : Text(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}