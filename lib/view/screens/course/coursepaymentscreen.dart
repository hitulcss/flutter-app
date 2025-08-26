// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sd_campus_app/api/base_client.dart';
import 'package:sd_campus_app/features/data/remote/models/course_details_model.dart' as coursedetailsmodel;
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
// import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
// import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';
import 'package:sd_campus_app/features/cubit/coins/coin_cubit.dart';
import 'package:sd_campus_app/features/cubit/coupon/coupon_cubit.dart';
import 'package:sd_campus_app/features/cubit/course_plan/plan_cubit.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/auth/auth_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/base_model.dart';
import 'package:sd_campus_app/features/data/remote/models/coursesmodel.dart';
import 'package:sd_campus_app/features/data/remote/models/order_id_generated.dart';
import 'package:sd_campus_app/features/data/remote/models/payment_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/payment_status.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/view/screens/bottomnav/course_valdity.dart';
import 'package:sd_campus_app/view/screens/coupon_page.dart';
import 'package:easebuzz_flutter/easebuzz_flutter.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

//const String razorPayId = 'rzp_test_CWt1qviQEvI8wW';

class CoursePaymentScreen extends StatefulWidget {
  final CoursesDataModel course;
  final bool isEnroll;
  const CoursePaymentScreen({
    super.key,
    required this.course,
    required this.isEnroll,
  });

  @override
  State<CoursePaymentScreen> createState() => _CoursePaymentScreenState();
}

class _CoursePaymentScreenState extends State<CoursePaymentScreen> {
  late CoursesDataModel course;
  final _easebuzzFlutterPlugin = EasebuzzFlutter();
  // final Razorpay _razorpay = Razorpay();
  // var cfPaymentGatewayService = CFPaymentGatewayService();
  String? mobileNumber;
  String? userName;
  String? userEmail;
  List<Widget> images = [];

  double couponamount = 0;
  double coinamount = 0;

  final TextEditingController _emailController = TextEditingController();
  // CFEnvironment environment = CFEnvironment.SANDBOX;
  @override
  void initState() {
    super.initState();
    course = widget.course;
    remove();
    bannerimage();
    analytics.logEvent(name: "app_course_payment", parameters: {
      "batch_id": widget.course.id,
      "course_name": widget.course.batchName,
    });
    // callApigetbanner();
    // cfPaymentGatewayService.setCallback(verifyPayment, onError, receivedEvent);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getUserInfo();
  }

  void getUserInfo() {
    mobileNumber = SharedPreferenceHelper.getString(Preferences.phoneNUmber)!;
    userName = SharedPreferenceHelper.getString(Preferences.name)!;
    userEmail = SharedPreferenceHelper.getString(Preferences.email)!;
    context.read<CoinCubit>().getcoinApplied(isselected: false);
  }

  @override
  void dispose() {
    // _razorpay.clear();
    _emailController.dispose();
    super.dispose();
  }

  remove() {
    context.read<CouponCubit>().couponremove();
  }

  // void verifyPayment(String orderId) {
  //   print("Verify Payment");
  //   _savePaymentStatus(
  //       PaymentModel(
  //           orderId: orderId,
  //           description: "upschindi",
  //           mobileNumber: mobileNumber!,
  //           userName: userName!,
  //           userEmail: userEmail!,
  //           batchId: widget.course.batchDetails.id,
  //           price: (int.parse(widget.course.charges) -
  //                   ((int.parse(widget.course.charges) *
  //                       (int.parse(widget.course.batchDetails.discount) /
  //                           100))) -
  //                   couponamount)
  //               .toStringAsFixed(2),
  //           success: true),
  //       true);
  // }

  // void onError(CFErrorResponse errorResponse, String orderId) {
  //   print(errorResponse.getMessage());
  //   print("Error while making payment");
  //   _savePaymentStatus(
  //       PaymentModel(
  //         orderId: orderId,
  //         description: "upschindi",
  //         mobileNumber: mobileNumber!,
  //         userName: userName!,
  //         userEmail: userEmail!,
  //         batchId: widget.course.batchDetails.id,
  //         price: (int.parse(widget.course.charges) -
  //                 ((int.parse(widget.course.charges) *
  //                     (int.parse(widget.course.batchDetails.discount) / 100))) -
  //                 couponamount)
  //             .toStringAsFixed(2),
  //         success: false,
  //       ),
  //       false);
  // }

