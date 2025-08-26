import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/util/color_resources.dart';

class ErrorWidgetapp extends StatelessWidget {
  const ErrorWidgetapp({
    super.key,
    required this.image,
    required this.text,
  });
  final String image;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 100,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "We’re usually a treasure chest of knowledge, but we couldn’t  what you’re looking for.",
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 15,
                color: ColorResources.textblack,
              ),
            )
          ],
        ),
      ),
    );
  }
}
