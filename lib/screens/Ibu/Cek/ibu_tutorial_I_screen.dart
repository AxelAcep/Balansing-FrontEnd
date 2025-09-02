import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/screens/Ibu/Cek/ibu_tutorial_page.dart';
import 'package:balansing/screens/Ibu/Cek/ibu_tutorial_data.dart';

class TutorialFlowScreen extends StatefulWidget {
  const TutorialFlowScreen({super.key});

  @override
  State<TutorialFlowScreen> createState() => _TutorialFlowScreenState();
}

class _TutorialFlowScreenState extends State<TutorialFlowScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: tutorialData.length,
              itemBuilder: (context, index) {
                final data = tutorialData[index];
                return TutorialPage(
                  videoUrl: data.videoUrl,
                  category: data.category,
                  markdownText: data.markdownText,
                  totalPages: tutorialData.length,
                  currentPageIndex: index,
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _currentPage > 0
                        ? () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                        : null,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF4B5563),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Kembali",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF4B5563),
                            fontWeight: FontWeight.w600,
                            fontSize: width * 0.04,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _currentPage < tutorialData.length - 1
                        ? () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9FC86A),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Selanjutnya",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: width * 0.04,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
