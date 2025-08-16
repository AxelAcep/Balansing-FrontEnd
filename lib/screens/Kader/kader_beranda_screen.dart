import 'package:balansing/screens/Kader/Beranda/kaderTambahI.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart'; // Untuk fl_chart
import 'package:balansing/models/filter_model.dart';
import 'package:balansing/providers/KaderProvider.dart';
import 'package:provider/provider.dart';
import 'package:balansing/card/filterModal.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  int _selectedIndex = 0;
  bool _isDetailStunting = false;
  bool _isDetailPie = false;
  bool _isDetailGender = false;

  void _toggleSecondContainerVisibility() {
    setState(() {
      _isDetailStunting = !_isDetailStunting;
    });
  }

  void _toggleSecondContainerVisibility1() {
    setState(() {
      _isDetailPie = !_isDetailPie;
    });
  }

  void _toggleSecondContainerVisibility2() {
    setState(() {
      _isDetailGender = !_isDetailGender;
    });
  }
  

  void _showFilterModal() {
    showDialog(
      context: context,
      builder: (context) {
        return FilterModalContent(); 
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Panggil provider untuk mengambil data awal saat widget dibuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardProvider>(context, listen: false).fetchDashboardData();
      Provider.of<DashboardProvider>(context, listen: false).fetchKaderProfile();
    });
  }

  Widget _buildLegendItem(String title, Color color) {
  return Row(
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      const SizedBox(width: 5),
      Text(
        title,
        style: const TextStyle(fontSize: 10, color: Colors.black),
      ),
    ],
  );
}
  

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final filterModel = Provider.of<FilterModel>(context, listen: false);
    final riwayatProvider = Provider.of<RiwayatProvider>(context, listen: false);

    final List<String> _periods = ['1 bulan', '3 bulan', '6 bulan', '1 tahun'];
    //final List<MonthlyData> data = dummyData;


    return Consumer<DashboardProvider>(
      builder: (context, dashboardProvider, child) {
        if (dashboardProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (dashboardProvider.errorMessage != null) {
          return Center(
            child: Text('Error: ${dashboardProvider.errorMessage}', style: const TextStyle(color: Colors.red)),
          );
        } else {
          // Data sudah siap, gunakan untuk membangun UI
          final pieChartData = dashboardProvider.pieChartData;
          final monthlyData = dashboardProvider.monthlyAnemiaStuntingData;
          final ageDistributionData = dashboardProvider.ageDistributionData;
          // Di dalam build method Anda
          final monthlyStuntingData = Provider.of<DashboardProvider>(context).monthlyStuntingData;
          final pieStuntingData = dashboardProvider.stuntingPieChartData;

          final femaleCount = dashboardProvider.femaleCount;
          final maleCount = dashboardProvider.maleCount;


          final monthlyAnemiaData = dashboardProvider.monthlyAnemiaData;

          final rt = dashboardProvider.rt;
          final rw = dashboardProvider.rw;
          final posyandu = dashboardProvider.posyandu;
          
          final double totalChildren = pieChartData.fold(0, (sum, item) => sum + item.value);

          double findHighestValue(List<AgeGroupData> data) {
            if (data.isEmpty) {
              return 0.0; // Kembalikan double 0.0 jika list kosong
            }

            // Inisialisasi dengan double untuk menghindari konversi
            double highestValue = 0.0;
            for (var item in data) {
              if (item.males.toDouble() > highestValue) {
                highestValue = item.males.toDouble();
              }
              if (item.females.toDouble() > highestValue) {
                highestValue = item.females.toDouble();
              }
            }
            return highestValue*1.1;
          }

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
                                "${posyandu}",
                                style: GoogleFonts.poppins(
                                  fontSize: height * 0.015,
                                  color: const Color.fromARGB(255, 100, 116, 139),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: height * 0.07,
                            height: height * 0.07,
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => KaderTambahI()),
                            );
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
                      Container( height: height*0.03,
                        child: Row(
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
                            ),
                          ],
                        ))
                    ],
                  ),
                ),
                SizedBox(height: height * 0.02),
                Container(
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
                            
                            int SelectedIndex = 20;

                            if(filterModel.filter){

                              if(filterModel.count == 1){
                                SelectedIndex = 0;
                              } else if(filterModel.count == 3){
                                SelectedIndex = 1;
                              } else if(filterModel.count == 6){
                                SelectedIndex = 2;
                              } else if(filterModel.count == 12){
                                SelectedIndex = 3;
                              }else{
                                SelectedIndex = 5;
                              }
                            } else{
                              SelectedIndex = 20;
                            }

                            bool isSelected = SelectedIndex == index;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  
                                  filterModel.setFilter(true);
                                  int convertIndex = 1;
                                  if(index == 0) {
                                    convertIndex = 1;
                                  } else if (index == 1){
                                    convertIndex = 3;
                                  } else if (index == 2){
                                    convertIndex = 6;
                                  } else if (index == 3){
                                    convertIndex = 12;
                                  }

                                  filterModel.setCount(convertIndex);
                                  riwayatProvider.filterChildrenByMonth(
                                    filterModel.month,
                                    filterModel.year,
                                    filterModel.count,
                                  );

                                  dashboardProvider.filterDashboardData(filterModel);
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.025, vertical: height*0.01),
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
                                    fontSize: height * 0.013,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          GestureDetector(
                            onTap: () {
                              String selectedPeriod = _periods[_selectedIndex];
                              print('Periode yang dipilih: $selectedPeriod');

                              _showFilterModal();

                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.025,vertical: height*0.013),
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
                                    size:  height*0.012,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Filter',
                                    style: TextStyle(
                                      color: const Color(0xFF64748B),
                                      fontWeight: FontWeight.w600,
                                      fontSize:  height*0.01,
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
                          final dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
                          final filterModel = Provider.of<FilterModel>(context, listen: false);

                          if(filterModel.filter){
                            dashboardProvider.filterDashboardData(filterModel);
                          } else{
                            dashboardProvider.fetchDashboardData();
                          }
                          
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
                            "${rt}/${rw}",
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
                                            if (value.toInt() < monthlyData.length &&
                                                value % 1 == 0) {
                                              return SideTitleWidget(
                                                axisSide: meta.axisSide,
                                                space: 8.0,
                                                child: Text(
                                                    monthlyData[value.toInt()].month,
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
                                        spots: monthlyData.asMap().entries.map((entry) {
                                          return FlSpot(
                                              entry.key.toDouble(), entry.value.value);
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

                      GestureDetector(
                        onTap: _toggleSecondContainerVisibility,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isDetailStunting ? "Sembunyikan" : "Lihat Lainnya",
                              style: GoogleFonts.poppins(
                                fontSize: height * 0.018,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF76A73B),
                              ),
                            ),
                            Icon(
                              _isDetailStunting ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: const Color(0xFF76A73B),
                              size: height * 0.02,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: height * 0.02),

                      if (_isDetailStunting)
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
                                    "Data Stunting Bulanan",
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
                                            horizontalInterval: 1, // Atur interval
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
                                                  if (value.toInt() < monthlyStuntingData.length &&
                                                      value % 1 == 0) {
                                                    return SideTitleWidget(
                                                      axisSide: meta.axisSide,
                                                      space: 8.0,
                                                      child: Text(
                                                          monthlyStuntingData[value.toInt()].month,
                                                          style: const TextStyle(fontSize: 10)),
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
                                                color: const Color(0xff37434d), width: 1),
                                          ),
                                          lineBarsData: [
                                            // Sangat Pendek
                                            LineChartBarData(
                                              spots: monthlyStuntingData.asMap().entries.map((entry) {
                                                return FlSpot(
                                                  entry.key.toDouble(),
                                                  entry.value.counts['SangatPendek']!.toDouble(),
                                                );
                                              }).toList(),
                                              isCurved: true,
                                              color: const Color(0xFFDC2626),
                                              barWidth: 3,
                                              isStrokeCapRound: true,
                                              dotData: const FlDotData(show: true),
                                              belowBarData: BarAreaData(show: false),
                                            ),
                                            // Pendek
                                            LineChartBarData(
                                              spots: monthlyStuntingData.asMap().entries.map((entry) {
                                                return FlSpot(
                                                  entry.key.toDouble(),
                                                  entry.value.counts['Pendek']!.toDouble(),
                                                );
                                              }).toList(),
                                              isCurved: true,
                                              color: const Color(0xFFFACC15),
                                              barWidth: 3,
                                              isStrokeCapRound: true,
                                              dotData: const FlDotData(show: true),
                                              belowBarData: BarAreaData(show: false),
                                            ),
                                            // Normal
                                            LineChartBarData(
                                              spots: monthlyStuntingData.asMap().entries.map((entry) {
                                                return FlSpot(
                                                  entry.key.toDouble(),
                                                  entry.value.counts['Normal']!.toDouble(),
                                                );
                                              }).toList(),
                                              isCurved: true,
                                              color: const Color(0xFF9FC86A),
                                              barWidth: 3,
                                              isStrokeCapRound: true,
                                              dotData: const FlDotData(show: true),
                                              belowBarData: BarAreaData(show: false),
                                            ),
                                            // Tinggi
                                            LineChartBarData(
                                              spots: monthlyStuntingData.asMap().entries.map((entry) {
                                                return FlSpot(
                                                  entry.key.toDouble(),
                                                  entry.value.counts['Tinggi']!.toDouble(),
                                                );
                                              }).toList(),
                                              isCurved: true,
                                              color: const Color(0xFFD0E6B0),
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
                                  SizedBox(height: height * 0.02),
                                  // Legenda Grafik
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildLegendItem("Sangat Pendek", const Color(0xFFDC2626)),
                                      _buildLegendItem("Pendek", const Color(0xFFFACC15)),
                                      _buildLegendItem("Normal", const Color(0xFF9FC86A)),
                                      _buildLegendItem("Tinggi", const Color(0xFFD0E6B0)),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                      if (_isDetailStunting)      
                        SizedBox(height: height*0.02,),
                     
                      if (_isDetailStunting)
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
                              "Kasus Anemia",
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
                                            if (value.toInt() < monthlyAnemiaData.length &&
                                                value % 1 == 0) {
                                              return SideTitleWidget(
                                                axisSide: meta.axisSide,
                                                space: 8.0,
                                                child: Text(
                                                    monthlyAnemiaData[value.toInt()].month,
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
                                        spots: monthlyAnemiaData.asMap().entries.map((entry) {
                                          return FlSpot(
                                              entry.key.toDouble(), entry.value.count.toDouble());
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

                      if(_isDetailStunting)
                        SizedBox(height: height*0.02,),

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
                                                  value: (data.value).roundToDouble(),
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

                      SizedBox(height: height * 0.02),

                      GestureDetector(
                        onTap: _toggleSecondContainerVisibility1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isDetailPie ? "Sembunyikan" : "Lihat Lainnya",
                              style: GoogleFonts.poppins(
                                fontSize: height * 0.018,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF76A73B),
                              ),
                            ),
                            Icon(
                              _isDetailPie ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: const Color(0xFF76A73B),
                              size: height * 0.02,
                            ),
                          ],
                        ),
                      ),

                      if(_isDetailPie)
                        SizedBox(height: height* 0.02,),
                      
                      if(_isDetailPie)
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
                              "Rincian Stunting",
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
                                              sections: pieStuntingData.map((data) {
                                                return PieChartSectionData(
                                                  color: data.color,
                                                  value: (data.value).roundToDouble(),
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
                                      children: pieStuntingData.map((data) {
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
                                                  fontSize: height * 0.01,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              Text(
                                                '${data.value.toInt()}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: height * 0.01,
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
                                  maxY: findHighestValue(ageDistributionData), // Sesuaikan dengan nilai maksimum data Anda
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
                                            // Panggil properti 'group' untuk mendapatkan label rentang usia
                                            final data = ageDistributionData[value.toInt()];
                                            return SideTitleWidget(
                                              axisSide: meta.axisSide,
                                              space: 4.0,
                                              child: Text(
                                                data.group, // Perbaiki: Gunakan `data.group`
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
                                          toY: data.males.toDouble(),
                                          color: Color(0xFFFACC15), // Warna untuk laki-laki
                                          width: width*0.03,
                                          borderRadius: BorderRadius.circular(4), // Bar tidak melengkung
                                        ),
                                        BarChartRodData(
                                          toY: data.females.toDouble(),
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

                      SizedBox(height: height*0.02,),

                      GestureDetector(
                        onTap: _toggleSecondContainerVisibility2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isDetailGender ? "Sembunyikan" : "Lihat Lainnya",
                              style: GoogleFonts.poppins(
                                fontSize: height * 0.018,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF76A73B),
                              ),
                            ),
                            Icon(
                              _isDetailGender ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: const Color(0xFF76A73B),
                              size: height * 0.02,
                            ),
                          ],
                        ),
                      ),

                      if(_isDetailGender)
                        SizedBox(height: height* 0.02,),

                      if (_isDetailGender)
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
                                  "Rincian Gender",
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
                                                    sections: [
                                                      // Data untuk Laki-laki
                                                      PieChartSectionData(
                                                        color: const Color(0xFFFACC15),
                                                        value: maleCount.toDouble(),
                                                        title: '${maleCount}',
                                                        radius: width * 0.18,
                                                        titleStyle: GoogleFonts.poppins(
                                                            fontSize: width*0.06,
                                                            color: Colors.white
                                                        ),
                                                      ),
                                                      // Data untuk Perempuan
                                                      PieChartSectionData(
                                                        color: const Color(0xFF93C5FD),
                                                        value: femaleCount.toDouble(),
                                                        title: '${femaleCount}',
                                                        radius: width * 0.18,
                                                        titleStyle: GoogleFonts.poppins(
                                                            fontSize: width*0.06,
                                                            color: Colors.white
                                                        ),
                                                      ),
                                                    ],
                                                    sectionsSpace: 0,
                                                    centerSpaceRadius: 0,
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
                                          children: [
                                            // Keterangan untuk Perempuan
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: width * 0.02,
                                                    height: width * 0.02,
                                                    decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color(0xFF93C5FD), // Biru
                                                    ),
                                                  ),
                                                  SizedBox(width: width * 0.01),
                                                  Text(
                                                    'Perempuan ',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: height * 0.012,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  Text(
                                                    '$femaleCount',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: height * 0.012,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                              Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: width * 0.02,
                                                    height: width * 0.02,
                                                    decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color(0xFFFACC15), // Kuning
                                                    ),
                                                  ),
                                                  SizedBox(width: width * 0.01),
                                                  Text(
                                                    'Laki-laki ',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: height * 0.012,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  Text(
                                                    '$maleCount',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: height * 0.012,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
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
  
  }});
  }
  
}

