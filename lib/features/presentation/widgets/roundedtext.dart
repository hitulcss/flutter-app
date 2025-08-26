import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/util/color_resources.dart';

class RounderTextwidget extends StatelessWidget {
  final Color backgroundcolor;
  final String center;
  final Color centertextcolor;
  final String footer;
  const RounderTextwidget({super.key, required this.backgroundcolor, required this.center, required this.centertextcolor, required this.footer});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: MediaQuery.of(context).size.width * 0.12,
          width: MediaQuery.of(context).size.width * 0.12,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: backgroundcolor, borderRadius: BorderRadius.circular(100)),
          child: Text(
            center,
            style: GoogleFonts.notoSansDevanagari(fontWeight: FontWeight.bold, color: centertextcolor, fontSize: 14.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Text(
            footer,
            style: GoogleFonts.notoSansDevanagari(
              color: ColorResources.textblack,
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
        )
      ],
    );
  }
}
