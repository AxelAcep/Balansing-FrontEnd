import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/card/ArtikelCard.dart';
import 'package:balansing/services/ibu_services.dart'; // Asumsikan file ini berisi fungsi getArticle

class IbuArtikelScreen extends StatefulWidget {
  const IbuArtikelScreen({super.key});

  @override
  State<IbuArtikelScreen> createState() => _IbuMakananScreenState();
}

class _IbuMakananScreenState extends State<IbuArtikelScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _articlesFuture = IbuServices().getArticle();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.05),
              Text(
                "Artikel Bunda",
                style: GoogleFonts.poppins(
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: height * 0.02),
              Container(
                width: width * 0.9,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.grey[600],
                      size: height * 0.025,
                    ),
                    SizedBox(width: width * 0.02),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari Informasi',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: width * 0.035,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: width * 0.035,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),
              // Menggunakan FutureBuilder untuk menampilkan data dari API
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _articlesFuture,
                builder: (context, snapshot) {
                  // Jika data sedang dimuat
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // Jika terjadi error saat memuat data
                  else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  // Jika data berhasil dimuat
                  else if (snapshot.hasData) {
                    final articles = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];

                        // Mengambil nama tag saja
                        final List<String> tagNames =
                            (article['tags'] as List<dynamic>).map((tag) => tag['nama'].toString()).toList();

                        // Mengambil gambar URL. Jika null atau tidak ada, gunakan URL default.
                        final String imageUrl = article['gambar'] ??
                            'https://fqpalkzlylkiqmnsizji.supabase.co/storage/v1/object/public/Video/Artikel/NoImage.png';
                        
                        // Mengambil waktu baca. Jika null atau tidak ada, gunakan nilai default.
                        final String waktuBaca = article['waktuBaca']?.toString() ?? '4';

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: ArticleCard(
                            id: article['id']!,
                            tags: tagNames,
                            judul: article['judul']!,
                            waktuBaca: waktuBaca,
                            gambarUrl: imageUrl,
                          ),
                        );
                      },
                    );
                  }
                  // Jika tidak ada data
                  else {
                    return const Center(child: Text("Tidak ada artikel yang ditemukan."));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}