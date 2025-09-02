class TutorialPageData {
  final String videoUrl;
  final String category;
  final String markdownText;

  TutorialPageData({
    required this.videoUrl,
    required this.category,
    required this.markdownText,
  });
}

// Data untuk 4 halaman tutorial
final List<TutorialPageData> tutorialData = [
  TutorialPageData(
    videoUrl: 'https://cdn.pixabay.com/video/2021/02/18/65562-515098354_large.mp4',
    category: 'Pengukuran Fisik',
    markdownText: """
# Pengukuran Fisik

**Ukur tinggi badan:**
1. Ajak si Kecil berdiri tegak. Pastikan punggung, bokong, dan tumitnya menempel lurus di dinding.
2. Gunakan pengukur tinggi badan atau meteran, lalu tandai tinggi badannya dengan pensil.
3. Catat hasil pengukurannya.

**Ukur berat badan:**
1. Pastikan angka pada timbangan sudah kembali ke nol (0) terlebih dahulu.
2. Lepas jaket dan sepatu si Kecil sebelum ditimbang.
3. Catat hasilnya.
""",
  ),
  TutorialPageData(
    videoUrl: 'https://cdn.pixabay.com/video/2021/02/18/65562-515098354_large.mp4',
    category: 'Pemeriksaan Anemia Mata',
    markdownText: """
# Pemeriksaan Anemia Mata

**Periksa kelopak mata bagian bawah:**
1. Ajak si Kecil duduk atau berbaring.
2. Tarik kelopak mata bagian bawah secara perlahan ke bawah.
3. Perhatikan warna di dalam kelopak mata. Warna pucat (bukan merah muda) bisa menjadi tanda anemia.

**Catatan penting:**
Konsultasikan dengan dokter atau tenaga medis jika Anda menemukan tanda-tanda yang mencurigakan.
""",
  ),
  TutorialPageData(
    videoUrl: 'https://cdn.pixabay.com/video/2021/02/18/65562-515098354_large.mp4',
    category: 'Pemeriksaan Anemia Kuku',
    markdownText: """
# Pemeriksaan Anemia Kuku

**Periksa warna kuku:**
1. Tekan ujung kuku si Kecil selama beberapa detik hingga warnanya menjadi pucat.
2. Lepaskan tekanan dan perhatikan warna yang kembali. Warna merah muda seharusnya kembali dengan cepat.
3. Jika warna kuku tetap pucat, itu bisa menjadi indikasi anemia.

**Catatan:**
Pemeriksaan ini hanyalah langkah awal. Diagnosis yang akurat harus dilakukan oleh profesional kesehatan.
""",
  ),
  TutorialPageData(
    videoUrl: 'https://cdn.pixabay.com/video/2021/02/18/65562-515098354_large.mp4',
    category: 'Gejala Tambahan Lainnya',
    markdownText: """
# Gejala Tambahan Lainnya

**Perhatikan gejala fisik dan perilaku:**
1. **Lemas dan mudah lelah:** Anak terlihat tidak berenergi dan sering mengantuk.
2. **Nafsu makan menurun:** Si Kecil menolak makan atau makan dengan porsi yang sangat sedikit.
3. **Pusing dan sakit kepala:** Keluhan pusing atau sakit kepala yang sering.
4. **Kulit pucat:** Warna kulit, terutama di wajah dan telapak tangan, terlihat lebih pucat dari biasanya.

Jika Anda menemukan beberapa gejala ini, segera konsultasikan dengan dokter untuk penanganan lebih lanjut.
""",
  ),
];
