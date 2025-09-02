import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TutorialPage extends StatefulWidget {
  final String videoUrl;
  final String category;
  final String markdownText;
  final int totalPages;
  final int currentPageIndex;

  const TutorialPage({
    super.key,
    required this.videoUrl,
    required this.category,
    required this.markdownText,
    required this.totalPages,
    required this.currentPageIndex,
  });

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      _controller.play();
      _controller.setLooping(true);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height * 0.05),
          Container(
            color: Colors.transparent,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
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
              ],
            ),
          ),
          SizedBox(height: height * 0.01),
          Text(
            "Cara Cek Kesehatan Anak",
            style: GoogleFonts.poppins(
              fontSize: width * 0.05,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: height*0.01,),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _controller.value.isPlaying ? _controller.pause() : _controller.play();
                            });
                          },
                          child: Icon(
                            _controller.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                            color: Colors.white.withOpacity(0.7),
                            size: 50.0,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9FC86A)),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          SizedBox(height: height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Langkah ${widget.currentPageIndex + 1}/${widget.totalPages}",
                style: GoogleFonts.poppins(
                  fontSize: width * 0.035,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                widget.category,
                style: GoogleFonts.poppins(
                  fontSize: width * 0.035,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.01),
          LinearProgressIndicator(
            minHeight: height * 0.012,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            value: (widget.currentPageIndex + 1) / widget.totalPages,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF9FC86A)),
          ),
          SizedBox(height: height * 0.015),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Markdown(
                data: widget.markdownText,
                styleSheet: MarkdownStyleSheet(
                  p: GoogleFonts.poppins(
                    fontSize: width * 0.035,
                    color: Colors.black87,
                  ),
                  h1: GoogleFonts.poppins(
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  h2: GoogleFonts.poppins(
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  strong: GoogleFonts.poppins(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
