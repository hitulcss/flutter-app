// // ignore_for_file: use_build_context_synchronously, unused_local_variable

// import 'dart:convert';

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:crypto/crypto.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // import 'package:http/http.dart' as http;
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:r_dotted_line_border/r_dotted_line_border.dart';
// import 'package:sd_campus_app/features/cubit/coins/coin_cubit.dart';
// import 'package:sd_campus_app/features/cubit/coupon/coupon_cubit.dart';
// import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
// import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
// import 'package:sd_campus_app/models/Test_series/testserie.dart';
// import 'package:sd_campus_app/util/color_resources.dart';
// import 'package:sd_campus_app/util/langauge.dart';
// import 'package:sd_campus_app/util/payment_status.dart';
// import 'package:sd_campus_app/util/prefconstatnt.dart';
// import 'package:sd_campus_app/util/preference.dart';
// import 'package:sd_campus_app/view/screens/coupon_page.dart';
// import 'package:uuid/uuid.dart';

// class TestPaymentScreen extends StatefulWidget {
//   final TestSeriesData testseries;
//   final List<Widget> image;
//   const TestPaymentScreen({super.key, required this.testseries, required this.image});

//   @override
//   State<TestPaymentScreen> createState() => _TestPaymentScreenState();
// }

// class _TestPaymentScreenState extends State<TestPaymentScreen> {
//   // final Razorpay _razorpay = Razorpay();
//   // var cfPaymentGatewayService = CFPaymentGatewayService();
//   String? mobileNumber;
//   String? userName;
//   String? userEmail;
//   List<Widget> images = [];
//   double couponamount = 0;
//   double coinamount = 0;
//   // CFEnvironment environment = CFEnvironment.SANDBOX;
//   @override
//   void initState() {
//     super.initState();
//     images = widget.image;
//     // callApigetbanner();
//     remove();
//     // cfPaymentGatewayService.setCallback(verifyPayment, onError, receivedEvent);
//     // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//     getUserInfo();
//   }

//   remove() {
//     context.read<CouponCubit>().couponremove();
//   }

//   void getUserInfo() {
//     mobileNumber = SharedPreferenceHelper.getString(Preferences.phoneNUmber)!;
//     userName = SharedPreferenceHelper.getString(Preferences.name)!;
//     userEmail = SharedPreferenceHelper.getString(Preferences.email)!;
//     context.read<CoinCubit>().getcoinApplied(isselected: false);
//   }

//   void verifyPayment(String orderId) {
//     // print("Verify Payment");
//     Map<String, dynamic> body = {
//       "orderId": orderId,
//       "description": "upschindi",
//       "mobileNumber": mobileNumber!,
//       "userName": userName!,
//       "userEmail": userEmail!,
//       "TestSeriesId": widget.testseries.sId!,
//       "price": (int.parse(widget.testseries.discount!) - (couponamount + coinamount)).toStringAsFixed(2),
//       "success": true,
//       "isCoinApplied": context.read<CoinCubit>().getcoinApplied()
//     };
//     _savePaymentStatus(body, true);
//   }

//   // void onError(CFErrorResponse errorResponse, String orderId) {
//   // print(errorResponse.getMessage());
//   // print("Error while making payment");
//   //   Map<String, dynamic> body = {
//   //     "orderId": orderId,
//   //     "description": "upschindi",
//   //     "mobileNumber": mobileNumber!,
//   //     "userName": userName!,
//   //     "userEmail": userEmail!,
//   //     "TestSeriesId": widget.testseries.sId!,
//   //     "price": (int.parse(widget.testseries.charges!) - ((int.parse(widget.testseries.charges!) * (int.parse(widget.testseries.discount!) / 100))) - couponamount).toStringAsFixed(2),
//   //     "success": false
//   //   };
//   //   _savePaymentStatus(body, false);
//   // }

//   // void receivedEvent(String event_name, Map<dynamic, dynamic> meta_data) {
//   // print(event_name);
//   // print(meta_data);
//   // }

