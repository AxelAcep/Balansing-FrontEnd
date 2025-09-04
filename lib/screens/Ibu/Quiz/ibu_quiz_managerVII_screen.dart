import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/screens/Ibu/Quiz/ibu_quiz_managerI_screen.dart';
import 'package:balansing/screens/Ibu/Quiz/ibu_quiz_managerVIII_screen.dart';

class IbuQuizManagerVIIScreen extends StatefulWidget {
  const IbuQuizManagerVIIScreen({super.key});

  @override
  State<IbuQuizManagerVIIScreen> createState() => _IbuQuizManagerVIIScreenState();
}

class _IbuQuizManagerVIIScreenState extends State<IbuQuizManagerVIIScreen> {
  // Variabel untuk melacak pilihan setiap pertanyaan
  bool? _isQ1Selected;
  bool? _isQ2Selected;
  bool? _isQ3Selected;
  bool? _isQ4Selected;

  final QuizScoreManager _scoreManager = QuizScoreManager();

  // Memperbaiki metode onAnswerSelected untuk mengupdate state yang benar
  void _onAnswerSelected(int questionIndex, bool isYes) {
    setState(() {
      if (questionIndex == 1) {
        _isQ1Selected = isYes;
      } else if (questionIndex == 2) {
        _isQ2Selected = isYes;
      } else if (questionIndex == 3) {
        _isQ3Selected = isYes;
      } else if (questionIndex == 4) {
        _isQ4Selected = isYes;
      }
    });
  }

  // Memeriksa apakah semua pertanyaan sudah dijawab
  bool get _allQuestionsAnswered =>
      _isQ1Selected != null &&
      _isQ2Selected != null &&
      _isQ3Selected != null &&
      _isQ4Selected != null;

  // Menghitung skor
  int _calculateScore() {
    int score = 0;
    if (_isQ1Selected == true) score++;
    if (_isQ2Selected == true) score++;
    if (_isQ3Selected == true) score++;
    if (_isQ4Selected == true) score++;
    return score;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.055),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Sanitasi',
                  style: GoogleFonts.poppins(
                      fontSize: width * 0.04, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Pertanyaan 5 dari 7',
                  style: GoogleFonts.poppins(
                      color: const Color(0xFFA1A1AA),
                      fontSize: width * 0.035,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
            SizedBox(height: height * 0.005),
            LinearProgressIndicator(
              value: 7 / 9,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFB1D581)),
              minHeight: height * 0.012,
              borderRadius: BorderRadius.circular(10),
            ),
            SizedBox(height: height * 0.02),
            Text(
              "Kapan Saja si Kecil mencuci tangan?",
              style: GoogleFonts.poppins(
                  fontSize: width * 0.05, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: height * 0.02),

            // --- Multiple Choice Questions Section ---
            QuizQuestion(
              question: '1. Sebelum makan',
              onAnswer: (isYes) => _onAnswerSelected(1, isYes),
              selectedAnswer: _isQ1Selected,
            ),
            SizedBox(height: height * 0.02),
            QuizQuestion(
              question: '2. Sesudah makan',
              onAnswer: (isYes) => _onAnswerSelected(2, isYes),
              selectedAnswer: _isQ2Selected,
            ),
            SizedBox(height: height * 0.02),
            QuizQuestion(
              question: '3. Sebelum BAK/BAB',
              onAnswer: (isYes) => _onAnswerSelected(3, isYes),
              selectedAnswer: _isQ3Selected,
            ),
            SizedBox(height: height * 0.02),
            QuizQuestion(
              question: '4. Sesudah BAK/BAB',
              onAnswer: (isYes) => _onAnswerSelected(4, isYes),
              selectedAnswer: _isQ4Selected,
            ),
            SizedBox(height: height * 0.02),
            // --- End of Questions Section ---

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      print('Kembali');
                      _scoreManager.resetScore();
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Color(0xFFE2E8F0),
                          width: 2.0,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      backgroundColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_left,
                          color: Color(0xFF454545),
                        ),
                        SizedBox(width: width * 0.01),
                        Text(
                          'Kembali',
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF454545),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _allQuestionsAnswered
                        ? () {
                            int currentScore = _calculateScore();
                            _scoreManager.addScore(currentScore);
                            print('Total poin yang ditambahkan: $currentScore');
                            print('Total skor keseluruhan: ${_scoreManager.totalScore}');
                            
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const IbuQuizManagerVIIIScreen()),
                            );
                          }
                        : null,
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      backgroundColor: _allQuestionsAnswered
                          ? const Color(0xFF9FC86A)
                          : Colors.grey,
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
              ),
            ),
            SizedBox(height: height * 0.05)
          ],
        ),
      ),
    );
  }
}

// Custom widget for a single quiz question with "Ya" and "Tidak" buttons
class QuizQuestion extends StatelessWidget {
  final String question;
  final Function(bool) onAnswer;
  final bool? selectedAnswer;

  const QuizQuestion({
    super.key,
    required this.question,
    required this.onAnswer,
    this.selectedAnswer,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: GoogleFonts.poppins(
            fontSize: width * 0.045,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: width * 0.02),
        Row(
          children: [
            Container(
              width: width * 0.22,
              height: height * 0.055,
              child: _buildChoiceButton(
                context,
                label: '(A) Ya',
                isSelected: selectedAnswer == true,
                onTap: () => onAnswer(true),
              ),
            ),
            SizedBox(width: width * 0.02),
            Container(
              width: width * 0.22,
              height: height * 0.055,
              child: _buildChoiceButton(
                context,
                label: '(B) Tidak',
                isSelected: selectedAnswer == false,
                onTap: () => onAnswer(false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChoiceButton(BuildContext context,
      {required String label, required bool isSelected, required VoidCallback onTap}) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF4F9EC) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFFB1D581) : const Color(0xFFE2E8F0),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: width * 0.035,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF454545),
            ),
          ),
        ),
      ),
    );
  }
}