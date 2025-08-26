import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/contactus.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: ColorResources.textWhite),
        backgroundColor: ColorResources.buttoncolor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(children: [
            CustomPaint(
              painter: MyPainter(),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.30,
                child: Column(
                  children: [
                    CachedNetworkImage(
                      height: 110,
                      imageUrl: SvgImages.aboutLogo,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Text(
                      //'About US'
                      Preferences.appString.aboutUs ?? Languages.aboutUs,
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 25,
                        color: ColorResources.textWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.33,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    Preferences.remoteAppInfo["about"] ?? "",
                    // "Welcome to SD Empire – a hub dedicated to education, growth, and empowerment. Our ventures – SD Campus, SD School, SD Abroad, SD Media, SD Publication, SD Library, and SD Hostels – shape a brighter future. Join us in creating a global network of educational and creative endeavors, making a positive impact.\n\nExplore our offerings for competitive exam prep, nurturing education, studying abroad, inspiring content, knowledge-packed publications, resourceful library, and comfortable hostels. Our commitment to integrity, innovation, and inclusivity fosters continuous learning.\n\nJoin our family – students, seekers, creatives – let's build a world where dreams come true. Embrace Empowerment, Education, Excellence with SD Empire.\n\nJai Hind- Jai Bharat ",
                    // textAlign: TextAlign.justify,
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
