import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/screens/Ibu/Quiz/ibu_quiz_managerVI_screen.dart'; // Keep this import for the next screen
import 'package:balansing/screens/Ibu/Quiz/ibu_quiz_managerI_screen.dart'; // Make sure this path is correct

class IbuQuizManagerVScreen extends StatefulWidget {
  const IbuQuizManagerVScreen({super.key});

  @override
  State<IbuQuizManagerVScreen> createState() => _IbuQuizManagerVScreenState();
}

class _IbuQuizManagerVScreenState extends State<IbuQuizManagerVScreen> {
  // Variables to track selections for each question
  bool? _isMorningSelected;
  bool? _isAfternoonSelected;
  bool? _isEveningSelected;

  final QuizScoreManager _scoreManager = QuizScoreManager();

  // A list to hold the quiz question data

  void _onAnswerSelected(String question, bool isYes) {
    setState(() {
      if (question == 'Saat mandi pagi') {
        _isMorningSelected = isYes;
      } else if (question == 'Saat mandi sore') {
        _isAfternoonSelected = isYes;
      } else if (question == 'Sebelum tidur malam') {
        _isEveningSelected = isYes;
      }
    });
  }

  // Check if all questions have been answered
  bool get _allQuestionsAnswered =>
      _isMorningSelected != null &&
      _isAfternoonSelected != null &&
      _isEveningSelected != null;

  // Calculate the score
  int _calculateScore() {
    int score = 0;
    if (_isMorningSelected == true) score++;
    if (_isAfternoonSelected == true) score++;
    if (_isEveningSelected == true) score++;
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
                  'Pertanyaan 3 dari 7',
                  style: GoogleFonts.poppins(
                      color: const Color(0xFFA1A1AA),
                      fontSize: width * 0.035,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
            SizedBox(height: height * 0.005),
            LinearProgressIndicator(
              value: 5 / 9,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFB1D581)),
              minHeight: height * 0.012,
              borderRadius: BorderRadius.circular(10),
            ),
            SizedBox(height: height * 0.02),

             Text(
              "Kapan Saja si Kecil menyikat gigi?",
              style: GoogleFonts.poppins(
                  fontSize: width * 0.05, fontWeight: FontWeight.w600),
            ),

            SizedBox(height: height * 0.02),

            // --- Multiple Choice Questions Section ---
            QuizQuestion(
              question: '1. Saat mandi pagi',
              onAnswer: (isYes) => _onAnswerSelected('Saat mandi pagi', isYes),
              selectedAnswer: _isMorningSelected,
            ),
            SizedBox(height: height * 0.02),
            QuizQuestion(
              question: '2. Setelah makan siang',
              onAnswer: (isYes) => _onAnswerSelected('Saat mandi sore', isYes),
              selectedAnswer: _isAfternoonSelected,
            ),
            SizedBox(height: height * 0.02),
            QuizQuestion(
              question: '3. Sebelum tidur malam',
              onAnswer: (isYes) => _onAnswerSelected('Sebelum tidur malam', isYes),
              selectedAnswer: _isEveningSelected,
            ),
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
                            // Calculate the score and add it to the manager
                            int currentScore = _calculateScore();
                            _scoreManager.addScore(currentScore);
                            print('Total poin yang ditambahkan: $currentScore');
                            print('Total skor keseluruhan: ${_scoreManager.totalScore}');
                            
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder:     (context) => const IbuQuizManagerVIScreen()),
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
              width: width*0.22,
              height: height*0.055,
              child: _buildChoiceButton(
                context,
                label: '(A) Ya',
                isSelected: selectedAnswer == true,
                onTap: () => onAnswer(true),
              ),
            ),
            SizedBox(width: width * 0.02),
            Container(
              width: width*0.22,
              height: height*0.055,
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
              fontSize: width*0.035,
              fontWeight: FontWeight.w600,
              color: isSelected ? const Color(0xFF454545) : const Color(0xFF454545),
            ),
          ),
        ),
      ),
    );
  }
}