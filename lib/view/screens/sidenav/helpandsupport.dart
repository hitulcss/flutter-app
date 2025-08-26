import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/presentation/widgets/cus_player.dart';
import 'package:sd_campus_app/models/gethelp_and_support.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/const/help_and_support.dart';
import 'package:sd_campus_app/util/enum/playertype.dart';
import 'package:sd_campus_app/util/extenstions/string_extenstions.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/sidenav/faq_list.dart';
import 'package:sd_campus_app/view/screens/sidenav/help_videos.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorResources.textblack),
        backgroundColor: Colors.white,
        title: Text(
          Preferences.appString.helpAndSupport ?? Languages.helpAndSupport,
          style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack),
        ),
        elevation: 0,
      ),
      body: FutureBuilder(
        initialData: GetNeedHelp.fromMap(helpAndSupport),
        future: RemoteDataSourceImpl().getHelpandSupportRequest(),
        builder: (context, snapshot) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              spacing: 10,
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: ColorResources.borderColor),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      if ((snapshot.data?.data?.videos?.isNotEmpty ?? false))
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Recommended Videos",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: ColorResources.textblack,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => HelpVideosList(
                                      videos: snapshot.data?.data?.videos ?? [],
                                    ),
                                  ));
                                },
                                child: Text(
                                  "View All",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: ColorResources.buttoncolor,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      Divider(),
                      SizedBox(
                        height: 150,
                        child: ListView.separated(
                          itemCount: snapshot.data?.data?.videos?.length ?? 0,
                          padding: EdgeInsets.only(
                            left: 10,
                          ),
                          separatorBuilder: (context, index) => const SizedBox(
                            width: 5,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => Container(
                            padding: EdgeInsets.all(5),
                            constraints: BoxConstraints(
                              maxWidth: 200,
                            ),
                            decoration: BoxDecoration(
                              // color: Colors.white10,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: ColorResources.borderColor),
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                        child: CuPlayerScreen(
                                          canpop: true,
                                          playerType: (snapshot.data?.data?.videos?[index].type ?? "yt") == "yt" ? PlayerType.youtube : PlayerType.network,
                                          url: snapshot.data?.data?.videos?[index].url ?? "",
                                          wallpaper: snapshot.data?.data?.videos?[index].banner ?? SvgImages.aboutLogo,
                                          isLive: false,
                                          autoPLay: true,
                                          children: [],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 200,
                                    constraints: BoxConstraints(
                                      minHeight: 100,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: ColorResources.textWhite,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          snapshot.data?.data?.videos?[index].banner ?? SvgImages.aboutLogo,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: ColorResources.borderColor,
                                      //     blurRadius: 55,
                                      //     spreadRadius: 0,
                                      //     offset: Offset(0, 4),
                                      //   )
                                      // ]
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      snapshot.data?.data?.videos?[index].title ?? "Context",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: ColorResources.textblack,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: ColorResources.borderColor),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          Text(
                            "Need Help?",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: ColorResources.textblack),
                          ),
                          Text(
                            "Related to any of the below Query:",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ColorResources.textblack),
                          ),
                        ],
                      ).paddingAll(10),
                      Divider(),
                      HelpList(needHelp: snapshot.data?.data?.needHelp ?? []),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: ColorResources.borderColor),
                    color: Colors.white,
                  ),
                  child: Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              "Have any question about the courses purchase",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: ColorResources.textblack,
                              ),
                            ),
                            Text("our expert can answer all your questions."),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        launchUrl(Uri.parse("https://wa.me/${Preferences.remoteSocial["whatsAppNumber"]}"), mode: LaunchMode.externalApplication);
                                      },
                                      child: Row(
                                        children: [
                                          Image.network(
                                            SvgImages.whatsapp,
                                            width: 25,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Chat on WhatsApp",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                Text("Call us"),
                                Icon(
                                  Icons.ring_volume,
                                  size: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    launchUrl(Uri.parse("tel:${Preferences.remoteSocial["number"]}"));
                                  },
                                  child: Text("${Preferences.remoteSocial["number"]}"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Image.network(
                          SvgImages.supportimage,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

//  Column(
//   children: [
//     const SizedBox(
//       height: 50,
//     ),
//     Text(
//       Preferences.appString.helpAndSupportQuote ?? Languages.freeMessage,
//       style: GoogleFonts.notoSansDevanagari(
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//     const SizedBox(
//       height: 30,
//     ),
//     Center(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 30),
//         width: MediaQuery.of(context).size.width * 0.80,
//         decoration: BoxDecoration(
//           shape: BoxShape.rectangle,
//           border: Border.all(color: ColorResources.gray),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           children: [
//             CachedNetworkImage(
//               placeholder: (context, url) => const Center(
//                 child: CircularProgressIndicator(),
//               ),
//               errorWidget: (context, url, error) => const Icon(Icons.error),
//               imageUrl: SvgImages.email,
//               height: 40,
//             ),
//             const SizedBox(height: 10),
//             Text(
//               Languages.emailText,
//               style: GoogleFonts.notoSansDevanagari(
//                 fontSize: 20,
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 launchUrl(Uri(
//                   scheme: 'mailto',
//                   path: 'info@sdcampus.co.in',
//                   query: 'subject=helpandsupport&body=msg',
//                 ));
//               },
//               child: Text(
//                 'info@sdcampus.co.in',
//                 style: GoogleFonts.notoSansDevanagari(
//                   fontSize: 20,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Phone',
//               style: GoogleFonts.notoSansDevanagari(
//                 fontSize: 20,
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 launchUrl(Uri.parse("tel:${Preferences.remoteSocial["number"]}"));
//               },
//               child: Text(
//                 Preferences.remoteSocial["number"],
//                 style: GoogleFonts.notoSansDevanagari(
//                   fontSize: 20,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 5),
//             GestureDetector(
//               onTap: () {
//                 launchUrl(Uri.parse("https://wa.me/${Preferences.remoteSocial["whatsAppNumber"]}"), mode: LaunchMode.externalApplication);
//               },
//               child: CachedNetworkImage(
//                 height: 30,
//                 imageUrl: SvgImages.whatsappbackgroung,
//                 placeholder: (context, url) => const Center(
//                   child: CircularProgressIndicator(),
//                 ),
//                 errorWidget: (context, url, error) => const Icon(Icons.error),
//               ),
//             ),
//             const SizedBox(height: 5),
//             Text(Languages.whatsApp),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity * 0.40,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       launchUrl(Uri.parse(Preferences.remoteSocial["facebook"]), mode: LaunchMode.externalApplication);
//                     },
//                     child: CachedNetworkImage(
//                       imageUrl: SvgImages.facebook,
//                       height: 30,
//                       placeholder: (context, url) => const Center(
//                         child: CircularProgressIndicator(),
//                       ),
//                       errorWidget: (context, url, error) => const Icon(Icons.error),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       launchUrl(Uri.parse(Preferences.remoteSocial["twitter"]), mode: LaunchMode.externalApplication);
//                     },
//                     child: CachedNetworkImage(
//                       imageUrl: SvgImages.twitter,
//                       height: 30,
//                       placeholder: (context, url) => const Center(
//                         child: CircularProgressIndicator(),
//                       ),
//                       errorWidget: (context, url, error) => const Icon(Icons.error),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       launchUrl(Uri.parse(Preferences.remoteSocial["instagram"]), mode: LaunchMode.externalApplication);
//                     },
//                     child: CachedNetworkImage(
//                       imageUrl: SvgImages.instagram,
//                       height: 30,
//                       placeholder: (context, url) => const Center(
//                         child: CircularProgressIndicator(),
//                       ),
//                       errorWidget: (context, url, error) => const Icon(Icons.error),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     )
//   ],
// ),
class HelpList extends StatefulWidget {
  final List<NeedHelp> needHelp;
  const HelpList({super.key, required this.needHelp});

  @override
  State<HelpList> createState() => _HelpListState();
}

class _HelpListState extends State<HelpList> {
  bool isFull = false;
  @override
  void initState() {
    super.initState();
    isFull = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        MediaQuery.removeViewPadding(
          context: context,
          removeBottom: true,
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.needHelp.length > 3 && !isFull ? 3 : widget.needHelp.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) => SizedBox(
              height: 10,
            ),
            itemBuilder: (context, index) => Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: widget.needHelp[index].color?.toColor() ?? Colors.white,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FAQList(
                      title: widget.needHelp[index].key ?? "Title",
                      faqs: widget.needHelp[index].topicName ?? [],
                    ),
                  ));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Image.network(
                            widget.needHelp[index].icon ?? SvgImages.aboutLogo,
                            height: 40,
                            width: 40,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                              widget.needHelp[index].key ?? "Title",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ColorResources.textblack,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => isFull = !isFull),
          child: Text(
            isFull ? "Explore Less" : "Explore More",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ColorResources.buttoncolor,
            ),
          ),
        ),
        SizedBox(
          height: 0.01,
        ),
      ],
    );
  }
}
