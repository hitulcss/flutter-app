// ignore_for_file: library_prefixes, unused_field

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/api/api.dart';
import 'package:sd_campus_app/features/cubit/youtubeStream_cubit/youtubestreamcubit_cubit.dart';
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
import 'package:sd_campus_app/util/showcase_tour.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class YTClassScreen extends StatefulWidget {
  final LectureDetails lecture;
  const YTClassScreen({super.key, required this.lecture});

  @override
  State<YTClassScreen> createState() => _YTClassScreenState();
}

class _YTClassScreenState extends State<YTClassScreen> with WidgetsBindingObserver {
  // late final YoutubePlayerController _controller;
  // PodPlayerController? podPlayerController;

  bool timetohide = false;
  final TextEditingController _message = TextEditingController();
  List messages = [];
  bool isfullscreen = false;
  int myDuration = 0;

  // bool chatopend = false;
  // StreamSocket streamSocket = StreamSocket();
  IO.Socket? socket;
  // final batchName = widget.lecture.batchDetails.batchName??"";
  // final batchid = "BatchId";
  @override
  void initState() {
    context.read<YoutubeStreamCubit>().messages.clear();
    if (widget.lecture.liveOrRecorded != 'Live') {
      context.read<YoutubeStreamCubit>().commentget(lectureId: widget.lecture.sId ?? "");
    }
    analytics.logEvent(name: "app_class_video_yt", parameters: {
      "islive": widget.lecture.liveOrRecorded == 'Live' ? true.toString() : false.toString(),
      "url": widget.lecture.link!,
    });
    Timer.periodic(const Duration(seconds: 1), (_) {
      myDuration++;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      List<String> keywords = SharedPreferenceHelper.getStringList(Preferences.showTour);
      if (!keywords.contains(Preferences.lectureVideoYtTour)) {
        ShowCaseWidget.of(context).startShowCase([
          infoLectureTab,
          resourcesLectureTab,
          if (widget.lecture.isCommentAllowed ?? false) chatLectureTab,
          ratingLectureTab,
          reportLectureTab,
        ]);
      }
    });

    connectAndListen();
    WidgetsBinding.instance.addObserver(this);
    //print('*' * 100);
    //print(widget.lecture.link!);
    //print('*' * 100);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        RemoteDataSourceImpl().getTimeSpendLRequest(
          id: widget.lecture.sId!,
          time: myDuration.toString(),
        );

        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

//STEP2: Add this function in file and add incoming data to the stream
  void connectAndListen() {
    SocketConnetion.connect(url: Apis.rootUrl);
    socket = IO.io(
        Apis.rootUrl,
        IO.OptionBuilder().setTransports([
          'websocket'
        ]).build());
    // SocketConnetion.connection..disconnect().connect();
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
      SocketConnetion.connection.on("getUsers", (data) {
        context.read<YoutubeStreamCubit>().nousers = data.length;
        // print(context.read<YoutubeStreamCubit>().nousers);
        // context.read<YoutubeStreamCubit>().stateupdate();
        safeSetState(() {});
      });
    });
    // SocketConnetion.connection.onConnectError((data) => SocketConnetion.connection..disconnect()..connect());
    // SocketConnetion.connection.onConnectTimeout((data) => SocketConnetion.connection..disconnect()..connect());
    //When an event recieved from server, data is added to the stream
    SocketConnetion.connection.on('receive-message', (data) {
      // streamSocket.addResponse(data);
      context.read<YoutubeStreamCubit>().messages.insert(0, data);
      // context.read<YoutubeStreamCubit>().stateupdate();
      // context.read<YoutubeStreamCubit>().stateupdate();
      safeSetState(() {});
    });
    // SocketConnetion.connection..onDisconnect((_) => //print('disconnect'));
  }

  @override
  void dispose() async {
    // print('*' * 10);
    // print(myDuration);
    // print('*' * 10);
    RemoteDataSourceImpl().getTimeSpendLRequest(
      id: widget.lecture.sId!,
      time: myDuration.toString(),
    );
    WidgetsBinding.instance.removeObserver(this);
    SocketConnetion.connection.dispose();
    _message.dispose();
    // if (podPlayerController?.isInitialised ?? false) {
    //   podPlayerController?.dispose();
    // }
    // _chatscrollController.dispose();
    // _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values); // to re-show bars
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // PlayerState playerState = _controller.value.playerState;
    return Scaffold(
      // backgroundColor: Colors.white,
      //resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   iconTheme: IconThemeData(color: ColorResources.textblack),
      //   backgroundColor: Colors.white,
      //   title: Text(
      //     widget.lecture.lectureTitle,
      //     style:
      //         GoogleFonts.notoSansDevanagari(color: ColorResources.textblack),
      //   ),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // isfullscreen
          //     ? Container()
          //     : SafeArea(
          //         child: Row(
          //           children: [
          //             IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back)),
          //             Expanded(
          //               child: Text(
          //                 widget.lecture.lectureTitle!,
          //                 overflow: TextOverflow.ellipsis,
          //                 style: GoogleFonts.notoSansDevanagari(
          //                   fontSize: 16,
          //                   fontWeight: FontWeight.bold,
          //                   color: ColorResources.textblack,
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            // removeTop: true,
            child: CuPlayerScreen(
              autoPLay: true,
              url: widget.lecture.link ?? "",
              isLive: widget.lecture.liveOrRecorded == "Live" ? true : false,
              playerType: PlayerType.youtube,
              wallpaper: widget.lecture.banner ?? "",
              canpop: true,
              children: const [],
            ),
          ),
          // widget.lecture.liveOrRecorded == 'Live'
          //     ? PodVideoPlayer(
          //         controller: podPlayerController!,
          //         podProgressBarConfig: const PodProgressBarConfig(),
          //         alwaysShowProgressBar: false,
          //       )
          //     : PodPlayerScreen(
          //         youtubeUrl: extractYouTubeVideolink(widget.lecture.link!) ?? "",
          //         isWidget: true,
          //       ),
          Expanded(
            child: DefaultTabController(
              length: widget.lecture.isCommentAllowed ?? false ? 5 : 4,
              child: Column(
                children: [
                  TabBar(
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    tabs: [
                      Tab(
                        icon: const Icon(
                          Icons.description_outlined,
                        ),
                        child: Showcase(
                          titleTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          titleAlignment: Alignment.centerLeft,
                          key: infoLectureTab,
                          title: Preferences.apptutor.infoLectureTab?.title,
                          description: Preferences.apptutor.infoLectureTab?.des ?? " Lecture Info",
                          targetPadding: EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 5),
                          child: Text(Preferences.appString.info ?? "Info"),
                        ),
                      ),
                      Tab(
                        icon: const Icon(
                          Icons.snippet_folder_outlined,
                        ),
                        child: Showcase(
                          titleTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          titleAlignment: Alignment.centerLeft,
                          key: resourcesLectureTab,
                          title: Preferences.apptutor.resourcesLectureTab?.title,
                          description: Preferences.apptutor.resourcesLectureTab?.des ?? "Lecture Resources",
                          targetPadding: EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 5),
                          child: Text(Preferences.appString.resources ?? "Resources"),
                        ),
                      ),
                      if (widget.lecture.isCommentAllowed ?? false)
                        Tab(
                          icon: const Icon(
                            Icons.chat_bubble_outline,
                          ),
                          child: Showcase(
                            titleTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          titleAlignment: Alignment.centerLeft,
                            key: chatLectureTab,
                            title: Preferences.apptutor.chatLectureTab?.title,
                            description: Preferences.apptutor.chatLectureTab?.des ?? "chat",
                            targetPadding: EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 5),
                            child: Text(widget.lecture.liveOrRecorded == 'Live' ? Preferences.appString.liveChat ?? "Live Chat" : Preferences.appString.comments ?? "Comments"),
                          ),
                        ),
                      Tab(
                        icon: const Icon(
                          Icons.star_border_rounded,
                        ),
                        child: Showcase(
                          titleTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          titleAlignment: Alignment.centerLeft,
                          key: ratingLectureTab,
                          title: Preferences.apptutor.ratingLectureTab?.title,
                          description: Preferences.apptutor.ratingLectureTab?.des ?? "Lecture rating",
                          targetPadding: EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 5),
                          child: Text(Preferences.appString.rating ?? "Rating"),
                        ),
                      ),
                      Tab(
                        icon: const Icon(
                          Icons.warning_amber_outlined,
                        ),
                        child: Showcase(titleTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          titleAlignment: Alignment.centerLeft, key: reportLectureTab, title: Preferences.apptutor.reportLectureTab?.title, description: Preferences.apptutor.reportLectureTab?.des ?? "Lecture report", targetPadding: EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 5), child: Text(Preferences.appString.report ?? "Report")),
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
                                    child: BlocBuilder<YoutubeStreamCubit, YoutubeStreamState>(
                                      builder: (context, state) {
                                        return context.read<YoutubeStreamCubit>().messages.isEmpty
                                            ? Center(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Live Chat (${context.read<YoutubeStreamCubit>().nousers})"),
                                                    const Divider(),
                                                    EmptyWidget(image: SvgImages.nochatEmpty, text: Preferences.appString.noComments ?? "There are no messages here yet. Start a Chat by sending a message"),
                                                  ],
                                                ),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 15.0,
                                                ),
                                                child: MediaQuery.removePadding(
                                                  context: context,
                                                  removeTop: true,
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        // Text("Live Chat (${context.read<YoutubeStreamCubit>().nousers})"),
                                                        // const Divider(),
                                                        ListView.separated(
                                                          separatorBuilder: (context, index) => const SizedBox(
                                                            height: 10,
                                                          ),
                                                          shrinkWrap: true,
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          itemCount: context.read<YoutubeStreamCubit>().messages.length,
                                                          itemBuilder: (context, index) => Row(
                                                            children: [
                                                              CircleAvatar(
                                                                backgroundImage: CachedNetworkImageProvider(context.read<YoutubeStreamCubit>().messages[index][2]),
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Expanded(
                                                                child: Text.rich(TextSpan(text: context.read<YoutubeStreamCubit>().messages[index][1] + " : ", children: [
                                                                  TextSpan(
                                                                      text: context.read<YoutubeStreamCubit>().messages[index][0],
                                                                      style: TextStyle(
                                                                        color: ColorResources.textBlackSec,
                                                                      ))
                                                                ])),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
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
                                                      "Please Enter The Message.",
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
                                                  FocusScope.of(context).unfocus();
                                                  context.read<YoutubeStreamCubit>().stateupdate();
                                                }
                                              },
                                              decoration: InputDecoration(
                                                filled: true,
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
                                                      context.read<YoutubeStreamCubit>().stateupdate();
                                                      FocusScope.of(context).unfocus();
                                                    }
                                                  },
                                                  child: const Icon(Icons.send),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                hintText: Preferences.appString.saysomething ?? "Say something...",
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
                      BlocBuilder<YoutubeStreamCubit, YoutubeStreamState>(
                        builder: (context, state) {
                          return context.read<YoutubeStreamCubit>().israted
                              ? Center(child: Text(Preferences.appString.thanksForRating ?? "Thank you for rating"))
                              : LectureRatingScreen(
                                  id: widget.lecture.sId ?? "",
                                  cubit: context.read<YoutubeStreamCubit>(),
                                );
                        },
                      ),
                      BlocBuilder<YoutubeStreamCubit, YoutubeStreamState>(
                        builder: (context, state) {
                          return !context.read<YoutubeStreamCubit>().isreported
                              ? ReportSuggestionWidget(
                                  cubit: context.read<YoutubeStreamCubit>(),
                                )
                              // Center(
                              //     child: Text(Preferences.appString.thanksForReporting ?? "Thank you for reporting, were trying to improve"),
                              //   )
                              : LectureReportScreen(
                                  id: widget.lecture.sId ?? "",
                                  cubit: context.read<YoutubeStreamCubit>(),
                                );
                        },
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
      // floatingActionButton: widget.lecture.liveOrRecorded == 'Live'
      //     ? isfullscreen
      //         ? null
      //         : AnimatedOpacity(
      //             opacity: isfullscreen ? 0.0 : 1.0,
      //             duration: const Duration(milliseconds: 1000),
      //             child: FloatingActionButton(
      //               onPressed: () {
      //                 livechat();
      //               },
      //               child: const Icon(Icons.chat_outlined),
      //             ),
      //           )
      //     : null,
    );
  }

  Widget commentWidget(BuildContext context, LectureDetails lecture) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: BlocConsumer<YoutubeStreamCubit, YoutubeStreamState>(
        listener: (context, state) {
          switch (state) {
            case YtCommentsDeleteApiSuccess() || YtCommentsEditApiSuccess() || YtCommentsPostApiSuccess() || YtCommentsReplyApiSuccess() || YtCommentsReplyDeleteApiSuccess() || YtCommentsReportApiSuccess() || YtCommentsPinApiSuccess():
              context.read<YoutubeStreamCubit>().commentget(lectureId: widget.lecture.sId ?? "");
              break;
            default:
              break;
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?.isEmpty ?? true
                    ? EmptyWidget(image: SvgImages.nochatEmpty, text: Preferences.appString.noComments ?? "There are no messages here yet. Start a Chat by sending a message")
                    : MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        removeBottom: true,
                        child: ListView.builder(
                          itemCount: context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?.length ?? 0,
                          itemBuilder: (context, index) => Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.white,
                                    backgroundImage: CachedNetworkImageProvider(context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?[index].user?.profilePhoto ?? ""),
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
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text.rich(
                                                  TextSpan(
                                                    text: "${context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?[index].user?.name ?? ""} ",
                                                    children: [
                                                      TextSpan(
                                                        text: context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?[index].createdAt ?? "",
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
                                                Text(context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?[index].comment ?? ""),
                                                SizedBox(
                                                  height: context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?[index].isPin ?? false ? 5 : 0,
                                                ),
                                                context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?[index].isPin ?? false
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          if (SharedPreferenceHelper.getString(Preferences.email)!.contains("@sdempire.co.in")) {
                                                            context.read<YoutubeStreamCubit>().commentPin(commentId: context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?[index].id ?? "");
                                                          }
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
                                                              Preferences.appString.pinned ?? 'Pinned',
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
                                          threedot(index: index, isReply: false, isPined: context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?[index].isPin ?? false),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?[index].replies?.isNotEmpty ?? false
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 25.0),
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?[index].replies?.length ?? 0,
                                          itemBuilder: (context, rindex) {
                                            return Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: Colors.white,
                                                  backgroundImage: CachedNetworkImageProvider(
                                                    context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?[index].replies?[rindex].user?.profilePhoto ?? "",
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
                                                      color: Colors.white,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text.rich(
                                                                TextSpan(
                                                                  text: "${context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?[index].replies?[rindex].user?.name ?? ""} ",
                                                                  children: [
                                                                    TextSpan(
                                                                      text: context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?[index].replies?[rindex].createdAt ?? "",
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
                                                              Text(context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?[index].replies?[rindex].comment ?? "")
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
                    context.read<YoutubeStreamCubit>().commentpost(commentText: _message.text, lectureId: widget.lecture.sId ?? "");
                    _message.clear();
                    FocusScope.of(context).unfocus();
                    context.read<YoutubeStreamCubit>().stateupdate();
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      if (_message.text.isEmpty) {
                        var snackBar = const SnackBar(content: Text("Please Enter the Message"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        context.read<YoutubeStreamCubit>().commentpost(commentText: _message.text, lectureId: widget.lecture.sId ?? "");
                        _message.clear();
                        context.read<YoutubeStreamCubit>().stateupdate();
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
      color: Colors.white,
      elevation: 5,
      surfaceTintColor: Colors.white,
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
        } else if (SharedPreferenceHelper.getString(Preferences.userid) == context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?[index].user?.id) {
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
                  const Icon(Icons.delete_outline_outlined),
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
            "comment_id": context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?[index].id ?? "",
            "comment_msg": context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?[index].comment ?? "",
          });
          context.read<YoutubeStreamCubit>().commentDelete(commentId: context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?[index].id ?? "");
        } else if (value == 2) {
          replycomment(
            id: context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?[index].id ?? "",
            msg: context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?[index].comment ?? "",
            isReply: true,
          );
        } else if (value == 3) {
          _message.text = context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?[index].comment ?? "";
          replycomment(
            id: context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?[index].id ?? "",
            msg: context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?[index].comment ?? "",
            isReply: false,
          );
        } else if (value == 4) {
          context.read<YoutubeStreamCubit>().commentReport(commentId: context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?[index].id ?? "");
        } else if (value == 5) {
          context.read<YoutubeStreamCubit>().commentPin(commentId: context.read<YoutubeStreamCubit>().getrecordedvideocomments.data?[index].id ?? "");
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
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                        hintText: Preferences.appString.saysomething ?? "Say Somthing...",
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
                        context.read<YoutubeStreamCubit>().commentReply(replyTo: id, commentText: _message.text, lectureId: widget.lecture.sId ?? "");
                      } else {
                        context.read<YoutubeStreamCubit>().commentEdit(commentText: _message.text, commentId: id);
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
