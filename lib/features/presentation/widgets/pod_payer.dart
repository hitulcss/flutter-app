// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pod_player/pod_player.dart';
// import 'package:sd_campus_app/main.dart';
// import 'package:sd_campus_app/util/prefconstatnt.dart';
// import 'package:sd_campus_app/util/preference.dart';

// class PodPlayerScreen extends StatefulWidget {
//   final String youtubeUrl;
//   final bool isWidget;
//   final bool autoPlay;
//   const PodPlayerScreen({super.key, required this.isWidget, required this.youtubeUrl, this.autoPlay = true});

//   @override
//   State<PodPlayerScreen> createState() => _PodPlayerScreenState();
// }

// class _PodPlayerScreenState extends State<PodPlayerScreen> {
//   late final PodPlayerController controller;
//   @override
//   void initState() {
//     analytics.logEvent(name: "app_youtube_video", parameters: {
//       "id": SharedPreferenceHelper.getString(Preferences.enrollId) ?? analytics.getSessionId().toString(),
//       "name": SharedPreferenceHelper.getString(Preferences.name) ?? "Unknown",
//       "video": widget.youtubeUrl,
//       "date": DateTime.now().toString(),
//     });
//     controller = PodPlayerController(
//       playVideoFrom: PlayVideoFrom.youtube(widget.youtubeUrl),
//       podPlayerConfig: PodPlayerConfig(
//         autoPlay: widget.autoPlay,
//         forcedVideoFocus: true,
//         videoQualityPriority: [
//           4320,
//           2160,
//           1440,
//           1080,
//           720,
//           420,
//           360,
//           240,
//           144,
//         ],
//       ),
//     )..initialise();
//     if (!widget.isWidget) {
//       controller.enableFullScreen();
//       // print(controller.isFullScreen);
//     }
//     super.initState();
//   }

//   @override
//   void dispose() {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown
//     ]);
//     if(controller.isInitialised){
//     controller.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.isWidget
//         ? PodVideoPlayer(controller: controller)
//         : Scaffold(
//             body: PodVideoPlayer(controller: controller),
//           );
//   }
// }
