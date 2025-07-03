import 'package:balansing/screens/AuthKader/DaftarScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/services/auth_services.dart';

// Import halaman dashboard Kader
import 'package:balansing/screens/Kader/kader_dahboard_screen.dart';
// Tidak perlu lagi import IbuDashboardScreen di sini, karena ini khusus login Kader.

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isLoading = false;
  String? _errorMessage;

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Email dan password tidak boleh kosong.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final String message = await _authService.loginKader(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      print('DEBUG: Login Kader berhasil: $message');

      if (mounted) {
        // Karena ini adalah Login Kader, navigasi langsung ke KaderDashboardScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const KaderDashboardScreen()), // <--- Navigasi langsung ke Kader Dashboard
        );
      }

    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
        print('DEBUG: Login Kader gagal: $_errorMessage');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    bool emailInsert = _emailController.text.isNotEmpty;
    bool passwordInsert = _passwordController.text.isNotEmpty;  

     bool buttonEnabled = emailInsert && passwordInsert;

    final Color buttonColor = buttonEnabled ? const Color(0xFF9FC86A) : const Color(0xFF878b94);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Balansing-Logo.png',
                height: height * 0.1,
                fit: BoxFit.contain,
              ),
              SizedBox(height: height * 0.025),

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
                    Text(
                      "Masuk",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: width * 0.06,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      "Dampingi Pertumbuhanya, Pastikan Masa Depanya",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF64748B),
                        fontSize: width * 0.030,
                        fontWeight: FontWeight.normal,
                        height: 1.25,
                        letterSpacing: 0.0,
                      ),
                    ),

                    SizedBox(height: height * 0.025),

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
                      decoration: InputDecoration(
                        hintText: "Input Email",
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
                          borderSide: const BorderSide(color: Color(0xFF0F172A)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                      ),
                    ),

                    SizedBox(height: height * 0.02),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Password",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            print("Lupa Password ditekan!");
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            "Lupa Password?",
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF64748B),
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: height * 0.01),

                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: "Input password",
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
                          borderSide: const BorderSide(color: Color(0xFF0F172A)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: const Color(0xFF64748B),
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.025),

                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          _errorMessage!,
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    SizedBox(
                      width: double.infinity,
                      height: height * 0.04,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text(
                                "Masuk",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: width * 0.03,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),

                    SizedBox(height: height * 0.02),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Belum punya akun? ",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF64748B),
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("Daftar ditekan!");
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Daftarscreen()),
                            );
                          },
                          child: Text(
                            "Daftar",
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF9FC86A),
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}