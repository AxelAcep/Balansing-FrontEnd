import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart'; 
import 'package:balansing/services/ibu_services.dart'; 
import 'package:url_launcher/url_launcher.dart'; // Tambahkan ini untuk membuka link jika ada

class ArtikelDetailScreen extends StatefulWidget {
  final String id;
  
  const ArtikelDetailScreen({super.key, required this.id});

  @override
  State<ArtikelDetailScreen> createState() => _ArtikelDetailScreenState();
}

class _ArtikelDetailScreenState extends State<ArtikelDetailScreen> {
  late Future<Map<String, dynamic>> _articleDetailFuture;

  @override
  void initState() {
    super.initState();
    _articleDetailFuture = IbuServices().getDetailArticle(widget.id);
  }
  
  String _formatDate(String isoDateString) {
    try {
      final dateTime = DateTime.parse(isoDateString);
      return DateFormat('d MMMM yyyy').format(dateTime);
    } catch (e) {
      return "Tanggal tidak valid";
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _articleDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat artikel: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final article = snapshot.data!;
            final List<String> tagNames = (article['tags'] as List<dynamic>)
                .map((tag) => tag['nama'].toString())
                .toList();
            final String imageUrl = article['gambar'] ??
                'https://fqpalkzlylkiqmnsizji.supabase.co/storage/v1/object/public/Video/Artikel/NoImage.png';
            final String waktuBaca = article['waktuBaca']?.toString() ?? '4'; // Menambahkan waktuBaca

            return SingleChildScrollView(
              child: Container(
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.03),
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
                    SizedBox(height: height * 0.02),
                    Text(
                      article['judul'],
                      style: GoogleFonts.poppins(
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            color: Color.fromARGB(26, 100, 116, 139),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.person_4_outlined, size: width * 0.035),
                              Text(
                                "Tim Balansing",
                                style: GoogleFonts.poppins(
                                  fontSize: width * 0.025,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            color: Color.fromARGB(26, 100, 116, 139),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today_outlined, size: width * 0.035),
                              SizedBox(width: width * 0.01),
                              Text(
                                _formatDate(article['tanggal']),
                                style: GoogleFonts.poppins(
                                  fontSize: width * 0.025,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            color: Color.fromARGB(26, 100, 116, 139),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.timer_outlined, size: width * 0.035),
                              SizedBox(width: width * 0.01),
                              Text(
                                "baca $waktuBaca menit",
                                style: GoogleFonts.poppins(
                                  fontSize: width * 0.025,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    SizedBox(
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.error_outline, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: tagNames.map((tag) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
                          child: Text(
                            tag,
                            style: GoogleFonts.poppins(
                              fontSize: width * 0.03,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            color: Color(0xFFDBEAFE),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: height * 0.02),
                    // MarkdownBody dengan style yang lebih lengkap
                    MarkdownBody(
                      data: article['konten'],
                      onTapLink: (text, href, title) => href != null ? launchUrl(Uri.parse(href)) : null,
                      styleSheet: MarkdownStyleSheet(
                        // Mengatur gaya untuk H1 dan H2
                        h1: GoogleFonts.poppins(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                        ),
                        h2: GoogleFonts.poppins(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                        h3: GoogleFonts.poppins(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                        // Mengatur gaya untuk paragraf (teks biasa)
                        p: GoogleFonts.poppins(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          height: 1.5,
                        ),
                        // Mengatur gaya untuk list item
                        listBullet: GoogleFonts.poppins(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          height: 1.5,
                        ),
                        // Mengatur gaya untuk bold text
                        strong: const TextStyle(fontWeight: FontWeight.bold),
                        // Mengatur gaya untuk link
                        a: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                      ),
                    ),
                    SizedBox(height: height*0.08),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('Tidak ada data'));
          }
        },
      ),
    );
  }
}