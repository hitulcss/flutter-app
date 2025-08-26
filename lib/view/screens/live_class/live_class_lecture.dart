import 'dart:ui';

// import 'package:wakelock/wakelock.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sd_campus_app/features/cubit/live_Stream_quiz/livestream_quiz_cubit.dart';
import 'package:sd_campus_app/features/presentation/widgets/lecture/lecture_info.dart';
import 'package:sd_campus_app/features/presentation/widgets/lecture/lecture_rating.dart';
import 'package:sd_campus_app/features/presentation/widgets/lecture/lecture_report.dart';
import 'package:sd_campus_app/features/presentation/widgets/lecture/lecture_resource.dart';
import 'package:sd_campus_app/features/presentation/widgets/lecture/report_sugg.dart';
import 'package:sd_campus_app/main.dart';
import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mediasoup_client_flutter/mediasoup_client_flutter.dart';
import 'package:sd_campus_app/features/cubit/mediasoup/mediasoup_cubit.dart';
import 'package:sd_campus_app/features/data/remote/models/get_poll.dart';
import 'package:sd_campus_app/features/data/remote/models/getdoubt.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/features/services/mediasoup_handler.dart';
import 'package:sd_campus_app/features/services/socket_connection.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/util/showcase_tour.dart';
import 'package:sd_campus_app/view/screens/live_class/fullscreen_live_class.dart';
import 'package:sd_campus_app/view/screens/live_class/poll_option.dart';
import "package:sd_campus_app/features/data/remote/models/my_courses_model.dart";
import 'package:showcaseview/showcaseview.dart';
// import 'package:wakelock_plus/wakelock_plus.dart';

class LiveClassLecture extends StatefulWidget {
  final LectureDetails lecture;
  final String roomName;
  final String name;
  final String url;
  final String mentor;
  final String batch;
  final String token;
  const LiveClassLecture({
    super.key,
    required this.roomName,
    required this.name,
    required this.url,
    required this.mentor,
    required this.batch,
    required this.token,
    required this.lecture,
  });

  @override
  State<LiveClassLecture> createState() => _LiveClassLectureState();
}

class _LiveClassLectureState extends State<LiveClassLecture> with SingleTickerProviderStateMixin {
  late MediaSoupHandler _mediaSoupHandler;
  final TextEditingController _chatInputController = TextEditingController();
  final DragController dragController = DragController();
  bool isCameraOn = false;
  TabController? tabController;

  final TextEditingController _askDoubtInputController = TextEditingController();

  final TextEditingController _reportController = TextEditingController();

  final TextEditingController _ratingController = TextEditingController();

