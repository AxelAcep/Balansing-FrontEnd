import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart'; // Untuk fl_chart

class MonthlyData {
  final String month;
  final double amount;

  MonthlyData(this.month, this.amount);
}

class PieData {
  final String title;
  final double value;
  final Color color;

  PieData(this.title, this.value, this.color);
}

// --- Data baru untuk Bar Chart ---
class AgeGroupData {
  final String ageRange;
  final double maleCount;
  final double femaleCount;

  AgeGroupData(this.ageRange, this.maleCount, this.femaleCount);
}

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  int _selectedIndex = 0;

  List<PieData> pieChartData = [
    PieData('Sehat', 25, const Color(0xFF9FC86A)), // Hijau
    PieData('Anemia', 8, const Color(0xFFFEF08A)), // Merah
    PieData('Stunting', 5, const Color(0xFFFACC15)), // Kuning/ Kuning
    PieData('Keduanya', 22, const Color(0xFFF43F5E)), // Biru
  ];

  List<MonthlyData> dummyData = [
    MonthlyData('Jan', 1200.0),
    MonthlyData('Feb', 1500.0),
    MonthlyData('Mar', 1350.0),
    MonthlyData('Apr', 1800.0),
    MonthlyData('Mei', 1600.0),
    MonthlyData('Jun', 2000.0),
  ];

  // --- Data dummy untuk Bar Chart distribusi umur ---
  List<AgeGroupData> ageDistributionData = [
    AgeGroupData('0-6', 10, 12),
    AgeGroupData('7-12', 15, 18),
    AgeGroupData('12-24', 8, 10),
    AgeGroupData('25-36', 5, 7),
    AgeGroupData('37-48', 3, 4),
    AgeGroupData('49-60', 1, 2),
  ];

  // Fungsi untuk mengupdate data Pie Chart (contoh)
  void _updatePieChartData() {
    setState(() {
      pieChartData = [
      PieData('Sehat', 25, const Color(0xFF9FC86A)), // Hijau
      PieData('Anemia', 8, const Color(0xFFFEF08A)), // Merah
      PieData('Stunting', 5, const Color(0xFFFACC15)), // Kuning/ Kuning
      PieData('Keduanya', 22, const Color(0xFFF43F5E)), // Biru
      ];
    });
  }

  // Fungsi untuk mengupdate data Line Chart (contoh)
  void _updateLineChartData() {
    setState(() {
      dummyData = [
        MonthlyData('Jul', 2200.0),
        MonthlyData('Agu', 1900.0),
        MonthlyData('Sep', 2100.0),
        MonthlyData('Okt', 2100.0),
        MonthlyData('Nov', 2400.0),
        MonthlyData('Des', 2000.0),
      ];
    });
  }

  // Fungsi untuk mengupdate data Bar Chart (contoh)
  void _updateAgeDistributionData() {
    setState(() {
      ageDistributionData = [
        AgeGroupData('0-6', 8, 15),
        AgeGroupData('7-12', 12, 20),
        AgeGroupData('12-24', 10, 7),
        AgeGroupData('25-36', 6, 9),
        AgeGroupData('37-48', 2, 5),
        AgeGroupData('49-60', 4, 1),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double totalChildren = pieChartData.fold(0, (sum, item) => sum + item.value);

    final List<String> _periods = ['1 bulan', '3 bulan', '6 bulan', '1 tahun'];
    final List<MonthlyData> data = dummyData;

    _updateAgeDistributionData();
    _updateLineChartData();
    _updatePieChartData();

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.05),
              Container(
                width: width * 0.9,
                height: height * 0.18,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFFE2E8F0),
                      width: 2.0,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dashboard",
                              style: GoogleFonts.poppins(
                                fontSize: height * 0.035,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Posyandu Bekasi",
                              style: GoogleFonts.poppins(
                                fontSize: height * 0.015,
                                color: const Color.fromARGB(255, 100, 116, 139),
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                        Container(
                          width: width * 0.14,
                          height: width * 0.14,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                'https://th.bing.com/th/id/OIP.LlyCbCQzCNj09nSh50xwJgHaGL?o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3',
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    ElevatedButton(
                      onPressed: () {
                        print("Test123");
                        // Anda bisa menambahkan _updateAgeDistributionData() di sini jika tombol ini relevan
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9FC86A),
                        minimumSize: Size(width * 0.9, height * 0.035),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        "Tambah Data Baru +",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: height * 0.015,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.005),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/circle-alert.png',
                          width: height * 0.02,
                          height: height * 0.02,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: width * 0.01),
                        Text(
                          "Pengecekan selanjutnya: 4 Juli 2025",
                          style: GoogleFonts.poppins(
                            fontSize: height * 0.013,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF94A3B8),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),
              Container(
                height: height * 0.1,
                color: Colors.transparent,
                width: width * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._periods.asMap().entries.map((entry) {
                          int index = entry.key;
                          String text = entry.value;
                          bool isSelected = _selectedIndex == index;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                                // Anda bisa menambahkan logika untuk memfilter data di sini
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.025, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFF4F9EC)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF9FC86A)
                                      : Colors.transparent,
                                  width: 1.0,
                                ),
                              ),
                              child: Text(
                                text,
                                style: TextStyle(
                                  color: const Color(0xFF64748B),
                                  fontWeight: FontWeight.w600,
                                  fontSize: width * 0.03,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        GestureDetector(
                          onTap: () {
                            String selectedPeriod = _periods[_selectedIndex];
                            print('Periode yang dipilih: $selectedPeriod');
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.025, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.filter_list,
                                  color: const Color(0xFF64748B),
                                  size: width * 0.04,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Filter',
                                  style: TextStyle(
                                    color: const Color(0xFF64748B),
                                    fontWeight: FontWeight.w600,
                                    fontSize: width * 0.03,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print("Simpan Data");
                        _updatePieChartData(); // Memperbarui Pie Chart
                        _updateLineChartData(); // Memperbarui Line Chart
                        _updateAgeDistributionData(); // Memperbarui Bar Chart
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF4F9EC),
                        minimumSize: Size(width * 0.9, height * 0.035),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: const BorderSide(
                            color: Color(0xFF9FC86A),
                            width: 1.0,
                          ),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Simpan Data saat ini",
                            style: TextStyle(
                              color: const Color(0xFF9FC86A),
                              fontSize: height * 0.015,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.download,
                            color: const Color(0xFF9FC86A),
                            size: height * 0.018,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: height * 0.015),
              Container(
                width: width * 0.9,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Riwayat Data",
                      style: GoogleFonts.poppins(
                        fontSize: width * 0.06,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "RT/RW",
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF60646C),
                          ),
                        ),
                        Text(
                          "04/01",
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Tanggal",
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF60646C),
                          ),
                        ),
                        Text(
                          "Januari - Juli 2025",
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    Container(
                      width: width * 0.85,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Kasus Stunting & Anemia",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: width * 0.035,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          Center(
                            child: SizedBox(
                              height: height * 0.2,
                              width: width * 0.7,
                              child: LineChart(
                                LineChartData(
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    horizontalInterval: height * 0.1,
                                    getDrawingHorizontalLine: (value) {
                                      return const FlLine(
                                        color: Color(0xFFE2E8F0),
                                        strokeWidth: 1,
                                      );
                                    },
                                  ),
                                  titlesData: FlTitlesData(
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 30,
                                        interval: 1,
                                        getTitlesWidget: (value, meta) {
                                          if (value.toInt() < data.length &&
                                              value % 1 == 0) {
                                            return SideTitleWidget(
                                              axisSide: meta.axisSide,
                                              space: 8.0,
                                              child: Text(
                                                  data[value.toInt()].month,
                                                  style: const TextStyle(
                                                      fontSize: 10)),
                                            );
                                          }
                                          return const Text('');
                                        },
                                      ),
                                    ),
                                    leftTitles: const AxisTitles(
                                        sideTitles: SideTitles(showTitles: false)),
                                    topTitles: const AxisTitles(
                                        sideTitles: SideTitles(showTitles: false)),
                                    rightTitles: const AxisTitles(
                                        sideTitles: SideTitles(showTitles: false)),
                                  ),
                                  borderData: FlBorderData(
                                    show: false,
                                    border: Border.all(
                                        color: const Color(0xff37434d),
                                        width: 1),
                                  ),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: data.asMap().entries.map((entry) {
                                        return FlSpot(
                                            entry.key.toDouble(), entry.value.amount);
                                      }).toList(),
                                      isCurved: true,
                                      color: const Color(0xFF76A73B),
                                      barWidth: 3,
                                      isStrokeCapRound: true,
                                      dotData: const FlDotData(show: true),
                                      belowBarData: BarAreaData(show: false),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.trending_down,
                                color: const Color(0xFF76A73B),
                                size: height * 0.02,
                              ),
                              SizedBox(width: width * 0.01),
                              Text(
                                "Turun 50%",
                                style: GoogleFonts.poppins(
                                  fontSize: height * 0.015,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF76A73B),
                                ),
                              ),
                              SizedBox(width: width * 0.02),
                              Text(
                                "kasus selama 6 bulan",
                                style: GoogleFonts.poppins(
                                  fontSize: height * 0.015,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF60646C),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Container(
                      width: width * 0.85,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Rincian",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: width * 0.035,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "Juni 2025",
                            style: GoogleFonts.poppins(
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF60646C),
                            ),
                          ),
                          Container(
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        PieChart(
                                          PieChartData(
                                            sections: pieChartData.map((data) {
                                              return PieChartSectionData(
                                                color: data.color,
                                                value: data.value,
                                                title: '',
                                                radius: width * 0.05,
                                                titleStyle: GoogleFonts.poppins(
                                                    fontSize: 0,
                                                    color: Colors.white),
                                              );
                                            }).toList(),
                                            sectionsSpace: 0,
                                            centerSpaceRadius: height * 0.07,
                                          ),
                                        ),
                                        Text(
                                          '${totalChildren.toInt()} Anak',
                                          style: GoogleFonts.poppins(
                                            fontSize: height * 0.02,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: width * 0.02),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: pieChartData.map((data) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: width * 0.02,
                                              height: width * 0.02,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: data.color,
                                              ),
                                            ),
                                            SizedBox(width: width * 0.01),
                                            Text(
                                              '${data.title}  ',
                                              style: GoogleFonts.poppins(
                                                fontSize: height * 0.015,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Text(
                                              '${data.value.toInt()}',
                                              style: GoogleFonts.poppins(
                                                fontSize: height * 0.015,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // --- Container Baru untuk Bar Chart Distribusi Umur ---
                    SizedBox(height: height * 0.02),
                    Container(
                      width: width * 0.85,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Distribusi Umur",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: width * 0.035,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "Juni 2025",
                            style: GoogleFonts.poppins(
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF60646C),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.25, // Tinggi yang cukup untuk bar chart
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: 25, // Sesuaikan dengan nilai maksimum data Anda
                                barTouchData: BarTouchData(enabled: true), // Nonaktifkan interaksi sentuh
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 30,
                                      getTitlesWidget: (value, meta) {
                                        // Pastikan index tidak melebihi batas data
                                        if (value.toInt() >= 0 && value.toInt() < ageDistributionData.length) {
                                          return SideTitleWidget(
                                            axisSide: meta.axisSide,
                                            space: 4.0,
                                            child: Text(
                                              ageDistributionData[value.toInt()].ageRange,
                                              style: const TextStyle(fontSize: 10),
                                            ),
                                          );
                                        }
                                        return const Text('');
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: false,
                                      interval: 5, // Interval untuk garis horizontal
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          value.toInt().toString(), // Tampilkan nilai Y sebagai teks
                                          style: const TextStyle(fontSize: 10),
                                        );
                                      },
                                      reservedSize: 28, // Ruang untuk label Y
                                    ),
                                  ),
                                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false, // Mirip dengan chart pertama
                                  horizontalInterval: 5, // Interval garis horizontal
                                  getDrawingHorizontalLine: (value) {
                                    return const FlLine(
                                      color: Color(0xFFE2E8F0), // Warna abu-abu
                                      strokeWidth: 1,
                                    );
                                  },
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                barGroups: ageDistributionData.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  AgeGroupData data = entry.value;
                                  return BarChartGroupData(
                                    x: index,
                                    barRods: [
                                      BarChartRodData(
                                        toY: data.maleCount,
                                        color: Color(0xFFFACC15), // Warna untuk laki-laki
                                        width: width*0.03,
                                        borderRadius: BorderRadius.circular(4), // Bar tidak melengkung
                                      ),
                                      BarChartRodData(
                                        toY: data.femaleCount,
                                        color: Color(0xFF93C5FD), // Warna untuk perempuan
                                        width: width*0.03,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ],
                                    // Spasi antar grup bar (umur)
                                    // Anda bisa sesuaikan jika ingin spasi lebih lebar
                                    barsSpace: 4,
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          Center(child: Text(
                            "Rentang Umur (bulan)",
                            style: GoogleFonts.poppins(
                              fontSize: width * 0.025,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF60646C),
                            ),
                          ),),
                          SizedBox(height: height*0.01),
                          Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Container(
                              width: width * 0.02,
                              height: width * 0.02,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Color(0xFFFACC15),
                              ),
                            ),
                            Text(
                            " Laki-Laki",
                            style: GoogleFonts.poppins(
                              fontSize: width * 0.025,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF60646C),
                            ),),
                            SizedBox(width: width*0.02,),
                            Container(
                              width: width * 0.02,
                              height: width * 0.02,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Color(0xFF93C5FD),
                              ),
                            ),
                            Text(
                            " Perempuan",
                            style: GoogleFonts.poppins(
                              fontSize: width * 0.025,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF60646C),
                            ),),

                          ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height*0.02),
              Container(
                width: width * 0.9,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Edukasi",
                      style: GoogleFonts.poppins(
                        fontSize: width * 0.06,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: height*0.01),
                ])
              )
            ],
          ),
        ),
      ),
    );
  }
}