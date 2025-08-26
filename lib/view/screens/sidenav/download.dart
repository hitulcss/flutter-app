// import 'dart:io' as io;
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'dart:isolate';

import 'package:sd_campus_app/util/pdf_render.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  final ReceivePort _port = ReceivePort();
  List<Map> downloadsListMaps = [];

  @override
  void initState() {
    super.initState();
    analytics.logScreenView(screenClass: "DownloadScreen", screenName: "app_downloadscreen");
    task();
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = DownloadTaskStatus.fromInt(data[1]);
      int progress = data[2];
      var task = downloadsListMaps.where((element) => element['id'] == id);
      for (var element in task) {
        element['progress'] = progress;
        element['status'] = status;
        safeSetState(() {});
      }
    });
  }

  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([
      id,
      status,
      progress
    ]);
  }

  void _unbindBackgroundIsolate() {
    _port.close();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  Future task() async {
    List<DownloadTask>? getTasks = await FlutterDownloader.loadTasks();
    for (var task in getTasks!) {
      Map map = {};
      map['status'] = task.status;
      map['progress'] = task.progress;
      map['id'] = task.taskId;
      map['filename'] = task.filename;
      map['savedDirectory'] = task.savedDir;
      // print(map['status']);
      // print(map['filename']);
      if ([
        DownloadTaskStatus.complete, //completed successfully.
        DownloadTaskStatus.enqueued, //The task is scheduled, but is not running yet.
        DownloadTaskStatus.paused, //paused
        DownloadTaskStatus.running, //in progress
      ].contains(map['status'])) {
        downloadsListMaps.insert(0, map);
      }
    }
    // Create a set to store unique filenames
    Set<String> uniqueFilenames = {};

    // Iterate through the downloadsListMaps list
    downloadsListMaps.removeWhere((map) {
      // Check if the filename is already in the set
      if (uniqueFilenames.contains(map['filename'])) {
        FlutterDownloader.remove(taskId: map['id'], shouldDeleteContent: false);
        return true; // Remove the duplicate
      } else {
        // Add the filename to the set and keep the item
        uniqueFilenames.add(map['filename']);
        return false;
      }
    });
    safeSetState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: ColorResources.textWhite,
        iconTheme: IconThemeData(color: ColorResources.textblack),
        title: Text(
          Preferences.appString.myDownloads ?? Languages.download,
          style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack),
        ),
        elevation: 0,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              constraints: const BoxConstraints.expand(height: 50),
              color: Colors.white,
              child: TabBar(
                indicatorColor: ColorResources.buttoncolor,
                unselectedLabelColor: ColorResources.gray,
                labelColor: ColorResources.buttoncolor,
                onTap: (value) {
                  if (value == 1) {
                    analytics.logScreenView(screenName: "app_screen_resources");
                  } else {
                    analytics.logScreenView(screenName: "app_screen_video");
                  }
                },
                tabs: [
                  Tab(text: Preferences.appString.resources ?? Languages.resources),
                  Tab(text: Preferences.appString.videos ?? Languages.video),
                  //Tab(text: Languages.testSeries),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(physics: const NeverScrollableScrollPhysics(), children: [
                //EmptyWidget(image: SvgImages.emptyCard, text: "There in no Videos"),
                // EmptyWidget(
                //     image: SvgImages.emptyCard,
                //     text: "There in no Test Series"),
                _videoCardWidget(context),
                EmptyWidget(image: SvgImages.emptyvideo, text: Preferences.appString.noVideos ?? Languages.novideo),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget _videoCardWidget(BuildContext context) {
    return downloadsListMaps.isEmpty
        ? EmptyWidget(image: SvgImages.emptydownload, text: Preferences.appString.noResources ?? Languages.noresources)
        : SingleChildScrollView(
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: downloadsListMaps.length,
                itemBuilder: (BuildContext context, index) {
                  Map map = downloadsListMaps[index];
                  String filename = map['filename'];
                  int progress = map['progress'];
                  DownloadTaskStatus status = map['status'];
                  String id = map['id'];
                  String savedDirectory = map['savedDirectory'];
                  // print(_savedDirectory);
                  // List<io.FileSystemEntity> directories = io.Directory(savedDirectory).listSync(followLinks: true);
                  // var file = directories.isNotEmpty ? directories.first : null;
                  return GestureDetector(
                    onTap: () =>
                        //OpenFilex.open("$_savedDirectory/$_filename"),
                        Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => PdfRenderScreen(
                        name: filename.split('.').first,
                        filePath: "$savedDirectory/$filename",
                        isoffline: true,
                      ),
                    )),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                      decoration: BoxDecoration(
                        //border: Border.all(color: ColorResources.gray),
                        borderRadius: BorderRadius.circular(10),
                        color: ColorResources.textWhite,
                        boxShadow: [
                          BoxShadow(
                            color: ColorResources.gray.withValues(alpha: 0.5),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.picture_as_pdf,
                            size: 30,
                            color: ColorResources.buttoncolor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  filename.split('.').first,
                                  style: GoogleFonts.notoSansDevanagari(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                status == DownloadTaskStatus.complete
                                    ? Container()
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text('$progress%'),
                                          Expanded(
                                            child: LinearProgressIndicator(
                                              value: progress / 100,
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buttons(status, id, index),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          );
  }

  Widget buttons(DownloadTaskStatus status, String taskid, int index) {
    void changeTaskID(String taskid, String newTaskID) {
      Map task = downloadsListMaps.firstWhere(
        (element) => element['taskId'] == taskid,
        orElse: () => {},
      );
      task['taskId'] = newTaskID;
      safeSetState(() {});
    }

    return status == DownloadTaskStatus.canceled
        ? GestureDetector(
            child: const Icon(Icons.cached, size: 30, color: Colors.green),
            onTap: () {
              FlutterDownloader.retry(taskId: taskid).then((newTaskID) {
                changeTaskID(taskid, newTaskID!);
              });
            },
          )
        : status == DownloadTaskStatus.failed
            ? GestureDetector(
                child: const Icon(Icons.cached, size: 30, color: Colors.green),
                onTap: () {
                  FlutterDownloader.retry(taskId: taskid).then((newTaskID) {
                    changeTaskID(taskid, newTaskID!);
                  });
                },
              )
            : status == DownloadTaskStatus.paused
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        child: const Icon(Icons.play_arrow, size: 30, color: Colors.blue),
                        onTap: () {
                          FlutterDownloader.resume(taskId: taskid).then(
                            (newTaskID) => changeTaskID(taskid, newTaskID ?? ""),
                          );
                        },
                      ),
                      GestureDetector(
                        child: const Icon(Icons.close, size: 30, color: Colors.red),
                        onTap: () {
                          FlutterDownloader.cancel(taskId: taskid);
                        },
                      )
                    ],
                  )
                : status == DownloadTaskStatus.running
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            child: const Icon(Icons.pause, size: 30, color: Colors.green),
                            onTap: () {
                              FlutterDownloader.pause(taskId: taskid);
                            },
                          ),
                          GestureDetector(
                            child: const Icon(Icons.close, size: 30, color: Colors.red),
                            onTap: () {
                              FlutterDownloader.cancel(taskId: taskid);
                            },
                          )
                        ],
                      )
                    : status == DownloadTaskStatus.complete
                        ? GestureDetector(
                            child: const Icon(Icons.delete, size: 30, color: Colors.red),
                            onTap: () {
                              downloadsListMaps.removeAt(index);
                              FlutterDownloader.remove(taskId: taskid, shouldDeleteContent: true);
                              safeSetState(() {});
                            },
                          )
                        : Container();
  }
}
