// import 'dart:convert';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
// import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
// import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
// import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
// import 'package:sd_campus_app/main.dart';
// import 'package:sd_campus_app/models/Test_series/mytests.dart';
// import 'package:sd_campus_app/models/Test_series/testserie.dart';
// import 'package:sd_campus_app/util/color_resources.dart';
// import 'package:sd_campus_app/util/images_file.dart';
// import 'package:sd_campus_app/util/langauge.dart';
// import 'package:sd_campus_app/util/prefconstatnt.dart';
// import 'package:sd_campus_app/util/preference.dart';
// import 'package:sd_campus_app/view/screens/sidenav/mytest.dart';
// import 'package:sd_campus_app/view/screens/sidenav/test_screen/testsdetails.dart';
// import 'package:intl/intl.dart';

// class Mocktestscreen extends StatefulWidget {
//   final RemoteDataSourceImpl remoteDataSourceImpl;

//   const Mocktestscreen({super.key, required this.remoteDataSourceImpl});

//   @override
//   State<Mocktestscreen> createState() => MocktestscreenState();
// }

// class MocktestscreenState extends State<Mocktestscreen> {
//   TextEditingController searchtest = TextEditingController();
//   RemoteDataSourceImpl remoteDataSourceImpl = RemoteDataSourceImpl();

//   @override
//   void initState() {
//     analytics.logEvent(name: "app_TestSeries");
//     super.initState();
//   }

