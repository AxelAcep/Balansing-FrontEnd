import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Pastikan jalur impor ini benar di proyek Anda
// Jika digunakan
// Jika digunakan untuk navigasi kembali
import 'package:balansing/screens/AuthKader/DaftarScreenII.dart';

class Daftarscreen extends StatefulWidget {
  const Daftarscreen({super.key});

  @override
  State<Daftarscreen> createState() => _DaftarScreenState();
}

class _DaftarScreenState extends State<Daftarscreen> {
  // States untuk visibilitas password dan controllers untuk input teks
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false; // State baru untuk visibilitas konfirmasi password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController(); // Menggunakan nama yang lebih jelas
  bool _isChecked = false; // State untuk checkbox

  // States baru untuk validasi
  bool _isEmailValid = true;
  bool _isPasswordLengthValid = true;

  @override
  void dispose() {
    // Pastikan untuk membuang controller saat widget dihapus
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose(); // Pastikan controller baru juga dibuang
    super.dispose();
  }

  // Fungsi untuk memvalidasi format email
  void _validateEmail(String email) {
    // Regex untuk validasi email dasar
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    setState(() {
      _isEmailValid = emailValid;
    });
  }

  // Fungsi untuk memvalidasi panjang password
  void _validatePasswordLength(String password) {
    setState(() {
      _isPasswordLengthValid = password.length >= 8;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    bool emailInsert = _emailController.text.isNotEmpty;
    bool passwordInsert = _passwordController.text.isNotEmpty;
    bool confirmPasswordInsert = _confirmPasswordController.text.isNotEmpty; // Menggunakan controller yang benar

    bool passwordsMatch = _passwordController.text == _confirmPasswordController.text;

    // Menambahkan validasi email dan panjang password ke kondisi buttonEnabled
    bool buttonEnabled = emailInsert &&
        passwordInsert &&
        confirmPasswordInsert &&
        passwordsMatch &&
        _isChecked &&
        _isEmailValid &&
        _isPasswordLengthValid;

    final Color buttonColor = buttonEnabled ? const Color(0xFF9FC86A) : const Color(0xFF878b94);

    return Scaffold(
      backgroundColor: Colors.white, // Background screen putih
      body: Stack(
        // Gunakan Stack untuk menempatkan tombol kembali di atas konten scrollable
        children: [
          // Row untuk tombol Kembali dan teks Langkah 1 dari 2
          Positioned(
            top: height * 0.07, // Sesuaikan jarak dari atas
            left: width * 0.05, // Sesuaikan jarak dari kiri
            right: width * 0.07, // Sesuaikan jarak dari kanan untuk lebar 0.9
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Sejajarkan ke kiri dan kanan
              crossAxisAlignment: CrossAxisAlignment.center, // Pusatkan secara vertikal
              children: [
                // Tombol Kembali
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Fungsi kembali
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
                          size: 20.0, // Ukuran ikon
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
                // Teks Langkah 1 dari 2
                Text(
                  "Langkah 1 dari 2",
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFA1A1AA),
                    fontSize: width * 0.03, // Sesuaikan ukuran font jika perlu
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Konten utama yang bisa di-scroll
          Positioned(
            top: height * 0.12, // Sesuaikan posisi awal konten utama di bawah header baru
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                        // Container untuk teks "Daftar" dan "Satu Langkah Anda..."
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
                              "Satu Langkah Anda, Sejuta Terima Kasih.",
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

                        // Container untuk semua input fields (dengan scrollability)
                        Container(
                          constraints: BoxConstraints(maxHeight: height * 0.6, minHeight: height * 0.6),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: height * 0.015),
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
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (text) {
                                    _validateEmail(text); // Panggil validasi saat teks berubah
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Masukan email",
                                    hintStyle: GoogleFonts.poppins(
                                      color: const Color(0xFF64748B),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                        color: _isEmailValid ? const Color(0xFFE2E8F0) : Colors.red, // Warna border berdasarkan validasi
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                        color: _isEmailValid ? const Color(0xFF0F172A) : Colors.red, // Warna border berdasarkan validasi
                                      ),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                  ),
                                ),
                                // Pesan error email
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

                                SizedBox(height: height * 0.02),

                                // Label Password
                                Text(
                                  "Password",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                // Input Password
                                TextField(
                                  controller: _passwordController,
                                  obscureText: !_isPasswordVisible,
                                  onChanged: (text) {
                                    _validatePasswordLength(text); // Panggil validasi saat teks berubah
                                    setState(() {
                                      // Perbarui state untuk memastikan buttonEnabled dihitung ulang
                                      // dan teks konfirmasi password berubah warna jika tidak cocok
                                    });
                                  },
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
                                      borderSide: BorderSide(
                                        color: _isPasswordLengthValid ? const Color(0xFFE2E8F0) : Colors.red, // Warna border berdasarkan validasi
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                        color: _isPasswordLengthValid ? const Color(0xFF0F172A) : Colors.red, // Warna border berdasarkan validasi
                                      ),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
                                // Pesan error panjang password
                                if (!_isPasswordLengthValid && _passwordController.text.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                                    child: Text(
                                      "Password minimal 8 karakter.",
                                      style: GoogleFonts.poppins(
                                        color: Colors.red,
                                        fontSize: width * 0.028,
                                      ),
                                    ),
                                  ),

                                SizedBox(height: height * 0.02),
                                Text(
                                  "Konfirmasi Password",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                // Input Konfirmasi Password
                                TextField(
                                  controller: _confirmPasswordController, // Menggunakan controller yang benar
                                  obscureText: !_isConfirmPasswordVisible, // Menggunakan state visibilitas yang berbeda
                                  onChanged: (text) {
                                    setState(() {
                                      // Perbarui state untuk memastikan buttonEnabled dihitung ulang
                                      // dan teks konfirmasi password berubah warna jika tidak cocok
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Ketik ulang password",
                                    hintStyle: GoogleFonts.poppins(
                                      color: const Color(0xFF64748B),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                        color: passwordsMatch || _confirmPasswordController.text.isEmpty
                                            ? const Color(0xFFE2E8F0)
                                            : Colors.red, // Warna border berdasarkan kecocokan password
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                        color: passwordsMatch || _confirmPasswordController.text.isEmpty
                                            ? const Color(0xFF0F172A)
                                            : Colors.red, // Warna border berdasarkan kecocokan password
                                      ),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                        color: const Color(0xFF64748B),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                // Pesan error kecocokan password
                                if (!passwordsMatch && _confirmPasswordController.text.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                                    child: Text(
                                      "Password tidak cocok.",
                                      style: GoogleFonts.poppins(
                                        color: Colors.red,
                                        fontSize: width * 0.028,
                                      ),
                                    ),
                                  ),
                                SizedBox(height: height * 0.03),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start, // Penting untuk perataan atas
                                  children: [
                                    // Menggunakan Checkbox biasa
                                    Checkbox(
                                      value: _isChecked,
                                      onChanged: (bool? newValue) {
                                        setState(() {
                                          _isChecked = newValue!;
                                        });
                                      },
                                      activeColor: const Color(0xFF9FC86A),
                                      checkColor: Colors.white,
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Membuat area tap lebih kecil
                                    ),
                                    const SizedBox(width: 4.0), // Jarak antara checkbox dan teks
                                    Expanded( // Memastikan Column mengambil sisa ruang
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start, // Memastikan konten Column dimulai dari atas
                                        children: [
                                          Text(
                                            'Saya menyetujui Syarat dan Ketentuan',
                                            style: GoogleFonts.poppins(
                                              color: const Color.fromARGB(255, 0, 0, 0),
                                              fontSize: width * 0.032,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            'Anda menyetujui Ketentuan Layanan dan Kebijakan Privasi kami.',
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFF64748B),
                                              fontSize: width * 0.03,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.025), // Jarak sebelum tombol Lanjut

                        // Container untuk tombol Lanjut
                        SizedBox(
                          width: double.infinity,
                          height: height * 0.04,
                          child: ElevatedButton(
                            onPressed: buttonEnabled
                                ? () {
                                    // Logika print data dan jenis
                                    print("Email: ${_emailController.text}");
                                    print("Password: ${_passwordController.text}");
                                    print("Konfirmasi Password: ${_confirmPasswordController.text}");

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => DaftarscreenII(initialEmail: _emailController.text, initialPassword: _passwordController.text,)),
                                    );
                                  }
                                : null, // Tombol nonaktif jika buttonEnabled false
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor, // Warna tombol #878b94
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
                        Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Sudah Punya Akun? ",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF64748B),
                            fontSize: width * 0.03,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("Daftar ditekan!");
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Masuk!",
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF9FC86A),
                              fontSize: width * 0.03,
                              fontWeight: FontWeight.w300,
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
        ],
      ),
    );
  }
}