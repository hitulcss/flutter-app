import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sd_campus_app/features/cubit/mediasoup/mediasoup_cubit.dart';
import 'package:sd_campus_app/features/services/mediasoup_handler.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/live_class/live_class_lecture.dart';

class FullScreenLiveClass extends StatefulWidget {
  final MediaSoupHandler mediaSoupHandler;
  final String banner;
  final String title;
  const FullScreenLiveClass({super.key, required this.mediaSoupHandler, required this.banner, required this.title});

  @override
  State<FullScreenLiveClass> createState() => _FullScreenLiveClassState();
}

class _FullScreenLiveClassState extends State<FullScreenLiveClass> {
  @override
  void initState() {
    super.initState();
    analytics.logEvent(name: "TwowayLiveClassFullScreen", parameters: {
      "isopen": "true",
      "CalssName": widget.title
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
// SystemChrome.setEnabledSystemUIOverlays([]);
    // SystemChrome.setPreferredOrientations(
    //   [
    //     // DeviceOrientation.portraitUp,
    //     // DeviceOrientation.portraitDown,
    //     DeviceOrientation.landscapeLeft,
    //     DeviceOrientation.landscapeRight,
    //   ],
    // );
  }

  @override
  void dispose() {
    super.dispose();
    analytics.logEvent(name: "TwowayLiveClassFullScreen", parameters: {
      "isopen": "false",
      "CalssName": widget.title
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    // SystemChrome.setPreferredOrientations(
    //   [
    //     DeviceOrientation.portraitUp,
    //     DeviceOrientation.portraitDown,
    //   ],
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Hero(
        tag: "fullscreen_video",
        child: BlocBuilder<MediasoupCubit, MediasoupState>(
          builder: (context, state) {
            // print("F " * 100);
            // print(state);
            // print(context.read<MediasoupCubit>().noOfuser);
            // print(widget.mediaSoupHandler.socketids);
            // print("F " * 100);
            return RotatedBox(
              quarterTurns: 1,
              child: SizedBox(
                height: MediaQuery.sizeOf(context).width,
                width: MediaQuery.sizeOf(context).height,
                child: Stack(
                  children: [
                    Wrap(
                      children: checkAdminAval(widget.mediaSoupHandler.socketids)
                          ? [
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        widget.banner,
                                      ),
                                      fit: BoxFit.fill,
                                      filterQuality: FilterQuality.low,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    // make sure we apply clip it properly
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                      child: Container(
                                        alignment: Alignment.center,
                                        color: Colors.grey.withValues(alpha: 0.1),
                                        child: Text(
                                          Preferences.appString.classAbouttoStart ?? "Class about to start. \nPlease Wait...",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ]
                          : widget.mediaSoupHandler.socketids.entries
                              .map((e) => e.value.containsKey("audio")
                                  ? e.value["video"] != null && e.value["isvideo"] && e.value["isAdmin"]
                                      ? LayoutBuilder(builder: (context, constraints) {
                                          return SizedBox(
                                            height: MediaQuery.sizeOf(context).width,
                                            width: MediaQuery.sizeOf(context).height,
                                            child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxHeight: constraints.maxHeight - 100,
                                                ),
                                                child: e.value["video"] as Widget),
                                          );
                                        })
                                      : e.value["audio"] != null && e.value["isaudio"] && e.value["isAdmin"]
                                          ? e.value["audio"] as Widget
                                          : Container()
                                  : Container())
                              .toList(),
                    ),
                    Positioned(
                        right: 0,
                        bottom: 0,
                        child: IconButton(
                            onPressed: () async {
                              // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
                              // await SystemChrome.setPreferredOrientations(
                              //   [
                              //     DeviceOrientation.portraitUp,
                              //     DeviceOrientation.portraitDown,
                              //   ],
                              // );
                              // print("FullScreen " * 10);
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.fullscreen_exit,
                              color: Colors.white,
                            ))),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Row(
                        children: [
                          Text.rich(
                            const TextSpan(children: [
                              TextSpan(
                                text: '🔴 ',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: "Live",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                            style: TextStyle(
                              background: Paint()..color = Colors.redAccent.withValues(alpha: 0.20),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.4),
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: BlocBuilder<MediasoupCubit, MediasoupState>(
                              builder: (context, state) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      BlocProvider.of<MediasoupCubit>(context).noOfuser.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
