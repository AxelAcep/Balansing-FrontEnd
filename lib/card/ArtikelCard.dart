import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/screens/Ibu/Artikel/artikel_detail.screen.dart';

class ArticleCard extends StatelessWidget {
  final List<String> tags;
  final String judul;
  final String waktuBaca;
  final String gambarUrl;
  final String id;

  const ArticleCard({
    Key? key,
    required this.tags,
    required this.judul,
    required this.waktuBaca,
    required this.gambarUrl,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () async {
        await Navigator.push( // Await the push so you can refresh
          context,
          MaterialPageRoute(
            builder: (context) => ArtikelDetailScreen(id: id),
          ),
        );
        print("Id: $id");
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: const Color(0xFFE2E8F0)),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container untuk tags
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(25, 128, 128, 128), // Menggunakan warna abu-abu dengan opacity
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: tags.map((tag) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4), // Mengurangi margin untuk kerapatan
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
            ),
            // Container untuk gambar dan teks
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, // Align item ke atas
                children: [
                  SizedBox(
                    width: width * 0.25,
                    height: width * 0.25,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        gambarUrl,
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
                  SizedBox(width: width * 0.03),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align teks ke kiri
                      children: [
                        Text(
                          judul,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              'baca $waktuBaca menit',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}