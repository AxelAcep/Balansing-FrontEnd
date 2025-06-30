import 'package:balansing/screens/AuthIbu/DaftarScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class LoginScreenIbu extends StatefulWidget {

  const LoginScreenIbu({super.key});

  @override
  State<LoginScreenIbu> createState() => _LoginScreenStateIbu();
}

class _LoginScreenStateIbu extends State<LoginScreenIbu> {
  bool _isPasswordVisible = false; // State untuk mengontrol visibilitas password
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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

                    // CONTAINER BESAR UNTUK SEMUA ELEMEN FORM
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
                          // Teks "Masuk"
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
                          // Teks "Dampingi Pertumbuhanya..."
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

                          // Label Email
                          Text(
                            "Email",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: height * 0.01),

                          // Input Email
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
                          ),

                          SizedBox(height: height * 0.02),

                          // Label Password dan Lupa Password?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Label Password
                              Text(
                                "Password",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: width * 0.035,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              // Lupa Password Button
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

                          // Input Password
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

                          // Button Masuk
                          SizedBox(
                            width: double.infinity,
                            height: height * 0.04,
                            child: ElevatedButton(
                              onPressed: () {
                                // --- Perubahan logika di sini ---
                                  print("Email: ${_usernameController.text}");
                                  print("Password: ${_passwordController.text}");
                                  print("0");
                                  print("Email: ${_usernameController.text}");
                                  print("Password: ${_passwordController.text}");
                                  print("1");
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF878b94), // Warna tombol tetap #878b94
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Text(
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

                          // Teks "Belum punya akun? Daftar"
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
                                    color: const Color(0xFF64748B), // Warna tetap #64748B
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
                )
        ),
      ),
    );
  }
}