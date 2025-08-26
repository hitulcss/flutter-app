import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sd_campus_app/features/cubit/course_plan/plan_cubit.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/course_details_model.dart' as coursedetailsmodel;
import 'package:sd_campus_app/features/data/remote/models/coursesmodel.dart';
import 'package:sd_campus_app/features/data/remote/models/payment_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/shimmer_custom.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/lang/banner_lang.dart';
import 'package:sd_campus_app/util/payment_status.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/view/screens/bottomnav/course_valdity.dart';
import 'package:sd_campus_app/view/screens/bottomnav/coursesdetails.dart';
import 'package:sd_campus_app/view/screens/course/coursepaymentscreen.dart';

class CourseBodyDataWidget extends StatefulWidget {
  final List<CoursesDataModel> courseData;
  final bool ispaid;
  final String currentStreem;
  final String? subcurrentStreem;
  final ScrollController scrollController;
  const CourseBodyDataWidget({
    super.key,
    required this.courseData,
    required this.ispaid,
    required this.currentStreem,
    required this.scrollController,
    this.subcurrentStreem,
  });

  @override
  State<CourseBodyDataWidget> createState() => _CourseBodyDataWidgetState();
}

class _CourseBodyDataWidgetState extends State<CourseBodyDataWidget> {
  List<CoursesDataModel> courseData = [];
  // ScrollController scrollController = ScrollController();
  int page = 2;
  bool isLoading = false;
  bool hasMore = true;
  @override
  void initState() {
    super.initState();
    if (widget.courseData.isEmpty) {
      fetchdata();
    } else {
      courseData = widget.courseData;
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.scrollController.position.maxScrollExtent > 0) {
        widget.scrollController.addListener(() async {
          if (widget.scrollController.position.pixels >= widget.scrollController.position.maxScrollExtent * 0.95 && !isLoading) {
            if (mounted) {
              safeSetState(() {
                isLoading = true;
              });
            }
            if (hasMore) {
              fetchdata();
            }
          }
        });
      } else {
        safeSetState(() {
          isLoading = false;
          hasMore = false;
        });
      }
    });
  }

  fetchdata() async {
    if (widget.ispaid) {
      CoursesModel data = await RemoteDataSourceImpl().getpaidCourses(
        page: page,
        stream: widget.currentStreem == "ALL" ? "all" : widget.currentStreem,
        subCategory: widget.subcurrentStreem,
      );
      safeSetState(() {
        courseData.addAll(data.data);
        isLoading = false;
        page = page + 1;
        hasMore = data.data.isNotEmpty;
      });
    } else {
      CoursesModel data = await RemoteDataSourceImpl().getfreeCourses(
        page: page,
        stream: widget.currentStreem == "ALL" ? "all" : widget.currentStreem,
        subCategory: widget.subcurrentStreem,
      );
      safeSetState(() {
        courseData.addAll(data.data);
        isLoading = false;
        page = page + 1;
        hasMore = data.data.isNotEmpty;
      });
    }
  }

  @override
  void dispose() {
    // widget.scrollController.dispose();
    page = 1;
    isLoading = false;
    hasMore = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          controller: widget.scrollController,
          shrinkWrap: true,
          itemCount: widget.courseData.length + (hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index != widget.courseData.length) {
              return _cardWidget(widget.courseData[index]);
            } else {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
    );
  }

  Widget _cardWidget(CoursesDataModel data) {
    return Stack(
      key: Key(data.id.toString()),
      children: [
        Container(
          margin: const EdgeInsets.only(top: 9, left: 15, right: 10, bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorResources.textWhite,
            boxShadow: [
              BoxShadow(
                color: ColorResources.gray.withValues(alpha: 0.5),
                blurRadius: 5.0,
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            data.batchName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.notoSansDevanagari(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ColorResources.textblack,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: CachedNetworkImage(
                            imageUrl: data.banner[0].fileLoc,
                            placeholder: (context, url) => Center(
                              child: ShimmerCustom.rectangular(height: 150),
                            ),
                            errorWidget: (context, url, error) => AspectRatio(aspectRatio: 16 / 9, child: const Icon(Icons.error)),
                          ),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.track_changes,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            '${Preferences.appString.targetedBatchFor} ${data.subCategory.isEmpty ? data.stream : data.subCategory}',
                            overflow: TextOverflow.clip,
                            style: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.textblack,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    data.batchFeatureUrl.isEmpty
                        ? Row(
                            children: [
                              const Icon(
                                Icons.calendar_month_outlined,
                                size: 15,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Start on ',
                                        style: TextStyle(
                                          color: ColorResources.textBlackSec,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextSpan(
                                        text: DateFormat("dd MMM yyyy").format(DateFormat("yyyy-MM-dd").parse(data.startingDate.toString().split(" ").first)),
                                        style: TextStyle(
                                          color: ColorResources.textblack,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' | End on ',
                                        style: TextStyle(
                                          color: ColorResources.textBlackSec,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextSpan(
                                        text: DateFormat("dd MMM yyyy").format(DateFormat("yyyy-MM-dd").parse(data.endingDate.toString().split(" ").first)),
                                        style: TextStyle(
                                          color: ColorResources.textblack,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              data.batchFeatureUrl,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                            ),
                          ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  int.parse(data.discount) == 0 ? "Free" : '₹ ${(int.parse(data.discount))}',
                                  style: GoogleFonts.notoSansDevanagari(
                                    color: int.parse(data.discount) == 0 ? Colors.green : ColorResources.buttoncolor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  int.parse(data.discount) < int.parse(data.charges) ? '${data.charges}  ' : "",
                                  style: GoogleFonts.notoSansDevanagari(
                                    decoration: TextDecoration.lineThrough,
                                    color: ColorResources.gray,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "(For Full Batch)",
                              style: GoogleFonts.notoSansDevanagari(
                                color: ColorResources.textblack,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        ClipPath(
                          clipper: LeftArrowClipper(),
                          child: Container(
                            padding: const EdgeInsets.only(left: 15.0, right: 5, bottom: 5, top: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(100), bottomLeft: Radius.circular(100), topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
                              color: Color(0xFFD5FFD9),
                            ),
                            child: Row(
                              spacing: 5,
                              children: [
                                Transform.flip(
                                  flipX: true,
                                  child: SvgPicture.string(
                                    "<svg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24'><g fill='none' stroke='currentColor' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' color='currentColor'><path d='M10.996 10h.015M11 16h.015M7 13h8'/><circle cx='1.5' cy='1.5' r='1.5' transform='matrix(1 0 0 -1 16 8)'/><path d='M2.774 11.144c-1.003 1.12-1.024 2.81-.104 4a34 34 0 0 0 6.186 6.186c1.19.92 2.88.899 4-.104a92 92 0 0 0 8.516-8.698a1.95 1.95 0 0 0 .47-1.094c.164-1.796.503-6.97-.902-8.374s-6.578-1.066-8.374-.901a1.95 1.95 0 0 0-1.094.47a92 92 0 0 0-8.698 8.515'/></g></svg>",
                                    height: 15,
                                    colorFilter: ColorFilter.mode(Color(0xFF1E7026), BlendMode.srcIn),
                                  ),
                                ),
                                Text(
                                  int.parse(data.discount) < int.parse(data.charges)
                                      ? data.charges != "0"
                                          ? 'Discount of ${(((int.parse(data.charges) - int.parse(data.discount)) / int.parse(data.charges)) * 100).toString().split('.').first}% Applied'
                                          : ""
                                      : "",
                                  style: GoogleFonts.notoSansDevanagari(
                                    color: const Color(0xFF1D7025),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => CoursesDetailsScreens(
                                  courseId: data.id,
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                              side: BorderSide(width: 1.0, color: ColorResources.buttoncolor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), // <-- Radius
                              ),
                            ),
                            child: Text(
                              Preferences.appString.viewDetails ?? 'View Details',
                              style: GoogleFonts.notoSansDevanagari(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (int.parse(data.discount) == 0) {
                                _savePaymentStatus(
                                  PaymentModel(
                                    paymentid: "",
                                    orderId: '',
                                    description: "",
                                    mobileNumber: SharedPreferenceHelper.getString(Preferences.phoneNUmber)!,
                                    userName: SharedPreferenceHelper.getString(Preferences.name)!,
                                    userEmail: SharedPreferenceHelper.getString(Preferences.email)!,
                                    batchId: data.id,
                                    price: int.parse(data.discount).toStringAsFixed(1),
                                    success: true,
                                    isCoinApplied: false,
                                  ),
                                  true,
                                );
                              } else {
                                Preferences.onLoading(context);
                                context.read<CoursePlanCubit>().getPlan(id: data.id).then((_) {
                                  Preferences.hideDialog(context);
                                  if (context.read<CoursePlanCubit>().plans.length > 1) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => Dialog.fullscreen(
                                        child: CourseValdityScreen(
                                          isEnroll: false,
                                          value: context.read<CoursePlanCubit>().plans,
                                          batchName: data.batchName,
                                          data: coursedetailsmodel.BatchDetails.fromJson(data.toJson()),
                                          isCheckOut: false,
                                        ),
                                      ),
                                    );
                                  } else if (context.read<CoursePlanCubit>().plans.length == 1) {
                                    CoursesDataModel datato = data;
                                    datato.discount = (context.read<CoursePlanCubit>().plans.first.salePrice ?? 0).toString();
                                    datato.charges = (context.read<CoursePlanCubit>().plans.first.regularPrice ?? 0).toString();
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => CoursePaymentScreen(
                                          course: datato,
                                          isEnroll: false,
                                        ),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => CoursePaymentScreen(
                                                course: data,
                                                isEnroll: false,
                                              ) // cartSelectedItem!,
                                          ),
                                    );
                                  }
                                }).onError((_, __) {
                                  Preferences.hideDialog(context);
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                              backgroundColor: ColorResources.buttoncolor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), // <-- Radius
                              ),
                            ),
                            child: Text(
                              Preferences.appString.buyNow ?? 'Buy Now',
                              style: GoogleFonts.notoSansDevanagari(
                                fontSize: 12,
                                color: ColorResources.textWhite,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 8,
          child: SvgPicture.string(
            BannerLangSvg().getBannerSvg(type: BannerLangSvg().gettype(lang: data.language)),
            height: 20,
          ),
        )
      ],
    );
  }

  void _savePaymentStatus(PaymentModel paymentData, bool status) async {
    // print("----Saving Payment Details -----");
    analytics.logEvent(
      name: "app_trying_to_perchase",
      parameters: {
        "batch": paymentData.batchId,
      },
    );
    RemoteDataSourceImpl remoteDataSourceImpl = RemoteDataSourceImpl();
    Preferences.onLoading(context);
    try {
      Response response = await remoteDataSourceImpl.savePaymentStatus(paymentData, null);
      if (response.statusCode == 200) {
        // print(response.data);
        analytics.logEvent(
          name: "app_success_to_perchase",
          parameters: {
            "batch": paymentData.batchId,
          },
        );
        flutterToast(response.data['msg']);
        Preferences.hideDialog(context);
        paymentstatus(context: context, ispaided: status, paymentfor: "course");
      } else {
        // print("-----api Payment error -----");
        Preferences.onLoading(context);
        flutterToast("Pls Refresh (or) Reopen App");
      }
    } catch (error) {
      // print(error);
      flutterToast(error.toString());
    }
  }
}

class LeftArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const arrowWidth = 16.0;

    Path path = Path();
    path.moveTo(arrowWidth, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(arrowWidth, size.height);
    path.lineTo(0, size.height / 2);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
