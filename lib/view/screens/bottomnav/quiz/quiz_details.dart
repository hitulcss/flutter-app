// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:sd_campus_app/features/cubit/quiz/quiz_cubit.dart';
// import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
// import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
// import 'package:sd_campus_app/main.dart';
// import 'package:sd_campus_app/util/color_resources.dart';
// import 'package:sd_campus_app/util/langauge.dart';
// import 'package:sd_campus_app/util/prefconstatnt.dart';
// import 'package:sd_campus_app/view/screens/bottomnav/quiz/quiz_page.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:url_launcher/url_launcher.dart';

// class QuizDetailsScreen extends StatelessWidget {
//   final String shareLink;
//   final String shareText;
//   final String image;
//   final bool isnegative;
//   final int noQuestion;
//   final String duration;
//   final String descration;
//   final String id;
//   final String title;
//   final String language;
//   final String startdate;
//   const QuizDetailsScreen({
//     super.key,
//     required this.language,
//     required this.title,
//     required this.id,
//     required this.descration,
//     required this.duration,
//     required this.isnegative,
//     required this.noQuestion,
//     required this.startdate,
//     required this.shareLink,
//     required this.shareText,
//     required this.image,
//   });
//   @override
//   Widget build(BuildContext context) {
//     analytics.logScreenView(screenName: "app_quize_detail", parameters: {
//       "id": id,
//       "title": title,
//       "startdate": startdate,
//     });
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: ColorResources.textWhite,
//         iconTheme: IconThemeData(color: ColorResources.textblack),
//         title: Text(
//           title,
//           style: GoogleFonts.notoSansDevanagari(
//             color: ColorResources.textblack,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           if (shareLink.isNotEmpty)
//             IconButton(
//               onPressed: () {
//                 try {
//                   Share.share("$shareText\n$shareLink");
//                 } catch (e) {
//                   // print(e);
//                 }
//               },
//               icon: const Icon(Icons.share),
//             ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             CachedNetworkImage(
//               imageUrl: image,
//               errorWidget: (context, url, error) => SizedBox(),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     decoration: BoxDecoration(color: ColorResources.gray.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Text(
//                               "-ve",
//                               style: GoogleFonts.notoSansDevanagari(color: ColorResources.buttoncolor, fontWeight: FontWeight.bold),
//                             ),
//                             const SizedBox(
//                               width: 5,
//                             ),
//                             Text(Languages.negtiveMarketing),
//                           ],
//                         ),
//                         Switch(
//                           value: isnegative,
//                           activeColor: ColorResources.buttoncolor,
//                           trackColor: WidgetStateProperty.resolveWith((state) {
//                             if (state.contains(WidgetState.selected)) {
//                               return Colors.white;
//                             } else {
//                               return Colors.grey[300];
//                             }
//                           }),
//                           trackOutlineColor: WidgetStateProperty.all(Colors.grey),
//                           onChanged: (value) {},
//                         )
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Text(
//                     "Brief explanation about this quiz",
//                     style: GoogleFonts.notoSansDevanagari(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[800],
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                     decoration: BoxDecoration(
//                       color: ColorResources.gray.withValues(alpha: 0.1),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Row(
//                       children: [
//                         Row(
//                           children: [
//                             Container(padding: const EdgeInsets.all(5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: ColorResources.buttoncolor), child: const Icon(Icons.sticky_note_2_outlined, color: Colors.white)),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             Text(
//                               "$noQuestion ${Languages.questions}",
//                               style: GoogleFonts.notoSansDevanagari(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             )
//                           ],
//                         ),
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width * 0.15,
//                         ),
//                         Row(
//                           children: [
//                             Container(
//                                 padding: const EdgeInsets.all(5),
//                                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: ColorResources.buttoncolor),
//                                 child: const Icon(
//                                   Icons.access_time,
//                                   color: Colors.white,
//                                 )),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             Text(
//                               "$duration Min",
//                               style: GoogleFonts.notoSansDevanagari(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Text(
//                     "Please read the text below carefully so you can understand it",
//                     style: GoogleFonts.notoSansDevanagari(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[800],
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width * 0.95,
//                     padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//                     decoration: BoxDecoration(
//                       color: ColorResources.gray.withValues(alpha: 0.1),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Html(
//                       data: descration,
//                       onAnchorTap: (url, attributes, element) {
//                         Uri openurl = Uri.parse(url!);
//                         launchUrl(
//                           openurl,
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 60,
//                   ),
//                   Align(
//                     child: Column(
//                       children: [
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: DateFormat('dd-MM-yyyy HH:mm:ss').parse(startdate).difference(DateTime.now()).inSeconds > 0 ? ColorResources.gray : ColorResources.buttoncolor,
//                             shape: const StadiumBorder(),
//                           ),
//                           onPressed: DateFormat('dd-MM-yyyy HH:mm:ss').parse(startdate).difference(DateTime.now()).inSeconds > 0
//                               ? () {
//                                   analytics.logEvent(name: "app_quiz_attempt_before", parameters: {
//                                     "id": id,
//                                     "title": title
//                                   });
//                                   flutterToast('Test well start $startdate');
//                                 }
//                               : () {
//                                   analytics.logEvent(
//                                     name: "app_quiz_attempt",
//                                     parameters: {
//                                       "id": id,
//                                       "name": title,
//                                     },
//                                   );
//                                   Preferences.onLoading(context);
//                                   RemoteDataSourceImpl().getQuestionsById(id).then(
//                                     (value) {
//                                       Preferences.hideDialog(context);
//                                       if (value.status!) {
//                                         // print(startdate);
//                                         context.read<QuizCubit>().questionNumber = 1;
//                                         context.read<QuizCubit>().answerarr.clear();
//                                         context.read<QuizCubit>().init(noQuestion);
//                                         // print(context.read<QuizCubit>().answerarr);
//                                         Navigator.of(context).push(
//                                           MaterialPageRoute(
//                                             builder: (context) => QuizScreen(
//                                               title: title,
//                                               listofquestionsdata: value.data,
//                                               noQuestion: noQuestion,
//                                               id: id,
//                                               language: language,
//                                               time: Duration(
//                                                 minutes: int.parse(duration),
//                                               ).inSeconds,
//                                             ),
//                                           ),
//                                         );
//                                       } else {
//                                         flutterToast(value.msg!);
//                                       }
//                                     },
//                                   );
//                                 },
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//                             child: Text(
//                               Languages.startquiz,
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         DateFormat('dd-MM-yyyy HH:mm:ss').parse(startdate).difference(DateTime.now()).inSeconds > 0 ? Text("Note:Test Will Start at $startdate") : Container(),
//                         const SizedBox(
//                           height: 100,
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
