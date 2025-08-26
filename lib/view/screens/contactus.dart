import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  Size get preferredSize => const Size.fromHeight(400.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(children: [
            CustomPaint(
              painter: MyPainter(),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.35,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: ColorResources.textWhite,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CachedNetworkImage(
                      imageUrl: SvgImages.aboutLogo,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      height: 80,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      Languages.feelfree,
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: Languages.isEnglish ? 30 : 15,
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
                  height: MediaQuery.of(context).size.height * 0.40,
                ),
                Text(
                  Languages.freeMessage,
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    width: MediaQuery.of(context).size.width * 0.80,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(color: ColorResources.gray),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        CachedNetworkImage(
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    imageUrl:
                          SvgImages.email,
                          height: 30,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          Languages.emailText,
                          style: GoogleFonts.notoSansDevanagari(
                            fontSize: 20,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            launchUrl(
                                Uri(
                                  scheme: 'mailto',
                                  path: 'info@upschindi.online',
                                  query: 'subject=helpandsupport&body=msg',
                                ),
                                mode: LaunchMode.externalApplication);
                          },
                          child: Text(
                            'info@upschindi.online',
                            style: GoogleFonts.notoSansDevanagari(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          Languages.phoneText,
                          style: GoogleFonts.notoSansDevanagari(
                            fontSize: 20,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            launchUrl(Uri.parse("tel:+919519780078"));
                          },
                          child: Text(
                            '+91  951 978 0078',
                            style: GoogleFonts.notoSansDevanagari(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => launchUrl(Uri.parse('https://www.wa.me/+919519780078'), mode: LaunchMode.externalApplication),
                          child: CachedNetworkImage(
                            height: 70,
                            imageUrl: SvgImages.whatsappbackgroung,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        ),
                        Text(Languages.whatsApp),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity * 0.40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    launchUrl(Uri.parse("https://www.facebook.com/UPSCHINDI4CSE"), mode: LaunchMode.externalApplication);
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: SvgImages.facebook,
                                    height: 30,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  )),
                              GestureDetector(
                                onTap: () {
                                  launchUrl(Uri.parse("https://twitter.com/upschindi4cse"), mode: LaunchMode.externalApplication);
                                },
                                child: CachedNetworkImage(
                                  imageUrl: SvgImages.twitter,
                                  height: 30,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  launchUrl(Uri.parse("https://www.instagram.com/upschindi4cse"), mode: LaunchMode.externalApplication);
                                },
                                child: CachedNetworkImage(
                                  imageUrl: SvgImages.instagram,
                                  height: 30,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    // Path number 1

    paint.color = ColorResources.buttoncolor;
    path = Path();
    path.lineTo(size.width, 0);
    path.cubicTo(size.width, 0, 0, 0, 0, 0);
    path.cubicTo(0, 0, 0, size.height * 0.76, 0, size.height * 0.76);
    path.cubicTo(size.width / 4, size.height * 1.1, size.width * 0.79, size.height * 1.05, size.width, size.height * 0.76);
    path.cubicTo(size.width, size.height * 0.76, size.width, 0, size.width, 0);
    path.cubicTo(size.width, 0, size.width, 0, size.width, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