  double ratingstar = 0;

  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
    // WakelockPlus.enable();
    // print(context.read<MediasoupCubit>().isVideoOn);
    analytics.logScreenView(screenName: "app_live_class_lecture", screenClass: "LiveClassLectureScreen");
    // Wakelock.enable();
    tabController = TabController(length: 7, vsync: this);
    // print(context.read<MediasoupCubit>().roomName);
    if (context.read<MediasoupCubit>().roomName != widget.roomName) {
      context.read<MediasoupCubit>().messages = [];
    } else {
      context.read<MediasoupCubit>().roomName = widget.roomName;
    }
    _mediaSoupHandler = MediaSoupHandler(mediasoupCubit: context.read<MediasoupCubit>());
    SocketConnetion.connect(
      url: widget.url,
    );
    socketconnetionhandel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      List<String> keywords = SharedPreferenceHelper.getStringList(Preferences.showTour);
      if (!keywords.contains(Preferences.lectureVideotwoWayTour)) {
        ShowCaseWidget.of(context).startShowCase([
          infoLectureTab,
          resourcesLectureTab,
          if (widget.lecture.isCommentAllowed ?? false) chatLectureTab,
          askDoubtLectureTab,
          pollLectureTab,
          ratingLectureTab,
          reportLectureTab,
        ]);
        SharedPreferenceHelper.setStringList(Preferences.showTour, [
          ...keywords,
          Preferences.lectureVideotwoWayTour
        ]);
      }
    });
  }

  socketconnetionhandel() async {
    SocketConnetion.connection.on('connection-success', (data) async {
      //print("connection-success : $data");
      joinRoom();
    });
  }

  joinRoom() {
    SocketConnetion.connection.emitWithAck('joinRoom', {
      "roomName": [
        widget.lecture.roomDetails?.id ?? ""
      ], // widget.roomName,
      "name": widget.name,
      "isAdmin": false,
      "lectureTitle": widget.lecture.lectureTitle,
      "roomId": widget.lecture.roomDetails?.id ?? "",
      "userId": SharedPreferenceHelper.getString(Preferences.userid),
      "mentor": widget.mentor,
      "batch": widget.batch,
      "lectureId": widget.lecture.sId,
      "role": "user",
    }, ack: (data) {
      // print('Router RTP Capabilities... ${data["rtpCapabilities"]}');
      // we assign to local variable and will be used when
      // loading the client Device (see createDevice above)
      _mediaSoupHandler.rtpCapabilities = data["rtpCapabilities"]; // data["rtpCapabilities"];
      // print(_mediaSoupHandler.rtpCapabilities.toString());
      // once we have rtpCapabilities from the Router, create Device
      _mediaSoupHandler.createDevice(rtpCapabilities: _mediaSoupHandler.rtpCapabilities).then((value) {
        _mediaSoupHandler.getProducers();
      });
      SocketConnetion.connection.on('recieve-message', (data) async {
        //
        context.read<MediasoupCubit>().newMessage(data);
      });
      SocketConnetion.connection.on("doubt-session", (data) {
        // print("D" * 100);
        //
        // print("D" * 100);
        context.read<MediasoupCubit>().doubtenable = data['status'];
      });
      SocketConnetion.connection.on('delete-msg', (data) {
        context.read<MediasoupCubit>().deleteMessage(data);
      });
      SocketConnetion.connection.on('permission-admin-to-user', (data) async {
        SocketConnetion.connection.emit("user-controls-status", {
          "isMicOn": false,
          "isCameraOn": false,
          "userid": SharedPreferenceHelper.getString(Preferences.userid),
          "roomname": widget.lecture.roomDetails?.title ?? "",
          "roomid": widget.lecture.roomDetails?.id ?? "",
          "lectureid": widget.lecture.sId ?? ""
        });
        isFirstTime = false;
        // print("K" * 100);
        // print("connection-error : $data");
        // print("permission  id : ${data["userId"]}");
        // print("permission status : ${data["status"]}");
        // print("K" * 100);

        if (data['status']) {
          _mediaSoupHandler.localvideoStream().then((value) {
            if (_mediaSoupHandler.producerTransport?.closed ?? true) {
              _mediaSoupHandler.createSendTransport();
              context.read<MediasoupCubit>().statecall();
            }
          });
        } else {
          _mediaSoupHandler.disposeTransport();
          context.read<MediasoupCubit>().doubtreq = false;
        }
        // if (data["for"] == "audio") {
        // data["status"] ? dragController.showWidget() : dragController.hideWidget();
        // if (data["status"]) {
        //   SocketConnetion.connection.emit("audio-resume", {
        //     "id": SocketConnetion.connection.id,
        //   });
        // _mediaSoupHandler.producerTransport.
        // if (_mediaSoupHandler.producerTransport?.closed ?? true) {
        //   _mediaSoupHandler.createSendTransport();
        // }
        // _mediaSoupHandler.appProducer(_mediaSoupHandler.producerTransport!, _mediaSoupHandler.localRTCVideoRenderer.srcObject!, "audio");
        // } else {
        //   _mediaSoupHandler.localRTCVideoRenderer.srcObject == null
        //       ? _mediaSoupHandler.createVideoStream().then((videoStream) {
        //           _mediaSoupHandler.producerTransport?.produce(track: videoStream.getAudioTracks().first, stream: videoStream, source: "audio");
        //         })
        //       : _mediaSoupHandler.producerTransport?.produce(track: _mediaSoupHandler.localRTCVideoRenderer.srcObject!.getAudioTracks().first, stream: _mediaSoupHandler.localRTCVideoRenderer.srcObject!, source: "audio");
        // }
        // } else {
        //   SocketConnetion.connection.emit("audio-pause", {
        //     "id": SocketConnetion.connection.id,
        //   });
        // _mediaSoupHandler.disposeTransport();
        // }
        // context.read<MediasoupCubit>().toggleMic(mediaStream: _mediaSoupHandler.localRTCVideoRenderer.srcObject ?? await _mediaSoupHandler.createVideoStream(), status: data["status"]);
        context.read<MediasoupCubit>().statecall();
        // } else {
        // await _mediaSoupHandler.localvideoStream();

        // if (data["status"]) {
        // SocketConnetion.connection.emit("video-resume", {
        //   "id": SocketConnetion.connection.id,
        // });
        //*** isCameraOn = data["status"];
        // if (_mediaSoupHandler.producerTransport?.closed ?? true) {
        // await _mediaSoupHandler.createSendTransport();
        // }
        // _mediaSoupHandler.appProducer(_mediaSoupHandler.producerTransport??, _mediaSoupHandler.localRTCVideoRenderer.srcObject!, "video");
        // } else {
        //   _mediaSoupHandler.localRTCVideoRenderer.srcObject == null
        //       ? _mediaSoupHandler.createVideoStream().then((videoStream) {
        //           _mediaSoupHandler.producerTransport?.produce(track: videoStream.getVideoTracks().first, stream: videoStream, source: "video");
        //         })
        //       : _mediaSoupHandler.producerTransport?.produce(track: _mediaSoupHandler.localRTCVideoRenderer.srcObject!.getVideoTracks().first, stream: _mediaSoupHandler.localRTCVideoRenderer.srcObject!, source: "video");
        // }
        // } else {
        // SocketConnetion.connection.emit("video-pause", {
        //   "id": SocketConnetion.connection.id,
        // });
        // SocketConnetion.connection.emit("video-close", {
        //   'id': SocketConnetion.connection.id
        // });
        // _mediaSoupHandler.disposeTransport();
        // }
        // context.read<MediasoupCubit>().toggleCamera(mediaStream: _mediaSoupHandler.localRTCVideoRenderer.srcObject ?? await _mediaSoupHandler.createVideoStream(), status: data['status']);

        // }
        // context.read<MediasoupCubit>().isAudioOn || context.read<MediasoupCubit>().isVideoOn
        context.read<MediasoupCubit>().statecall();
        data['status'] ? dragController.showWidget() : dragController.hideWidget();
      });
      SocketConnetion.connection.on("informationAboutDoubtsStatus", (data) {
        //
        context.read<MediasoupCubit>().doubtenable = data["status"] ?? false;
        context.read<MediasoupCubit>().statecall();
      });
      SocketConnetion.connection.on("controlling-camera", (data) async {
        // print("t" * 100);
        // print(data);
        context.read<MediasoupCubit>().toggleCamera(mediaStream: _mediaSoupHandler.localRTCVideoRenderer.srcObject ?? await _mediaSoupHandler.createVideoStream());
        //data["cameraOn"]?  dragController.showWidget() : dragController.hideWidget();
      });
      SocketConnetion.connection.on("controlling-mic", (data) async {
        // print("t" * 100);
        // print(data);
        context.read<MediasoupCubit>().toggleMic(mediaStream: _mediaSoupHandler.localRTCVideoRenderer.srcObject ?? await _mediaSoupHandler.createVideoStream());
      });
      SocketConnetion.connection.on("response-admin-to-user", (data) async {
        SocketConnetion.connection.emit("user-controls-status", {
          "isMicOn": false,
          "isCameraOn": false,
          "userid": SharedPreferenceHelper.getString(Preferences.userid),
          "roomname": widget.lecture.roomDetails?.title ?? "",
          "roomid": widget.lecture.roomDetails?.id ?? "",
          "lectureid": widget.lecture.sId ?? ""
        });
        isFirstTime = false;
        // print("L" * 10);
        //
        // print("L" * 10);
        // var snackBar = SnackBar(content: Text("for Admin" + data.toString()));
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        if (data["status"]) {
          await _mediaSoupHandler.localvideoStream();
        }
        // safeSetState(() {
        // isCameraOn = data["status"];
        // });
        // });
        if (data["status"]) {
          data["status"] ? dragController.showWidget() : dragController.hideWidget();
          if (_mediaSoupHandler.producerTransport?.closed ?? true) {
            _mediaSoupHandler.createSendTransport();
          }
          _mediaSoupHandler.appProducer(_mediaSoupHandler.producerTransport!, _mediaSoupHandler.localRTCVideoRenderer.srcObject!, "video");
          // context.read<MediasoupCubit>().isAudioOn = true;
          // context.read<MediasoupCubit>().isVideoOn = true;
          // SocketConnetion.connection.emit("audio-resume", {
          //   "id": SocketConnetion.connection.id,
          // });
        } else {
          // SocketConnetion.connection.emit("audio-pause", {
          //   "id": SocketConnetion.connection.id,
          // });
          context.read<MediasoupCubit>().doubtreq = false;
        }
        context.read<MediasoupCubit>().statecall();
      });
      SocketConnetion.connection.on('new-producer', (producerId) {
        // print("*" * 100);
        // print("new-producer : $producerId");
        // print("*" * 100);
        // if (producerId["isAdmin"]) {
        _mediaSoupHandler.signalNewConsumerTransport(producerId["producerId"], producerId["socketId"], producerId["name"], producerId["isAdmin"]);
        context.read<MediasoupCubit>().addConsumer(socketids: _mediaSoupHandler.socketids);
        // }
      });
      SocketConnetion.connection.on('producer-closed', (data) {
        //
        // print("producer-closed : call");
        // print("producer-closed : $data");
        final String remoteProducerId = data['remoteProducerId'];
        // print("remoteProducerId : $remoteProducerId");
        // server notification is received when a producer is closed
        // we need to close the client-side consumer and associated transport
        // Find the corresponding consumer data using producerId
        final Map producerToClose = _mediaSoupHandler.consumerTransports.firstWhere(
          (transportData) => transportData['producerId'] == remoteProducerId,
          orElse: () => {}, // Handle case where producer data not found
        );
        // print(producerToClose);
        if (producerToClose.containsKey("consumerTransport")) {
          // print("found");
          // Close consumer transport and consumer
          producerToClose["consumerTransport"].close();
          producerToClose["consumer"].close();
          _mediaSoupHandler.remoteVideoRendererswidget[remoteProducerId]!["instance"].dispose();
          // Remove the transport data from the list

          _mediaSoupHandler.remoteVideoRendererswidget.removeWhere((key, value) => key == remoteProducerId);
          _mediaSoupHandler.consumerTransports.removeWhere((transportData) => transportData["producerId"] == remoteProducerId);
          _mediaSoupHandler.socketids.removeWhere((key, value) => value["remoteProducerId"] == remoteProducerId);
          context.read<MediasoupCubit>().addConsumer(socketids: _mediaSoupHandler.socketids);
        } else {
          // print('Warning: Producer data not found for $remoteProducerId');
        }
      });
    });
    SocketConnetion.connection.emitWithAck("doubt-session-information", {
      'lectureId': widget.lecture.sId
    }, ack: (data) {
      context.read<MediasoupCubit>().doubtenable = data['doubtsEnabled'];
    });
    SocketConnetion.connection.on("doubt-solved", (data) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text(data['data']["title"]),
                content: Text(data['data']["answer"]),
              ));
      SocketConnetion.connection.emitWithAck("getDoubts", {
        "lectureId": widget.lecture.sId,
        "token": widget.token,
      }, ack: (data) {
        if (data["status"]) {
          context.read<MediasoupCubit>().doubts = GetDoubt.fromJson(data);
          context.read<MediasoupCubit>().statecall();
        }
      });
    });
    SocketConnetion.connection.on('participants', (data) {
      int count = 0;
      data.forEach((value) {
        if (value["room"].contains(widget.lecture.roomDetails?.id)) {
          count++;
        }
      });
      context.read<MediasoupCubit>().noOfuser = count;
      context.read<MediasoupCubit>().addConsumer(socketids: _mediaSoupHandler.socketids);
    });
    SocketConnetion.connection.emitWithAck("getDoubts", {
      "lectureId": widget.lecture.sId,
      "token": widget.token,
    }, ack: (data) {
      if (data["status"]) {
        flutterToast(data["msg"]);
        context.read<MediasoupCubit>().doubts = GetDoubt.fromJson(data);
        context.read<MediasoupCubit>().statecall();
      }
    });
    SocketConnetion.connection.on('student-submission-started', (data) async {
      // print("student-submission-started" + data.toString());
      context.read<LivestreamQuizCubit>().selectedValue.clear();
      // print(widget.lecture.sId);
      SocketConnetion.connection.emitWithAck("getPoll", {
        "lectureId": widget.lecture.sId,
        "token": widget.token,
      }, ack: (data) {
        context.read<LivestreamQuizCubit>().getpoll = Getpoll();
        context.read<LivestreamQuizCubit>().getpoll = Getpoll.fromJson(data);
        context.read<LivestreamQuizCubit>().pollstarted();
        context.read<LivestreamQuizCubit>().submited = false;
        context.read<LivestreamQuizCubit>().initialDuration = int.parse(context.read<LivestreamQuizCubit>().getpoll.data?.duration ?? "0");
        tabController!.animateTo(4);
        context.read<LivestreamQuizCubit>().countDownController.start();
      });
    });
  }

  @override
  void dispose() {
    _mediaSoupHandler.dispose();
    SocketConnetion.connection.dispose();
    // Wakelock.disable();
    _askDoubtInputController.dispose();
    _chatInputController.dispose();
    _reportController.dispose();
    _ratingController.dispose();
    // WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lecture.lectureTitle ?? ""),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  BlocBuilder<MediasoupCubit, MediasoupState>(
                    builder: (context, state) {
                      return Wrap(
                        children: checkAdminAval(_mediaSoupHandler.socketids)
                            ? isFirstTime
                                ? [
                                    AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                              widget.lecture.banner ?? "",
                                            ),
                                            fit: BoxFit.fill,
                                            filterQuality: FilterQuality.low,
                                          ),
                                        ),
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
                                    )
                                  ]
                                : [
                                    AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Container(
                                        color: Colors.black,
                                      ),
                                    )
                                  ]
                            : _mediaSoupHandler.socketids.entries
                                .map((e) => e.value.containsKey("audio")
                                    ? e.value["video"] != null && e.value["isvideo"] && e.value["isAdmin"]
                                        ? e.value["video"] as Widget
                                        : e.value["audio"] != null && e.value["isaudio"] && e.value["isAdmin"]
                                            ? e.value["audio"] as Widget
                                            : Container()
                                    : Container())
                                .toList(),
                      );
                    },
                  ),
                  Positioned(
                      right: 0,
                      bottom: 0,
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (newcontext) => BlocProvider.value(
                                  value: context.read<MediasoupCubit>(),
                                  child: FullScreenLiveClass(
                                    mediaSoupHandler: _mediaSoupHandler,
                                    banner: widget.lecture.banner ?? "",
                                    title: widget.lecture.lectureTitle ?? "",
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.fullscreen,
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
                                    context.read<MediasoupCubit>().noOfuser.toString(),
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
              Expanded(
                child: DefaultTabController(
                  length: widget.lecture.isCommentAllowed ?? false ? 7 : 6,
                  child: Column(
                    children: [
                      TabBar(
                        tabAlignment: TabAlignment.start,
                        controller: tabController,
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
                              description: Preferences.apptutor.resourcesLectureTab?.des ?? " Lecture Resources",
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
                                description: Preferences.apptutor.chatLectureTab?.des ?? " Lecture chat",
                                targetPadding: EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 5),
                                child: Text(Preferences.appString.liveChat ?? "Live Chat"),
                              ),
                            ),
                          Tab(
                            icon: const Icon(
                              Icons.live_help_outlined,
                            ),
                            child: Showcase(
                              titleTextStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              titleAlignment: Alignment.centerLeft,
                              key: askDoubtLectureTab,
                              title: Preferences.apptutor.askDoubtLectureTab?.title,
                              description: Preferences.apptutor.askDoubtLectureTab?.des ?? " Lecture ask doubt",
                              targetPadding: EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 5),
                              child: Text(Preferences.appString.askDoubt ?? "Ask’s Doubt"),
                            ),
                          ),
                          Tab(
                            icon: const Icon(
                              Icons.align_vertical_bottom,
                            ),
                            child: Showcase(
                              titleTextStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              titleAlignment: Alignment.centerLeft,
                              key: pollLectureTab,
                              title: Preferences.apptutor.pollLectureTab?.des,
                              description: Preferences.apptutor.pollLectureTab?.des ?? " Lecture poll",
                              targetPadding: EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 5),
                              child: Text(Preferences.appString.poll ?? "Poll"),
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
                              description: Preferences.apptutor.ratingLectureTab?.des ?? " Lecture rating",
                              targetPadding: EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 5),
                              child: Text(Preferences.appString.rating ?? "Rating"),
                            ),
                          ),
                          Tab(
                            icon: const Icon(
                              Icons.warning_amber_outlined,
                            ),
                            child: Showcase(
                              titleTextStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              titleAlignment: Alignment.centerLeft,
                              key: reportLectureTab,
                              title: Preferences.apptutor.reportLectureTab?.title,
                              description: Preferences.apptutor.reportLectureTab?.des ?? " Lecture report",
                              targetPadding: EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 5),
                              child: Text(Preferences.appString.report ?? "Report"),
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: TabBarView(controller: tabController, children: [
                          LectureInfoScreen(lecture: widget.lecture),
                          LectureResourceScreen(lecture: widget.lecture),
                          if (widget.lecture.isCommentAllowed ?? false)
                            Column(
                              children: [
                                Expanded(
                                  child: BlocBuilder<MediasoupCubit, MediasoupState>(
                                    builder: (context, state) {
                                      return context.read<MediasoupCubit>().messages.isEmpty
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
                                                itemCount: context.read<MediasoupCubit>().messages.length,
                                                itemBuilder: (context, index) => Row(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage: CachedNetworkImageProvider(context.read<MediasoupCubit>().messages[index]["imageUrl"]),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Expanded(
                                                      child: Text.rich(TextSpan(text: context.read<MediasoupCubit>().messages[index]["name"] + " : ", children: [
                                                        TextSpan(
                                                            text: context.read<MediasoupCubit>().messages[index]["msg"],
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
                                            controller: _chatInputController,
                                            onSubmitted: (value) {
                                              if (_chatInputController.text.isEmpty) {
                                                var snackBar = const SnackBar(
                                                  content: Text(
                                                    "Please Enter The Message",
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              } else {
                                                SocketConnetion.connection.emitWithAck("send-message", {
                                                  "name": widget.name,
                                                  "msg": _chatInputController.text,
                                                  "id": SocketConnetion.connection.id,
                                                  "roomNameOfUser": widget.lecture.roomDetails?.id ?? "", //widget.roomName,
                                                  "to": widget.roomName,
                                                  "imageUrl": SharedPreferenceHelper.getString(Preferences.profileImage),
                                                }, ack: (data) {
                                                  if ((data['msg'] as String).isNotEmpty) {
                                                    var snackBar = SnackBar(
                                                      content: Text(
                                                        data['msg'],
                                                      ),
                                                    );
                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                  }
                                                });
                                                _chatInputController.clear();
                                              }
                                            },
                                            decoration: InputDecoration(
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  if (_chatInputController.text.isEmpty) {
                                                    var snackBar = const SnackBar(content: Text("please enter the message"));
                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                  } else {
                                                    SocketConnetion.connection.emitWithAck("send-message", {
                                                      "name": widget.name,
                                                      "msg": _chatInputController.text,
                                                      "id": SocketConnetion.connection.id,
                                                      "roomNameOfUser": widget.lecture.roomDetails?.id ?? "",
                                                      "to": widget.roomName,
                                                      "imageUrl": SharedPreferenceHelper.getString(Preferences.profileImage),
                                                    }, ack: (data) {
                                                      if ((data['msg'] as String).isNotEmpty) {
                                                        var snackBar = SnackBar(
                                                          content: Text(
                                                            data['msg'],
                                                          ),
                                                        );
                                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                      }
                                                    });
                                                    _chatInputController.clear();
                                                  }
                                                },
                                                child: const Icon(Icons.send),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(
                                                  12,
                                                ),
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
                            ),
                          Center(
                            child: DefaultTabController(
                              length: 2,
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 20.0,
                                      vertical: 8.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorResources.buttoncolor.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
                                    child: TabBar(
                                      dividerColor: Colors.transparent,
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                                      indicator: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: ColorResources.textWhite,
                                      ),
                                      tabs: [
                                        Tab(
                                          text: Preferences.appString.video ?? "Video",
                                        ),
                                        Tab(
                                          text: Preferences.appString.text ?? "Text",
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: TabBarView(children: [
                                      BlocBuilder<MediasoupCubit, MediasoupState>(builder: (context, state) {
                                        return context.read<MediasoupCubit>().doubtenable
                                            ? Column(
                                                children: [
                                                  CachedNetworkImage(
                                                      placeholder: (context, url) => const Center(
                                                            child: CircularProgressIndicator(),
                                                          ),
                                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                                      imageUrl: SvgImages.noaskdoubt),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  context.read<MediasoupCubit>().doubtreq
                                                      ? Text(Preferences.appString.doutrequestSent ?? "Doubt Request Sent",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            color: ColorResources.textBlackSec,
                                                          ))
                                                      : ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: ColorResources.buttoncolor,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Fluttertoast.showToast(
                                                              msg: "send request for microphone",
                                                            );
                                                            SocketConnetion.connection.emit('permission-user-to-admin', {
                                                              "userId": SocketConnetion.connection.id,
                                                              "name": widget.name,
                                                              "for": "video",
                                                              "status": true
                                                            });
                                                            context.read<MediasoupCubit>().doubtreq = true;
                                                            context.read<MediasoupCubit>().statecall();
                                                          },
                                                          child: Text(
                                                            Preferences.appString.requestForRealTimeComminication ?? "Request Real-Time Coummincation",
                                                            style: TextStyle(
                                                              color: ColorResources.textWhite,
                                                            ),
                                                          ),
                                                        ),
                                                ],
                                              )
                                            : Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                                                  child: EmptyWidget(
                                                    image: SvgImages.noaskdoubt,
                                                    text: Preferences.appString.pleaseWaitForDoutSession ?? "Please wait a few minutes for the admin to open the video doubt window.",
                                                  ),
                                                ),
                                              );
                                      }),
                                      Column(
                                        children: [
                                          Expanded(child: BlocBuilder<MediasoupCubit, MediasoupState>(
                                            builder: (context, state) {
                                              return (context.read<MediasoupCubit>().doubts.data?.isEmpty ?? true)
                                                  ? Center(
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons.live_help_outlined,
                                                            size: 100,
                                                            color: ColorResources.buttoncolor,
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            Preferences.appString.noDoubts ?? "No Doubt’s Found!",
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : ListView.separated(
                                                      padding: const EdgeInsets.only(top: 10),
                                                      separatorBuilder: (context, index) => const SizedBox(
                                                            height: 10,
                                                          ),
                                                      shrinkWrap: true,
                                                      reverse: true,
                                                      itemCount: context.read<MediasoupCubit>().doubts.data?.length ?? 0,
                                                      itemBuilder: (context, index) {
                                                        return Container(
                                                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: ColorResources.borderColor,
                                                                spreadRadius: 0,
                                                                blurRadius: 50,
                                                                offset: const Offset(0, 4), // changes position of shadow
                                                              )
                                                            ],
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  context.read<MediasoupCubit>().doubts.data?[index].title ?? "",
                                                                  style: const TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                                context.read<MediasoupCubit>().doubts.data?[index].isResolved ?? false
                                                                    ? Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          const Divider(),
                                                                          Text(context.read<MediasoupCubit>().doubts.data?[index].answer ?? ""),
                                                                        ],
                                                                      )
                                                                    : Container(),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        const Icon(Icons.schedule),
                                                                        Text(context.read<MediasoupCubit>().doubts.data?[index].time ?? ""),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        Icon(
                                                                          context.read<MediasoupCubit>().doubts.data![index].isResolved! ? Icons.check_circle_outline : Icons.cancel_outlined,
                                                                          color: context.read<MediasoupCubit>().doubts.data![index].isResolved! ? Colors.green : Colors.red,
                                                                        ),
                                                                        Text(context.read<MediasoupCubit>().doubts.data![index].isResolved! ? Preferences.appString.resloved ?? "Resolved" : Preferences.appString.notResloved ?? "Not Resolved"),
                                                                      ],
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      });
                                            },
                                          )),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextField(
                                              controller: _askDoubtInputController,
                                              onSubmitted: (value) {
                                                if (_askDoubtInputController.text.isEmpty) {
                                                  var snackBar = const SnackBar(content: Text("Please Enter The Message"));
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                } else {
                                                  SocketConnetion.connection.emitWithAck("postDoubt", {
                                                    "lectureId": widget.lecture.sId,
                                                    "title": _askDoubtInputController.text,
                                                    "time": DateTime.now().toString().split(" ").last.split('.').first,
                                                    "token": widget.token,
                                                  }, ack: (data) {
                                                    _askDoubtInputController.clear();
                                                    if (data["status"]) {
                                                      SocketConnetion.connection.emitWithAck("getDoubts", {
                                                        "lectureId": widget.lecture.sId,
                                                        "token": widget.token,
                                                      }, ack: (data) {
                                                        if (data["status"]) {
                                                          context.read<MediasoupCubit>().doubts = GetDoubt.fromJson(data);
                                                          context.read<MediasoupCubit>().statecall();
                                                        }
                                                      });
                                                      flutterToast(data["msg"]);
                                                    } else {
                                                      flutterToast(data["msg"]);
                                                    }
                                                  });
                                                }
                                              },
                                              decoration: InputDecoration(
                                                suffixIcon: GestureDetector(
                                                  onTap: () {
                                                    // print(DateTime.now().toString().split(" ").last.split('.').first);
                                                    if (_askDoubtInputController.text.isEmpty) {
                                                      var snackBar = const SnackBar(content: Text("Please Enter The Message"));
                                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                    } else {
                                                      SocketConnetion.connection.emitWithAck("postDoubt", {
                                                        "lectureId": widget.lecture.sId,
                                                        "title": _askDoubtInputController.text,
                                                        "time": DateTime.now().toString().split(" ").last.split('.').first,
                                                        "token": widget.token,
                                                      }, ack: (data) {
                                                        // print(widget.lecture.sId);
                                                        _askDoubtInputController.clear();
                                                        if (data["status"]) {
                                                          SocketConnetion.connection.emitWithAck("getDoubts", {
                                                            "lectureId": widget.lecture.sId,
                                                            "token": widget.token,
                                                          }, ack: (data) {
                                                            if (data["status"]) {
                                                              context.read<MediasoupCubit>().doubts = GetDoubt.fromJson(data);
                                                              context.read<MediasoupCubit>().statecall();
                                                            }
                                                          });
                                                          flutterToast(data["msg"]);
                                                        } else {
                                                          flutterToast(data["msg"]);
                                                        }
                                                      });
                                                    }
                                                  },
                                                  child: const Icon(Icons.send),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(
                                                    20,
                                                  ),
                                                ),
                                                hintText: "Ask a doubt...",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          BlocProvider.value(
                            value: context.read<LivestreamQuizCubit>(),
                            child: DynamicRadio(token: widget.token),
                          ),
                          BlocBuilder<MediasoupCubit, MediasoupState>(
                            builder: (context, state) {
                              return context.read<MediasoupCubit>().israted
                                  ? Center(child: Text(Preferences.appString.thanksForRating ?? "Thank you for rating"))
                                  : LectureRatingScreen(
                                      id: widget.lecture.sId ?? "",
                                      cubit: context.read<MediasoupCubit>(),
                                    );
                            },
                          ),
                          BlocBuilder<MediasoupCubit, MediasoupState>(
                            builder: (context, state) {
                              return !context.read<MediasoupCubit>().isreported
                                  ? ReportSuggestionWidget(
                                      cubit: context.read<MediasoupCubit>(),
                                    )
                                  // Center(
                                  //     child: Text(Preferences.appString.thanksForReporting ?? "Thank you for reporting, were trying to improve"),
                                  //   )
                                  : LectureReportScreen(
                                      id: widget.lecture.sId ?? "",
                                      cubit: context.read<MediasoupCubit>(),
                                    );
                            },
                          ),
                        ]),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          BlocBuilder<MediasoupCubit, MediasoupState>(
            builder: (context, state) {
              return DraggableWidget(
                bottomMargin: 110,
                topMargin: 0,
                intialVisibility: isCameraOn,
                horizontalSpace: 10,
                initialPosition: AnchoringPosition.bottomLeft,
                dragController: dragController,
                child: Container(
                  height: 200,
                  width: 150,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Stack(
                    children: [
                      RTCVideoView(
                        _mediaSoupHandler.localRTCVideoRenderer,
                        objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      ),
                      Row(
                        children: [
                          IconButton.filledTonal(
                            onPressed: () {
                              // if (!_mediaSoupHandler.producers.containsKey('audio')) {
                              //   //&& !_mediaSoupHandler.producers['audio']!.closed) {

                              //   _mediaSoupHandler.appProducer(_mediaSoupHandler.producerTransport!, _mediaSoupHandler.localRTCVideoRenderer.srcObject!, "audio");
                              // } else {
                              //   _mediaSoupHandler.disposeTransport(fortype: 'audio');
                              // }
                              context.read<MediasoupCubit>().toggleMic(mediaStream: _mediaSoupHandler.localRTCVideoRenderer.srcObject!);
                              // if (context.read<MediasoupCubit>().isAudioOn) {
                              //   SocketConnetion.connection.emit("audio-resume", {
                              //     "id": SocketConnetion.connection.id,
                              //   });
                              // } else {
                              //   SocketConnetion.connection.emit("audio-pause", {
                              //     "id": SocketConnetion.connection.id,
                              //   });
                              // }
                              SocketConnetion.connection.emit("user-controls-status", {
                                "isMicOn": context.read<MediasoupCubit>().isAudioOn,
                                "isCameraOn": context.read<MediasoupCubit>().isVideoOn,
                                "userid": SharedPreferenceHelper.getString(Preferences.userid),
                                "roomname": widget.lecture.roomDetails?.title ?? "",
                                "roomid": widget.lecture.roomDetails?.id ?? "",
                                "lectureid": widget.lecture.sId ?? ""
                              });
                              context.read<MediasoupCubit>().statecall();
                            },
                            icon: Icon(context.read<MediasoupCubit>().isAudioOn ? Icons.mic : Icons.mic_off),
                          ),
                          IconButton.filledTonal(
                            onPressed: () async {
                              context.read<MediasoupCubit>().toggleCamera(mediaStream: _mediaSoupHandler.localRTCVideoRenderer.srcObject ?? await _mediaSoupHandler.createVideoStream());
                              // if (!_mediaSoupHandler.producers.containsKey('video')) {
                              //   //&& !_mediaSoupHandler.producers['video']!.closed) {
                              //   _mediaSoupHandler.appProducer(_mediaSoupHandler.producerTransport!, _mediaSoupHandler.localRTCVideoRenderer.srcObject!, "audio");
                              // } else {
                              //   _mediaSoupHandler.disposeTransport(fortype: 'video');
                              // }
                              // if (context.read<MediasoupCubit>().isVideoOn) {
                              //   // SocketConnetion.connection.emit("video-resume", {
                              //   //   "id": SocketConnetion.connection.id,
                              //   // });
                              // } else {
                              //   SocketConnetion.connection.emit("video-pause", {
                              //     "id": SocketConnetion.connection.id,
                              //   });
                              // }

                              // print(_mediaSoupHandler.localRTCVideoRenderer.srcObject);

                              SocketConnetion.connection.emit("user-controls-status", {
                                "isMicOn": context.read<MediasoupCubit>().isAudioOn,
                                "isCameraOn": context.read<MediasoupCubit>().isVideoOn,
                                "userid": SharedPreferenceHelper.getString(Preferences.userid),
                                "roomname": widget.lecture.roomDetails?.title ?? "",
                                "roomid": widget.lecture.roomDetails?.id ?? "",
                                "lectureid": widget.lecture.sId ?? ""
                              });
                              context.read<MediasoupCubit>().statecall();
                            },
                            icon: Icon(context.read<MediasoupCubit>().isVideoOn ? Icons.camera_alt_outlined : Icons.no_photography_outlined),
                          ),
                          IconButton.filledTonal(
                            onPressed: () {
                              context.read<MediasoupCubit>().switchCamera(_mediaSoupHandler.localRTCVideoRenderer.srcObject);
                              SocketConnetion.connection.emit("user-controls-status", {
                                "isMicOn": context.read<MediasoupCubit>().isAudioOn,
                                "isCameraOn": context.read<MediasoupCubit>().isVideoOn,
                                "userid": SharedPreferenceHelper.getString(Preferences.userid),
                                "roomname": widget.lecture.roomDetails?.title ?? "",
                                "roomid": widget.lecture.roomDetails?.id ?? "",
                                "lectureid": widget.lecture.sId ?? ""
                              });
                              context.read<MediasoupCubit>().statecall();
                            },
                            icon: const Icon(Icons.cameraswitch),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: IconButton.filledTonal(
                            style: IconButton.styleFrom(backgroundColor: Colors.red),
                            onPressed: () {
                              context.read<MediasoupCubit>().doubtreq = false;
                              context.read<MediasoupCubit>().isAudioOn = false;
                              context.read<MediasoupCubit>().isVideoOn = false;
                              dragController.hideWidget();
                              _mediaSoupHandler.disposeTransport();
                              SocketConnetion.connection.emit("video-close", {
                                'id': SocketConnetion.connection.id
                              });
                              SocketConnetion.connection.emit("user-controls-status", {
                                "isMicOn": false,
                                "isCameraOn": false,
                                "userid": SharedPreferenceHelper.getString(Preferences.userid),
                                "roomname": widget.lecture.roomDetails?.title ?? "",
                                "roomid": widget.lecture.roomDetails?.id ?? "",
                                "lectureid": widget.lecture.sId ?? ""
                              });
                            },
                            icon: const Icon(
                              Icons.call_end_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

checkAdminAval(Map<String?, dynamic> socketids) {
  int admin = 0;
  socketids.forEach((key, value) {
    // print(key);
    // print(value);
    if (value["isAdmin"]) {
      admin = 1;
    }
  });
  // print("admin check $admin");
  return admin > 0 ? false : true;
}