//   // Future<BaseModel<getbannerdetails>> callApigetbanner() async {
//   //   getbannerdetails response;
//   //   try {
//   //     response = await RestClient(RetroApi2().dioData2()).bannerimagesRequest();
//   // print(response.msg);
//   //     for (var entry in response.data!) {
//   //       for (String image in entry.bannerUrl!) {
//   // images.add(Image.network(image));
//   //       }
//   //     }
//   //     safeSetState(() {});
//   //   } catch (error, stacktrace) {
//   // print("Exception occur: $error stackTrace: $stacktrace");
//   //     return BaseModel()..setException(ServerError.withError(error: error));
//   //   }
//   //   return BaseModel()..data = response;
//   // }

//   // void _handlePaymentSuccess(PaymentSuccessResponse response) {
//   // print("-----Payment Success-----");
//   // print(response.paymentId);
//   // print(response.orderId);
//   // print(response.signature);
//   //   Fluttertoast.showToast(
//   //       msg:
//   //           "SUCCESS: ${response.orderId} ${response.paymentId} ${response.signature}");
//   //   Map<String, dynamic> body = {
//   //     "orderId": '',
//   //     "userpaymentOrderId": response.orderId!,
//   //     "paymentId": response.paymentId!.toString(),
//   //     "description": "upschindi",
//   //     "mobileNumber": mobileNumber!,
//   //     "userName": userName!,
//   //     "userEmail": userEmail!,
//   //     "Signature": response.signature!,
//   //     "TestSeriesId": widget.testseries.sId!,
//   //     "price": (int.parse(widget.testseries.charges!) -
//   //             ((int.parse(widget.testseries.charges!) *
//   //                 (int.parse(widget.testseries.discount!) / 100))))
//   //         .round()
//   //         .toString(),
//   //     "success": true.toString()
//   //   };
//   //   _savePaymentStatus(body, true);
//   // }

//   // void _handlePaymentError(PaymentFailureResponse response) {
//   // print("-----Payment error-----");
//   //   Fluttertoast.showToast(
//   //       msg: "ERROR: ${response.code} - ${response.message!}");
//   //   Map<String, dynamic> body = {
//   //     "orderId": '',
//   //     "userpaymentOrderId": '',
//   //     "paymentId": '',
//   //     "description": "",
//   //     "mobileNumber": mobileNumber!,
//   //     "userName": userName!,
//   //     "userEmail": userEmail!,
//   //     "Signature": '',
//   //     "TestSeriesId": widget.testseries.sId!,
//   //     "price": (int.parse(widget.testseries.charges!) -
//   //             ((int.parse(widget.testseries.charges!) *
//   //                 (int.parse(widget.testseries.discount!) / 100))) -
//   //             couponamount)
//   //         .toString(),
//   //     "success": false.toString()
//   //   };
//   //   _savePaymentStatus(body, false);
//   // }

//   // void _handleExternalWallet(ExternalWalletResponse response) {
//   // print("-----Payment Success W-----");
//   //   Fluttertoast.showToast(msg: "EXTERNAL_WALLET: ${response.walletName!}");
//   // }

