// import 'dart:async';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/services.dart';
// // import 'package:agora_uikit/agora_uikit.dart';
// // import 'package:agora_uikit/controllers/session_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sd_campus_app/api/retrofit_api.dart';
// import 'package:sd_campus_app/api/base_model.dart';
// import 'package:sd_campus_app/api/network_api.dart';
// import 'package:sd_campus_app/api/server_error.dart';
// import 'package:sd_campus_app/features/data/remote/models/my_courses_model.dart';
// import 'package:sd_campus_app/models/deleteuserdetailsfromstream.dart';
// import 'package:sd_campus_app/models/streaminguserdetails.dart';
// import 'package:sd_campus_app/util/color_resources.dart';
// import 'package:sd_campus_app/util/prefconstatnt.dart';
// import 'package:sd_campus_app/util/preference.dart';

// class JoinStreamingScreen extends StatefulWidget {
//   final String rtctoken;
//   final String rtmtoken;
//   final bool userblock;
//   final String userID;
//   final LectureDetails lecture;
//   final int uid;
//   const JoinStreamingScreen({Key? key, required this.lecture, required this.rtctoken, required this.rtmtoken, required this.userblock, required this.userID, required this.uid}) : super(key: key);

//   @override
//   State<JoinStreamingScreen> createState() => _JoinStreamingScreenState();
// }

// class _JoinStreamingScreenState extends State<JoinStreamingScreen> {
//   // static String? channel;
//   // String? userID;
//   // static String appId = "5d035487d2bb4859a5faa4677c039873"; //"1541a573c5d84ce6ae3996f02626f462";//9675807e93584b4c9fec19451a1186fa
//   // static String? rtctoken;
//   // static String? name = SharedPreferenceHelper.getString(Preferences.name);
//   // //static int uid; //random.nextInt(999); //= 123456;
//   // static String? rtmtoken;
//   // final TextEditingController _message = TextEditingController();
//   // final int _selectedIndex = 0;
//   // int? participants;
//   // List<String> chatmessges = [];

//   // List<Data>? userdetails;

//   // static bool blockchat = false;

//   // bool view = false;

//   @override
//   void initState() {
//     // blockchat = widget.userblock;
//     // userID = widget.userID;
//     // channel = widget.lecture.lectureTitle;
//     // rtctoken = widget.rtctoken;
//     // rtmtoken = widget.rtmtoken;
//     // initAgora();
//     // callApigetuserdetails();
//     super.initState();
//   }

// // // Instantiate the client
// //   late AgoraClient client = AgoraClient(
// //     agoraChannelData: AgoraChannelData(
// //       clientRoleType: ClientRoleType.clientRoleAudience,
// //       channelProfileType: ChannelProfileType.channelProfileLiveBroadcasting,
// //     ),
// //     agoraConnectionData: AgoraConnectionData(
// //       username: name,
// //       appId: appId,
// //       channelName: channel.toString(),
// //       tempToken: rtctoken,
// //       uid: widget.uid,
// //       rtmEnabled: true,
// //       rtmUid: widget.uid.toString(),
// //       rtmChannelName: channel,
// //       tempRtmToken: rtmtoken,
// //     ),
// //     agoraRtmChannelEventHandler: AgoraRtmChannelEventHandler(
// //       onMemberCountUpdated: (count) {
// //         participants = count - 1;
// //         // print(count);
// //       },
// //       onMemberLeft: (member) {
// //         safeSetState(() {
// //           callApigetuserdetails();
// //         });
// //       },
// //       onMemberJoined: (onMemberJoined) async {
// //         safeSetState(() {
// //           callApigetuserdetails();
// //         });
// //         // print(AgoraRtmMember.toString());
// //       },
// //       onMessageReceived: (message, fromMember) {
// //         // print('*' * 3000);
// //         //chatmessges.add(fromMember.userId + ':' + message.text);
// //         if (message.text.contains('{')) {
// //         } else {
// //           // print(message.text + ' in first');
// //           if (message.text.contains("blockeduserid:") || message.text.contains('unblockeduserid:')) {
// //             if (message.text.contains("blockeduserid:")) {
// //               if (userID == message.text.split(':')[1]) {
// //                 safeSetState(() {
// //                   // print("*" * 3000);
// //                   // print(message.text + ' in uid');
// //                   blockchat = true;
// //                 });
// //               }
// //             }
// //             if (message.text.contains('unblockeduserid:')) {
// //               if (userID == message.text.split(':')[1]) {
// //                 safeSetState(() {
// //                   // print("*" * 3000);
// //                   blockchat = false;
// //                   // print(message.text + ' in uid');
// //                   // print("*" * 3000);
// //                 });
// //               }
// //             }
// //           } else {
// //             // print("*" * 3000);
// //             // print(message.text + ' in data');
// //             safeSetState(() {
// //               message.text.contains('blockeduserid:')
// //                   ? print("df")
// //                   : message.text.contains('unblockeduserid:')
// //                       ? print("")
// //                       : chatmessges.add(message.text);
// //             });
// //           }
// //         }

