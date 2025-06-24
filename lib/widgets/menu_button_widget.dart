import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuWidget extends StatelessWidget {
  final String textHeader;
  final String desc;
  final String image;
  final VoidCallback handler;

  const MenuWidget({
    super.key,
    required this.textHeader,
    required this.desc,
    required this.image,
    required this.handler,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.9,
      height: height * 0.17,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
          minimumSize: MaterialStateProperty.all<Size>(
            Size(200, 50),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 238, 238, 238),
          ),
        ),
        onPressed: handler, // Menggunakan handler yang diberikan
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: width * 0.12,
              width: width * 0.12,
              child: Image.asset(
                image,
                fit: BoxFit.contain,
              ),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 142, 196, 56),
                borderRadius: BorderRadius.all(
                  Radius.circular(width * 0.04),
                ),
              ),
            ),
            SizedBox(width: width * 0.05),
            Container(
              width: width * 0.57,
              height: height * 0.16,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    textHeader,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: height * 0.018,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: height * 0.005),
                  Text(
                    desc,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: height * 0.014,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
