import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/ebook/get_my_ebook.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/e_book/ebookdetail.dart';
import 'package:sd_campus_app/view/screens/e_book/my_e_book/myEbookDetail.dart';
import 'package:sd_campus_app/view/screens/home.dart';

class MyEbookScreen extends StatefulWidget {
  const MyEbookScreen({super.key});

  @override
  State<MyEbookScreen> createState() => _MyEbookScreenState();
}

class _MyEbookScreenState extends State<MyEbookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Preferences.appString.myEbooks ?? "My E-Books",
        ),
      ),
      body: FutureBuilder(
          future: RemoteDataSourceImpl().getMyEbookRequest(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return snapshot.data?.data?.isEmpty ?? false
                    ? Center(
                        child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          EmptyWidget(image: SvgImages.noEbooks, text: Preferences.appString.noEbooks ?? "Oho, No Any Found E-Books"),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorResources.buttoncolor,
                                shape: const StadiumBorder(),
                              ),
                              onPressed: () {
                                Navigator.of(context).popUntil((route) => route.isFirst);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const HomeScreen(
                                              index: 3,
                                            )));
                              },
                              child: Text(
                                Preferences.appString.explore ?? "Explore Now",
                                style: TextStyle(color: ColorResources.textWhite),
                              ))
                        ],
                      ))
                    : ListView.builder(
                        itemCount: snapshot.data?.data?.length ?? 0,
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        itemBuilder: (context, index) => card(snapshot.data?.data?[index] ?? GetMyEbooksData()),
                      );
              } else {
                return ErrorWidgetapp(image: SvgImages.error404, text: "Page not found");
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Widget card(GetMyEbooksData getMyEbooksData) {
    return Card(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: CachedNetworkImage(
                imageUrl: getMyEbooksData.banner ?? "",
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getMyEbooksData.title ?? "",
                  style: TextStyle(
                    color: ColorResources.textblack,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 0,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(
                  height: 5,
                ),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF2EBFF),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignOutside,
                              color: ColorResources.buttoncolor.withValues(alpha: 0.3),
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          getMyEbooksData.language == "en" ? "English" : "Hindi",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ColorResources.buttoncolor,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF2EBFF),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignOutside,
                              color: ColorResources.buttoncolor.withValues(alpha: 0.3),
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.book_outlined,
                              size: 15,
                              color: ColorResources.buttoncolor,
                            ),
                            Text(
                              '${getMyEbooksData.chapterCount} ${Preferences.appString.chapters ?? "Chapters"}',
                              style: TextStyle(
                                color: ColorResources.buttoncolor,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  removeBottom: true,
                  child: ListView.builder(
                      itemCount: getMyEbooksData.keyFeatures?.length ?? 0,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Icon(
                              Icons.emoji_objects_outlined,
                              size: 20,
                              color: ColorResources.buttoncolor,
                            ),
                            Expanded(
                                child: Text(
                              getMyEbooksData.keyFeatures?[index] ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: ColorResources.textblack,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            )),
                          ],
                        );
                      }),
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                        child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => EBookDetailScreen(
                              id: getMyEbooksData.ebookId ?? "",
                              isPaid: true,
                            ),
                          ),
                        );
                        // callApiaddtocart(snapshot.data!.data[index].id);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                        side: BorderSide(
                          width: 1,
                          color: ColorResources.buttoncolor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // <-- Radius
                        ),
                      ),
                      child: Text(
                        Preferences.appString.viewDetails ?? 'View Details',
                        style: GoogleFonts.notoSansDevanagari(
                          fontSize: 16,
                          color: ColorResources.buttoncolor,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => MyEBookDetailScreen(
                                id: getMyEbooksData.ebookId ?? "",
                                name: getMyEbooksData.title ?? "",
                              ),
                            ),
                          );
                          // callApiaddtocart(snapshot.data!.data[index].id);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                          backgroundColor: ColorResources.buttoncolor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // <-- Radius
                          ),
                        ),
                        child: Text(
                          Preferences.appString.readNow ?? 'Read Now',
                          style: GoogleFonts.notoSansDevanagari(
                            fontSize: 16,
                            color: ColorResources.textWhite,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
