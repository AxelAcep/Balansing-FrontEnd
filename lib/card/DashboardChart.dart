import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

// Model untuk data pertumbuhan
class GrowthData {
  final int month;
  final double value;

  GrowthData({required this.month, required this.value});
}

class GrowthChartCard extends StatelessWidget {
  final String title;
  final List<GrowthData> data;
  final String unit;
  final double datasebelum;

  final String title2;
  final String status2;
  final double beratLahir;
  final String unit2;

  const GrowthChartCard({
    super.key,
    required this.title,
    required this.data,
    required this.unit,
    required this.datasebelum,

    required this.title2,
    required this.status2,
    required this.beratLahir,
    required this.unit2,
  });

  String _getMonthLabel(int month) {
    switch (month) {
      case 1: return 'Jan';
      case 2: return 'Feb';
      case 3: return 'Mar';
      case 4: return 'Apr';
      case 5: return 'May';
      case 6: return 'Jun';
      case 7: return 'Jul';
      case 8: return 'Aug';
      case 9: return 'Sep';
      case 10: return 'Oct';
      case 11: return 'Nov';
      case 12: return 'Dec';
      default: return '';
    }
  }


  Widget _getGrowthComparison(double width, String TextJenis) {
    if (data.length < 2) {
      return Text(
        'Data tidak cukup untuk perbandingan',
        style: GoogleFonts.poppins(fontSize: width * 0.025, color: Colors.grey),
      );
    }
    //final lastValue = data.last.value;
    //final secondLastValue = data[data.length - 2].value;
    //final growth = lastValue - secondLastValue;
    final selisih = data.last.value - datasebelum;
    final sign = selisih >= 0 ? '↑' : '↓';
    final color = selisih >= 0 ? const Color(0xFF76A73B) : const Color(0xFFDC2626);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(TextJenis, style: GoogleFonts.poppins(fontSize: width*0.04, fontWeight: FontWeight.w600),),
        Text(
          '$sign ${selisih.abs().toStringAsFixed(1)} $unit',
          style: GoogleFonts.poppins(
            fontSize: width * 0.04,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _getGrowthComparison2(double width, String TextJenis, double beratLahir) {

    //final lastValue = data.last.value;
    //final secondLastValue = data[data.length - 2].value;
    //final growth = lastValue - secondLastValue;

    String status2 = '';
    late Color color;

    if(TextJenis == 'Berat Lahir'){
      if(beratLahir >= 2500){
        status2 = 'Normal';
        color = const Color(0xFF76A73B);
      } else {
        status2 = 'Rendah';
        color = const Color(0xFFFACC15);
      }
    } else if (TextJenis == 'Tinggi Lahir'){
      if(beratLahir >= 45){
        status2 = 'Normal';
        color = const Color(0xFF76A73B);
      } else {
        status2 = 'Pendek';
        color = const Color(0xFFFACC15);
      }
    }


    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(TextJenis, style: GoogleFonts.poppins(fontSize: width*0.04, fontWeight: FontWeight.w600),),
        Text(
          status2,
          style: GoogleFonts.poppins(
            fontSize: width * 0.04,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    late String standar;
    if(title2 == 'Berat Lahir'){
      if(beratLahir >= 2500){
        standar = 'Di atas ${beratLahir-2500}';
      } else {
        standar = 'Di bawah ${2500 - beratLahir}';
      }
    } else if (title2 == 'Tinggi Lahir'){
      if(beratLahir >= 45){
        standar = 'Di atas ${beratLahir-45}';
      } else {
        standar = 'Di bawah ${45-beratLahir}';
      }
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(width * 0.04),
        boxShadow: const [
          BoxShadow(
            color: Colors.transparent,
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
            child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: width * 0.045,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: height * 0.02),
          SizedBox(height: height * 0.02),
          SizedBox(
            height: height * 0.25,
            child: LineChart(
              LineChartData(
                minX: data.first.month.toDouble(),
                maxX: data.last.month.toDouble(),
                minY: 0,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1, // Mengatur interval agar label tidak tumpang tindih
                      reservedSize: height * 0.04,
                      getTitlesWidget: (value, meta) {
                        final month = value.toInt();
                        return Padding(
                          padding: EdgeInsets.only(top: height * 0.01),
                          child: Text(
                            "$month",
                            style: GoogleFonts.poppins(
                              fontSize: width * 0.025,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(1),
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.025,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.left,
                        );
                      },
                      reservedSize: width * 0.1,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: height * 0.008,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Color(0xFFE2E8F0),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: data.map((d) => FlSpot(d.month.toDouble(), d.value)).toList(),
                    isCurved: true,
                    color: const Color(0xFF9FC86A),
                    barWidth: width * 0.008,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
            ],),
          ),
          SizedBox(height: height * 0.02),
          SizedBox(
            height: height * 0.15,
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
            Container(
            height: height * 0.12,
            width: width * 0.75,
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
            child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _getGrowthComparison(width, title),
          SizedBox(height: height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sekarang:',
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.03,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '${data.last.value.toStringAsFixed(1)} $unit',
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Sebelumnya:',
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.03,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '$datasebelum $unit',
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
              ],
            ),
          ),
          SizedBox(width: width * 0.04),
          Container(
            width: width * 0.75,
            height: height * 0.12,
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
            child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _getGrowthComparison2(width, title2, beratLahir),
          SizedBox(height: height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title2,
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.03,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '$beratLahir $unit2',
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Standar',
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.03,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '$standar $unit2',
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.03,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
              ],
            ),
          )
                  ],
                ),
              ),
          )
          // Container(
          //   padding: const EdgeInsets.all(16.0),
          //                     decoration: BoxDecoration(
          //                       color: Colors.white,
          //                       borderRadius: BorderRadius.circular(12),
          //                       border: Border.all(
          //                         color: const Color(0xFFE2E8F0),
          //                         width: 0,
          //                       ),
          //                       boxShadow: [
          //                         BoxShadow(
          //                           color: Colors.grey.withOpacity(0.2),
          //                           spreadRadius: 2,
          //                           blurRadius: 5,
          //                           offset: const Offset(0, 3),
          //                         ),
          //                       ],
          //                     ),
          //   child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       _getGrowthComparison(width, title),
          // SizedBox(height: height * 0.01),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text(
          //           'Sekarang:',
          //           style: GoogleFonts.poppins(
          //             fontSize: width * 0.03,
          //             color: Colors.grey,
          //           ),
          //         ),
          //         Text(
          //           '${data.last.value.toStringAsFixed(1)} $unit',
          //           style: GoogleFonts.poppins(
          //             fontSize: width * 0.04,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ],
          //     ),
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.end,
          //       children: [
          //         Text(
          //           'Sebelumnya:',
          //           style: GoogleFonts.poppins(
          //             fontSize: width * 0.03,
          //             color: Colors.grey,
          //           ),
          //         ),
          //         Text(
          //           '${datasebelum} $unit',
          //           style: GoogleFonts.poppins(
          //             fontSize: width * 0.04,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}