import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sd_campus_app/util/color_resources.dart';

class ProgressbarWidget extends StatelessWidget {
  final double percent;
  final String center;
  final String footer;
  final double radius;
  const ProgressbarWidget({
    super.key,
    required this.percent,
    required this.center,
    required this.footer,
    required this.radius,
  });
  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      backgroundColor: Colors.grey.withValues(alpha: 0.25),
      radius: radius, //  MediaQuery.of(context).size.width * 0.10,
      lineWidth: 8.0,
      animation: true,
      percent: percent,
      animationDuration: 1000,
      center: Text(
        center,
        style: GoogleFonts.notoSansDevanagari(fontWeight: FontWeight.bold, fontSize: 10.0),
      ),
      footer: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          footer,
          style: GoogleFonts.notoSansDevanagari(fontWeight: FontWeight.bold, fontSize: 12.0),
        ),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: ColorResources.buttoncolor,
    );
  }
}