//   @override
//   void dispose() {
//     searchtest.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: DefaultTabController(
//             length: 3,
//             child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
//               Container(
//                 constraints: const BoxConstraints.expand(height: 50),
//                 color: Colors.white,
//                 child: TabBar(
//                   isScrollable: true,
//                   indicatorColor: ColorResources.buttoncolor,
//                   labelColor: ColorResources.buttoncolor,
//                   unselectedLabelColor: ColorResources.textblack.withValues(alpha:0.6),
//                   onTap: (value) {
//                     if (value == 0) {
//                       analytics.logEvent(name: "app_mytest");
//                     } else if (value == 1) {
//                       analytics.logEvent(name: "app_paidtest");
//                     } else if (value == 2) {
//                       analytics.logEvent(name: "app_freetest");
//                     }
//                   },
//                   tabs: const [
//                     Tab(
//                       text: 'My Test series',
//                     ),
//                     Tab(
//                       text: 'Paid Test Series',
//                     ),
//                     Tab(
//                       text: 'Free Test Series',
//                     )
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: TabBarView(
//                   physics: const NeverScrollableScrollPhysics(),
//                   children: [
//                     FutureBuilder<MyTestsModel>(
//                       future: remoteDataSourceImpl.getMyTests(),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState == ConnectionState.done) {
//                           if (snapshot.hasData && snapshot.data!.status!) {
//                             MyTestsModel? myTestsModel = snapshot.data;
//                             return myTestsModel!.data!.isNotEmpty
//                                 ? myTestsbody(myTestsModel)
//                                 : Center(
//                                     child: EmptyWidget(image: SvgImages.emptytestseries, text: Languages.notestseries),
//                                   );
//                           } else {
//                             return Center(
//                                 child: Image.asset(
//                               SvgImages.error404,
//                               height: 120,
//                             )
//                                 //Text('Pls Refresh (or) Reopen App'),
//                                 );
//                           }
//                         } else {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }
//                       },
//                     ),
//                     FutureBuilder<TestSeriesModel>(
//                         initialData: SharedPreferenceHelper.getString(Preferences.getTestSeries) == 'N/A' ? TestSeriesModel(status: true, data: [], msg: '') : TestSeriesModel.fromJson(jsonDecode(SharedPreferenceHelper.getString(Preferences.getTestSeries)!)),
//                         future: widget.remoteDataSourceImpl.getTestSeries(),
//                         builder: (context, snapshots) {
//                           // if (ConnectionState.done == snapshots.connectionState) {
//                           if (snapshots.hasData) {
//                             TestSeriesModel? response = snapshots.data;
//                             response!.data!.removeWhere((element) => !element.isPaid!);
//                             if (response.status!) {
//                               return testscreenbody(
//                                 response.data,
//                               );
//                             } else {
//                               return Text(response.msg!);
//                             }
//                           } else {
//                             return Center(child: SizedBox(height: MediaQuery.of(context).size.height * 0.6, width: MediaQuery.of(context).size.width * 0.8, child: ErrorWidgetapp(image: SvgImages.error404, text: "Page not found"))
//                                 //Text('Pls Refresh (or) Reopen App'),
//                                 );
//                           }
//                           // } else {
//                           //   return Padding(
//                           //     padding: const EdgeInsets.symmetric(horizontal: 15),
//                           //     child: SingleChildScrollView(
//                           //       child: Column(
//                           //         crossAxisAlignment: CrossAxisAlignment.start,
//                           //         children: [
//                           //           ShimmerCustom.rectangular(
//                           //             height: 20,
//                           //             width: MediaQuery.of(context).size.width * 0.3,
//                           //           ),
//                           //           const SizedBox(
//                           //             height: 10,
//                           //           ),
//                           //           ListView.builder(
//                           //             physics: const NeverScrollableScrollPhysics(),
//                           //             itemCount: 9,
//                           //             shrinkWrap: true,
//                           //             itemBuilder: (BuildContext context, int index) {
//                           //               return Container(
//                           //                 margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
//                           //                 decoration: BoxDecoration(
//                           //                   borderRadius: BorderRadius.circular(20),
//                           //                   color: ColorResources.textWhite,
//                           //                   boxShadow: [
//                           //                     BoxShadow(
//                           //                       color: ColorResources.gray.withValues(alpha:0.5),
//                           //                       blurRadius: 5.0,
//                           //                     ),
//                           //                   ],
//                           //                 ),
//                           //                 padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                           //                 child: Column(
//                           //                   crossAxisAlignment: CrossAxisAlignment.start,
//                           //                   children: [
//                           //                     ShimmerCustom.rectangular(
//                           //                       height: 20,
//                           //                     ),
//                           //                     const SizedBox(
//                           //                       height: 10,
//                           //                     ),
//                           //                     Row(
//                           //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           //                       children: [
//                           //                         ShimmerCustom.rectangular(
//                           //                           height: 10,
//                           //                           width: MediaQuery.of(context).size.width * 0.3,
//                           //                         ),
//                           //                         ShimmerCustom.rectangular(
//                           //                           height: 10,
//                           //                           width: MediaQuery.of(context).size.width * 0.3,
//                           //                         ),
//                           //                       ],
//                           //                     ),
//                           //                     const SizedBox(
//                           //                       height: 10,
//                           //                     ),
//                           //                     Row(
//                           //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           //                       children: [
//                           //                         ShimmerCustom.rectangular(
//                           //                           height: 15,
//                           //                           width: MediaQuery.of(context).size.width * 0.3,
//                           //                         ),
//                           //                         ShimmerCustom.rectangular(
//                           //                           height: 15,
//                           //                           width: MediaQuery.of(context).size.width * 0.3,
//                           //                         ),
//                           //                       ],
//                           //                     ),
//                           //                   ],
//                           //                 ),
//                           //               );
//                           //             },
//                           //           ),
//                           //         ],
//                           //       ),
//                           //     ),
//                           //   );
//                           // }
//                         }),
//                     FutureBuilder<TestSeriesModel>(
//                         initialData: SharedPreferenceHelper.getString(Preferences.getTestSeries) == 'N/A' ? TestSeriesModel(status: true, data: [], msg: '') : TestSeriesModel.fromJson(jsonDecode(SharedPreferenceHelper.getString(Preferences.getTestSeries)!)),
//                         future: widget.remoteDataSourceImpl.getTestSeries(),
//                         builder: (context, snapshots) {
//                           // if (ConnectionState.done == snapshots.connectionState) {
//                           if (snapshots.hasData) {
//                             TestSeriesModel? response = snapshots.data;
//                             response!.data!.removeWhere((element) => element.isPaid!);
//                             if (response.status!) {
//                               return testscreenbody(
//                                 response.data,
//                               );
//                             } else {
//                               return Text(response.msg!);
//                             }
//                           } else {
//                             return Center(child: SizedBox(height: MediaQuery.of(context).size.height * 0.6, width: MediaQuery.of(context).size.width * 0.8, child: ErrorWidgetapp(image: SvgImages.error404, text: "Page not found"))
//                                 //Text('Pls Refresh (or) Reopen App'),
//                                 );
//                           }
//                           // } else {
//                           //   return Padding(
//                           //     padding: const EdgeInsets.symmetric(horizontal: 15),
//                           //     child: SingleChildScrollView(
//                           //       child: Column(
//                           //         crossAxisAlignment: CrossAxisAlignment.start,
//                           //         children: [
//                           //           ShimmerCustom.rectangular(
//                           //             height: 20,
//                           //             width: MediaQuery.of(context).size.width * 0.3,
//                           //           ),
//                           //           const SizedBox(
//                           //             height: 10,
//                           //           ),
//                           //           ListView.builder(
//                           //             physics: const NeverScrollableScrollPhysics(),
//                           //             itemCount: 9,
//                           //             shrinkWrap: true,
//                           //             itemBuilder: (BuildContext context, int index) {
//                           //               return Container(
//                           //                 margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
//                           //                 decoration: BoxDecoration(
//                           //                   borderRadius: BorderRadius.circular(20),
//                           //                   color: ColorResources.textWhite,
//                           //                   boxShadow: [
//                           //                     BoxShadow(
//                           //                       color: ColorResources.gray.withValues(alpha:0.5),
//                           //                       blurRadius: 5.0,
//                           //                     ),
//                           //                   ],
//                           //                 ),
//                           //                 padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                           //                 child: Column(
//                           //                   crossAxisAlignment: CrossAxisAlignment.start,
//                           //                   children: [
//                           //                     ShimmerCustom.rectangular(
//                           //                       height: 20,
//                           //                     ),
//                           //                     const SizedBox(
//                           //                       height: 10,
//                           //                     ),
//                           //                     Row(
//                           //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           //                       children: [
//                           //                         ShimmerCustom.rectangular(
//                           //                           height: 10,
//                           //                           width: MediaQuery.of(context).size.width * 0.3,
//                           //                         ),
//                           //                         ShimmerCustom.rectangular(
//                           //                           height: 10,
//                           //                           width: MediaQuery.of(context).size.width * 0.3,
//                           //                         ),
//                           //                       ],
//                           //                     ),
//                           //                     const SizedBox(
//                           //                       height: 10,
//                           //                     ),
//                           //                     Row(
//                           //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           //                       children: [
//                           //                         ShimmerCustom.rectangular(
//                           //                           height: 15,
//                           //                           width: MediaQuery.of(context).size.width * 0.3,
//                           //                         ),
//                           //                         ShimmerCustom.rectangular(
//                           //                           height: 15,
//                           //                           width: MediaQuery.of(context).size.width * 0.3,
//                           //                         ),
//                           //                       ],
//                           //                     ),
//                           //                   ],
//                           //                 ),
//                           //               );
//                           //             },
//                           //           ),
//                           //         ],
//                           //       ),
//                           //     ),
//                           //   );
//                           // }
//                         }),
//                   ],
//                 ),
//               )
//             ])));
//   }

//   Widget testscreenbody(List<TestSeriesData>? response) {
//     return response!.isNotEmpty
//         ? SingleChildScrollView(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ListView.builder(
//                     physics: const NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: response.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return testseriesCard(response[index]);
//                     },
//                   )
//                 ],
//               ),
//             ),
//           )
//         : SizedBox(
//             height: 500,
//             child: Center(
//               child: EmptyWidget(
//                 image: SvgImages.emptytestseries,
//                 text: Languages.notestseries,
//               ),
//             ),
//           );
//   }

//   Widget myTestsbody(MyTestsModel response) {
//     return ListView.builder(
//       itemCount: response.data!.length,
//       itemBuilder: (BuildContext context, int index) {
//         return _mytestsCard(response.data![index]);
//       },
//     );
//   }

//   Widget _mytestsCard(Data response) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.90,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: ColorResources.textWhite,
//           boxShadow: [
//             BoxShadow(
//               color: ColorResources.gray.withValues(alpha:0.5),
//               blurRadius: 5.0,
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.75,
//                     child: Text(
//                       response.testseriesId!.testseriesName!,
//                       overflow: TextOverflow.ellipsis,
//                       style: GoogleFonts.notoSansDevanagari(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Text(
//                     response.progress!.value!,
//                     style: GoogleFonts.notoSansDevanagari(color: ColorResources.gray),
//                   )
//                 ],
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               LinearProgressIndicator(
//                 value: double.parse(response.progress!.percentage!),
//                 valueColor: AlwaysStoppedAnimation<Color>(ColorResources.buttoncolor),
//                 backgroundColor: ColorResources.gray.withValues(alpha:0.5),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       '${Languages.startingon} ${response.testseriesId!.startingDate}',
//                       overflow: TextOverflow.clip,
//                       style: GoogleFonts.notoSansDevanagari(color: ColorResources.gray),
//                     ),
//                   ),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: DateFormat('yyyy-MM-dd').parse(response.testseriesId!.startingDate!).difference(DateTime.now()).inDays <= 0 ? ColorResources.buttoncolor : ColorResources.gray,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                         //d
//                       ),
//                     ),
//                     onPressed: () {
//                       if (DateFormat('yyyy-MM-dd').parse(response.testseriesId!.startingDate!).difference(DateTime.now()).inDays <= 0) {
//                         // print(DateFormat('yyyy-MM-dd').parse(response.testseriesId!.startingDate!).difference(DateTime.now()).inDays);
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => TestSeries(
//                               id: response.testseriesId!.sId!,
//                             ),
//                           ),
//                         );
//                       } else {
//                         flutterToast('test series start on ${response.testseriesId!.startingDate}');
//                       }
//                     },
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           Languages.continueText,
//                           style: TextStyle(
//                             color: ColorResources.textWhite,
//                           ),
//                         ), // <-- Text
//                         const SizedBox(
//                           width: 8,
//                         ),
//                         Container(
//                           padding: const EdgeInsets.all(4),
//                           decoration: BoxDecoration(
//                             color: ColorResources.textWhite.withValues(alpha:0.3),
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                             Icons.arrow_forward_ios,
//                             size: 15,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget testseriesCard(TestSeriesData response) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: ColorResources.textWhite,
//         boxShadow: [
//           BoxShadow(
//             color: ColorResources.gray.withValues(alpha:0.5),
//             blurRadius: 5.0,
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             response.testseriesName!,
//             style: GoogleFonts.notoSansDevanagari(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   CachedNetworkImage(
//                     imageUrl: SvgImages.exampen,
//                     height: 25,
//                     width: 25,
//                     placeholder: (context, url) => const Center(
//                       child: CircularProgressIndicator(),
//                     ),
//                     errorWidget: (context, url, error) => const Icon(Icons.error),
//                   ),
//                   const SizedBox(
//                     width: 5,
//                   ),
//                   Text('${response.noOfTest!} ${Languages.noTest}')
//                 ],
//               ),
//               const Spacer(
//                 flex: 1,
//               ),
//               Expanded(
//                 flex: 10,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Icon(Icons.feedback_outlined),
//                     const SizedBox(
//                       width: 5,
//                     ),
//                     Expanded(
//                       child: Text(
//                         "for ${response.stream} ${response.examType!}",
//                         overflow: TextOverflow.clip,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(child: Text("${Languages.startingon} ${response.startingDate!}")),
//               ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: ColorResources.buttoncolor,
//                     shape: const StadiumBorder(),
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => TestSeriesDetailScreen(
//                           testseriesId: response.sId!,
//                         ),
//                       ),
//                     );
//                   },
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         Languages.learnMore,
//                         style: TextStyle(
//                           color: ColorResources.textWhite,
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 8,
//                       ),
//                       Container(
//                         padding: const EdgeInsets.all(4),
//                         decoration: BoxDecoration(
//                           color: ColorResources.textWhite.withValues(alpha:0.3),
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(
//                           Icons.arrow_forward_ios,
//                           size: 15,
//                           color: Colors.white,
//                         ),
//                       )
//                     ],
//                   )),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