//   @override
//   void dispose() {
//     super.dispose();
//     // _razorpay.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           backgroundColor: ColorResources.textWhite,
//           iconTheme: IconThemeData(color: ColorResources.textblack),
//           title: Text(
//             Languages.orderSummary,
//             style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack, fontWeight: FontWeight.bold),
//           )),
//       body: SafeArea(
//         child: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 20),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   margin: const EdgeInsets.only(top: 20),
//                   padding: const EdgeInsets.only(top: 0, bottom: 20),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: ColorResources.textWhite,
//                     boxShadow: [
//                       BoxShadow(
//                         offset: const Offset(0, 0),
//                         spreadRadius: 5,
//                         blurRadius: 25,
//                         color: ColorResources.gray.withValues(alpha:0.2),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       CarouselSlider(
//                         items: images,
//                         options: CarouselOptions(
//                           viewportFraction: 1,
//                           initialPage: 0,
//                           enableInfiniteScroll: true,
//                           reverse: false,
//                           autoPlay: true,
//                           autoPlayInterval: const Duration(seconds: 3),
//                           autoPlayAnimationDuration: const Duration(milliseconds: 800),
//                           autoPlayCurve: Curves.fastOutSlowIn,
//                           enlargeCenterPage: true,
//                           scrollDirection: Axis.horizontal,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.67,
//                               child: Text(
//                                 widget.testseries.testseriesName!,
//                                 style: GoogleFonts.notoSansDevanagari(
//                                   fontSize: 18,
//                                   color: ColorResources.textblack,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               '₹${widget.testseries.charges!}',
//                               style: GoogleFonts.notoSansDevanagari(
//                                 color: ColorResources.textblack,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 int.parse(widget.testseries.charges!) > 0
//                     ? BlocBuilder<CouponCubit, CouponState>(
//                         builder: (context, state) {
//                           // print(state);
//                           if (state is CouponAddState) {
//                             if (state.coupontype == "fixed") {
//                               couponamount = (int.parse(widget.testseries.discount!) - (int.parse(widget.testseries.discount!) - state.value)) > 1 ? state.value.toDouble() : 0;
//                             } else {
//                               couponamount = (int.parse(widget.testseries.discount!) - (int.parse(widget.testseries.discount!) * (state.value / 100))) > 1 ? (int.parse(widget.testseries.discount!) * (state.value / 100)) : 0;
//                               // couponamount = (int.parse(widget.testseries.charges!) - ((int.parse(widget.testseries.charges!) * (int.parse(widget.testseries.discount!) / 100)))) * (state.value / 100);
//                             }
//                           } else {
//                             couponamount = 0;
//                           }
//                           if (state is CouponAddState) {
//                             return couponappllied(couponname: state.couponcode, couponvalue: couponamount.toStringAsFixed(2));
//                           }
//                           return GestureDetector(
//                             onTap: () {
//                               Navigator.of(context).push(
//                                 CupertinoPageRoute(
//                                   builder: (context) => CouponScreen(
//                                     linkwith: widget.testseries.sId!,
//                                     link: "testSeries",
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: Container(
//                               margin: const EdgeInsets.only(bottom: 10),
//                               padding: const EdgeInsets.symmetric(vertical: 10),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                                 color: ColorResources.textWhite,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     offset: const Offset(0, 0),
//                                     spreadRadius: 5,
//                                     blurRadius: 25,
//                                     color: ColorResources.gray.withValues(alpha:0.2),
//                                   ),
//                                 ],
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         Languages.applycoupon,
//                                         style: GoogleFonts.notoSansDevanagari(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                           color: ColorResources.textblack,
//                                         ),
//                                       ),
//                                       Text(
//                                         Languages.seeoffers,
//                                         style: GoogleFonts.notoSansDevanagari(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.bold,
//                                           color: ColorResources.textblack.withValues(alpha:0.5),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const Icon(Icons.arrow_forward_ios)
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       )
//                     : Container(),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 (widget.testseries.isCoinApplicable! && SharedPreferenceHelper.getInt(Preferences.usercoins) > int.parse(widget.testseries.maxAllowedCoins!)) && (int.parse(widget.testseries.discount!) - int.parse(widget.testseries.maxAllowedCoins!) > 0)
//                     ? BlocBuilder<CoinCubit, CoinState>(
//                         builder: (context, state) {
//                           return Row(
//                             children: [
//                               Checkbox.adaptive(
//                                 value: context.read<CoinCubit>().getcoinApplied(),
//                                 onChanged: (value) => context.read<CoinCubit>().getcoinApplied(isselected: value!),
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   'Available ${widget.testseries.maxAllowedCoins} coins will be debited from your Wallet coins.',
//                                 ),
//                               )
//                             ],
//                           );
//                         },
//                       )
//                     : Container(),
//                 Text(
//                   Languages.billDetails,
//                   style: GoogleFonts.notoSansDevanagari(
//                     fontSize: 22,
//                     //fontWeight: FontWeight.w900,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(vertical: 10),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: ColorResources.textWhite,
//                     boxShadow: [
//                       BoxShadow(
//                         offset: const Offset(0, 0),
//                         spreadRadius: 5,
//                         blurRadius: 15,
//                         color: ColorResources.gray.withValues(alpha:0.2),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               Languages.totalamount,
//                               style: GoogleFonts.notoSansDevanagari(
//                                 fontWeight: FontWeight.w900,
//                               ),
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   "₹${widget.testseries.charges!}",
//                                   style: GoogleFonts.notoSansDevanagari(
//                                     color: ColorResources.textblack,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Text(
//                                   ' (Inclusive of All Taxes)',
//                                   style: GoogleFonts.notoSansDevanagari(
//                                     fontSize: 8,
//                                     color: ColorResources.gray,
//                                     fontWeight: FontWeight.w900,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       (int.parse(widget.testseries.charges!) - int.parse(widget.testseries.discount!)) != 0
//                           ? const SizedBox(
//                               height: 10,
//                             )
//                           : Container(),
//                       (int.parse(widget.testseries.charges!) - int.parse(widget.testseries.discount!)) != 0
//                           ? Column(
//                               children: [
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     border: RDottedLineBorder(
//                                       top: BorderSide(color: ColorResources.gray),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: 5,
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         Languages.discount,
//                                         style: GoogleFonts.notoSansDevanagari(
//                                           fontWeight: FontWeight.w900,
//                                           color: ColorResources.buttoncolor,
//                                         ),
//                                       ),
//                                       Text(
//                                         "-₹${(int.parse(widget.testseries.charges!) - int.parse(widget.testseries.discount!)).toStringAsFixed(2)}",
//                                         style: GoogleFonts.notoSansDevanagari(
//                                           color: ColorResources.buttoncolor,
//                                           fontWeight: FontWeight.w900,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             )
//                           : Container(),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       BlocBuilder<CouponCubit, CouponState>(
//                         builder: (context, state) {
//                           if (state is CouponAddState) {
//                             return Column(
//                               children: [
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     border: RDottedLineBorder(
//                                       top: BorderSide(color: ColorResources.gray),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: 5,
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         Languages.applycoupon,
//                                         style: GoogleFonts.notoSansDevanagari(
//                                           color: ColorResources.buttoncolor,
//                                           fontWeight: FontWeight.w900,
//                                         ),
//                                       ),
//                                       Text(
//                                         "-₹$couponamount",
//                                         style: GoogleFonts.notoSansDevanagari(
//                                           color: ColorResources.buttoncolor,
//                                           fontWeight: FontWeight.w900,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             );
//                           }
//                           return Container();
//                         },
//                       ),
//                       BlocBuilder<CoinCubit, CoinState>(
//                         builder: (context, state) {
//                           return context.read<CoinCubit>().getcoinApplied()
//                               ? Column(
//                                   children: [
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         border: RDottedLineBorder(
//                                           top: BorderSide(color: ColorResources.gray),
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 5,
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             'Coin',
//                                             style: GoogleFonts.notoSansDevanagari(
//                                               color: ColorResources.buttoncolor,
//                                               fontWeight: FontWeight.w900,
//                                             ),
//                                           ),
//                                           Text(
//                                             "-₹${widget.testseries.maxAllowedCoins}",
//                                             style: GoogleFonts.notoSansDevanagari(
//                                               color: ColorResources.buttoncolor,
//                                               fontWeight: FontWeight.w900,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               : Container();
//                         },
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           border: RDottedLineBorder(
//                             top: BorderSide(color: ColorResources.gray),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               Languages.payableamount,
//                               style: GoogleFonts.notoSansDevanagari(
//                                 fontWeight: FontWeight.w900,
//                               ),
//                             ),
//                             BlocBuilder<CoinCubit, CoinState>(
//                               builder: (context, state) {
//                                 return BlocBuilder<CouponCubit, CouponState>(
//                                   builder: (context, state) {
//                                     coinamount = context.read<CoinCubit>().getcoinApplied()
//                                         ? int.parse(widget.testseries.discount!) - (couponamount + double.parse(widget.testseries.maxAllowedCoins!)) > 1
//                                             ? double.parse(widget.testseries.maxAllowedCoins!)
//                                             : 0
//                                         : 0;
//                                     return Text(
//                                       "₹${(int.parse(widget.testseries.discount!) - (couponamount + coinamount)).toStringAsFixed(2)}",
//                                       style: GoogleFonts.notoSansDevanagari(
//                                         fontWeight: FontWeight.w900,
//                                       ),
//                                     );
//                                   },
//                                 );
//                               },
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.03,
//                 ),
//                 Center(
//                   child: Container(
//                     width: MediaQuery.of(context).size.width * 0.50,
//                     margin: const EdgeInsets.symmetric(vertical: 30),
//                     decoration: BoxDecoration(color: ColorResources.buttoncolor, borderRadius: BorderRadius.circular(14)),
//                     child: TextButton(
//                       onPressed: () async {
//                         Preferences.onLoading(context);
//                         if ((int.parse(widget.testseries.discount!) - (couponamount + coinamount)) > 0) {
//                           // print('*' * 100);
//                           //EASEBUZZ_KEY = SIP6BADQQB
//                           // EASEBUZZ_SALT= BR9T1Z9XYK
//                           // EASEBUZZ_ENV = "prod"
//                           // EASEBUZZ_IFRAME = 0
//                           //  EASEBUZZ_KEY = 2PBP7IABZ2
//                           // EASEBUZZ_SALT= DAH88E3UWQ
//                           // EASEBUZZ_ENV =  "test"
//                           // EASEBUZZ_IFRAME = 0
//                           const String baseUrl = 'https://pay.easebuzz.in/payment/initiateLink';
//                           const String merchantKey = 'SIP6BADQQB';
//                           String transactionId = 'SD${const Uuid().v1().replaceAll('-', '')}';
//                           double amount = int.parse(widget.testseries.discount!) - (couponamount + coinamount);
//                           const String productInfo = 'mac';
//                           String firstName = SharedPreferenceHelper.getString(Preferences.name)?.replaceAll(' ', '') ?? '';
//                           String email = SharedPreferenceHelper.getString(Preferences.email)?.replaceAll(' ', '') ?? '';
//                           const String salt = 'BR9T1Z9XYK'; // Replace with your actual salt value
//                           final Map<String, dynamic> requestBody = {
//                             'request_flow': 'SEAMLESS',
//                             'key': merchantKey,
//                             'txnid': transactionId,
//                             'phone': SharedPreferenceHelper.getString(Preferences.phoneNUmber)?.replaceAll(' ', '') ?? '',
//                             'amount': amount.toStringAsFixed(2),
//                             'productinfo': productInfo,
//                             'firstname': firstName,
//                             'email': email,
//                             'surl': 'https://trando.in/web-development',
//                             'furl': 'https://trando.in/',
//                             'hash': generateHash(merchantKey, transactionId, amount, productInfo, firstName, email, salt), // key|txnid|amount|productinfo|firstname|email|udf1|udf2|udf3|udf4|udf5|udf6|udf7|udf8|udf9|udf10|salt
//                             'udf1': '',
//                             'udf2': '',
//                             'udf3': '',
//                             'udf4': '',
//                             'udf5': '',
//                             'udf6': '',
//                             'udf7': '',
//                             'udf8': '',
//                             'udf9': '',
//                             'udf10': '',
//                             'salt': salt,
//                           };

//                           try {
//                             final http.Response response = await http.post(
//                               Uri.parse(baseUrl),
//                               body: requestBody,
//                             );

//                             if (response.statusCode == 200) {
//                               // final Map<String, dynamic> responseData = json.decode(response.body);
//                               // Process the response as needed
//                               // print(response.body);
//                               // print('object');
//                               Future.delayed(const Duration(seconds: 2), () async {
//                                 Preferences.hideDialog(context);
//                                 MethodChannel channel = const MethodChannel('easebuzz');
//                                 String accesskey = merchantKey; //"Access key generated by the Initiate Payment API";
//                                 String paymode = "production"; //"This will either be 'test' or 'production'";
//                                 // print(accesskey);
//                                 Map<String, String> parameters = {
//                                   "access_key": jsonDecode(response.body)['data'],
//                                   "pay_mode": paymode,
//                                   "amount": amount.toStringAsFixed(2),
//                                 };
//                                 try {
//                                   final paymentResponse = await channel.invokeMethod('payWithEasebuzz', parameters);
//                                   Map<String, dynamic> body = {
//                                     "orderId": paymentResponse['payment_response']['easepayid'],
//                                     "description": widget.testseries.testseriesName,
//                                     "mobileNumber": mobileNumber!,
//                                     "userName": userName!,
//                                     "userEmail": userEmail!,
//                                     "TestSeriesId": widget.testseries.sId!,
//                                     "price": paymentResponse['payment_response']['amount'],
//                                     "success": paymentResponse['result'] == 'payment_successfull' ? true : false,
//                                     "isCoinApplied": context.read<CoinCubit>().getcoinApplied(),
//                                   };
//                                   _savePaymentStatus(
//                                     body,
//                                     paymentResponse['result'] == 'payment_successfull' ? true : false,
//                                   );

//                                   if (kDebugMode) {
//                                     print(paymentResponse);
//                                   }
//                                 } catch (e) {
//                                   if (kDebugMode) {
//                                     print('Error: $e');
//                                   }
//                                 }
//                               });
//                             } else {
//                               // Handle HTTP request failure
//                               flutterToast('HTTP Request failed with status: ${response.statusCode}');
//                             }
//                           } catch (e) {
//                             // Handle other errors
//                             flutterToast('Error: payment gatway not woking');
//                           }

//                           // Navigator.push(
//                           //   context,
//                           //   MaterialPageRoute(
//                           //     builder: (context) => qrscreen.PaymentScreen(
//                           //       itemimage: widget.testseries.banner!.first.fileLoc,
//                           //       itemamount: (int.parse(widget.testseries.charges!) - ((int.parse(widget.testseries.charges!) * (int.parse(widget.testseries.discount!) / 100)))).toString(),
//                           //       itemtitle: widget.testseries.testseriesName!,
//                           //       paymentfor: 'test',
//                           //     ),
//                           //   ),
//                           // );
//                           //callApiorderid(widget.testseries.sId);
//                         } else {
//                           Map<String, dynamic> body = {
//                             "orderId": '',
//                             "description": "",
//                             "mobileNumber": mobileNumber!,
//                             "userName": userName!,
//                             "userEmail": userEmail!,
//                             "TestSeriesId": widget.testseries.sId!,
//                             "price": (int.parse(widget.testseries.discount!) - (couponamount + coinamount)).toStringAsPrecision(2),
//                             "success": true,
//                             "isCoinApplied": context.read<CoinCubit>().getcoinApplied()
//                           };
//                           _savePaymentStatus(body, true);
//                         }
//                         //openCheckout(widget.course.batchDetails.id);
//                         //checkOutButton(context);
//                       },
//                       child: Text(
//                         Languages.checkout,
//                         style: GoogleFonts.notoSansDevanagari(color: ColorResources.textWhite, fontWeight: FontWeight.bold, fontSize: 20),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget couponappllied({required String couponname, required String couponvalue}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: ColorResources.textWhite,
//         boxShadow: [
//           BoxShadow(
//             offset: const Offset(0, 0),
//             spreadRadius: 5,
//             blurRadius: 15,
//             color: ColorResources.gray.withValues(alpha:0.2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "‘$couponname’ Applied",
//                 style: GoogleFonts.notoSansDevanagari(
//                   fontSize: 16,
//                   color: ColorResources.textblack,
//                 ),
//               ),
//               Text(
//                 "₹$couponvalue coupon saving",
//                 style: GoogleFonts.notoSansDevanagari(
//                   fontSize: 16,
//                   color: ColorResources.textblack,
//                 ),
//               )
//             ],
//           ),
//           TextButton(
//             onPressed: () {
//               context.read<CouponCubit>().couponremove();
//             },
//             child: Text(
//               Languages.remove,
//               style: GoogleFonts.notoSansDevanagari(
//                 fontSize: 18,
//                 color: ColorResources.buttoncolor,
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   // CFSession? createSession({
//   //   required String orderId,
//   //   required String paymentSessionId,
//   // }) {
//   //   try {
//   //     var session = CFSessionBuilder().setEnvironment(environment).setOrderId(orderId).setPaymentSessionId(paymentSessionId).build();
//   //     return session;
//   //   } on CFException catch (e) {
//   //     debug// print(e.message);
//   //     // print(e.message);
//   //   }
//   //   return null;
//   // }

//   // void openCheckout({
//   //   required String orderId,
//   //   required String paymentSessionId,
//   // }) async {
//   //   try {
//   //     var session = createSession(orderId: orderId, paymentSessionId: paymentSessionId);
//   //     List<CFPaymentModes> components = <CFPaymentModes>[CFPaymentModes.UPI];
//   //     var paymentComponent = CFPaymentComponentBuilder().setComponents(components).build();

//   //     var theme = CFThemeBuilder().setNavigationBarBackgroundColorColor("#ED5067").setPrimaryFont("Menlo").setSecondaryFont("Futura").build();

//   //     var cfDropCheckoutPayment = CFDropCheckoutPaymentBuilder().setSession(session!).setPaymentComponent(paymentComponent).setTheme(theme).build();

//   //     cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);
//   //   } on CFException catch (e) {
//   //     // print(e.message);
//   //   }
//   // }

//   // Future<BaseModel<OrderIdGeneration>> callApiorderid(id) async {
//   //   OrderIdGeneration response;
//   //   Map<String, dynamic> body = {
//   //     "amount": (int.parse(widget.testseries.charges!) - ((int.parse(widget.testseries.charges!) * (int.parse(widget.testseries.discount!) / 100))) - couponamount).toStringAsFixed(2),
//   //     // "name": SharedPreferenceHelper.getString(Preferences.name),
//   //     // "email": SharedPreferenceHelper.getString(Preferences.email),
//   //     // "mobileNumber": SharedPreferenceHelper.getString(Preferences.phoneNUmber),
//   //     // "description": "upschindi",
//   //     // "transactionId": '123',
//   //     // "transactiondate": DateTime.now().toString(),
//   //     //"batch_id": id,
//   //   };
//   //   safeSetState(() {
//   //     Preferences.onLoading(context);
//   //   });
//   //   try {
//   //     var token = SharedPreferenceHelper.getString(Preferences.access_token);
//   //     response = await RestClient(RetroApi().dioData(token!)).getorderidRequest(body);
//   //     if (response.status!) {
//   //       safeSetState(() {
//   //         Preferences.hideDialog(context);
//   //       });
//   //       Fluttertoast.showToast(
//   //         msg: '${response.msg}',
//   //         toastLength: Toast.LENGTH_SHORT,
//   //         gravity: ToastGravity.BOTTOM,
//   //         backgroundColor: ColorResources.gray,
//   //         textColor: ColorResources.textWhite,
//   //       );
//   //       openCheckout(orderId: response.data!.orderId!, paymentSessionId: response.data!.paymentSessionId!);
//   //     } else {
//   //       safeSetState(() {
//   //         Preferences.hideDialog(context);
//   //       });
//   //       Fluttertoast.showToast(
//   //         msg: '${response.msg}',
//   //         toastLength: Toast.LENGTH_SHORT,
//   //         gravity: ToastGravity.BOTTOM,
//   //         backgroundColor: ColorResources.gray,
//   //         textColor: ColorResources.textWhite,
//   //       );
//   //     }
//   //   } catch (error, stacktrace) {
//   //     safeSetState(() {
//   //       Preferences.hideDialog(context);
//   //     });
//   //     // print("Exception occur: $error stackTrace: $stacktrace");
//   //     return BaseModel()..setException(ServerError.withError(error: error));
//   //   }
//   //   return BaseModel()..data = response;
//   // }

//   // void openCheckout(id, razorpaykey) async {
//   //   // print('*' * 2000);
//   //   // print(razorpaykey);
//   //   // print(id.toString());
//   //   var options = {
//   //     'key': razorpaykey,
//   //     "order_id": id,
//   //     'amount': (100 * int.parse(widget.testseries.charges!) -
//   //             (100 *
//   //                 (int.parse(widget.testseries.charges!) *
//   //                     (int.parse(widget.testseries.discount!) / 100))))
//   //         .toString(),
//   //     'name': widget.testseries.testseriesName,
//   //     'description': "upschindi",
//   //     'prefill': {'contact': mobileNumber, 'email': userEmail},
//   //     "notify": {"sms": true, "email": true},
//   //     'timeout': 180,
//   //     "currency": "INR",
//   //     "external": {
//   //       "wallets": ["paytm"]
//   //     }
//   //   };

//   //   try {
//   //     _razorpay.open(options);
//   //   } catch (e) {
//   //     debug// print(e.toString());
//   //   }
//   // }

//   void _savePaymentStatus(Map<String, dynamic> paymentData, bool status) async {
//     // print("----Saving Payment Details -----");
//     RemoteDataSourceImpl remoteDataSourceImpl = RemoteDataSourceImpl();
//     Map<String, dynamic> body = paymentData;
//     safeSetState(() {
//       Preferences.onLoading(context);
//     });
//     try {
//       // print("----Saving Payment Details -----");
//       Response response = await remoteDataSourceImpl.savetestPaymentStatus(body);
//       // print("----Saving Payment Details -----");
//       if (response.statusCode == 200) {
//         // print("----Saving Payment Details -----");
//         // print(response.data);
//         flutterToast(response.data['msg']);
//         // safeSetState(() {
//           Preferences.hideDialog(context);
//         // });
//         // Navigator.pop(context);
//         paymentstatus(context: context, ispaided: status, paymentfor: "test");
//         // Navigator.push(
//         //   context,
//         //   MaterialPageRoute(
//         //     builder: (context) => statusscreen.PaymentScreen(paymentfor: "test", status: status),
//         //   ),
//         // );
//       } else {
//         // print("-----api Payment error -----");
//         safeSetState(() {
//           Preferences.hideDialog(context);
//         });
//         flutterToast("Pls Refresh (or) Reopen App");
//       }
//     } catch (error) {
//       // print(error);
//       safeSetState(() {
//         Preferences.hideDialog(context);
//       });
//       flutterToast(error.toString());
//     }
//   }

//   String generateHash(String key, String txnid, double amount, String productinfo, String firstname, String email, String salt) {
//     final String hashSequence = '$key|$txnid|${amount.toStringAsFixed(2)}|$productinfo|$firstname|$email|||||||||||$salt';
//     final List<int> utf8HashSequence = utf8.encode(hashSequence);
//     // print(utf8HashSequence.length);
//     final Digest hash = sha512.convert(utf8HashSequence);
//     // print(hash);
//     return hash.toString();
//   }
// }
