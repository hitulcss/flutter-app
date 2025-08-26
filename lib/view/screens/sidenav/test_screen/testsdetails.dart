// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
// import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
// import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
// import 'package:sd_campus_app/main.dart';
// import 'package:sd_campus_app/models/Test_series/testserie.dart';
// import 'package:sd_campus_app/util/color_resources.dart';
// import 'package:sd_campus_app/util/images_file.dart';
// import 'package:sd_campus_app/util/langauge.dart';
// import 'package:sd_campus_app/util/prefconstatnt.dart';
// import 'package:sd_campus_app/util/preference.dart';
// import 'package:sd_campus_app/view/screens/course/paymentscreen.dart';
// import 'package:sd_campus_app/view/screens/sidenav/test_screen/test_series_payment_screen.dart';

// class TestSeriesDetailScreen extends StatefulWidget {
//   final String testseriesId;
//   const TestSeriesDetailScreen({
//     super.key,
//     required this.testseriesId,
//   });

//   @override
//   State<TestSeriesDetailScreen> createState() => _TestSeriesDetailScreenState();
// }

// class _TestSeriesDetailScreenState extends State<TestSeriesDetailScreen> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: RemoteDataSourceImpl().getTestSeriesid(id: widget.testseriesId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             if (snapshot.hasError) {
//               return Scaffold(
//                 body: ErrorWidgetapp(
//                   image: SvgImages.error404,
//                   text: snapshot.error.toString(),
//                 ),
//               );
//             } else {
//               List<Widget> image = [];
//               for (var element in snapshot.data!.data!.banner!) {
//                 image.add(CachedNetworkImage(
//                     placeholder: (context, url) => const Center(
//                       child: CircularProgressIndicator(),
//                     ),
//                     errorWidget: (context, url, error) => const Icon(Icons.error),
//                     imageUrl:element.fileLoc!));
//               }
//               return Scaffold(
//                   appBar: AppBar(
//                     backgroundColor: ColorResources.textWhite,
//                     iconTheme: IconThemeData(color: ColorResources.textblack),
//                     title: Text(
//                       snapshot.data!.data!.testseriesName!,
//                       style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack),
//                     ),
//                   ),
//                   body: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Expanded(
//                         child: SingleChildScrollView(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 margin: const EdgeInsets.symmetric(horizontal: 16),
//                                 child: CarouselSlider(
//                                   items: image,
//                                   options: CarouselOptions(
//                                     height: 140,
//                                     viewportFraction: 1,
//                                     initialPage: 0,
//                                     enableInfiniteScroll: true,
//                                     reverse: false,
//                                     autoPlay: true,
//                                     autoPlayInterval: const Duration(seconds: 3),
//                                     autoPlayAnimationDuration: const Duration(milliseconds: 800),
//                                     autoPlayCurve: Curves.fastOutSlowIn,
//                                     enlargeCenterPage: true,
//                                     scrollDirection: Axis.horizontal,
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 15.0),
//                                       child: Text(
//                                         snapshot.data!.data!.testseriesName!,
//                                         style: GoogleFonts.notoSansDevanagari(fontSize: 20, fontWeight: FontWeight.bold, color: ColorResources.textblack),
//                                       ),
//                                     ),
//                                     Container(
//                                       margin: const EdgeInsets.all(10),
//                                       padding: const EdgeInsets.all(5),
//                                       decoration: BoxDecoration(color:  ColorResources.borderColor, borderRadius: BorderRadius.circular(90),),
//                                       child: Text(
//                                         Languages.testdetails,
//                                         style: GoogleFonts.notoSansDevanagari(fontSize: 16),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(15.0),
//                                       child: Text(
//                                         snapshot.data!.data!.description!,
//                                         style: GoogleFonts.lato(fontSize: 16),
//                                         textAlign: TextAlign.justify,
//                                       ),
//                                     ),
//                                     snapshot.data!.data!.remark!.isNotEmpty
//                                         ? Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Padding(
//                                                 padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
//                                                 child: Row(
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text(
//                                                       "Note: ",
//                                                       style: GoogleFonts.notoSansDevanagari(fontSize: 20, color: ColorResources.buttoncolor),
//                                                     ),
//                                                     SizedBox(
//                                                       width: MediaQuery.of(context).size.width * 0.70,
//                                                       child: Text(
//                                                         snapshot.data!.data!.remark!,
//                                                         style: GoogleFonts.lato(fontSize: 16),
//                                                         textAlign: TextAlign.justify,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               )
//                                             ],
//                                           )
//                                         : const Text(''),
//                                     GridView.count(
//                                       physics: const NeverScrollableScrollPhysics(),
//                                       padding: const EdgeInsets.all(8),
//                                       crossAxisCount: 2,
//                                       crossAxisSpacing: 10.0,
//                                       mainAxisSpacing: 10.0,
//                                       childAspectRatio: 20 / 4,
//                                       shrinkWrap: true,
//                                       children: [
//                                         Row(children: [
//                                           const Icon(
//                                             Icons.play_circle_fill_outlined,
//                                           ),
//                                           Text('  ${snapshot.data!.data!.noOfTest} ${Languages.noTest}')
//                                         ]),
//                                         // Row(children: [
//                                         //   const Icon(
//                                         //     Icons.person,
//                                         //   ),
//                                         //   Text(
//                                         //       ' ${snapshot.data!.data!.student!.length} Taken')
//                                         // ]),
//                                         Row(children: [
//                                           Icon(
//                                             Icons.sensors_outlined,
//                                             color: ColorResources.buttoncolor,
//                                           ),
//                                           const Text(' Live Access')
//                                         ]),

//                                         // Row(children: [
//                                         //   Icon(
//                                         //     Icons.people,
//                                         //   ),
//                                         //   Text(Languages.bestrecommended)
//                                         // ]),
//                                       ],
//                                     ),
//                                     Container(
//                                       margin: const EdgeInsets.all(10),
//                                       padding: const EdgeInsets.all(5),
//                                       decoration: BoxDecoration(color:  ColorResources.borderColor, borderRadius: BorderRadius.circular(90),),
//                                       child: Text(
//                                         Languages.duration,
//                                         style: GoogleFonts.notoSansDevanagari(fontSize: 16),
//                                       ),
//                                     ),
//                                     GridView.count(physics: const NeverScrollableScrollPhysics(), padding: const EdgeInsets.all(8), crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0, childAspectRatio: 20 / 4, shrinkWrap: true, children: [
//                                       Row(children: [
//                                         const Icon(
//                                           Icons.calendar_month_rounded,
//                                         ),
//                                         Text(' ${Languages.starts} : ${snapshot.data!.data!.startingDate}')
//                                       ]),
//                                       Row(children: [
//                                         const Icon(
//                                           Icons.access_time_rounded,
//                                         ),
//                                         Text("${snapshot.data!.data!.validity!} months")
//                                       ]),
//                                     ]),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Container(
//                           height: 80,
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Text(
//                                 int.parse(snapshot.data!.data!.discount!) == 0 ? "Free" : '₹${snapshot.data!.data!.discount}',
//                                 style: GoogleFonts.notoSansDevanagari(
//                                   fontSize: 30,
//                                   fontWeight: FontWeight.bold,
//                                   color: int.parse(snapshot.data!.data!.discount!) == 0 ? Colors.green : ColorResources.textblack,
//                                 ),
//                               ),
//                               ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: ColorResources.buttoncolor,
//                                     shape: const StadiumBorder(),
//                                   ),
//                                   onPressed: () {
//                                     //callApiaddtocart(course.data.batchDetails.id);
//                                     int.parse(snapshot.data!.data!.discount!) == 0
//                                         ? _savePaymentStatus({
//                                             "orderId": '',
//                                             "description": "",
//                                             "mobileNumber": SharedPreferenceHelper.getString(Preferences.phoneNUmber)!,
//                                             "userName": SharedPreferenceHelper.getString(Preferences.name),
//                                             "userEmail": SharedPreferenceHelper.getString(Preferences.name),
//                                             "TestSeriesId": snapshot.data!.data!.sId!,
//                                             "price": (int.parse(snapshot.data!.data!.discount!)).toStringAsPrecision(2),
//                                             "success": true,
//                                             "isCoinApplied": false
//                                           }, true)
//                                         : Navigator.of(context).push(MaterialPageRoute(
//                                             builder: (context) =>
//                                                 // PaymentScreen(
//                                                 //       itemimage: widget
//                                                 //           .testseriesName.banner!.first.fileLoc,
//                                                 //       itemamount: snapshot.data!.data!.charges!,
//                                                 //       itemtitle:
//                                                 //           snapshot.data!.data!.testseriesName!,
//                                                 //       paymentfor: 'test',
//                                                 //     )
//                                                 TestPaymentScreen(
//                                               testseries: TestSeriesData.fromJson(snapshot.data!.data!.toJson()),
//                                               image: image,
//                                             ),
//                                           ));
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
//                                     child: Text(Languages.makePayment, style: GoogleFonts.notoSansDevanagari(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600)),
//                                   ))
//                             ],
//                           )),
//                     ],
//                   ));
//             }
//           } else {
//             return const Scaffold(
//               body: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             );
//           }
//         });
//   }

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
//         analytics.logEvent(
//           name: "app_success_to_perchase",
//           parameters: {
//             "TestSeriesId": paymentData["TestSeriesId"],
//           },
//         );
//         // print("----Saving Payment Details -----");
//         // print(response.data);
//         flutterToast(response.data['msg']);
//         safeSetState(() {
//           Preferences.hideDialog(context);
//         });
//         Navigator.pop(context);
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => PaymentScreen(paymentfor: "test", status: status),
//           ),
//         );
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
// }
