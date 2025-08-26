// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sd_campus_app/features/presentation/widgets/cus_player.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/features/presentation/widgets/videopaler.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/localfiles.dart';
import 'package:sd_campus_app/util/pdf_render.dart';
import 'package:sd_campus_app/util/enum/playertype.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/extenstions/string_extenstions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ResourcesDownloadWidget extends StatefulWidget {
  const ResourcesDownloadWidget({
    super.key,
    required this.title,
    required this.uploadFile,
    required this.resourcetype,
    required this.fileSize,
    this.localcheck = true,
  });
  final String title;
  final String uploadFile;
  final String resourcetype;
  final String? fileSize;
  final bool localcheck;

  @override
  State<ResourcesDownloadWidget> createState() => _ResourcesDownloadWidgetState();
}

class _ResourcesDownloadWidgetState extends State<ResourcesDownloadWidget> {
  final ReceivePort _port = ReceivePort();
  Future<String> getFilenamePath(Directory directory, String originalFileName) async {
    String fileName = originalFileName;
    var i = 0;
    while (true) {
      String fullPath = directory.path + Platform.pathSeparator + fileName;
      if (await File(fullPath).exists()) {
        i++;
        List splits = originalFileName.split('.');
        fileName = [
          "${splits[0]}.$i",
          splits[1]
        ].join('.');
      } else {
        break;
      }
    }

    return fileName;
  }

  Future download(String url, String name) async {
    final baseStorage = await getExternalStorageDirectory();

    // print('directory:${baseStorage!.path}');
    //todo pls chek this variable use
    // String? status =
    final fileName = await getFilenamePath(baseStorage!, '${Localfilesfind.localfiles.contains(name) ? "$name-${Localfilesfind.localfiles.countOf(name)}" : name}.${url.split('.').last}');

    await FlutterDownloader.enqueue(
      url: url,
      headers: {},
      // optional: header send with url (auth token etc)
      savedDir: baseStorage.path,
      showNotification: true,
      // show download progress in status bar (for Android)
      fileName: fileName,
      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
      saveInPublicStorage: false,
    );
  }

  @override
  void initState() {
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) async {
      //todo pls chek this variable use
      // String id = data[0];
      // int status = data[1];
      // int progress = data[2];
      // print('*' * 100);
      // print(data[1]);
      if (data[1] == 3) {
        Localfilesfind.initState();
        safeSetState(() {
          Localfilesfind.localfiles;
        });
      }
    });
    FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
  }

  @override
  void dispose() {
    _port.close();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');

    send!.send([
      id,
      status,
      progress
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.localcheck);
    return InkWell(
      onTap: widget.localcheck && Localfilesfind.localfiles.contains(widget.title) && widget.resourcetype == "pdf"
          ? () {
              // print(Localfilesfind.local[Localfilesfind.localfiles.indexOf(widget.title)].path);
              // print(Localfilesfind.localfiles.indexOf(widget.title));
              // print(Localfilesfind
              //     .local[Localfilesfind.localfiles.indexOf(widget.title)]);
              // OpenFilex.open(Localfilesfind
              //     .local[Localfilesfind.localfiles.indexOf(widget.title)]
              //     .toString()
              //     .split("'")[1]);
              Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => PdfRenderScreen(
                  name: widget.title,
                  filePath: Localfilesfind.local[Localfilesfind.localfiles.indexOf(widget.title)].path,
                  isoffline: true,
                ),
              ));
            }
          : () {
              Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => PdfRenderScreen(
                  name: widget.title,
                  filePath: widget.uploadFile,
                  isoffline: false,
                ),
              ));
            },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: widget.resourcetype == 'file' || widget.resourcetype == 'pdf'
                        ? CachedNetworkImage(
                            height: 20,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            imageUrl: SvgImages.pdfimage,
                          )
                        : widget.resourcetype == 'video'
                            ? const Icon(
                                Icons.video_collection_rounded,
                                size: 30,
                                color: Color.fromARGB(255, 143, 51, 51),
                              )
                            : widget.resourcetype == 'yt_videos'
                                ? CachedNetworkImage(
                                    height: 30,
                                    imageUrl: SvgImages.youtube,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  )
                                : const Icon(
                                    Icons.wordpress_outlined,
                                    size: 20,
                                    color: Color.fromARGB(255, 143, 51, 51),
                                  ),
                  ),
                  Expanded(
                    child: Text(
                      widget.title.toCapitalize(),
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: ColorResources.textblack,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            widget.localcheck && Localfilesfind.localfiles.contains(widget.title)
                ? Icon(
                    Icons.verified,
                    color: ColorResources.buttoncolor,
                  )
                : InkWell(
                    onTap: () async {
                      analytics.logEvent(name: "app_resources_click", parameters: {
                        "file_name": widget.title,
                        "file_type": widget.resourcetype,
                      });
                      bool status = await Preferences.checkStoragePermission();
                      // Map<Permission, PermissionStatus> status = await [
                      //   Permission.storage,
                      // ].request();
                      if (status) {
                        if (widget.resourcetype == "file" || widget.resourcetype == "pdf") {
                          flutterToast("Downloading... ");
                          download(widget.uploadFile, widget.title);
                        } else if (widget.resourcetype == "video") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayVideoFromNetwork(
                                videourl: widget.uploadFile,
                              ),
                            ),
                          );
                        } else if (widget.resourcetype == "yt_videos") {
                          String videoId = YoutubePlayer.convertUrlToId(widget.uploadFile)!;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CuPlayerScreen(
                                  autoPLay: true,
                                  url: videoId,
                                  isLive: false,
                                  playerType: PlayerType.youtube,
                                  // wallpaper: widget.lecture.banner ?? "",
                                  canpop: true,
                                  children: const [],
                                ),
                                // PodPlayerScreen(
                                //       youtubeUrl: videoId,
                                //       isWidget: false,
                                //     )
                                //  YoutubePlayerWidget(
                                //       videoId: videoId,
                                //     )
                              ));
                        } else {
                          launchUrl(Uri.parse(widget.uploadFile), mode: LaunchMode.externalApplication);
                        }
                      }
                    },
                    child: Icon(
                      //todo this dead code pls check onces
                      widget.resourcetype == "file" || widget.resourcetype == "pdf" ? Icons.file_download_outlined : Icons.link,
                      size: 25,
                      color: ColorResources.buttoncolor,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