// //         // print(message);
// //         // print(fromMember);
// //       },
// //     ),
// //     agoraRtmClientEventHandler: AgoraRtmClientEventHandler(onConnectionStateChanged2: (p0, p1) {
// //       // print('*' * 200);
// //       // print(p0);
// //       // print(p1);
// //     }),
// //   );

//   // @override
//   // void dispose() {
//   //   // print('8' * 3000);
//   //   callApideleteuserdetailsfromstream(widget.uid);
//   //   endthesession(sessionController: client.sessionController);
//   //   blockchat = false;
//   //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values); // to re-show bars
//   //   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
//   //   super.dispose();
//   // }

//   // Future<void> endthesession({required SessionController sessionController}) async {
//   //   await sessionController.value.engine?.leaveChannel();
//   //   if (sessionController.value.connectionData!.rtmEnabled) {
//   //     await sessionController.value.agoraRtmChannel?.leave();
//   //     await sessionController.value.agoraRtmClient?.logout();
//   //   }
//   //   await sessionController.value.engine?.release();
//   // }

//   // void initAgora() async {
//   //   await client.initialize();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return view
//         ? Scaffold(
//             body: SafeArea(
//               child: Stack(
//                 children: [
//                   AgoraVideoViewer(
//                     //showNumberOfUsers: true,
//                     client: client,
//                   ),
//                   Positioned(
//                       bottom: 0,
//                       left: 5,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
//                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: ColorResources.gray.withValues(alpha:0.5)),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.sensors,
//                               color: ColorResources.buttoncolor,
//                             ),
//                             Text(
//                               " Live",
//                               style: GoogleFonts.notoSansDevanagari(color: ColorResources.textWhite),
//                             ),
//                           ],
//                         ),
//                       )),
//                   Positioned(
//                     top: 5,
//                     left: -25,
//                     child: AgoraVideoButtons(
//                       onDisconnect: () async {
//                         //await callApideleteuserdetailsfromstream(
//                         //    widget.uid);
//                         // endthesession(
//                         //     sessionController:
//                         //         client.sessionController);
//                         Navigator.of(context).pop();
//                       },
//                       verticalButtonPadding: 0.0,
//                       client: client,
//                       disconnectButtonChild: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(50),
//                             color: ColorResources.gray.withValues(alpha:0.4),
//                           ),
//                           child: Icon(Icons.close, color: ColorResources.textWhite)),
//                       enabledButtons: const [BuiltInButtons.callEnd],
//                     ),
//                   ),
//                   Positioned(
//                       bottom: 5,
//                       right: 5,
//                       child: InkWell(
//                           onTap: () {
//                             view = false;
//                             SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values); // to re-show bars
//                             SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
//                           },
//                           child: Icon(
//                             Icons.fullscreen,
//                             color: ColorResources.textWhite,
//                           )))
//                 ],
//               ),
//             ),
//           )
//         : Scaffold(
//             body: SafeArea(
//               child: SingleChildScrollView(
//                 child: rtctoken == null
//                     ? const Center(
//                         child: CircularProgressIndicator(),
//                       )
//                     : Column(
//                         children: [
//                           SizedBox(
//                             height: MediaQuery.of(context).size.height * 0.30,
//                             child: Stack(
//                               children: [
//                                 AgoraVideoViewer(
//                                   //showNumberOfUsers: true,
//                                   client: client,
//                                 ),
//                                 Positioned(
//                                     bottom: 0,
//                                     left: 5,
//                                     child: Container(
//                                       padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
//                                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: ColorResources.gray.withValues(alpha:0.5)),
//                                       child: Row(
//                                         children: [
//                                           Icon(
//                                             Icons.sensors,
//                                             color: ColorResources.buttoncolor,
//                                           ),
//                                           Text(
//                                             " Live",
//                                             style: GoogleFonts.notoSansDevanagari(color: ColorResources.textWhite),
//                                           ),
//                                         ],
//                                       ),
//                                     )),
//                                 Positioned(
//                                   top: 5,
//                                   left: -25,
//                                   child: AgoraVideoButtons(
//                                     onDisconnect: () async {
//                                       //await callApideleteuserdetailsfromstream(
//                                       //    widget.uid);
//                                       // endthesession(
//                                       //     sessionController:
//                                       //         client.sessionController);
//                                       Navigator.of(context).pop();
//                                     },
//                                     verticalButtonPadding: 0.0,
//                                     client: client,
//                                     disconnectButtonChild: Container(
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(50),
//                                           color: ColorResources.gray.withValues(alpha:0.4),
//                                         ),
//                                         child: Icon(Icons.close, color: ColorResources.textWhite)),
//                                     enabledButtons: const [BuiltInButtons.callEnd],
//                                   ),
//                                 ),
//                                 Positioned(
//                                   bottom: 5,
//                                   right: 5,
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       view = true;
//                                       SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
//                                       SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
//                                     },
//                                     child: Icon(
//                                       Icons.fullscreen,
//                                       color: ColorResources.textWhite,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                               alignment: Alignment.centerLeft,
//                               padding: const EdgeInsets.all(15),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(widget.lecture.lectureTitle!, style: GoogleFonts.notoSansDevanagari(fontSize: 30)),
//                                   Text(widget.lecture.description!),
//                                   //Text('By ${widget.lecture.subject}'),
//                                   SizedBox(
//                                     height: MediaQuery.of(context).size.height * 0.05,
//                                   ),
//                                   // const Align(
//                                   //     alignment: Alignment.center,
//                                   //     child: Text('Documents Shared with you')),
//                                   // SizedBox(
//                                   //   height: MediaQuery.of(context).size.height * 0.04,
//                                   // ),
//                                   // Padding(
//                                   //   padding:
//                                   //       const EdgeInsets.symmetric(vertical: 10.0),
//                                   //   child: Container(
//                                   //     padding: const EdgeInsets.all(10),
//                                   //     width: double.infinity,
//                                   //     decoration: BoxDecoration(
//                                   //       border: Border.all(
//                                   //         color: ColorResources.gray.withValues(alpha:0.5),
//                                   //       ),
//                                   //       borderRadius: BorderRadius.circular(20),
//                                   //     ),
//                                   //     child: Column(
//                                   //       children: [
//                                   //         Row(
//                                   //           mainAxisAlignment:
//                                   //               MainAxisAlignment.spaceBetween,
//                                   //           children: [
//                                   //             Row(
//                                   //               children: [
//                                   //                 CachedNetworkImage(
//                                   //                   imageUrl: SvgImages.pdfimage,
//                                   //                   placeholder: (context, url) =>
//                                   //                       const Center(
//                                   //                           child:
//                                   //                               CircularProgressIndicator(),),
//                                   //                   errorWidget:
//                                   //                       (context, url, error) =>
//                                   //                           const Icon(Icons.error),
//                                   //                 ),
//                                   //                 const SizedBox(
//                                   //                   width: 20,
//                                   //                 ),
//                                   //                 Column(
//                                   //                   crossAxisAlignment:
//                                   //                       CrossAxisAlignment.start,
//                                   //                   children: [
//                                   //                     Text(
//                                   //                       'Class 1 Notes',
//                                   //                       style: GoogleFonts
//                                   //                           .notoSansDevanagari(
//                                   //                               fontSize: 20,
//                                   //                               fontWeight:
//                                   //                                   FontWeight.w400),
//                                   //                     ),
//                                   //                     Text(
//                                   //                       '2.5 MB',
//                                   //                       style: GoogleFonts.lato(
//                                   //                           fontSize: 16,
//                                   //                           color:
//                                   //                               ColorResources.gray),
//                                   //                     ),
//                                   //                   ],
//                                   //                 ),
//                                   //               ],
//                                   //             ),
//                                   //             Icon(
//                                   //               Icons.file_download_outlined,
//                                   //               size: 40,
//                                   //               color: ColorResources.buttoncolor,
//                                   //             )
//                                   //           ],
//                                   //         ),
//                                   //       ],
//                                   //     ),
//                                   //   ),
//                                   // ),
//                                 ],
//                               ))
//                         ],
//                       ),
//               ),
//             ),
//             bottomNavigationBar: BottomNavigationBar(
//               type: BottomNavigationBarType.fixed,
//               unselectedItemColor: Colors.grey,
//               items: const [
//                 BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'chat'),
//                 BottomNavigationBarItem(icon: Icon(Icons.people_sharp), label: 'Participants'),
//               ],
//               currentIndex: _selectedIndex,
//               selectedItemColor: ColorResources.buttoncolor,
//               onTap: (value) {
//                 if (value == 0) {
//                   showModalBottomSheet(
//                       isScrollControlled: true,
//                       context: context,
//                       builder: (context) {
//                         return StatefulBuilder(builder: (context, safeSetState) {
//                           return Container(
//                             width: MediaQuery.of(context).size.width,
//                             padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//                             child: SingleChildScrollView(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Column(
//                                     children: [
//                                       Row(
//                                         children: [
//                                           IconButton(
//                                             onPressed: () => Navigator.of(context).pop(),
//                                             icon: const Icon(Icons.close),
//                                           ),
//                                           const Text("Chat"),
//                                         ],
//                                       ),
//                                       SizedBox(
//                                         height: MediaQuery.of(context).size.height * 0.45,
//                                         child: SingleChildScrollView(
//                                           reverse: true,
//                                           physics: const ScrollPhysics(),
//                                           child: ListView.builder(
//                                             physics: const NeverScrollableScrollPhysics(),
//                                             shrinkWrap: true,
//                                             padding: const EdgeInsets.all(5),
//                                             itemCount: chatmessges.length,
//                                             itemBuilder: (BuildContext context, int index) {
//                                               return Container(
//                                                 margin: const EdgeInsets.all(5),
//                                                 padding: const EdgeInsets.all(5),
//                                                 decoration: BoxDecoration(
//                                                   borderRadius: BorderRadius.circular(10),
//                                                   color: ColorResources.gray.withValues(alpha:0.2),
//                                                 ),
//                                                 child: Text(
//                                                   chatmessges[index],
//                                                   overflow: TextOverflow.clip,
//                                                 ),
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                                     child: Row(
//                                       children: [
//                                         Expanded(
//                                           child: blockchat
//                                               ? const Text("user have been block by the admin")
//                                               : TextField(
//                                                   controller: _message,
//                                                   decoration: InputDecoration(
//                                                     focusedBorder: OutlineInputBorder(
//                                                       borderRadius: BorderRadius.circular(30),
//                                                       borderSide: BorderSide(color: ColorResources.gray, width: 1.0),
//                                                     ),
//                                                     enabledBorder: OutlineInputBorder(
//                                                       borderSide: BorderSide(color: ColorResources.gray, width: 1.0),
//                                                     ),
//                                                     hintText: 'message',
//                                                   ),
//                                                 ),
//                                         ),
//                                         IconButton(
//                                           onPressed: () async {
//                                             if (_message.text.isNotEmpty) {
//                                               await client.sessionController.value.agoraRtmChannel!.sendMessage2(
//                                                 RtmMessage.fromText("${name!} : ${_message.text}"),
//                                               );
//                                               safeSetState(() {
//                                                 chatmessges.add("you :${_message.text}");
//                                                 _message.clear();
//                                               });
//                                             }
//                                           },
//                                           icon: Icon(
//                                             Icons.send,
//                                             color: ColorResources.buttoncolor,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         });
//                       });
//                 } else {
//                   showModalBottomSheet(
//                       isScrollControlled: true,
//                       context: context,
//                       builder: (context) {
//                         return StatefulBuilder(builder: (context, safeSetState) {
//                           return SingleChildScrollView(
//                             reverse: true,
//                             child: SizedBox(
//                               height: MediaQuery.of(context).size.height * 0.45,
//                               child: SingleChildScrollView(
//                                 child: Column(
//                                   children: [
//                                     Row(
//                                       children: [
//                                         IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
//                                         Text("Participants ${userdetails!.length.toString()}"),
//                                       ],
//                                     ),
//                                     // userdetails!.length == 0
//                                     //     ? const Center(
//                                     //         child: Text('There no one yet..'),
//                                     //       )
//                                     //     :
//                                     GridView.builder(
//                                       physics: const NeverScrollableScrollPhysics(),
//                                       itemCount: userdetails!.length,
//                                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                                         crossAxisCount: 3,
//                                         crossAxisSpacing: 4.0,
//                                       ),
//                                       shrinkWrap: true,
//                                       itemBuilder: (BuildContext context, int index) {
//                                         // print("+" * 200);
//                                         // print(userdetails![index]
//                                         // .profilePicture!);
//                                         return Column(children: [
//                                           CircleAvatar(
//                                             radius: 40.0,
//                                             backgroundImage: CachedNetworkImageProvider(userdetails![index].profilePicture!),
//                                             backgroundColor: Colors.grey,
//                                           ),
//                                           Text(
//                                             userdetails![index].studentName!,
//                                             textAlign: TextAlign.center,
//                                           )
//                                         ]);
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         });
//                       });
//                 }
//               },
//             ),
//           );
//   }

//   Future<BaseModel<StreamingUserDetails>> callApigetuserdetails() async {
//     StreamingUserDetails response;

//     try {
//       var token = SharedPreferenceHelper.getString(Preferences.accesstoken);
//       response = await RestClient(RetroApi().dioData(token!)).streaminguserdetailsRequest();
//       userdetails = response.data;
//     } catch (error) {
//       // print("Exception occur: $error stackTrace: $stacktrace");
//       return BaseModel()..setException(ServerError.withError(error: error));
//     }
//     return BaseModel()..data = response;
//   }

//   Future<BaseModel<DeleteUserDetailsFromStream>> callApideleteuserdetailsfromstream(uid) async {
//     DeleteUserDetailsFromStream response;
//     Map<String, dynamic> body = {"id": uid};
//     try {
//       var token = SharedPreferenceHelper.getString(Preferences.accesstoken);
//       response = await RestClient(RetroApi().dioData(token!)).deleteuserdetailsfromstreamRequest(body);
//     } catch (error) {
//       // print("Exception occur: $error stackTrace: $stacktrace");
//       return BaseModel()..setException(ServerError.withError(error: error));
//     }
//     return BaseModel()..data = response;
//   }
// }
