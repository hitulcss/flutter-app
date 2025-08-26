// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:sd_campus_app/features/data/remote/models/my_courses_model.dart';
// import 'package:sd_campus_app/features/presentation/widgets/resourcespdfwidget.dart';
// import 'package:sd_campus_app/util/color_resources.dart';
// import 'package:sd_campus_app/util/langauge.dart';
// import 'package:sd_campus_app/view/screens/bottomnav/ncert.dart';

// class CoursePaidDetailScreen extends StatefulWidget {
//   final MyCoursesDataModel batch;
//   const CoursePaidDetailScreen({super.key, required this.batch});

//   @override
//   State<CoursePaidDetailScreen> createState() => _CoursePaidDetailScreenState();
// }

// class _CoursePaidDetailScreenState extends State<CoursePaidDetailScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.batch.batchName!,
//           style: TextStyle(
//             color: ColorResources.textblack,
//           ),
//         ),
//         backgroundColor: ColorResources.textWhite,
//         iconTheme: IconThemeData(
//           color: ColorResources.textblack,
//         ),
//       ),
//       body: Align(
//         alignment: Alignment.topCenter,
//         child: FractionallySizedBox(
//           widthFactor: 0.9,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Align(
//                   alignment: Alignment.center,
//                   child: Image.network(
//                     widget.batch.banner![0].fileLoc!,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   widget.batch.batchName!,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w900,
//                     fontSize: 24,
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.symmetric(vertical: 10),
//                   padding: const EdgeInsets.all(5),
//                   decoration: BoxDecoration(color:  ColorResources.borderColor.withValues(alpha:0.5), borderRadius: BorderRadius.circular(90),),
//                   child: Text(
//                     Languages.coursedetails,
//                     style: GoogleFonts.notoSansDevanagari(fontSize: 16),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Html(
//                   data: widget.batch.description!,
//                   // customRender: {
//                   //   'p': (RenderContext context, Widget child) {
//                   //     return ReadMoreText(
//                   //       context.tree.element!.innerHtml,
//                   //       trimLines: 4, // Adjust this value as needed
//                   //       trimMode: TrimMode.Line,
//                   //     );
//                   //   }
//                   // },
//                   // overflow: TextOverflow.ellipsis,
//                   // maxLines: 4,
//                   // textAlign: TextAlign.justify,
//                 ),
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(5),
//                   decoration: BoxDecoration(color:  ColorResources.borderColor.withValues(alpha:0.5), borderRadius: BorderRadius.circular(90),),
//                   child: Text(
//                     Languages.duration,
//                     style: GoogleFonts.notoSansDevanagari(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.access_time_rounded,
//                     ),
//                     Text('  ${DateFormat('yyyy-MM-dd').parse(widget.batch.endingdate!).difference(DateFormat('yyyy-MM-dd').parse(widget.batch.startingDate!)).inDays} ${Languages.days}'),
//                     const Expanded(child: SizedBox()),
//                     Row(children: [
//                       const Icon(
//                         Icons.calendar_month_rounded,
//                       ),
//                       Text('${Languages.starts} : ${DateFormat("dd-MM-yyyy").format(DateFormat('yyyy-MM-dd').parse(widget.batch.startingDate!))}')
//                     ]),
//                   ],
//                 ),
//                 // Container(
//                 //   margin:
//                 //       const EdgeInsets.symmetric(vertical: 10),
//                 //   padding: const EdgeInsets.all(5),
//                 //   decoration: BoxDecoration(
//                 //       color: const ColorResources.borderColor,
//                 //       borderRadius: BorderRadius.circular(90)),
//                 //   child: Text(
//                 //     'Faculty  ',
//                 //     style: GoogleFonts.notoSansDevanagari(
//                 //         fontSize: 16),
//                 //   ),
//                 // ),
//                 // Container(
//                 //   height: 100,
//                 //   child: ListView.builder(
//                 //     itemCount: widget.batch.teacher.length,
//                 //     scrollDirection: Axis.horizontal,
//                 //     itemBuilder: (context, index) => Padding(
//                 //       padding: const EdgeInsets.symmetric(
//                 //           horizontal: 5.0),
//                 //       child: Column(
//                 //         children: [
//                 //           CachedNetworkImage(
//                 //             imageUrl: widget.batch.teacher[index]
//                 //                 .profilePhoto,
//                 //             placeholder: (context, url) =>
//                 //                 const Center(
//                 //                     child:
//                 //                         CircularProgressIndicator(),),
//                 //             errorWidget: (context, url, error) =>
//                 //                 const Icon(Icons.error),
//                 //             height: 70,
//                 //           ),
//                 //           SizedBox(
//                 //             width: 70,
//                 //             child: Text(
//                 //               widget
//                 //                   .batch.teacher[index].fullName,
//                 //               textAlign: TextAlign.center,
//                 //               style:
//                 //                   GoogleFonts.notoSansDevanagari(
//                 //                       fontSize: 16,
//                 //                       fontWeight:
//                 //                           FontWeight.bold),
//                 //               overflow: TextOverflow.ellipsis,
//                 //             ),
//                 //           ),
//                 //         ],
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//                 widget.batch.planner!.fileLoc!.isEmpty
//                     ? Container()
//                     : ResourcesContainerWidget(
//                         title: widget.batch.planner!.fileName!,
//                         uploadFile: widget.batch.planner!.fileLoc!,
//                         resourcetype: "pdf",
//                         fileSize: "",
//                       ),
//                 widget.batch.teacher!.isEmpty
//                     ? Container()
//                     : Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Text(
//                           'Know  Your Teachers',
//                           style: TextStyle(
//                             color: ColorResources.textblack,
//                             fontSize: 16,
//
//                             fontWeight: FontWeight.w500,
//                             height: 0,
//                             letterSpacing: -0.64,
//                           ),
//                         ),
//                       ),
//                 widget.batch.teacher!.isEmpty
//                     ? Container()
//                     : Container(
//                         height: 170,
//                         child: ListView.builder(
//                           itemCount: widget.batch.teacher!.length,
//                           scrollDirection: Axis.horizontal,
//                           itemBuilder: (context, index) => Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 5.0),
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                               constraints: const BoxConstraints(maxWidth: 150, minWidth: 150),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 gradient: LinearGradient(
//                                   begin: const Alignment(0.00, -1.00),
//                                   end: const Alignment(0, 1),
//                                   colors: [
//                                     const Color(0xDB9603F2),
//                                     Colors.white.withValues(alpha:0)
//                                   ],
//                                 ),
//                               ),
//                               child: Column(
//                                 children: [
//                                   Image.network(
//                                     widget.batch.teacher![index].profilePhoto!,
//                                     height: 100,
//                                     width: 100,
//                                   ),
//                                   const SizedBox(
//                                     height: 5,
//                                   ),
//                                   Text(
//                                     widget.batch.teacher![index].fullName!,
//                                     style: GoogleFonts.notoSansDevanagari(
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   const SizedBox(
//                                     height: 5,
//                                   ),
//                                   Text(
//                                     widget.batch.teacher![index].subject!.fold("", (previousValue, element) => "${previousValue.trim()}${element.title!.trim()},") * 10,
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: GoogleFonts.notoSansDevanagari(
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   Languages.demovideo,
//                   style: GoogleFonts.notoSansDevanagari(fontWeight: FontWeight.bold, fontSize: 20, color: ColorResources.textblack),
//                 ),
//                 Container(
//                   height: 120,
//                   width: double.infinity,
//                   margin: const EdgeInsets.symmetric(vertical: 5),
//                   decoration: BoxDecoration(
//                     color: ColorResources.textWhite,
//                     boxShadow: [
//                       BoxShadow(
//                         color: ColorResources.gray.withValues(alpha:0.5),
//                         blurRadius: 2,
//                         blurStyle: BlurStyle.normal,
//                       ),
//                     ],
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   padding: const EdgeInsets.all(10),
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: widget.batch.demoVideo!.length,
//                     scrollDirection: Axis.horizontal,
//                     itemBuilder: (context, index) => Container(
//                       margin: const EdgeInsets.all(5),
//                       width: 130,
//                       height: 90,
//                       child: YouTubeContainerWidget(
//                         videoUrl: widget.batch.demoVideo![index].fileLoc!,
//                         height: 90,
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
// }
