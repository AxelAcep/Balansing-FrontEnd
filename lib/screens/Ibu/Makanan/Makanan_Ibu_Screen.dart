import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'package:balansing/services/ibu_services.dart';
import 'package:balansing/screens/Ibu/Makanan/Makanan_Confirm_Screen.dart';

class MakananIbuScreen extends StatefulWidget {
  const MakananIbuScreen({super.key});

  @override
  State<MakananIbuScreen> createState() => _IbuMakananScreenState();
}

class _IbuMakananScreenState extends State<MakananIbuScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  XFile? _capturedImage;
  bool _isLoading = false; // Tambahkan state untuk indikator loading

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Pastikan kamera tersedia di perangkat
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      // Handle kasus tidak ada kamera
      if (mounted) {
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          const SnackBar(content: Text('Tidak ada kamera tersedia')),
        );
      }
      return;
    }

    // Ambil kamera pertama dari daftar
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    // Inisialisasi controller
    _initializeControllerFuture = _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            if (mounted) {
              ScaffoldMessenger.of(context as BuildContext).showSnackBar(
                const SnackBar(content: Text('Akses kamera ditolak')),
              );
            }
            break;
          default:
            if (mounted) {
              ScaffoldMessenger.of(context as BuildContext).showSnackBar(
                const SnackBar(content: Text('Terjadi error pada kamera')),
              );
            }
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      // Pastikan controller sudah diinisialisasi sebelum mengambil gambar
      await _initializeControllerFuture;

      // Ambil gambar dan simpan ke dalam file
      final image = await _controller.takePicture();
      setState(() {
        _capturedImage = image;
      });
    } catch (e) {
      print(e);
      if (mounted) {
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(content: Text('Gagal mengambil gambar: $e')),
        );
      }
    }
  }

  void _retakePicture() {
    setState(() {
      _capturedImage = null;
    });
  }

  // Tambahkan method untuk mengirim file ke API
  Future<void> _uploadImageAndGetLabels() async {
  if (_capturedImage == null) {
    return;
  }

  setState(() {
    _isLoading = true; // Set loading to true
  });

  try {
    final List<dynamic> labels = await IbuServices().cekMakanan(_capturedImage!.path);

    // Check if the list is empty to determine which dialog to show
    if (labels.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Tidak Ada Makanan Terdeteksi'),
            content: const Text('Silahkan Ambil Ulang Kembali Foto'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Tutup'),
              ),
            ],
          );
        },
      );
    } else {
      _retakePicture();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MakananConfirmScreen(detectedLabels: labels,)),
      );
    }

  } catch (e) {
    print('Error saat mengunggah gambar: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memproses gambar: $e')),
      );
    }
  } finally {
    setState(() {
      _isLoading = false; // Set loading to false
    });
  }
}

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: _capturedImage == null
            ? const BoxDecoration(color: Colors.white)
            : const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black,
                    Color.fromARGB(255, 112, 136, 82),
                  ],
                  stops: [
                    0.45,
                    1.0,
                  ],
                ),
              ),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.03),
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

                _capturedImage == null ? 
                Text(
                  "Variasi Makanan", 
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.w600,
                  ),
                ):Text(
                  "Hasil Foto", 
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9FC86A)
                  ),
                ),

                SizedBox(height: height * 0.01),

                _capturedImage == null ? 
                Text(
                  "Cek Gizi di Piring si Kecil, Yuk!",
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF64748B),
                    fontSize: width * 0.035,
                    fontWeight: FontWeight.w400,
                  ),
                ):Text(
                  "Validasi Foto Makanan",
                  style: GoogleFonts.poppins(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: width * 0.035,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                SizedBox(height: height * 0.01),

                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: FutureBuilder<void>(
                        future: _initializeControllerFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            if (_capturedImage != null) {
                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.file(
                                    File(_capturedImage!.path),
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: IconButton(
                                      icon: const Icon(Icons.close, color: Colors.white),
                                      onPressed: _retakePicture,
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return CameraPreview(_controller);
                            }
                          } else {
                            return const Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.01),

                _capturedImage == null ?
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Color(0xFF9FC86A),
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Catatan",
                        style: GoogleFonts.poppins(
                          fontSize: width * 0.03,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Mohon tidak mengaduk makanan untuk memudahkan proses identifikasi",
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF64748B),
                          fontSize: width * 0.025,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ): Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF18181B),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border(
                      left: BorderSide(
                        color: Color(0xFF9FC86A),
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Konfirmasi Hal Berikut",
                        style: GoogleFonts.poppins(
                          fontSize: width * 0.03,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9FC86A),
                        ),
                      ),
                      SizedBox(height: height*0.005,),
                      Text(
                        "1. Seluruh makanan terlihat Jelas",
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: width * 0.025,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "2. Foto tidak buram",
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: width * 0.025,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: height*0.02,),

                if (_capturedImage != null)
                Container(
                  child: Container(
                    height: height*0.15,
                    width: double.infinity,
                    child: 
                        Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: _retakePicture,
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          backgroundColor: Colors.transparent
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.loop,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            SizedBox(width: width * 0.01),
                            Text(
                              'Ambil Ulang',
                              style: GoogleFonts.poppins(
                                fontSize: width * 0.035,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: _uploadImageAndGetLabels, // Panggil method baru di sini
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          backgroundColor: const Color(0xFF9FC86A),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Selanjutnya',
                              style: GoogleFonts.poppins(
                                fontSize: width * 0.035,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: width * 0.01),
                            const Icon(
                              Icons.arrow_right,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ),
              ),

              if (_capturedImage == null)
              Center(
                child: Container(
                height: height*0.18,
                child: Column( mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_capturedImage == null) {
                          _takePicture();
                        } else {
                          // Tidak melakukan apa-apa jika gambar sudah diambil
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _capturedImage == null ? Colors.transparent : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset("assets/images/CaptureButton.png", height: height*0.08,)
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      _capturedImage == null ? "Capture" : "Gambar Terambil",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF64748B),
                        fontSize: width * 0.03,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    if (_capturedImage != null)
                      TextButton(
                        onPressed: _retakePicture,
                        child: Text(
                          "Ambil Ulang",
                          style: GoogleFonts.poppins(
                            color: Colors.blue,
                            fontSize: width * 0.03,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              )),
            ],
          ),
        ),
        if (_isLoading) // Tampilkan indikator loading jika _isLoading true
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF9FC86A),
              ),
            ),
          ),
      ]),
    );
  }
}