import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/models/my_courses_model.dart';
import 'package:url_launcher/url_launcher.dart';

class LectureInfoScreen extends StatelessWidget {
  const LectureInfoScreen({super.key, required this.lecture});
  final LectureDetails lecture;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            left: 15.0,
            right: 15.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lecture.lectureTitle!,
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 16,
                ),
              ),
              Text(
                "By :${lecture.teacher?.fullName ?? ""}",
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 14,
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Html(
                      data: lecture.description!,
                      onAnchorTap: (url, attributes, element) {
                        Uri openurl = Uri.parse(url!);
                        launchUrl(
                          openurl,
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
