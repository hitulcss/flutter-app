// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sd_campus_app/features/cubit/course_plan/plan_cubit.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart' as rdsi;
import 'package:sd_campus_app/features/data/remote/models/course_details_model.dart' as course_d_m;
import 'package:sd_campus_app/features/data/remote/models/course_details_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/course_video_player.dart';
import 'package:sd_campus_app/features/presentation/widgets/cus_player.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/features/services/payment_fun.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/enum/batch_feature.dart';
import 'package:sd_campus_app/util/enum/before_buy_navig.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/pdf_render.dart';
import 'package:sd_campus_app/util/enum/playertype.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/extenstions/string_extenstions.dart';
import 'package:sd_campus_app/view/screens/bottomnav/course_before_buy/list_of_announcement.dart';
import 'package:sd_campus_app/view/screens/bottomnav/course_before_buy/list_of_subjects.dart';
import 'package:sd_campus_app/view/screens/bottomnav/course_valdity.dart';
import 'package:sd_campus_app/view/screens/bottomnav/ncert.dart';
import 'package:sd_campus_app/view/screens/course/batch_quiz.dart';
import 'package:sd_campus_app/view/screens/course/community/community_tab.dart';
import 'package:sd_campus_app/view/screens/course/courseview.dart';
import 'package:sd_campus_app/view/screens/course/doubt/doubts_tab.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class CoursesDetailsScreens extends StatefulWidget {
  final String courseId;
  const CoursesDetailsScreens({
    super.key,
    required this.courseId,
  });

  @override
  State<CoursesDetailsScreens> createState() => _CoursesDetailsScreensState();
}

