import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/util/appstring.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/payment_status.dart';
import 'package:sd_campus_app/util/pdf_render.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/e_book/ebook_all_review.dart';
import 'package:sd_campus_app/view/screens/e_book/ebook_checkout_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class EBookDetailScreen extends StatelessWidget {
  final String id;
  final bool isPaid;
  const EBookDetailScreen({
    super.key,
    required this.id,
    this.isPaid = false,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: RemoteDataSourceImpl().getEbookByIdRequest(id: id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      snapshot.data?.data?.title ?? "",
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    actions: [
                      if (snapshot.data?.data?.shareLink?.text != null)
                        IconButton(
                          onPressed: () {
                            try {
                              Share.share("${snapshot.data?.data?.shareLink?.text ?? ""}\n${snapshot.data?.data?.shareLink?.link ?? ""}");
                            } catch (e) {
                              // print(e);
                            }
                          },
                          icon: const Icon(Icons.share),
                        )
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: snapshot.data?.data?.featuredImage ?? "",
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                        //  ImageSlidePreviewWidget(
                        //   isImageindex: false,
                        //   images: [
                        //     "https://d1mbj426mo5twu.cloudfront.net/Batches/Combo_Batch_%28JNV_%7C%7C_Sainik_%7C%7C_RMS_%7C%7C_RIMC%29_Entrance_Exam_Two_Year_Program_For_Class_6/Combo_Batch_%28JNV_%7C%7C_Sainik_%7C%7C_RMS_%7C%7C_RIMC%29_Entrance_Exam_Two_Year_Program_For_Class_6_1717151176.jpeg",
                        //     "https://d1mbj426mo5twu.cloudfront.net/Batches/UP%20POLICE%202023-24%20Radio/%20able/%20SI/%20ASI%20%E0%A4%96%E0%A5%8D%E0%A4%B5%E0%A4%BE%E0%A4%AC%20Batch%20%28%E0%A4%85%E0%A4%AC%20%E0%A4%B9%E0%A4%B0%20%E0%A4%B8%E0%A4%AA%E0%A4%A8%E0%A4%BE%20%E0%A4%B9%E0%A5%8B%E0%A4%97%E0%A4%BE%20%E0%A4%B8%E0%A4%BE%E0%A4%95%E0%A4%BE%E0%A4%B0%29%20/khawab_1716962778.jpg",
                        //     "https://d1mbj426mo5twu.cloudfront.net/Batches/Combo_Batch_%28JNV_%7C%7C_Sainik_%7C%7C_RMS_%7C%7C_RIMC%29_Entrance_Exam_Two_Year_Program_For_Class_6/Combo_Batch_%28JNV_%7C%7C_Sainik_%7C%7C_RMS_%7C%7C_RIMC%29_Entrance_Exam_Two_Year_Program_For_Class_6_1717151176.jpeg",
                        //     "https://d1mbj426mo5twu.cloudfront.net/Batches/UP%20POLICE%202023-24%20Radio/%20able/%20SI/%20ASI%20%E0%A4%96%E0%A5%8D%E0%A4%B5%E0%A4%BE%E0%A4%AC%20Batch%20%28%E0%A4%85%E0%A4%AC%20%E0%A4%B9%E0%A4%B0%20%E0%A4%B8%E0%A4%AA%E0%A4%A8%E0%A4%BE%20%E0%A4%B9%E0%A5%8B%E0%A4%97%E0%A4%BE%20%E0%A4%B8%E0%A4%BE%E0%A4%95%E0%A4%BE%E0%A4%B0%29%20/khawab_1716962778.jpg",
                        //     "https://d1mbj426mo5twu.cloudfront.net/Batches/Combo_Batch_%28JNV_%7C%7C_Sainik_%7C%7C_RMS_%7C%7C_RIMC%29_Entrance_Exam_Two_Year_Program_For_Class_6/Combo_Batch_%28JNV_%7C%7C_Sainik_%7C%7C_RMS_%7C%7C_RIMC%29_Entrance_Exam_Two_Year_Program_For_Class_6_1717151176.jpeg",
                        //     "https://d1mbj426mo5twu.cloudfront.net/Batches/UP%20POLICE%202023-24%20Radio/%20able/%20SI/%20ASI%20%E0%A4%96%E0%A5%8D%E0%A4%B5%E0%A4%BE%E0%A4%AC%20Batch%20%28%E0%A4%85%E0%A4%AC%20%E0%A4%B9%E0%A4%B0%20%E0%A4%B8%E0%A4%AA%E0%A4%A8%E0%A4%BE%20%E0%A4%B9%E0%A5%8B%E0%A4%97%E0%A4%BE%20%E0%A4%B8%E0%A4%BE%E0%A4%95%E0%A4%BE%E0%A4%B0%29%20/khawab_1716962778.jpg",
                        //     "https://d1mbj426mo5twu.cloudfront.net/Batches/Combo_Batch_%28JNV_%7C%7C_Sainik_%7C%7C_RMS_%7C%7C_RIMC%29_Entrance_Exam_Two_Year_Program_For_Class_6/Combo_Batch_%28JNV_%7C%7C_Sainik_%7C%7C_RMS_%7C%7C_RIMC%29_Entrance_Exam_Two_Year_Program_For_Class_6_1717151176.jpeg",
                        //     "https://d1mbj426mo5twu.cloudfront.net/Batches/UP%20POLICE%202023-24%20Radio/%20able/%20SI/%20ASI%20%E0%A4%96%E0%A5%8D%E0%A4%B5%E0%A4%BE%E0%A4%AC%20Batch%20%28%E0%A4%85%E0%A4%AC%20%E0%A4%B9%E0%A4%B0%20%E0%A4%B8%E0%A4%AA%E0%A4%A8%E0%A4%BE%20%E0%A4%B9%E0%A5%8B%E0%A4%97%E0%A4%BE%20%E0%A4%B8%E0%A4%BE%E0%A4%95%E0%A4%BE%E0%A4%B0%29%20/khawab_1716962778.jpg",
                        //     "https://d1mbj426mo5twu.cloudfront.net/Batches/Combo_Batch_%28JNV_%7C%7C_Sainik_%7C%7C_RMS_%7C%7C_RIMC%29_Entrance_Exam_Two_Year_Program_For_Class_6/Combo_Batch_%28JNV_%7C%7C_Sainik_%7C%7C_RMS_%7C%7C_RIMC%29_Entrance_Exam_Two_Year_Program_For_Class_6_1717151176.jpeg",
                        //     "https://d1mbj426mo5twu.cloudfront.net/Batches/UP%20POLICE%202023-24%20Radio/%20able/%20SI/%20ASI%20%E0%A4%96%E0%A5%8D%E0%A4%B5%E0%A4%BE%E0%A4%AC%20Batch%20%28%E0%A4%85%E0%A4%AC%20%E0%A4%B9%E0%A4%B0%20%E0%A4%B8%E0%A4%AA%E0%A4%A8%E0%A4%BE%20%E0%A4%B9%E0%A5%8B%E0%A4%97%E0%A4%BE%20%E0%A4%B8%E0%A4%BE%E0%A4%95%E0%A4%BE%E0%A4%B0%29%20/khawab_1716962778.jpg",
                        //     "https://d1mbj426mo5twu.cloudfront.net/Batches/Combo_Batch_%28JNV_%7C%7C_Sainik_%7C%7C_RMS_%7C%7C_RIMC%29_Entrance_Exam_Two_Year_Program_For_Class_6/Combo_Batch_%28JNV_%7C%7C_Sainik_%7C%7C_RMS_%7C%7C_RIMC%29_Entrance_Exam_Two_Year_Program_For_Class_6_1717151176.jpeg",
                        //   ],
                        // ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MediaQuery.removePadding(
                                context: context,
                                removeBottom: true,
                                removeTop: true,
                                child: Html(
                                  data: snapshot.data?.data?.description ?? "",
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              StaggeredGrid.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.document_scanner_outlined,
                                            color: ColorResources.buttoncolor,
                                          )),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        Preferences.appString.studyMaterial ?? 'Study Materials',
                                        style: const TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.history_edu_outlined,
                                            color: ColorResources.buttoncolor,
                                          )),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        Preferences.appString.lattestPattern ?? 'Latest Pattern',
                                        style: const TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.local_library_outlined,
                                            color: ColorResources.buttoncolor,
                                          )),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        Preferences.appString.selfPacedLearning ?? 'Self Paced Learning',
                                        style: const TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.mobile_friendly_rounded,
                                            color: ColorResources.buttoncolor,
                                          )),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        Preferences.appString.devicesCompatible ?? 'Device Compatibility',
                                        style: const TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                Preferences.appString.freeDemoEbooks ?? 'Free Demo E-Books',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              ListView.builder(
                                  itemCount: snapshot.data?.data?.samplePdfs?.length ?? 0,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PdfRenderScreen(
                                              isoffline: false,
                                              filePath: snapshot.data?.data?.samplePdfs?[index].fileLoc ?? "",
                                              name: snapshot.data?.data?.samplePdfs?[index].name ?? "",
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(vertical: 5),
                                        padding: const EdgeInsets.all(11),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0x29000000),
                                              blurRadius: 5,
                                              offset: Offset(0, 2), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.picture_as_pdf_outlined,
                                              color: ColorResources.buttoncolor,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                snapshot.data?.data?.samplePdfs?[index].name?.replaceAll("_", "") ?? "",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Color(0xFF333333),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  height: 0,
                                                ),
                                              ),
                                            ),
                                            Icon(Icons.remove_red_eye_outlined, color: ColorResources.buttoncolor),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          Preferences.appString.reviews ?? 'Reviews',
                                          style: TextStyle(
                                            color: ColorResources.textblack,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            height: 0,
                                          ),
                                        ),
                                        if (snapshot.data?.data?.reviews?.isNotEmpty ?? false)
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (context) => EbookAllReviewScreen(
                                                          id: snapshot.data?.data?.id ?? "",
                                                        )));
                                              },
                                              child: Text(
                                                Preferences.appString.showAllReviews ?? 'Show All Review',
                                                style: TextStyle(
                                                  color: ColorResources.buttoncolor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  height: 0,
                                                ),
                                              ))
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                  IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        snapshot.data?.data?.averageRating ?? "",
                                                        style: GoogleFonts.notoSansDevanagari(
                                                          color: ColorResources.textblack,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.star,
                                                        color: ColorResources.buttoncolor,
                                                      )
                                                    ],
                                                  ),
                                                  Text(
                                                    '${snapshot.data?.data?.totalRatings} ratings and ${snapshot.data?.data?.totalReviews} reviews',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.notoSansDevanagari(
                                                      color: ColorResources.textblack,
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  if (isPaid)
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: ColorResources.buttoncolor,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        double userRating = 0.0;
                                                        TextEditingController controllerDescripation = TextEditingController();
                                                        showModalBottomSheet(
                                                            context: context,
                                                            isScrollControlled: true,
                                                            builder: (context) => StatefulBuilder(
                                                                  builder: (context, safeSetState) {
                                                                    return Padding(
                                                                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                      child: Column(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          const SizedBox(
                                                                            height: 10,
                                                                          ),
                                                                          Center(
                                                                            child: Text(
                                                                              "Write a Review",
                                                                              style: TextStyle(
                                                                                color: ColorResources.textblack,
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const Divider(),
                                                                          Padding(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                            child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  "Rate this E-Book",
                                                                                  style: TextStyle(
                                                                                    color: ColorResources.textblack,
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                ),
                                                                                RatingBar.builder(
                                                                                  initialRating: 0,
                                                                                  minRating: 1,
                                                                                  direction: Axis.horizontal,
                                                                                  allowHalfRating: false,
                                                                                  itemCount: 5,
                                                                                  // itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                                                  itemBuilder: (context, _) => const Icon(
                                                                                    Icons.star,
                                                                                    color: Colors.amber,
                                                                                  ),
                                                                                  onRatingUpdate: (rating) {
                                                                                    userRating = rating;
                                                                                  },
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                Text(
                                                                                  'Add detailed Review',
                                                                                  style: TextStyle(
                                                                                    color: ColorResources.textblack,
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                TextField(
                                                                                  controller: controllerDescripation,
                                                                                  maxLines: 3,
                                                                                  decoration: InputDecoration(
                                                                                    border: OutlineInputBorder(
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                    ),
                                                                                    hintText: 'Write here....',
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    Expanded(
                                                                                      child: ElevatedButton(
                                                                                          onPressed: () {
                                                                                            if (controllerDescripation.text.isNotEmpty) {
                                                                                              Preferences.onLoading(context);
                                                                                              RemoteDataSourceImpl().postEbookReviewRequest(ebookid: snapshot.data?.data?.id ?? "", rating: userRating.toInt(), title: controllerDescripation.text).then((value) {
                                                                                                flutterToast(value.msg);
                                                                                                Navigator.of(context).pop();
                                                                                                Navigator.of(context).pop();
                                                                                              });
                                                                                            } else {
                                                                                              flutterToast('Please write a review');
                                                                                            }
                                                                                          },
                                                                                          style: ElevatedButton.styleFrom(
                                                                                            backgroundColor: ColorResources.buttoncolor,
                                                                                            shape: RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                            ),
                                                                                          ),
                                                                                          child: Text(
                                                                                            'Submit',
                                                                                            style: TextStyle(color: ColorResources.textWhite),
                                                                                          )),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                ));
                                                      },
                                                      child: Text(
                                                        'Write a review'.toTitleCase(),
                                                        style: TextStyle(
                                                          color: ColorResources.textWhite,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const VerticalDivider(),
                                        // (snapshot.data?.data?.totalRatings ?? 0) == 0
                                        //     ? Container()
                                        //     :
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      '5',
                                                      textAlign: TextAlign.center,
                                                      style: GoogleFonts.notoSansDevanagari(
                                                        color: ColorResources.textblack,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                        height: 0,
                                                      ),
                                                    ),
                                                    const Icon(Icons.star),
                                                    Expanded(
                                                      child: LinearProgressIndicator(
                                                        value: snapshot.data?.data?.totalRatings == 0 ? 0 : (((snapshot.data?.data?.ratingCounts?.i5 ?? 1) / (snapshot.data?.data?.totalRatings ?? 1)) * 100) / 100,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      snapshot.data?.data?.ratingCounts?.i5?.toString() ?? "0",
                                                      textAlign: TextAlign.center,
                                                      style: GoogleFonts.notoSansDevanagari(
                                                        color: ColorResources.textblack,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                        height: 0,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '4',
                                                      textAlign: TextAlign.center,
                                                      style: GoogleFonts.notoSansDevanagari(
                                                        color: ColorResources.textblack,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                        height: 0,
                                                      ),
                                                    ),
                                                    const Icon(Icons.star),
                                                    Expanded(
                                                      child: LinearProgressIndicator(
                                                        value: snapshot.data?.data?.totalRatings == 0 ? 0 : (((snapshot.data?.data?.ratingCounts?.i4 ?? 1) / (snapshot.data?.data?.totalRatings ?? 1)) * 100) / 100,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      snapshot.data?.data?.ratingCounts?.i4.toString() ?? "0",
                                                      textAlign: TextAlign.center,
                                                      style: GoogleFonts.notoSansDevanagari(
                                                        color: ColorResources.textblack,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                        height: 0,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '3',
                                                      textAlign: TextAlign.center,
                                                      style: GoogleFonts.notoSansDevanagari(
                                                        color: ColorResources.textblack,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                        height: 0,
                                                      ),
                                                    ),
                                                    const Icon(Icons.star),
                                                    Expanded(
                                                      child: LinearProgressIndicator(
                                                        value: snapshot.data?.data?.totalRatings == 0 ? 0 : (((snapshot.data?.data?.ratingCounts?.i3 ?? 1) / (snapshot.data?.data?.totalRatings ?? 1)) * 100) / 100,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      snapshot.data?.data?.ratingCounts?.i3.toString() ?? "0",
                                                      textAlign: TextAlign.center,
                                                      style: GoogleFonts.notoSansDevanagari(
                                                        color: ColorResources.textblack,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                        height: 0,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '2',
                                                      textAlign: TextAlign.center,
                                                      style: GoogleFonts.notoSansDevanagari(
                                                        color: ColorResources.textblack,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                        height: 0,
                                                      ),
                                                    ),
                                                    const Icon(Icons.star),
                                                    Expanded(
                                                      child: LinearProgressIndicator(
                                                        value: snapshot.data?.data?.totalRatings == 0 ? 0 : (((snapshot.data?.data?.ratingCounts?.i2 ?? 1) / (snapshot.data?.data?.totalRatings ?? 1)) * 100) / 100,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      snapshot.data?.data?.ratingCounts?.i2.toString() ?? "0",
                                                      textAlign: TextAlign.center,
                                                      style: GoogleFonts.notoSansDevanagari(
                                                        color: ColorResources.textblack,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                        height: 0,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '1',
                                                      textAlign: TextAlign.center,
                                                      style: GoogleFonts.notoSansDevanagari(
                                                        color: ColorResources.textblack,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                        height: 0,
                                                      ),
                                                    ),
                                                    const Icon(Icons.star),
                                                    Expanded(
                                                      child: LinearProgressIndicator(
                                                        value: snapshot.data?.data?.totalRatings == 0 ? 0 : (((snapshot.data?.data?.ratingCounts?.i1 ?? 1) / (snapshot.data?.data?.totalRatings ?? 1)) * 100).toDouble(),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      snapshot.data?.data?.ratingCounts?.i1.toString() ?? "0",
                                                      textAlign: TextAlign.center,
                                                      style: GoogleFonts.notoSansDevanagari(
                                                        color: ColorResources.textblack,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                        height: 0,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  snapshot.data?.data?.reviews?.isEmpty ?? true
                                      ? Container(
                                          height: 5,
                                        )
                                      : const Divider(),
                                  Scrollbar(
                                    // thumbVisibility: true,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: (snapshot.data?.data?.reviews?.length ?? 0) >= 5 ? 5 : snapshot.data?.data?.reviews?.length ?? 0,
                                      itemBuilder: (context, index) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                                                  decoration: BoxDecoration(
                                                    color: ColorResources.buttoncolor,
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.star,
                                                        color: Colors.white,
                                                        size: 12,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        (snapshot.data?.data?.reviews?[index].rating ?? "").toString(),
                                                        textAlign: TextAlign.center,
                                                        style: GoogleFonts.notoSansDevanagari(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  snapshot.data?.data?.reviews?[index].user?.name ?? "",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.notoSansDevanagari(
                                                    color: ColorResources.textblack,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              snapshot.data?.data?.reviews?[index].title ?? "",
                                              style: GoogleFonts.notoSansDevanagari(
                                                color: ColorResources.textBlackSec,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                height: 0,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      separatorBuilder: (context, index) => const Divider(),
                                    ),
                                  )
                                ]),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                // margin:  EdgeInsets.symmetric(
                                //   horizontal: 15,
                                // ),
                                decoration: BoxDecoration(
                                  color: ColorResources.textWhite,
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorResources.borderColor,
                                      blurRadius: 55,
                                      offset: const Offset(0, 4),
                                      spreadRadius: 0,
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          Preferences.appString.needOurHelp ?? 'Need Our Help?',
                                          style: TextStyle(
                                            color: ColorResources.textblack,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            height: 0,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        OutlinedButton(
                                          onPressed: () {
                                            launchUrl(Uri.parse("tel:${Preferences.remoteSocial["number"]}"));
                                          },
                                          style: OutlinedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            side: BorderSide(
                                              color: ColorResources.buttoncolor,
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.ring_volume_outlined,
                                                color: ColorResources.buttoncolor,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                '${Preferences.appString.call ?? 'Call'} ${Preferences.remoteSocial["number"]}',
                                                style: TextStyle(
                                                  color: ColorResources.buttoncolor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: ColorResources.buttoncolor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () {
                                            // https://api.whatsapp.com/send/?phone=7428394519&text&type=phone_number&app_absent=0
                                            launchUrl(
                                              Uri.parse("https://wa.me/${Preferences.remoteSocial["whatsAppNumber"]}"),
                                              mode: LaunchMode.externalApplication,
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              CachedNetworkImage(
                                                placeholder: (context, url) => const Center(
                                                  child: CircularProgressIndicator(),
                                                ),
                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                                imageUrl: SvgImages.whatsapp,
                                                height: 25,
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                Preferences.appString.chatOnWhatsApp ?? 'Chat on WhatsApp',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: ColorResources.textWhite,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: CachedNetworkImage(
                                          placeholder: (context, url) => const Center(
                                                child: CircularProgressIndicator(),
                                              ),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                          imageUrl: SvgImages.helpandsupport),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottomNavigationBar: isPaid
                      ? null
                      : BottomAppBar(
                          color: ColorResources.textWhite,
                          surfaceTintColor: ColorResources.textWhite,
                          child: Row(
                            children: [
                              int.parse(snapshot.data!.data?.salePrice ?? "0") == 0
                                  ? const Text(
                                      "Free",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 18,
                                      ),
                                    )
                                  : Text.rich(
                                      TextSpan(children: [
                                        TextSpan(
                                          text: '₹${snapshot.data?.data?.salePrice ?? "0"}  ',
                                          style: TextStyle(
                                            color: ColorResources.textblack,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '₹ ${snapshot.data?.data?.regularPrice ?? "0"}\n',
                                          style: TextStyle(
                                            color: ColorResources.textBlackSec,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                        TextSpan(
                                          text: int.parse(snapshot.data!.data!.salePrice!) < int.parse(snapshot.data!.data!.regularPrice!) && int.parse(snapshot.data!.data!.salePrice ?? "0") != 0 ? "(${(((int.parse(snapshot.data!.data?.regularPrice ?? "0") - int.parse(snapshot.data!.data?.salePrice ?? "0")) / int.parse(snapshot.data!.data?.regularPrice ?? "0")) * 100).toString().split('.').first}% OFF)" : "",
                                          // :
                                          // "200% Off",
                                          style: const TextStyle(
                                            color: Color(0xFF1D7025),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ]),
                                    ),
                              const Spacer(),
                              // if (!(snapshot.data?.isPurchase ?? true))
                              Expanded(
                                  flex: 2,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorResources.buttoncolor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (int.parse(snapshot.data?.data?.salePrice ?? "0") <= 0) {
                                          RemoteDataSourceImpl().postFreePaymentEbookRequest(ebookid: snapshot.data?.data?.id ?? "").then((value) {
                                            if (value.status == true) {
                                              paymentstatus(context: context, ispaided: true, paymentfor: "ebook");
                                              // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  MyEbookScreen()));
                                            } else {
                                              flutterToast(value.msg);
                                            }
                                          });
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => EbookCheckoutScreen(
                                                        salePrice: double.parse(snapshot.data?.data?.salePrice ?? "0"),
                                                        originalPrice: double.parse(snapshot.data?.data?.regularPrice ?? "0"),
                                                        bookName: snapshot.data?.data?.title ?? "",
                                                        bookId: snapshot.data?.data?.id ?? "",
                                                      )));
                                        }

                                        // callApiaddtocart(course.data!.batchDetails!.sId!);
                                      },
                                      child: Text(
                                        Preferences.appString.buyNow ?? 'Buy Now', //Languages.addtocart,
                                        style: GoogleFonts.notoSansDevanagari(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: ColorResources.textWhite,
                                        ),
                                      ))),
                            ],
                          ),
                        ),
                );
              } else {
                return Scaffold(body: ErrorWidgetapp(image: SvgImages.error404, text: "Page not found"));
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