  // void receivedEvent(String event_name, Map<dynamic, dynamic> meta_data) {
  //   print(event_name);
  //   print(meta_data);
  // }

  // void openCheckout(id, razorpaykey) async {
  //   print('*' * 2000);
  //   print(razorpaykey);
  //   print(id.toString());
  //   var options = {
  //     'key': razorpaykey,
  //     "order_id": id,
  //     'amount': (100 * int.parse(widget.course.charges) -
  //             (100 *
  //                 (int.parse(widget.course.charges) *
  //                     (int.parse(widget.course.batchDetails.discount) / 100))) -
  //             couponamount)
  //         .toString(),
  //     'name': widget.course.batchDetails.batchName,
  //     'description': "upschindi",
  //     'prefill': {'contact': mobileNumber, 'email': userEmail},
  //     "notify": {"sms": true, "email": true},
  //     'timeout': 180,
  //     "currency": "INR",
  //     "external": {
  //       "wallets": ["paytm"]
  //     }
  //   };

  //   try {
  //     _razorpay.open(options);
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }
  // CFSession? createSession({
  //   required String orderId,
  //   required String paymentSessionId,
  // }) {
  //   try {
  //     var session = CFSessionBuilder()
  //         .setEnvironment(environment)
  //         .setOrderId(orderId)
  //         .setPaymentSessionId(paymentSessionId)
  //         .build();
  //     return session;
  //   } on CFException catch (e) {
  //     debugPrint(e.message);
  //     print(e.message);
  //   }
  //   return null;
  // }

  // void openCheckout({
  //   required String orderId,
  //   required String paymentSessionId,
  // }) async {
  //   try {
  //     var session =
  //         createSession(orderId: orderId, paymentSessionId: paymentSessionId);
  //     List<CFPaymentModes> components = <CFPaymentModes>[];
  //     var paymentComponent =
  //         CFPaymentComponentBuilder().setComponents(components).build();

  //     var theme = CFThemeBuilder()
  //         .setNavigationBarBackgroundColorColor("#FF0000")
  //         .setPrimaryFont("Menlo")
  //         .setSecondaryFont("Futura")
  //         .build();

  //     var cfDropCheckoutPayment = CFDropCheckoutPaymentBuilder()
  //         .setSession(session!)
  //         .setPaymentComponent(paymentComponent)
  //         .setTheme(theme)
  //         .build();

  //     cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);
  //   } on CFException catch (e) {
  //     print(e.message);
  //   }
  // }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   print("-----Payment Success-----");
  //   print(response.paymentId);
  //   print(response.orderId);
  //   print(response.signature);
  //   // Fluttertoast.showToast(
  //   //     msg:
  //   //         "SUCCESS: ${response.orderId} ${response.paymentId} ${response.signature}");
  //   _savePaymentStatus(
  //       PaymentModel(
  //           orderId: '',
  //           userpaymentOrderId: response.orderId!,
  //           paymentId: response.paymentId!.toString(),
  //           description: "upschindi",
  //           mobileNumber: mobileNumber!,
  //           userName: userName!,
  //           userEmail: userEmail!,
  //           Signature: response.signature!,
  //           batchId: widget.course.batchDetails.id,
  //           price: (int.parse(widget.course.charges) -
  //                   ((int.parse(widget.course.charges) *
  //                       (int.parse(widget.course.batchDetails.discount) /
  //                           100))))
  //               .toStringAsFixed(2),
  //           success: true.toString()),
  //       true);
  // }

  // void _handlePaymentError(PaymentFailureResponse response) {
  //   print("-----Payment error-----");
  //   // Fluttertoast.showToast(
  //   //     msg: "ERROR: ${response.code} - ${response.message!}");
  //   _savePaymentStatus(
  //       PaymentModel(
  //           orderId: '',
  //           userpaymentOrderId: '',
  //           paymentId: '',
  //           description: "",
  //           mobileNumber: mobileNumber!,
  //           userName: userName!,
  //           userEmail: userEmail!,
  //           Signature: '',
  //           batchId: widget.course.batchDetails.id,
  //           price: (int.parse(widget.course.charges) -
  //                   ((int.parse(widget.course.charges) *
  //                       (int.parse(widget.course.batchDetails.discount) /
  //                           100))))
  //               .toStringAsFixed(2),
  //           success: false.toString()),
  //       false);
  // }

  // Future<BaseModel<Getbannerdetails>> callApigetbanner() async {
  //   Getbannerdetails response;
  //   try {
  //     response = await RestClient(RetroApi2().dioData2()).bannerimagesRequest();
  //     // print(response.msg);

  //     safeSetState(() {});
  //   } catch (error) {
  //     // print("Exception occur: $error stackTrace: $stacktrace");
  //     return BaseModel()..setException(ServerError.withError(error: error));
  //   }
  //   return BaseModel()..data = response;
  // }

  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   print("-----Payment Success W-----");
  //   // Fluttertoast.showToast(msg: "EXTERNAL_WALLET: ${response.walletName!}");
  // }
  bannerimage() {
    for (var element in course.banner) {
      images.add(
        CachedNetworkImage(
            placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            imageUrl: element.fileLoc),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursePlanCubit, CoursePlanState>(
      builder: (context, state) {
        if (context.read<CoursePlanCubit>().plans.isNotEmpty) {
          course.discount = (context.read<CoursePlanCubit>().plans.firstWhere((element) => element.validityId == context.read<CoursePlanCubit>().planId).salePrice ?? 0).toString();
          course.charges = (context.read<CoursePlanCubit>().plans.firstWhere((element) => element.validityId == context.read<CoursePlanCubit>().planId).regularPrice ?? 0).toString();
        }
        return Scaffold(
          appBar: AppBar(
              backgroundColor: ColorResources.textWhite,
              iconTheme: IconThemeData(color: ColorResources.textblack),
              title: Text(
                Preferences.appString.orderSummary ?? Languages.orderSummary,
                style: GoogleFonts.notoSansDevanagari(
                  color: ColorResources.textblack,
                  fontWeight: FontWeight.bold,
                ),
              )),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorResources.textWhite,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 4),
                        spreadRadius: 5,
                        blurRadius: 20,
                        color: ColorResources.gray.withValues(alpha: 0.2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      if (course.banner.isNotEmpty)
                        ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            child: CachedNetworkImage(
                              imageUrl: course.banner.first.fileLoc,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            )),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              course.batchName,
                              style: GoogleFonts.notoSansDevanagari(
                                fontSize: 18,
                                color: ColorResources.textblack,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '₹${course.charges}',
                            style: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.textblack,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      // if (context.read<CoursePlanCubit>().plans.length == 1)
                      //   BlocBuilder<CoursePlanCubit, CoursePlanState>(
                      //     builder: (context, state) {
                      //       return Container(
                      //         margin: EdgeInsets.only(top: 10),
                      //         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(8),
                      //           color: ColorResources.buttoncolor.withValues(alpha:0.1),
                      //         ),
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
                      if (context.read<CoursePlanCubit>().plans.length > 1)
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: ColorResources.buttoncolor.withValues(alpha: 0.1),
                          ),
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
                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog.fullscreen(
                                    child: CourseValdityScreen(
                                      value: context.read<CoursePlanCubit>().plans,
                                      batchName: course.batchName,
                                      data: coursedetailsmodel.BatchDetails.fromJson(course.toJson()),
                                      isCheckOut: true,
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
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                int.parse(course.charges) > 0
                    ? BlocBuilder<CouponCubit, CouponState>(
                        builder: (context, state) {
                          // print(state);
                          if (state is CouponAddState) {
                            couponamount = 0;
                            if (state.coupontype == "fixed") {
                              couponamount = (int.parse(course.discount) - state.value) > 1 ? state.value.toDouble() : 0;
                            } else {
                              couponamount = (int.parse(course.discount) - (int.parse(course.discount) / 100) * (state.value / 100)) > 1 ? (int.parse(course.discount) * (state.value / 100)) : 0;
                              // couponamount = (int.parse(widget.course.charges) - ((int.parse(widget.course.charges) * (int.parse(widget.course.discount) / 100)))) * (state.value / 100);
                            }
                          } else {
                            couponamount = 0;
                          }
                          if (state is CouponAddState) {
                            return couponappllied(couponname: state.couponcode, couponvalue: couponamount.toStringAsFixed(2));
                          }
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => CouponScreen(
                                    linkwith: course.id,
                                    link: "batch",
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: ColorResources.textWhite,
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 0),
                                    spreadRadius: 5,
                                    blurRadius: 25,
                                    color: ColorResources.gray.withValues(alpha: 0.2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Languages.applycoupon,
                                        style: GoogleFonts.notoSansDevanagari(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: ColorResources.textblack,
                                        ),
                                      ),
                                      Text(
                                        Languages.seeoffers,
                                        style: GoogleFonts.notoSansDevanagari(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: ColorResources.textblack.withValues(alpha: 0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Icon(Icons.arrow_forward_ios)
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Container(),
                (course.isCoinApplicable && SharedPreferenceHelper.getInt(Preferences.usercoins) > int.parse(course.maxAllowedCoins)) && (int.parse(course.discount) - int.parse(course.maxAllowedCoins) > 0)
                    ? BlocBuilder<CoinCubit, CoinState>(
                        builder: (context, state) {
                          return Row(
                            children: [
                              Checkbox.adaptive(
                                value: context.read<CoinCubit>().getcoinApplied(),
                                onChanged: (value) => context.read<CoinCubit>().getcoinApplied(isselected: value!),
                              ),
                              Expanded(
                                child: Text(
                                  'Available ${course.maxAllowedCoins} coins will be debited from your Wallet coins.',
                                ),
                              )
                            ],
                          );
                        },
                      )
                    : Container(),
                const SizedBox(
                  height: 10,
                ),
                AnimatedSize(
                  duration: const Duration(seconds: 1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorResources.textWhite,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 0),
                          spreadRadius: 5,
                          blurRadius: 15,
                          color: ColorResources.gray.withValues(alpha: 0.2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 20),
                          child: Text(
                            Languages.billDetails,
                            style: GoogleFonts.notoSansDevanagari(fontSize: 22, fontWeight: FontWeight.bold, color: ColorResources.textblack),
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Languages.totalamount,
                                style: GoogleFonts.notoSansDevanagari(fontWeight: FontWeight.w900, color: ColorResources.textBlackSec),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "₹${course.charges}",
                                    style: GoogleFonts.notoSansDevanagari(
                                      fontWeight: FontWeight.w900,
                                      color: ColorResources.textBlackSec,
                                    ),
                                  ),
                                  Text(
                                    ' (${Preferences.appString.inclusiveAllOfTaxes ?? "Inclusive of All Taxes"})',
                                    style: GoogleFonts.notoSansDevanagari(
                                      fontSize: 8,
                                      color: ColorResources.gray,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // const SizedBox(
                        //   height: 5,
                        // ),
                        // (int.parse(widget.course.charges) - int.parse(widget.course.discount)) != 0
                        //     ? Container(
                        //         decoration: BoxDecoration(
                        //           border: RDottedLineBorder(
                        //             top: BorderSide(color: ColorResources.gray),
                        //           ),
                        //         ),
                        //       )
                        //     : Container(),
                        // (int.parse(widget.course.charges) - int.parse(widget.course.discount)) != 0
                        //     ? const SizedBox(
                        //         height: 10,
                        //       )
                        //     : Container(),
                        (int.parse(course.charges) - int.parse(course.discount)) != 0
                            ? Column(
                                children: [
                                  // Container(
                                  //   decoration: BoxDecoration(
                                  //     border: RDottedLineBorder.all(
                                  //       color: ColorResources.buttoncolor,
                                  //     ),
                                  //   ),
                                  // ),
                                  // const SizedBox(
                                  //   height: 5,
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          Languages.discount,
                                          style: GoogleFonts.notoSansDevanagari(
                                            color: ColorResources.textBlackSec,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        Text(
                                          "- ₹${(int.parse(course.charges) - int.parse(course.discount)).toStringAsFixed(1)}",
                                          style: GoogleFonts.notoSansDevanagari(
                                            color: ColorResources.greenshad,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        const SizedBox(
                          height: 5,
                        ),
                        BlocBuilder<CouponCubit, CouponState>(
                          builder: (context, state) {
                            if (state is CouponAddState) {
                              return Column(
                                children: [
                                  // Container(
                                  //   decoration: BoxDecoration(
                                  //     border: RDottedLineBorder(
                                  //       top: BorderSide(color: ColorResources.gray),
                                  //     ),
                                  //   ),
                                  // ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          Languages.applycoupon,
                                          style: GoogleFonts.notoSansDevanagari(
                                            color: ColorResources.textBlackSec,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        Text(
                                          "-₹${couponamount.toStringAsFixed(2)}",
                                          style: GoogleFonts.notoSansDevanagari(
                                            color: ColorResources.textBlackSec,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Container();
                          },
                        ),
                        BlocBuilder<CoinCubit, CoinState>(
                          builder: (context, state) {
                            coinamount = context.read<CoinCubit>().getcoinApplied()
                                ? int.parse(course.discount) - couponamount - double.parse(course.maxAllowedCoins) > 1
                                    ? double.parse(course.maxAllowedCoins)
                                    : 0
                                : 0;
                            return context.read<CoinCubit>().getcoinApplied() && coinamount > 0
                                ? Column(
                                    children: [
                                      // Container(
                                      //   decoration: BoxDecoration(
                                      //     border: RDottedLineBorder(
                                      //       top: BorderSide(color: ColorResources.gray),
                                      //     ),
                                      //   ),
                                      // ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              Preferences.appString.coin ?? 'Coin',
                                              style: GoogleFonts.notoSansDevanagari(
                                                color: ColorResources.textBlackSec,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            Text(
                                              "-₹${course.maxAllowedCoins}",
                                              style: GoogleFonts.notoSansDevanagari(
                                                color: ColorResources.textBlackSec,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Container();
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: RDottedLineBorder(
                              top: BorderSide(color: ColorResources.gray),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Languages.payableamount,
                                style: GoogleFonts.notoSansDevanagari(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              BlocBuilder<CoinCubit, CoinState>(
                                builder: (context, state) {
                                  return BlocBuilder<CouponCubit, CouponState>(
                                    builder: (context, state) {
                                      return Text(
                                        "₹${(int.parse(course.discount) - (couponamount + coinamount)).toStringAsFixed(1)}",
                                        style: GoogleFonts.notoSansDevanagari(
                                          fontWeight: FontWeight.w900,
                                        ),
                                      );
                                    },
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
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ColorResources.textWhite,
                    border: Border.all(color: ColorResources.borderColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Icon(
                                Icons.volunteer_activism_outlined,
                                size: 20,
                                color: ColorResources.buttoncolor,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                Preferences.appString.trustedByStudents ?? 'Trusted by students',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.notoSansDevanagari(
                                  color: ColorResources.textblack,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          ),
                        ),
                        const VerticalDivider(),
                        Expanded(
                          child: Column(
                            children: [
                              Icon(
                                Icons.verified_user_outlined,
                                size: 20,
                                color: ColorResources.buttoncolor,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                Preferences.appString.securePayment ?? 'Secure Payments',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.notoSansDevanagari(
                                  color: ColorResources.textblack,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                  letterSpacing: -0.40,
                                ),
                              )
                            ],
                          ),
                        ),
                        const VerticalDivider(),
                        Expanded(
                          child: Column(
                            children: [
                              Icon(
                                Icons.cast_for_education_outlined,
                                size: 20,
                                color: ColorResources.buttoncolor,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                Preferences.appString.affordableEducation ?? 'Affordable Education',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.notoSansDevanagari(
                                  color: ColorResources.textblack,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                  letterSpacing: -0.40,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            padding: EdgeInsets.zero,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: ColorResources.buttoncolor),
                      onPressed: () async {
                        if (SharedPreferenceHelper.getString(Preferences.email) == "N/A" && SharedPreferenceHelper.getString(Preferences.email)!.isEmpty) {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => Column(
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Please Add your Email',
                                        style: GoogleFonts.notoSansDevanagari(
                                          color: ColorResources.textblack,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                          letterSpacing: -0.24,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '*',
                                        style: GoogleFonts.notoSansDevanagari(
                                          color: const Color(0xFFFD0303),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                          letterSpacing: -0.24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.name,
                                  enableSuggestions: true,
                                  autofillHints: const [
                                    AutofillHints.email
                                  ],
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      hintText: 'Enter your Email.'),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_emailController.text == "" || _emailController.text == "N/A") {
                                      flutterToast("Please Enter Name");
                                    } else {
                                      AuthDataSourceImpl().updateUserDetails(_emailController.text, SharedPreferenceHelper.getString(Preferences.email)!, SharedPreferenceHelper.getString(Preferences.address)!).then((value) {
                                        if (value.statusCode == 200) {
                                          SharedPreferenceHelper.setString(Preferences.email, _emailController.text);
                                          Navigator.of(context).pop();
                                        }
                                      });
                                    }
                                  },
                                  child: const Text(
                                    'Update',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        } else {
                          Preferences.onLoading(context);
                          if ((int.parse(course.discount) - (couponamount + coinamount)) > 0) {
                            //EASEBUZZ_KEY = SIP6BADQQB
                            // EASEBUZZ_SALT= BR9T1Z9XYK
                            // EASEBUZZ_ENV = "prod"
                            // EASEBUZZ_IFRAME = 0

                            //  EASEBUZZ_KEY = 2PBP7IABZ2
                            // EASEBUZZ_SALT= DAH88E3UWQ
                            // EASEBUZZ_ENV =  "test"
                            // EASEBUZZ_IFRAME = 0
                            // const String baseUrl = 'https://pay.easebuzz.in/payment/initiateLink';
                            // const String merchantKey = 'SIP6BADQQB';
                            // const String salt = 'BR9T1Z9XYK'; // Replace with your actual salt value
                            // String transactionId = 'SD${const Uuid().v1().replaceAll('-', '')}';
                            double amount = int.parse(course.discount) - (couponamount + coinamount);

                            try {
                              OrderIdGenerated response;
                              if (widget.isEnroll) {
                                response = await RemoteDataSourceImpl().postinitiateBatchPaymentExtend(batchId: course.id, amount: amount, couponId: context.read<CouponCubit>().couponcodeid.isEmpty ? null : context.read<CouponCubit>().couponcodeid, coins: context.read<CoinCubit>().getcoinApplied() ? course.maxAllowedCoins : "0", courseValdityId: context.read<CoursePlanCubit>().planId);
                              } else {
                                response = await RemoteDataSourceImpl().postinitiateBatchPayment(batchId: course.id, amount: amount, couponId: context.read<CouponCubit>().couponcodeid.isEmpty ? null : context.read<CouponCubit>().couponcodeid, coins: context.read<CoinCubit>().getcoinApplied() ? course.maxAllowedCoins : "0", courseValdityId: context.read<CoursePlanCubit>().planId);
                              }
                              if (response.status ?? false) {
                                // final Map<String, dynamic> responseData = json.decode(response.body);
                                // Process the response as needed
                                // print(response.body);
                                // print('object');
                                Future.delayed(const Duration(seconds: 1), () async {
                                  Preferences.hideDialog(context);
                                  String paymode = "production"; //"This will either be 'test' or 'production'";
                                  // print("data");
                                  try {
                                    final paymentResponse = await initiatePayment(accessKey: response.data?.token ?? "", payMode: paymode);
                                    // log(paymentResponse.toString());
                                    // log(paymentResponse["payment_response"]["surl"]);
                                    if (paymentResponse.status) {
                                      _savePaymentStatusPaid(
                                        paymentData: jsonDecode(jsonEncode(paymentResponse.data["payment_response"])),
                                        status: paymentResponse.data['result'] == 'payment_successfull' ? true : false,
                                      );
                                    } else {
                                      flutterToast(paymentResponse.msg);
                                    }
                                    // _savePaymentStatus(
                                    //     PaymentModel(
                                    //       paymentid: paymentResponse["payment_response"]["txnid"],
                                    //       orderId: paymentResponse['payment_response']['easepayid'],
                                    //       description: course.batchName,
                                    //       mobileNumber: mobileNumber!,
                                    //       userName: userName!,
                                    //       userEmail: userEmail!,
                                    //       batchId: course.id,
                                    //       price: paymentResponse['payment_response']['amount'],
                                    //       success: paymentResponse['result'] == 'payment_successfull' ? true : false,
                                    //       isCoinApplied: context.read<CoinCubit>().getcoinApplied(),
                                    //     ),
                                    //     paymentResponse['result'] == 'payment_successfull' ? true : false,
                                    //     context.read<CouponCubit>().couponcodeid);
                                    if (kDebugMode) {
                                      print(paymentResponse);
                                    }
                                  } catch (e) {
                                    if (kDebugMode) {
                                      print('Error: $e');
                                    }
                                  }
                                });
                              } else {
                                // Handle HTTP request failure
                                Preferences.hideDialog(context);
                                flutterToast(response.msg ?? "Error: payment gatway not woking");
                                log(response.msg ?? "");
                              }
                            } catch (e) {
                              Preferences.hideDialog(context);
                              log("Error: $e");
                              // Handle other errors
                              flutterToast('Error: payment gatway not woking');
                            }

                            /* payment_response is the HashMap containing the response of the payment.
                                          You can parse it accordingly to handle response */
                            // Navigator.of(context).push(
                            // MaterialPageRoute(
                            // builder: (context) => qrscreen.PaymentScreen(
                            // itemimage: widget.course.batchDetails.banner.first.fileLoc,
                            // itemamount: (int.parse(widget.course.charges) - ((int.parse(widget.course.charges) * (int.parse(widget.course.batchDetails.discount) / 100)))).toString(),
                            // itemtitle: widget.course.batchDetails.batchName,
                            // paymentfor: 'course',
                            // ),
                            // ),
                            // );
                            // callApiorderid(widget.course.batchDetails.id);
                          } else {
                            _savePaymentStatus(
                                PaymentModel(
                                  paymentid: "",
                                  orderId: '',
                                  description: "",
                                  mobileNumber: mobileNumber!,
                                  userName: userName!,
                                  userEmail: userEmail!,
                                  batchId: course.id,
                                  price: (int.parse(course.discount) - (coinamount + couponamount)).toStringAsFixed(1),
                                  success: true,
                                  isCoinApplied: context.read<CoinCubit>().getcoinApplied(),
                                ),
                                true,
                                context.read<CouponCubit>().couponcodeid);
                          }
                        }
                        //openCheckout(widget.course.batchDetails.id);
                        //checkOutButton(context);
                      },
                      child: Text(
                        Preferences.appString.proceedToPay ?? "Proceed to Pay",
                        //Languages.checkout,
                        style: GoogleFonts.notoSansDevanagari(
                          color: ColorResources.textWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<BaseModel> initiatePayment({required String accessKey, required String payMode}) async {
    try {
      // Invoke the method on the platform to initiate payment
      final paymentResponse = await _easebuzzFlutterPlugin.payWithEasebuzz(accessKey, payMode);
      return BaseModel(status: true, data: paymentResponse, msg: "success"); // Store and display response
    } on PlatformException catch (e) {
      return BaseModel(status: false, data: "", msg: e.message ?? "Error: payment gatway not woking");
    }
  }

  Widget couponappllied({required String couponname, required String couponvalue}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: ColorResources.textWhite,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            spreadRadius: 5,
            blurRadius: 15,
            color: ColorResources.gray.withValues(alpha: 0.2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "‘$couponname’ ${Preferences.appString.applied ?? "Applied"}",
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 16,
                  color: ColorResources.textblack,
                ),
              ),
              Text(
                "₹$couponvalue ${Preferences.appString.couponSaving ?? "coupon saving"}",
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 16,
                  color: ColorResources.textblack,
                ),
              )
            ],
          ),
          TextButton(
            onPressed: () {
              context.read<CouponCubit>().couponremove();
            },
            child: Text(
              Languages.remove,
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 18,
                color: ColorResources.buttoncolor,
              ),
            ),
          )
        ],
      ),
    );
  }

  // Future<BaseModel<OrderIdGeneration>> callApiorderid(id) async {
  //   OrderIdGeneration response;
  //   Map<String, dynamic> body = {
  //     "amount": (int.parse(widget.course.charges) -
  //         ((int.parse(widget.course.charges) *
  //             (int.parse(widget.course.batchDetails.discount) / 100))) -
  //         couponamount),
  //     // "name": SharedPreferenceHelper.getString(Preferences.name),
  //     // "email": SharedPreferenceHelper.getString(Preferences.email),
  //     // "mobileNumber": SharedPreferenceHelper.getString(Preferences.phoneNUmber),
  //     // "description": "upschindi",
  //     // "transactionId": '123',
  //     // "transactiondate": DateTime.now().toString(),
  //     //"batch_id": id,
  //   };
  //   safeSetState(() {
  //     Preferences.onLoading(context);
  //   });
  //   try {
  //     var token = SharedPreferenceHelper.getString(Preferences.access_token);
  //     response =
  //         await RestClient(RetroApi().dioData(token!)).getorderidRequest(body);
  //     if (response.status!) {
  //       safeSetState(() {
  //         Preferences.hideDialog(context);
  //       });
  //       // Fluttertoast.showToast(
  //       //   msg: '${response.msg}',
  //       //   toastLength: Toast.LENGTH_SHORT,
  //       //   gravity: ToastGravity.BOTTOM,
  //       //   backgroundColor: ColorResources.gray,
  //       //   textColor: ColorResources.textWhite,
  //       // );
  //       openCheckout(
  //           orderId: response.data!.orderId!,
  //           paymentSessionId: response.data!.paymentSessionId!);
  //     } else {
  //       safeSetState(() {
  //         Preferences.hideDialog(context);
  //       });
  //       Fluttertoast.showToast(
  //         msg: '${response.msg}',
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         backgroundColor: ColorResources.gray,
  //         textColor: ColorResources.textWhite,
  //       );
  //     }
  //   } catch (error, stacktrace) {
  //     safeSetState(() {
  //       Preferences.hideDialog(context);
  //     });
  //     print("Exception occur: $error stackTrace: $stacktrace");
  //     return BaseModel()..setException(ServerError.withError(error: error));
  //   }
  //   return BaseModel()..data = response;
  // }
  void _savePaymentStatusPaid({required Map<String, dynamic> paymentData, required bool status}) async {
    // print("----Saving Payment Details -----");
    Preferences.onLoading(context);
    log(paymentData.toString());
    log(paymentData.toString());
    log(paymentData["surl"].toString());
    try {
      Response response = await dioAuthorizationData().post(paymentData["surl"], data: paymentData);
      BaseModel responseData = BaseModel.fromJson(response.data);
      if (responseData.status) {
        // print(response.data);
        flutterToast(responseData.msg);
        Preferences.hideDialog(context);
        // Navigator.popUntil(context, (route) => route.isFirst);
        paymentstatus(context: context, ispaided: status, paymentfor: "course");
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => statusscreen.PaymentScreen(
        //       paymentfor: "course",
        //       status: status,
        //     ),
        //   ),
        // );
      } else {
        // print("-----api Payment error -----");
        Preferences.hideDialog(context);
        flutterToast(responseData.msg);
        paymentstatus(context: context, ispaided: status, paymentfor: "course");
      }
    } catch (error) {
      Preferences.hideDialog(context);
      // print(error);
      flutterToast(error.toString());
    }
  }

  void _savePaymentStatus(PaymentModel paymentData, bool status, String? couponId) async {
    // print("----Saving Payment Details -----");
    RemoteDataSourceImpl remoteDataSourceImpl = RemoteDataSourceImpl();
    Preferences.onLoading(context);
    try {
      Response response = await remoteDataSourceImpl.savePaymentStatus(paymentData, couponId);
      if (response.statusCode == 200) {
        // print(response.data);
        flutterToast(response.data['msg']);
        Preferences.hideDialog(context);
        // Navigator.popUntil(context, (route) => route.isFirst);
        paymentstatus(context: context, ispaided: status, paymentfor: "course");
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => statusscreen.PaymentScreen(
        //       paymentfor: "course",
        //       status: status,
        //     ),
        //   ),
        // );
      } else {
        // print("-----api Payment error -----");
        Preferences.hideDialog(context);
        flutterToast("Pls Refresh (or) Reopen App");
      }
    } catch (error) {
      // print(error);
      Preferences.hideDialog(context);
      flutterToast(error.toString());
    }
  }

  String generateHash(String key, String txnid, double amount, String productinfo, String firstname, String email, String salt) {
    final String hashSequence = '$key|$txnid|${amount.toStringAsFixed(2)}|$productinfo|$firstname|$email|||||||||||$salt';
    final List<int> utf8HashSequence = utf8.encode(hashSequence);
    // print(utf8HashSequence.length);
    final Digest hash = sha512.convert(utf8HashSequence);
    // print(hash);
    return hash.toString();
  }
}