class _CoursesDetailsScreensState extends State<CoursesDetailsScreens> with SingleTickerProviderStateMixin {
  List<Widget> image = [];
  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<CoursePlanCubit>().plans.clear();
    context.read<CoursePlanCubit>().getPlan(id: widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<course_d_m.CoursesDetailsModel>(
        future: rdsi.RemoteDataSourceImpl().getCoursesDetails(widget.courseId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              for (var element in snapshot.data?.data?.batchDetails?.banner ?? []) {
                image.add(CachedNetworkImage(
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  imageUrl: element.fileLoc ?? "",
                ));
              }
              return Scaffold(
                // appBar: AppBar(
                //   backgroundColor: ColorResources.textWhite,
                //   iconTheme: IconThemeData(color: ColorResources.textblack),
                //   title: Text(
                //     snapshot.data!.data!.batchDetails!.batchName!,
                //     style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack),
                //   ),
                // ),
                body: _bodyWidget(snapshot.data!),
                bottomNavigationBar: MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  removeTop: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // if (!(snapshot.data?.isPurchase ?? false) && context.read<CoursePlanCubit>().plans.length == 1)
                      //   BlocBuilder<CoursePlanCubit, CoursePlanState>(
                      //     builder: (context, state) {
                      //       return Container(
                      //         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      //         color: ColorResources.buttoncolor.withValues(alpha:0.1),
                      //         child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      //           Text("Batch Validity",
                      //               style: TextStyle(
                      //                 fontSize: 14,
                      //                 color: ColorResources.buttoncolor,
                      //                 fontWeight: FontWeight.w600,
                      //               )),
                      //           Text(
                      //             "${context.read<CoursePlanCubit>().plans.firstWhere((x) => (x.validityId ?? "") == context.read<CoursePlanCubit>().planId, orElse: () => context.read<CoursePlanCubit>().plans.first).month} ${(context.read<CoursePlanCubit>().plans.firstWhere((x) => (x.validityId ?? "") == context.read<CoursePlanCubit>().planId, orElse: () => context.read<CoursePlanCubit>().plans.first).month ?? 0) == 1 ? "Month" : "Months"}",
                      //             style: TextStyle(
                      //               fontSize: 14,
                      //               color: ColorResources.buttoncolor,
                      //               fontWeight: FontWeight.w600,
                      //             ),
                      //           ),
                      //         ]),
                      //       );
                      //     },
                      //   ),
                      if (!(snapshot.data?.isPurchase ?? false) && context.read<CoursePlanCubit>().plans.length > 1)
                        BlocBuilder<CoursePlanCubit, CoursePlanState>(
                          builder: (context, state) {
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              color: ColorResources.buttoncolor.withValues(alpha: 0.1),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text(
                                  "${context.read<CoursePlanCubit>().plans.firstWhere((x) => (x.validityId ?? "") == context.read<CoursePlanCubit>().planId, orElse: () => context.read<CoursePlanCubit>().plans.first).month} ${(context.read<CoursePlanCubit>().plans.firstWhere((x) => (x.validityId ?? "") == context.read<CoursePlanCubit>().planId, orElse: () => context.read<CoursePlanCubit>().plans.first).month ?? 0) == 1 ? "Month" : "Months"}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: ColorResources.textblack,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    showDialog(
                                      context: context,
                                      builder: (context) => Dialog.fullscreen(
                                        child: CourseValdityScreen(
                                          value: context.read<CoursePlanCubit>().plans,
                                          batchName: snapshot.data?.data?.batchDetails?.batchName ?? "",
                                          data: snapshot.data!.data!.batchDetails!,
                                          isCheckOut: false,
                                          isEnroll: false,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Transform.rotate(
                                        angle: -0.70,
                                        child: Icon(
                                          Icons.sync_alt,
                                          size: 16,
                                          color: ColorResources.buttoncolor,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("Change Validity",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: ColorResources.buttoncolor,
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ],
                                  ),
                                )
                              ]),
                            );
                          },
                        ),
                      BottomAppBar(
                        color: ColorResources.textWhite,
                        surfaceTintColor: ColorResources.textWhite,
                        child: (snapshot.data?.isPurchase ?? false)
                            ? Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorResources.buttoncolor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          Navigator.of(context).pushReplacement(
                                            CupertinoPageRoute(
                                              builder: (context) => CourseViewScreen(
                                                batchId: snapshot.data?.data?.batchDetails?.sId ?? "",
                                                courseName: snapshot.data?.data?.batchDetails?.batchName ?? "",
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Let’s Study', //Languages.addtocart,
                                          style: GoogleFonts.notoSansDevanagari(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: ColorResources.textWhite,
                                          ),
                                        )),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  int.parse(snapshot.data!.data?.batchDetails?.discount ?? "0") == 0
                                      ? const Text(
                                          "Free",
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 18,
                                          ),
                                        )
                                      : context.read<CoursePlanCubit>().plans.isEmpty
                                          ? Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text.rich(
                                                  TextSpan(children: [
                                                    TextSpan(
                                                      text: '₹ ${snapshot.data?.data?.batchDetails?.discount ?? 0}  ',
                                                      style: TextStyle(
                                                        color: int.parse(snapshot.data!.data?.batchDetails?.discount ?? "0") == 0 ? ColorResources.greenshad : ColorResources.textblack,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: '₹${snapshot.data?.data?.batchDetails?.charges ?? 0}',
                                                      style: TextStyle(
                                                        color: ColorResources.textBlackSec,
                                                        fontSize: 13,
                                                        decoration: TextDecoration.lineThrough,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                                Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFC1FFB1),
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: Text(
                                                      int.parse(snapshot.data!.data!.batchDetails!.discount!) < int.parse(snapshot.data!.data!.batchDetails!.charges!) && int.parse(snapshot.data!.data!.batchDetails!.discount!) != 0
                                                          // ? (((int.parse(snapshot.data!.data[index].charges) - int.parse(snapshot.data!.data[index].discount)) / int.parse(snapshot.data!.data[index].charges)) * 100) > 0
                                                          ? "${(((int.parse(snapshot.data!.data!.batchDetails!.charges!) - int.parse(snapshot.data!.data!.batchDetails!.discount!)) / int.parse(snapshot.data!.data!.batchDetails!.charges!)) * 100).toString().split('.').first}% OFF"
                                                          // : ""
                                                          : "",
                                                      style: const TextStyle(
                                                        color: Color(0xFF1D7025),
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ))
                                              ],
                                            )
                                          : BlocBuilder<CoursePlanCubit, CoursePlanState>(
                                              builder: (context, state) {
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text.rich(
                                                      TextSpan(children: [
                                                        TextSpan(
                                                          text: '₹ ${context.read<CoursePlanCubit>().plans.firstWhere((x) => (x.validityId) == context.read<CoursePlanCubit>().planId, orElse: () => context.read<CoursePlanCubit>().plans.first).salePrice ?? 0}  ',
                                                          style: TextStyle(
                                                            color: int.parse(snapshot.data!.data?.batchDetails?.discount ?? "0") == 0 ? ColorResources.greenshad : ColorResources.textblack,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: '₹${context.read<CoursePlanCubit>().plans.firstWhere((x) => (x.validityId) == context.read<CoursePlanCubit>().planId, orElse: () => context.read<CoursePlanCubit>().plans.first).regularPrice ?? 0}',
                                                          style: TextStyle(
                                                            color: ColorResources.textBlackSec,
                                                            fontSize: 13,
                                                            decoration: TextDecoration.lineThrough,
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                        ),
                                                      ]),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                                      decoration: BoxDecoration(
                                                        color: Color(0xFFC1FFB1),
                                                        borderRadius: BorderRadius.circular(6),
                                                      ),
                                                      child: Text(
                                                        (context.read<CoursePlanCubit>().plans.firstWhere((x) => (x.validityId) == context.read<CoursePlanCubit>().planId, orElse: () => context.read<CoursePlanCubit>().plans.first).salePrice ?? 0) < (context.read<CoursePlanCubit>().plans.firstWhere((x) => (x.validityId) == context.read<CoursePlanCubit>().planId, orElse: () => context.read<CoursePlanCubit>().plans.first).regularPrice ?? 0) && context.read<CoursePlanCubit>().plans.firstWhere((x) => (x.validityId) == context.read<CoursePlanCubit>().planId, orElse: () => context.read<CoursePlanCubit>().plans.first).salePrice != 0
                                                            // ? (((int.parse(snapshot.data!.data[index].charges) - int.parse(snapshot.data!.data[index].discount)) / int.parse(snapshot.data!.data[index].charges)) * 100) > 0
                                                            ? "${((((context.read<CoursePlanCubit>().plans.firstWhere((x) => (x.validityId) == context.read<CoursePlanCubit>().planId, orElse: () => context.read<CoursePlanCubit>().plans.first).regularPrice ?? 0) - (context.read<CoursePlanCubit>().plans.firstWhere((x) => (x.validityId) == context.read<CoursePlanCubit>().planId, orElse: () => context.read<CoursePlanCubit>().plans.first).salePrice ?? 0)) / (context.read<CoursePlanCubit>().plans.firstWhere((x) => (x.validityId) == context.read<CoursePlanCubit>().planId, orElse: () => context.read<CoursePlanCubit>().plans.first).regularPrice ?? 0)) * 100).toString().split('.').first}% OFF"
                                                            // : ""
                                                            : "",
                                                        style: const TextStyle(
                                                          color: Color(0xFF1D7025),
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                );
                                              },
                                            ),
                                  const Spacer(),
                                  if (!(snapshot.data?.isPurchase ?? true))
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
                                              FocusScope.of(context).unfocus();
                                              Data data = snapshot.data!.data!;
                                              if (context.read<CoursePlanCubit>().plans.isNotEmpty) {
                                                data.batchDetails?.discount = (context.read<CoursePlanCubit>().plans.firstWhere((x) => (x.validityId) == context.read<CoursePlanCubit>().planId, orElse: () => context.read<CoursePlanCubit>().plans.first).salePrice ?? 0).toString();
                                                data.batchDetails?.charges = (context.read<CoursePlanCubit>().plans.firstWhere((x) => (x.validityId) == context.read<CoursePlanCubit>().planId, orElse: () => context.read<CoursePlanCubit>().plans.first).regularPrice ?? 0).toString();
                                              }
                                              buttonOnTap(context: context, data: data.batchDetails!, isEnroll: false);
                                            },
                                            child: Text(
                                              'Buy Now', //Languages.addtocart,
                                              style: GoogleFonts.notoSansDevanagari(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: ColorResources.textWhite,
                                              ),
                                            ))),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Scaffold(
                body: Center(
                    child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ErrorWidgetapp(
                    image: SvgImages.error404,
                    text: "Page not found",
                  ),
                )
                    //Text('Pls Refresh (or) Reopen App'),
                    ),
              );
            }
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  Widget _bodyWidget(course_d_m.CoursesDetailsModel course) {
    analytics.logScreenView(
      screenName: "app_course_details",
      parameters: {
        "batchName": course.data?.batchDetails?.batchName ?? "",
        "id": course.data?.batchDetails?.sId ?? "",
      },
    );
    return SafeArea(
      child: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar.large(
                // forceElevated: true,
                expandedHeight: 230,
                // floating: true,
                // pinned: true,
                // automaticallyImplyLeading: true,
                // snap: true,
                stretch: true,
                leading: IconButton.filledTonal(
                  color: ColorResources.textWhite,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back, color: ColorResources.textblack),
                ),
                actions: [
                  if (course.data?.batchDetails?.shareUrl?.link != null && (course.data?.batchDetails?.shareUrl?.link?.isNotEmpty ?? false))
                    IconButton.filledTonal(
                        onPressed: () {
                          try {
                            FocusScope.of(context).unfocus();
                            Share.share("${course.data?.batchDetails?.shareUrl?.text ?? ""}\n${course.data?.batchDetails?.shareUrl?.link ?? ""}");
                          } catch (e) {
                            // log(e.toString());
                          }
                        },
                        icon: const Icon(
                          Icons.share,
                        ))
                ],
                backgroundColor: ColorResources.textWhite,
                surfaceTintColor: ColorResources.textWhite,
                flexibleSpace: FlexibleSpaceBar(
                  // titlePadding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                  // title:
                  // Container(
                  //   width: double.infinity,
                  //   color: Colors.white,
                  //   child: Text(
                  //     course.data?.batchDetails?.batchName ?? "",
                  //     style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack),
                  //   ),
                  // ),
                  background: Column(
                    children: [
                      carousel_slider.CarouselSlider(
                        items: image,
                        options: carousel_slider.CarouselOptions(
                          height: 140,
                          viewportFraction: 1,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 3),
                          autoPlayAnimationDuration: const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        width: double.infinity,
                        color: ColorResources.textWhite,
                        child: Text(
                          course.data?.batchDetails?.batchName ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.notoSansDevanagari(
                            color: ColorResources.textblack,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                title: Text(
                  course.data?.batchDetails?.batchName ?? "",
                  style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack),
                ),
                bottom: TabBar(
                  tabAlignment: MediaQuery.of(context).size.width <= 400 ? TabAlignment.start : null,
                  isScrollable: MediaQuery.of(context).size.width <= 400 ? true : false,
                  tabs: [
                    Tab(text: Preferences.appString.info ?? 'Info'),
                    Tab(text: Preferences.appString.study ?? 'Study'),
                    Tab(text: Preferences.appString.educators ?? 'Educator`s'),
                    Tab(text: Preferences.appString.fAQs ?? 'FAQ`s'),
                  ],
                  controller: _tabController,
                ),
              )
            ];
          },
          body: TabBarView(controller: _tabController, children: [
            _info(course),
            _Study(course),
            _educator(course),
            _faq(course.data?.batchDetails?.faqs ?? []),
          ]),
        ),
      ),
    );
  }

  Widget _faq(List<GetFaqsData> faqs) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          if (faqs.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                Preferences.appString.fAQs ?? "FAQ's", //'Frequently Asked Questions',
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: faqs.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ExpansionTile(
                  collapsedBackgroundColor: ColorResources.textWhite,
                  shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                  ),
                  backgroundColor: ColorResources.textWhite,
                  title: Text(
                    faqs[index].question ?? "",
                    style: TextStyle(
                      color: ColorResources.textblack,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  expandedAlignment: Alignment.centerLeft,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                      child: Text(
                        faqs[index].answer ?? "",
                        style: TextStyle(
                          color: ColorResources.textblack,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ],
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            // margin: const EdgeInsets.symmetric(
            //   horizontal: 15,
            // ),
            decoration: BoxDecoration(
              color: ColorResources.textWhite,
              boxShadow: [
                BoxShadow(
                  color: ColorResources.borderColor,
                  blurRadius: 10,
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
                            '${Preferences.appString.call ?? "Call"} ${Preferences.remoteSocial["number"]}',
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
    );
  }

  Widget _educator(CoursesDetailsModel course) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      itemCount: course.data?.batchDetails?.teacher?.length ?? 0,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorResources.textWhite,
        ),
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CachedNetworkImage(
                    placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    imageUrl: course.data?.batchDetails?.teacher?[index].profilePhoto ?? ""),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
                color: ColorResources.buttoncolor,
              ),
              child: Column(
                children: [
                  Text(
                    course.data?.batchDetails?.teacher?[index].fullName ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: ColorResources.textWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                  Text(
                    course.data?.batchDetails?.teacher?[index].subject?.map((e) => e.title).toList().join(", ") ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: ColorResources.textWhite,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              backgroundColor: const Color(0xFFF2EBFF),
                              showDragHandle: true,
                              enableDrag: true,
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => Container(
                                constraints: BoxConstraints(
                                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) => Dialog.fullscreen(
                                                              child: Column(
                                                                children: [
                                                                  AppBar(
                                                                    title: Text(course.data?.batchDetails?.teacher?[index].fullName ?? ""),
                                                                  ),
                                                                  Expanded(
                                                                    child: CachedNetworkImage(
                                                                      placeholder: (context, url) => const Center(
                                                                        child: CircularProgressIndicator(),
                                                                      ),
                                                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                      fit: BoxFit.fitWidth,
                                                                      imageUrl: course.data?.batchDetails?.teacher?[index].profilePhoto ?? "",
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ));
                                                  },
                                                  child: CachedNetworkImage(
                                                    placeholder: (context, url) => const Center(
                                                      child: CircularProgressIndicator(),
                                                    ),
                                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                                    imageUrl: course.data?.batchDetails?.teacher?[index].profilePhoto ?? "",
                                                    height: 150,
                                                    width: 150,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        course.data?.batchDetails?.teacher?[index].fullName ?? "",
                                                        style: TextStyle(
                                                          color: ColorResources.textblack,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.school_outlined,
                                                            color: ColorResources.buttoncolor,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              course.data?.batchDetails?.teacher?[index].subject?.map((e) => e.title).toList().join(", ") ?? "",
                                                              style: TextStyle(
                                                                color: ColorResources.buttoncolor,
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(10),
                                        color: ColorResources.textWhite,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              (course.data?.batchDetails?.teacher?[index].demodemoVideo?.isEmpty ?? true)
                                                  ? Container()
                                                  : Text(
                                                      Preferences.appString.introduction ?? 'Introduction',
                                                      style: TextStyle(
                                                        color: ColorResources.textblack,
                                                        fontSize: 18,
                                                        decoration: TextDecoration.underline,
                                                        decorationColor: ColorResources.buttoncolor,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              (course.data?.batchDetails?.teacher?[index].demodemoVideo?.isEmpty ?? true)
                                                  ? Container()
                                                  : AspectRatio(
                                                      aspectRatio: 16 / 9,
                                                      child: CuPlayerScreen(
                                                        url: course.data?.batchDetails?.teacher?[index].demodemoVideo ?? "",
                                                        isLive: false,
                                                        playerType: PlayerType.youtube,
                                                        // wallpaper: await youtubeThumblineurl(videoId: course.data?.batchDetails?.teacher?[index].demodemoVideo ?? ""),
                                                        canpop: false,
                                                        autoPLay: false,
                                                        children: const [],
                                                      )
                                                      // PodPlayerScreen(
                                                      //   youtubeUrl: extractYouTubeVideolink(course.data?.batchDetails?.teacher?[index].demodemoVideo ?? "") ?? "",
                                                      //   isWidget: true,
                                                      //   autoPlay: false,
                                                      // ),
                                                      ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              (course.data?.batchDetails?.teacher?[index].qualification?.trim().isEmpty ?? true)
                                                  ? Container()
                                                  : Text(
                                                      Preferences.appString.experienceExpertise ?? 'Experience & Expertise',
                                                      style: TextStyle(
                                                        color: ColorResources.textblack,
                                                        fontSize: 14,
                                                        decoration: TextDecoration.underline,
                                                        decorationColor: ColorResources.buttoncolor,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              (course.data?.batchDetails?.teacher?[index].qualification?.trim().isEmpty ?? true)
                                                  ? Container()
                                                  : course.data?.batchDetails?.teacher?[index].qualification?.contains(",") ?? false
                                                      ? MediaQuery.removePadding(
                                                          context: context,
                                                          removeBottom: true,
                                                          child: ListView.builder(
                                                            shrinkWrap: true,
                                                            physics: NeverScrollableScrollPhysics(),
                                                            itemCount: course.data?.batchDetails?.teacher?[index].qualification?.split(",").length ?? 0,
                                                            itemBuilder: (context, tindex) {
                                                              String text = course.data?.batchDetails?.teacher?[index].qualification?.split(",")[tindex] ?? ".";
                                                              return IntrinsicHeight(
                                                                child: Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons.check_box,
                                                                      color: ColorResources.buttoncolor,
                                                                    ),
                                                                    Expanded(
                                                                      child: Text(
                                                                        text,
                                                                        style: TextStyle(
                                                                          height: 0.5,
                                                                          color: ColorResources.textBlackSec,
                                                                          fontSize: 12,
                                                                          fontWeight: FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        )
                                                      : Text(
                                                          course.data?.batchDetails?.teacher?[index].qualification ?? "dsd",
                                                          style: TextStyle(
                                                            color: ColorResources.textBlackSec,
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Text(
                            Preferences.appString.viewDetails ?? 'View Details',
                            style: TextStyle(
                              color: ColorResources.textblack,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _Study(CoursesDetailsModel course) {
    return GridView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.9,
          crossAxisSpacing: 3,
          mainAxisSpacing: 8,
        ),
        shrinkWrap: true,
        itemCount: course.data?.batchDetails?.batchFeatures?.length ?? 0,
        itemBuilder: (context, index) {
          final feature = course.data?.batchDetails?.batchFeatures?[index];
          return GestureDetector(
            onTap: () async {
              analytics.logEvent(name: "per_batch_feature", parameters: {
                "batch_id": course.data?.batchDetails?.sId ?? "",
                "feature": feature?.feature ?? "",
              });
              if (BatchFeatureEnum.lecture.name == feature?.feature) {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => ListOfSubjectsScreen(
                          batchId: course.data?.batchDetails?.sId ?? "",
                          beforeBuyNavig: BeforeBuyNavig.lecture,
                          data: course.data!,
                        )));
              } else if (BatchFeatureEnum.dpp.name == feature?.feature) {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => ListOfSubjectsScreen(
                          batchId: course.data?.batchDetails?.sId ?? "",
                          beforeBuyNavig: BeforeBuyNavig.dpp,
                          data: course.data!,
                        )));
              } else if (BatchFeatureEnum.note.name == feature?.feature) {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => ListOfSubjectsScreen(
                          batchId: course.data?.batchDetails?.sId ?? "",
                          beforeBuyNavig: BeforeBuyNavig.notes,
                          data: course.data!,
                        )));
              } else if (BatchFeatureEnum.announcement.name == feature?.feature) {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => ListOfAnnouncementScreen(
                          batchId: course.data?.batchDetails?.sId ?? "",
                          isFullScreen: true,
                        )));
              } else if (BatchFeatureEnum.quiz.name == feature?.feature) {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => BatchQuizScreen(
                      batchId: course.data?.batchDetails?.sId ?? "",
                      isFullScreen: true,
                      isLocked: true,
                    ),
                  ),
                );
              } else if (BatchFeatureEnum.doubt.name == feature?.feature) {
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => DoubtsTabWidgetScreen(
                    batchId: course.data?.batchDetails?.sId ?? "",
                    isLocked: true,
                    isFullScreen: true,
                    data: course.data,
                  ),
                ));
              } else if (BatchFeatureEnum.community.name == feature?.feature) {
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => CommunityTabWidgetScreen(
                    batchId: course.data?.batchDetails?.sId ?? "",
                    isLocked: true,
                    isFullScreen: true,
                    data: course.data,
                  ),
                ));
              } else if (BatchFeatureEnum.planner.name == feature?.feature) {
                Preferences.onLoading(context);
                await rdsi.RemoteDataSourceImpl().getPlannerBeforeBatch(batchid: widget.courseId).then((value) {
                  Navigator.of(context).pop();
                  if (value.status ?? false) {
                    if (value.data?.planner?.fileLoc?.isNotEmpty ?? false) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PdfRenderScreen(
                          name: feature?.feature ?? "",
                          filePath: value.data?.planner?.fileLoc ?? "",
                          isoffline: false,
                        ),
                      ));
                    } else {
                      flutterToast("Batch Planner will be available soon.");
                    }
                  }
                }).onError(
                  (error, stackTrace) {
                    Preferences.hideDialog(context);
                  },
                );
              } else {
                buytoaccess();
              }
            },
            child: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorResources.textWhite,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(
                    feature?.icon ?? '',
                    height: 70,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    (feature?.feature ?? '').toCapitalize(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: ColorResources.textblack,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  )
                ],
              ),
            ),
          );
        });
    // GestureDetector(
    //   onTap: buytoaccess,
    //   child: Container(
    //     alignment: Alignment.center,
    //     decoration: BoxDecoration(
    //       color: ColorResources.textWhite,
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         const Icon(
    //           Icons.rule,
    //           size: 40,
    //         ),
    //         const SizedBox(
    //           height: 10,
    //         ),
    //         Text(
    //           Preferences.appString.tests ?? 'Tests',
    //           style: TextStyle(
    //             color: ColorResources.textblack,
    //             fontSize: 18,
    //             fontWeight: FontWeight.w600,
    //             height: 0,
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // ),
    // GestureDetector(
    //   onTap: () {
    //     Navigator.of(context).push(CupertinoPageRoute(
    //       builder: (context) => ListOfSubjectsScreen(
    //         batchId: course.data?.batchDetails?.sId ?? "",
    //         beforeBuyNavig: BeforeBuyNavig.notes,
    //       ),
    //     ));
    //   },
    //   child: Container(
    //     alignment: Alignment.center,
    //     decoration: BoxDecoration(
    //       color: ColorResources.textWhite,
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         const Icon(
    //           Icons.note_alt_outlined,
    //           size: 40,
    //         ),
    //         const SizedBox(
    //           height: 10,
    //         ),
    //         Text(
    //           Preferences.appString.notes ?? 'Notes',
    //           style: TextStyle(
    //             color: ColorResources.textblack,
    //             fontSize: 18,
    //             fontWeight: FontWeight.w600,
    //             height: 0,
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // ),
    // GestureDetector(
    //   onTap: () {
    //     Navigator.of(context).push(CupertinoPageRoute(
    //       builder: (context) => ListOfSubjectsScreen(
    //         batchId: course.data?.batchDetails?.sId ?? "",
    //         beforeBuyNavig: BeforeBuyNavig.dpp,
    //       ),
    //     ));
    //   },
    //   child: Container(
    //     alignment: Alignment.center,
    //     decoration: BoxDecoration(
    //       color: ColorResources.textWhite,
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         const Icon(
    //           Icons.book_outlined,
    //           size: 40,
    //         ),
    //         const SizedBox(
    //           height: 10,
    //         ),
    //         Text(
    //           Preferences.appString.dPPs ?? 'DPP’s',
    //           style: TextStyle(
    //             color: ColorResources.textblack,
    //             fontSize: 18,
    //             fontWeight: FontWeight.w600,
    //             height: 0,
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // ),
    // GestureDetector(
    //   onTap: buytoaccess,
    //   child: Container(
    //     alignment: Alignment.center,
    //     decoration: BoxDecoration(
    //       color: ColorResources.textWhite,
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         const Icon(
    //           Icons.campaign_outlined,
    //           size: 40,
    //         ),
    //         const SizedBox(
    //           height: 10,
    //         ),
    //         Text(
    //           Preferences.appString.announcements ?? 'Announcement',
    //           style: TextStyle(
    //             color: ColorResources.textblack,
    //             fontSize: 18,
    //             fontWeight: FontWeight.w600,
    //             height: 0,
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // ),
    //   ],
    // );
  }

  Widget _info(CoursesDetailsModel course) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: ColorResources.textWhite,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Course Description",
                      style: TextStyle(
                        color: ColorResources.textblack,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Divider(),
                  if (course.data?.batchDetails?.featureVideo?.url?.isNotEmpty ?? false)
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: CourseVideoPlayer(
                        videoUrl: course.data?.batchDetails?.featureVideo?.url ?? "",
                        isYoutube: course.data?.batchDetails?.featureVideo?.videoType == "yt",
                      ),
                    ),
                  Html(
                    shrinkWrap: true,
                    data: course.data?.batchDetails?.description ?? "",
                    doNotRenderTheseTags: {
                      "br"
                    },
                    onAnchorTap: (url, attributes, element) {
                      Uri openurl = Uri.parse(url!);
                      launchUrl(
                        openurl,
                      );
                    },
                    //style: GoogleFonts.lato(fontSize: 16),
                    //textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 3.0,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: ColorResources.textWhite,
                      child: Icon(
                        Icons.calendar_month_outlined,
                        color: ColorResources.buttoncolor,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${Preferences.appString.startOn ?? "Batch Start on"} \n',
                            style: const TextStyle(
                              color: Color(0xFF616161),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: DateFormat("dd MMM yyyy").format(DateFormat("yyyy-MM-dd").parse(course.data?.batchDetails?.startingDate.toString() ?? "")),
                            style: TextStyle(
                              color: ColorResources.textblack,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: ColorResources.textWhite,
                      child: Icon(
                        Icons.schedule_outlined,
                        color: ColorResources.buttoncolor,
                        size: 30,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${Preferences.appString.duration ?? "Duration"}\n',
                              style: const TextStyle(
                                color: Color(0xFF616161),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: "${(DateFormat("yyyy-MM-dd").parse(course.data?.batchDetails?.endingDate ?? DateTime.now().toString()).difference(DateFormat("yyyy-MM-dd").parse(course.data?.batchDetails?.startingDate ?? DateTime.now().toString())).inDays / 30).floor()} Months",
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: ColorResources.textblack,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                if ((course.data?.noOfVideos ?? 0) > 0)
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: ColorResources.textWhite,
                        child: Icon(
                          Icons.subscriptions_outlined,
                          color: ColorResources.buttoncolor,
                          size: 25,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${Preferences.appString.lectures ?? "Lectures"}\n',
                              style: const TextStyle(
                                color: Color(0xFF616161),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: course.data?.noOfVideos.toString() ?? "",
                              style: TextStyle(
                                color: ColorResources.textblack,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                if (course.data?.batchDetails?.planner?.fileLoc?.isNotEmpty ?? false)
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => PdfRenderScreen(
                          name: course.data?.batchDetails?.batchName ?? "",
                          filePath: course.data?.batchDetails?.planner?.fileLoc ?? "",
                          isoffline: false,
                        ),
                      ));
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: ColorResources.textWhite,
                          child: Icon(
                            size: 30,
                            Icons.download_for_offline_outlined,
                            color: ColorResources.buttoncolor,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${Preferences.appString.planner ?? "Planner"}\n',
                                style: const TextStyle(
                                  color: Color(0xFF616161),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: Preferences.appString.download ?? 'Download',
                                style: TextStyle(
                                  color: ColorResources.textblack,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            if (course.data?.batchDetails?.demoVideo?.isNotEmpty ?? false)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ColorResources.textWhite,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Preferences.appString.freeDemoVideo ?? 'Free Demo Videos',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorResources.textblack,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: course.data?.batchDetails?.demoVideo?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return videolist(course.data!.batchDetails!.demoVideo![index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget videolist(course_d_m.DemoVideo demoVideo) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Container(
        height: 80,
        width: 150,
        decoration: BoxDecoration(
          color: ColorResources.gray.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            YouTubeContainerWidget(
              videoUrl: demoVideo.fileLoc!,
              height: 80,
            ),
            // Icon(
            //   Icons.play_circle,
            //   size: 40,
            // ),
            // Text('Raman Deep',
            //     style: GoogleFonts.notoSansDevanagari(
            //         fontSize: 16, fontWeight: FontWeight.bold)
            // )
          ],
        ),
      ),
    );
  }

  buytoaccess() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.key_off,
              size: 60,
              color: ColorResources.buttoncolor,
            ),
            title: Text(Preferences.appString.locked ?? "Locked!"),
            content: Text(Preferences.appString.pleasePerchaseBatch ?? "Please purchase the batch to unlock the  content"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(Preferences.appString.close ?? "Close"),
              )
            ],
          );
        });
  }
}
