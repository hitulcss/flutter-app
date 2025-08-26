import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/api/api.dart';
import 'package:sd_campus_app/features/cubit/appstream_cubit/app_stream_cubit.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/my_courses_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/cus_player.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/lecture/lecture_info.dart';
import 'package:sd_campus_app/features/presentation/widgets/lecture/lecture_rating.dart';
import 'package:sd_campus_app/features/presentation/widgets/lecture/lecture_report.dart';
import 'package:sd_campus_app/features/presentation/widgets/lecture/lecture_resource.dart';
import 'package:sd_campus_app/features/presentation/widgets/lecture/report_sugg.dart';
import 'package:sd_campus_app/features/services/socket_connection.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/enum/playertype.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class JoinStreamingScreen extends StatefulWidget {
  final LectureDetails lecture;
  const JoinStreamingScreen({super.key, required this.lecture});

  @override
  State<JoinStreamingScreen> createState() => _JoinStreamingScreenState();
}

class _JoinStreamingScreenState extends State<JoinStreamingScreen> with WidgetsBindingObserver {
  int myDuration = 0;
  final TextEditingController _message = TextEditingController();
  // List messageList = [];
  bool isfullscreen = false;
  // final FocusNode _focusNode = FocusNode();
  // final ScrollController _chatscrollController = ScrollController();
  // IO.Socket? socket;
  bool chatopend = false;
  @override
  void initState() {
    analytics.logEvent(name: "app_class_video_app", parameters: {
      "islive": widget.lecture.liveOrRecorded == 'Live' ? true.toString() : false.toString(),
      "url": widget.lecture.link!,
    });
    Timer.periodic(const Duration(seconds: 1), (_) {
      myDuration++;
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (chatopend) {
    //     _chatscrollController.jumpTo(_chatscrollController.position.maxScrollExtent);
    //   }
    // });
    connectAndListen();
    WidgetsBinding.instance.addObserver(this);
    //print('*' * 100);
    //print(widget.lecture.link!);
    //print('*' * 100);
    super.initState();
  }

  //STEP2: Add this function in main function in main.dart file and add incoming data to the stream
  void connectAndListen() {
    SocketConnetion.connect(url: Apis.rootUrl);
    // socket = IO.io(
    //     Apis.rootUrl,
    //     IO.OptionBuilder().setTransports([
    //       'websocket'
    //     ]).build());
    // socket!.disconnect().connect();
    SocketConnetion.connection.onConnect((_) {
      // print('connect');
      SocketConnetion.connection.emit('create', widget.lecture.commonName);
      //send-message send msg
      SocketConnetion.connection.emit('send-message', [
        'Joined',
        SharedPreferenceHelper.getString(Preferences.name),
        widget.lecture.commonName,
        SharedPreferenceHelper.getString(Preferences.profileImage),
        widget.lecture.batchDetails?.batchName ?? "",
        widget.lecture.batchDetails?.id ?? "",
      ]);
    });
    // SocketConnetion.connection.onConnectError((data) => SocketConnetion.connection.disconnect()..connect());
    // SocketConnetion.connection.onConnectTimeout((data) => SocketConnetion.connection.disconnect()..connect());
    //When an event recieved from server, data is added to the stream
    SocketConnetion.connection.on('receive-message', (data) {
      // streamSocket.addResponse(data);

      // print(data);
      context.read<AppStreamCubit>().messages.insert(0, data);
      // context.read<AppStreamCubit>().stateupdate();
      safeSetState(() {});
    });
    // socket!.onDisconnect((_) => //print('disconnect'));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        //print('*' * 100);
        //print(myDuration);
        //print('*' * 100);
        RemoteDataSourceImpl().getTimeSpendLRequest(
          id: widget.lecture.sId!,
          time: myDuration.toString(),
        );
        // context.read<QuizCubit>().submitResumeQuizobjective(
        //       testid: widget.id,
        //       timeSpent: context.read<QuizCubit>().getTimeQuiz,
        //     );
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void dispose() {
    // print('*' * 10);
    // print(myDuration);
    // print('*' * 10);
    RemoteDataSourceImpl().getTimeSpendLRequest(
      id: widget.lecture.sId!,
      time: myDuration.toString(),
    );
    // _chatscrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    SocketConnetion.connection.dispose();
    _message.dispose();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    ); // to re-show bars
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // BlocBuilder<AppStreamCubit, AppStreamState>(
            //   builder: (context, state) {
            //     return context.read<AppStreamCubit>().isfull
            //         ? Container()
            //         : Row(
            //             children: [
            //               IconButton(onPressed: () => Navigator.of(context).pop(), icon:  Icon(Icons.arrow_back)),
            //               Expanded(
            //                 child: Text(
            //                   widget.lecture.lectureTitle!,
            //                   overflow: TextOverflow.ellipsis,
            //                   style: GoogleFonts.notoSansDevanagari(
            //                     fontSize: 16,
            //                     fontWeight: FontWeight.bold,
            //                     color: ColorResources.textblack,
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           );
            //   },
            // ),
            MediaQuery.removePadding(
              context: context,
              removeBottom: true,
              removeTop: true,
              child: CuPlayerScreen(
                autoPLay: true,
                url: widget.lecture.link ?? "",
                isLive: widget.lecture.liveOrRecorded == "Live" ? true : false,
                playerType: PlayerType.hLS,
                wallpaper: widget.lecture.banner ?? "",
                canpop: true,
                children: const [],
              ),
            ),
            // Container(
            //   color: Colors.black,
            // child: YoYoPlayer(
            //     aspectRatio: 16 / 9,
            //     // Url (Video streaming links)
            //     // 'https://dsqqu7oxq6o1v.cloudfront.net/preview-9650dW8x3YLoZ8.webm',
            //     // "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
            //     // "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
            //     url: widget.lecture.link!,
            //     videoPlayerOptions: VideoPlayerOptions(),
            //     videoStyle: VideoStyle(
            //       videoDurationStyle: TextStyle(
            //         backgroundColor: widget.lecture.liveOrRecorded == 'Live' ? Colors.transparent : ColorResources.gray.withValues(alpha:0.3),
            //         color: widget.lecture.liveOrRecorded == 'Live' ? Colors.transparent : Colors.white,
            //         fontWeight: FontWeight.w500,
            //       ),
            //       videoSeekStyle: TextStyle(
            //         backgroundColor: widget.lecture.liveOrRecorded == 'Live' ? Colors.transparent : ColorResources.gray.withValues(alpha:0.3),
            //         color: widget.lecture.liveOrRecorded == 'Live' ? Colors.transparent : Colors.white,
            //         fontWeight: FontWeight.w500,
            //       ),
            //       bottomBarPadding: EdgeInsets.zero,
            //       forwardAndBackwardBtSize: 30.0,
            //       showLiveDirectButton: widget.lecture.liveOrRecorded == 'Live' ? true : false,
            //       progressIndicatorColors: VideoProgressColors(
            //         playedColor: widget.lecture.liveOrRecorded == 'Live' ? Colors.transparent :  Color.fromRGBO(255, 0, 0, 0.7),
            //         bufferedColor: widget.lecture.liveOrRecorded == 'Live' ? Colors.transparent :  Color.fromRGBO(50, 50, 200, 0.2),
            //         backgroundColor: widget.lecture.liveOrRecorded == 'Live' ? Colors.transparent :  Color.fromRGBO(200, 200, 200, 0.5),
            //       ),
            //       actionBarBgColor: Colors.grey.withValues(alpha:0.3),
            //       liveDirectButtonDisableColor: Colors.red,
            //       allowScrubbing: false,
            //       qualityStyle:  TextStyle(
            //         fontSize: 16.0,
            //         fontWeight: FontWeight.w500,
            //         color: Colors.white,
            //       ),
            //       progressIndicatorPadding:  EdgeInsets.symmetric(
            //         horizontal: 5,
            //       ),
            //       playButtonIconSize: 40.0,
            //       forwardIcon: Icon(
            //         Icons.forward_30,
            //         size: 40.0,
            //         shadows: [
            //           Shadow(color: ColorResources.borderColor)
            //         ],
            //         color: Colors.white,
            //       ),
            //       backwardIcon:  Icon(
            //         Icons.replay_30,
            //         size: 40.0,
            //         color: Colors.white,
            //       ),
            //       playIcon:  Icon(
            //         Icons.play_circle_outline,
            //         size: 40.0,
            //         color: Colors.white,
            //         fill: 1.0,
            //       ),
            //       pauseIcon:  Icon(
            //         Icons.pause_circle_outline,
            //         size: 40.0,
            //         color: Colors.white,
            //         fill: 1.0,
            //       ),
            //       videoQualityPadding:  EdgeInsets.all(5.0),
            //     ),
            //     videoLoadingStyle:  VideoLoadingStyle(
            //       loading: Center(
            //         child: Text("Loading video"),
            //       ),
            //     ),
            //     allowCacheFile: true,
            //     onCacheFileCompleted: (files) {
            //       //print('Cached file length ::: ${files?.length}');

            //       if (files != null && files.isNotEmpty) {
            //         for (var file in files) {
            //           //print('File path ::: ${file.path}');
            //         }
            //       }
            //     },
            //     onCacheFileFailed: (error) {
            //       //print('Cache file error ::: $error');
            //     },
            //     onFullScreen: (value) {
            //       context.read<AppStreamCubit>().isFullScreen(isfullscreen: value);
            //       // safeSetState(() {
            //       // if (isfullscreen != value) {
            //       // isfullscreen = value;
            //       // }
            //       // });
            //     }),
            // ),
            BlocBuilder<AppStreamCubit, AppStreamState>(
              builder: (context, state) {
                return context.read<AppStreamCubit>().isfull
                    ? Container()
                    : Expanded(
                        child: DefaultTabController(
                          length: widget.lecture.isCommentAllowed ?? false ? 5 : 4,
                          child: Column(
                            children: [
                              TabBar(
                                tabAlignment: TabAlignment.start,
                                isScrollable: true,
                                tabs: [
                                  Tab(
                                    text: Preferences.appString.info ?? "Info",
                                    icon: const Icon(
                                      Icons.description_outlined,
                                    ),
                                  ),
                                  Tab(
                                    text: Preferences.appString.resources ?? "Resources",
                                    icon: const Icon(
                                      Icons.snippet_folder_outlined,
                                    ),
                                  ),
                                  if (widget.lecture.isCommentAllowed ?? false)
                                    Tab(
                                      text: widget.lecture.liveOrRecorded == 'Live' ? Preferences.appString.liveChat ?? "Live Chat" : Preferences.appString.comments ?? "Comments",
                                      icon: const Icon(
                                        Icons.chat_bubble_outline,
                                      ),
                                    ),
                                  Tab(
                                    text: Preferences.appString.rating ?? "Rating",
                                    icon: const Icon(
                                      Icons.star_border_rounded,
                                    ),
                                  ),
                                  Tab(
                                    text: Preferences.appString.report ?? "Report",
                                    icon: const Icon(
                                      Icons.warning_amber_outlined,
                                    ),
                                  )
                                ],
                              ),
                              Expanded(
                                child: TabBarView(children: [
                                  LectureInfoScreen(lecture: widget.lecture),
                                  LectureResourceScreen(lecture: widget.lecture),
                                  if (widget.lecture.isCommentAllowed ?? false)
                                    widget.lecture.liveOrRecorded == 'Live'
                                        ? Column(
                                            children: [
                                              Expanded(
                                                child: BlocBuilder<AppStreamCubit, AppStreamState>(
                                                  builder: (context, state) {
                                                    return context.read<AppStreamCubit>().messages.isEmpty
                                                        ? Center(
                                                            child: EmptyWidget(image: SvgImages.nochatEmpty, text: Preferences.appString.noComments ?? "There are no messages here yet. Start a Chat by sending a message"),
                                                          )
                                                        : Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                                                            child: ListView.separated(
                                                              separatorBuilder: (context, index) => const SizedBox(
                                                                height: 10,
                                                              ),
                                                              shrinkWrap: true,
                                                              physics: const NeverScrollableScrollPhysics(),
                                                              itemCount: context.read<AppStreamCubit>().messages.length,
                                                              itemBuilder: (context, index) => Row(
                                                                children: [
                                                                  CircleAvatar(
                                                                    backgroundImage: CachedNetworkImageProvider(context.read<AppStreamCubit>().messages[index][2]),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Expanded(
                                                                    child: Text.rich(TextSpan(text: context.read<AppStreamCubit>().messages[index][1] + " : ", children: [
                                                                      TextSpan(
                                                                          text: context.read<AppStreamCubit>().messages[index][0],
                                                                          style: TextStyle(
                                                                            color: ColorResources.textBlackSec,
                                                                          ))
                                                                    ])),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                  },
                                                ),
                                              ),
                                              Container(
                                                color: Colors.white,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 25,
                                                        backgroundImage: CachedNetworkImageProvider(
                                                          SharedPreferenceHelper.getString(Preferences.profileImage)!,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        child: TextField(
                                                          controller: _message,
                                                          onSubmitted: (value) {
                                                            if (_message.text.isEmpty) {
                                                              var snackBar = const SnackBar(
                                                                content: Text(
                                                                  "Please Enter The Message",
                                                                ),
                                                              );
                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                            } else {
                                                              SocketConnetion.connection.emit('send-message', [
                                                                _message.text,
                                                                SharedPreferenceHelper.getString(Preferences.name),
                                                                widget.lecture.commonName,
                                                                SharedPreferenceHelper.getString(Preferences.profileImage),
                                                                widget.lecture.batchDetails?.batchName ?? "",
                                                                widget.lecture.batchDetails?.id ?? "",
                                                              ]);
                                                              _message.clear();
                                                              context.read<AppStreamCubit>().stateupdate();
                                                              FocusScope.of(context).unfocus();
                                                            }
                                                          },
                                                          decoration: InputDecoration(
                                                            suffixIcon: GestureDetector(
                                                              onTap: () {
                                                                if (_message.text.isEmpty) {
                                                                  var snackBar = const SnackBar(content: Text("Please Enter The Message"));
                                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                } else {
                                                                  SocketConnetion.connection.emit('send-message', [
                                                                    _message.text,
                                                                    SharedPreferenceHelper.getString(Preferences.name),
                                                                    widget.lecture.commonName,
                                                                    SharedPreferenceHelper.getString(Preferences.profileImage),
                                                                    widget.lecture.batchDetails?.batchName ?? "",
                                                                    widget.lecture.batchDetails?.id ?? "",
                                                                  ]);
                                                                  _message.clear();
                                                                  context.read<AppStreamCubit>().stateupdate();
                                                                  FocusScope.of(context).unfocus();
                                                                }
                                                              },
                                                              child: const Icon(Icons.send),
                                                            ),
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            hintText: "Say something...",
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : commentWidget(context, widget.lecture),
                                  BlocBuilder<AppStreamCubit, AppStreamState>(
                                    builder: (context, state) {
                                      return context.read<AppStreamCubit>().israted
                                          ? Center(child: Text(Preferences.appString.thanksForRating ?? "Thank you for rating"))
                                          : LectureRatingScreen(
                                              id: widget.lecture.sId ?? "",
                                              cubit: context.read<AppStreamCubit>(),
                                            );
                                    },
                                  ),
                                  BlocBuilder<AppStreamCubit, AppStreamState>(
                                    builder: (context, state) {
                                      return !context.read<AppStreamCubit>().isreported
                                          ? ReportSuggestionWidget(
                                              cubit: context.read<AppStreamCubit>(),
                                            )
                                          //  Center(
                                          //     child: Text(Preferences.appString.thanksForReporting ?? "Thank you for reporting, were trying to improve"),
                                          //   )
                                          : LectureReportScreen(
                                              id: widget.lecture.sId ?? "",
                                              cubit: context.read<AppStreamCubit>(),
                                            );
                                    },
                                  ),
                                ]),
                              )
                            ],
                          ),
                        ),
                      );
              },
            ),
          ],
        ),
      ),
      // floatingActionButton: widget.lecture.liveOrRecorded == 'Live'
      //     ? AnimatedOpacity(
      //         opacity: isfullscreen ? 0.0 : 1.0,
      //         duration:  Duration(milliseconds: 1000),
      //         child: FloatingActionButton(
      //           onPressed: () {
      //             livechat();
      //           },
      //           child:  Icon(Icons.chat_outlined),
      //         ),
      //       )
      //     : null,
    );
  }

  Widget commentWidget(BuildContext context, LectureDetails lecture) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: BlocConsumer<AppStreamCubit, AppStreamState>(
        listener: (context, state) {
          switch (state) {
            case AppCommentsDeleteApiSuccess() || AppCommentsEditApiSuccess() || AppCommentsPostApiSuccess() || AppCommentsReplyApiSuccess() || AppCommentsReplyDeleteApiSuccess() || AppCommentsReportApiSuccess() || AppCommentsPinApiSuccess():
              context.read<AppStreamCubit>().commentget(lectureId: widget.lecture.sId ?? "");
              break;
            default:
              break;
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: context.read<AppStreamCubit>().getrecordedvideocomments.data?.isEmpty ?? true
                    ? EmptyWidget(image: SvgImages.nochatEmpty, text: "There are no messages here yet. Start a Chat by sending a message")
                    : MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        removeBottom: true,
                        child: ListView.builder(
                          itemCount: context.read<AppStreamCubit>().getrecordedvideocomments.data?.length ?? 0,
                          itemBuilder: (context, index) => Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: CachedNetworkImageProvider(context.read<AppStreamCubit>().getrecordedvideocomments.data?[index].user?.profilePhoto ?? ""),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        top: 3,
                                        bottom: 3,
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: ColorResources.borderColor,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text.rich(
                                                  TextSpan(
                                                    text: "${context.read<AppStreamCubit>().getrecordedvideocomments.data?[index].user?.name ?? ""} ",
                                                    children: [
                                                      TextSpan(
                                                        text: context.read<AppStreamCubit>().getrecordedvideocomments.data?[index].createdAt ?? "",
                                                        style: TextStyle(
                                                          color: ColorResources.textBlackSec,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                    style: TextStyle(
                                                      color: ColorResources.textblack,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(context.read<AppStreamCubit>().getrecordedvideocomments.data?[index].comment ?? ""),
                                                SizedBox(
                                                  height: context.read<AppStreamCubit>().getrecordedvideocomments.data?[index].isPin ?? false ? 5 : 0,
                                                ),
                                                context.read<AppStreamCubit>().getrecordedvideocomments.data?[index].isPin ?? false
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          context.read<AppStreamCubit>().commentPin(commentId: context.read<AppStreamCubit>().getrecordedvideocomments.data?[index].id ?? "");
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Transform(
                                                              transform: Matrix4.identity()
                                                                ..translate(1.5, -2.0)
                                                                ..rotateZ(0.80),
                                                              child: Icon(
                                                                CupertinoIcons.pin,
                                                                color: ColorResources.buttoncolor,
                                                                size: 13,
                                                              ),
                                                            ),
                                                            Text(
                                                              Preferences.appString.pinned ?? 'Pinned Comment',
                                                              style: TextStyle(
                                                                color: ColorResources.buttoncolor,
                                                                fontSize: 10,
                                                                fontWeight: FontWeight.w600,
                                                                height: 0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          threedot(isReply: false, index: index, isPined: context.read<AppStreamCubit>().getrecordedvideocomments.data?[index].isPin ?? false),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              context.read<AppStreamCubit>().getrecordedvideocomments.data?[index].replies?.isNotEmpty ?? false
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 25.0),
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: context.read<AppStreamCubit>().getrecordedvideocomments.data?[index].replies?.length ?? 0,
                                          itemBuilder: (context, rindex) {
                                            return Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: CachedNetworkImageProvider(
                                                    context.read<AppStreamCubit>().getrecordedvideocomments.data?[index].replies?[rindex].user?.profilePhoto ?? "",
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: const EdgeInsets.only(
                                                      top: 3,
                                                      bottom: 3,
                                                    ),
                                                    padding: const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: ColorResources.gray.withValues(alpha: 0.3),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text.rich(
                                                                TextSpan(
                                                                  text: "${context.read<AppStreamCubit>().getrecordedvideocomments.data?[index].replies?[rindex].user?.name ?? ""} ",
                                                                  children: [
                                                                    TextSpan(
                                                                      text: context.read<AppStreamCubit>().getrecordedvideocomments.data?[index].replies?[rindex].createdAt ?? "",
                                                                      style: TextStyle(
                                                                        color: ColorResources.textBlackSec,
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                  style: TextStyle(
                                                                    color: ColorResources.textblack,
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(context.read<AppStreamCubit>().getrecordedvideocomments.data?[index].replies?[rindex].comment ?? "")
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        threedot(isReply: true, index: rindex, isPined: false)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
              ),
              TextField(
                controller: _message,
                onSubmitted: (value) {
                  if (_message.text.isEmpty) {
                    var snackBar = const SnackBar(
                      content: Text(
                        "Please Enter The Message",
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    context.read<AppStreamCubit>().commentpost(commentText: _message.text, lectureId: widget.lecture.sId ?? "");
                    _message.clear();
                    FocusScope.of(context).unfocus();
                    context.read<AppStreamCubit>().stateupdate();
                  }
                },
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      if (_message.text.isEmpty) {
                        var snackBar = const SnackBar(content: Text("Please Enter The Message"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        context.read<AppStreamCubit>().commentpost(commentText: _message.text, lectureId: widget.lecture.sId ?? "");
                        _message.clear();
                        context.read<AppStreamCubit>().stateupdate();
                        FocusScope.of(context).unfocus();
                      }
                    },
                    child: const Icon(Icons.send),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Say something...",
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget threedot({required int index, required bool isReply, required bool isPined}) {
    return PopupMenuButton(
      icon: const Icon(
        Icons.more_vert,
        size: 20,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      itemBuilder: (context) {
        if (SharedPreferenceHelper.getString(Preferences.email)!.contains('@sdempire.co.in')) {
          return [
            PopupMenuItem(
              value: 1,
              textStyle: GoogleFonts.notoSansDevanagari(
                color: ColorResources.buttoncolor,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.delete_outline_outlined,
                    color: Colors.red,
                  ),
                  Text(
                    Preferences.appString.delete ?? "Delete",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            if (!isReply)
              PopupMenuItem(
                value: 2,
                textStyle: GoogleFonts.notoSansDevanagari(
                  color: ColorResources.buttoncolor,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.reply_rounded),
                    Text(
                      Preferences.appString.reply ?? "Reply",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            PopupMenuItem(
              value: 3,
              textStyle: GoogleFonts.notoSansDevanagari(
                color: ColorResources.buttoncolor,
              ),
              child: Row(
                children: [
                  const Icon(Icons.edit),
                  Text(
                    Preferences.appString.edit ?? "Edit",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (!isReply && !isPined)
              PopupMenuItem(
                value: 5,
                textStyle: GoogleFonts.notoSansDevanagari(
                  color: ColorResources.buttoncolor,
                ),
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.pin),
                    Text(
                      Preferences.appString.pin ?? "Pin",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            PopupMenuItem(
              value: 4,
              textStyle: GoogleFonts.notoSansDevanagari(
                color: ColorResources.buttoncolor,
              ),
              child: Text(
                Preferences.appString.report ?? "Report",
                textAlign: TextAlign.center,
              ),
            ),
          ];
        } else if (SharedPreferenceHelper.getString(Preferences.userid) == context.read<AppStreamCubit>().getrecordedvideocomments.data?[index].user?.id) {
          return [
            PopupMenuItem(
              value: 3,
              textStyle: GoogleFonts.notoSansDevanagari(
                color: ColorResources.buttoncolor,
              ),
              child: Row(
                children: [
                  const Icon(Icons.edit),
                  Text(
                    Preferences.appString.edit ?? "Edit",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 1,
              textStyle: GoogleFonts.notoSansDevanagari(
                color: ColorResources.buttoncolor,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.delete_outline_outlined,
                    color: Colors.red,
                  ),
                  Text(
                    Preferences.appString.delete ?? "Delete",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 4,
              textStyle: GoogleFonts.notoSansDevanagari(
                color: ColorResources.buttoncolor,
              ),
              child: Text(
                Preferences.appString.report ?? "Report",
                textAlign: TextAlign.center,
              ),
            ),
          ];
        } else {
          return [
            PopupMenuItem(
              value: 4,
              textStyle: GoogleFonts.notoSansDevanagari(
                color: ColorResources.buttoncolor,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.report_outlined,
                    color: Colors.redAccent,
                  ),
                  Text(
                    Preferences.appString.report ?? "Report",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
          ];
        }
      },
      onSelected: (value) {
        if (value == 1) {
          analytics.logEvent(name: "comment_delete", parameters: {
            "comment_id": context.read<AppStreamCubit>().getrecordedvideocomments.data?[index].id ?? "",
            "comment_msg": context.read<AppStreamCubit>().getrecordedvideocomments.data?[index].comment ?? "",
          });
          context.read<AppStreamCubit>().commentDelete(commentId: context.read<AppStreamCubit>().getrecordedvideocomments.data?[index].id ?? "");
        } else if (value == 2) {
          replycomment(
            id: context.read<AppStreamCubit>().getrecordedvideocomments.data?[index].id ?? "",
            msg: context.read<AppStreamCubit>().getrecordedvideocomments.data?[index].comment ?? "",
            isReply: true,
          );
        } else if (value == 3) {
          _message.text = context.read<AppStreamCubit>().getrecordedvideocomments.data?[index].comment ?? "";
          replycomment(
            id: context.read<AppStreamCubit>().getrecordedvideocomments.data?[index].id ?? "",
            msg: context.read<AppStreamCubit>().getrecordedvideocomments.data?[index].comment ?? "",
            isReply: false,
          );
        } else if (value == 4) {
          context.read<AppStreamCubit>().commentReport(commentId: context.read<AppStreamCubit>().getrecordedvideocomments.data?[index].id ?? "");
        } else if (value == 5) {
          context.read<AppStreamCubit>().commentPin(commentId: context.read<AppStreamCubit>().getrecordedvideocomments.data?[index].id ?? "");
        }
      },
    );
  }

  void replycomment({
    required String id,
    required String msg,
    required bool isReply,
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15.0),
              child: Text(
                isReply ? Preferences.appString.reply ?? 'Reply' : "Edit",
                style: TextStyle(
                  color: ColorResources.textblack,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                msg,
                style: TextStyle(
                  color: ColorResources.textBlackSec,
                  fontSize: 12,
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: CachedNetworkImageProvider(SharedPreferenceHelper.getString(Preferences.profileImage)!),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _message,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[50],
                        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                        hintText: "Say Somthing...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  IconButton.filled(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (isReply) {
                        context.read<AppStreamCubit>().commentReply(replyTo: id, commentText: _message.text, lectureId: widget.lecture.sId ?? "");
                      } else {
                        context.read<AppStreamCubit>().commentEdit(commentText: _message.text, commentId: id);
                      }
                      _message.clear();
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: ColorResources.buttoncolor,
                    ),
                    icon: const Icon(Icons.send),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ).then((value) {
      _message.clear();
    });
  }
}
