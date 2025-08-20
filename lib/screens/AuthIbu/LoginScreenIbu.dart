import 'package:balansing/screens/AuthIbu/DaftarScreen.dart';
import 'package:flutter/material.dart';
import 'package:balansing/screens/ForgotScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/services/auth_services.dart';
import 'package:balansing/screens/Ibu/ibu_dashboard_screen.dart';

class LoginScreenIbu extends StatefulWidget {
  const LoginScreenIbu({super.key});

  @override
  State<LoginScreenIbu> createState() => _LoginScreenStateIbu();
}

class _LoginScreenStateIbu extends State<LoginScreenIbu> {
  bool _isPasswordVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
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
      final String message = await _authService.loginIbu(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      print('DEBUG: Login Kader berhasil: $message');

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const IbuDashboardScreen()),
          (Route<dynamic> route) => false,
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

    bool emailInsert = _usernameController.text.isNotEmpty;
    bool passwordInsert = _passwordController.text.isNotEmpty;
    bool buttonEnabled = emailInsert && passwordInsert && !_isLoading;

    final Color buttonColor = buttonEnabled ? const Color(0xFF9FC86A) : const Color(0xFF878b94);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.15),
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
                      "Dampingi Pertumbuhannya, Pastikan Masa Depannya",
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
                      controller: _usernameController,
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
                      onChanged: (text) => setState(() {}),
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
                          onPressed: _isLoading ? null : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Forgotscreen()),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            "Lupa Password?",
                            style: GoogleFonts.poppins(
                              color: _isLoading ? const Color(0xFF878b94) : const Color(0xFF64748B),
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
                      onChanged: (text) => setState(() {}),
                    ),
                    
                    // Displaying Error Message
                    if (_errorMessage != null)
                      Padding(
                        padding: EdgeInsets.only(top: height * 0.015),
                        child: Text(
                          _errorMessage!,
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: width * 0.035,
                          ),
                        ),
                      ),

                    SizedBox(height: height * 0.025),
                    SizedBox(
                      width: double.infinity,
                      height: height * 0.04,
                      child: ElevatedButton(
                        onPressed: buttonEnabled ? _handleLogin : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
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
                          onTap: _isLoading ? null : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Daftarscreen()),
                            );
                          },
                          child: Text(
                            "Daftar",
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF64748B),
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