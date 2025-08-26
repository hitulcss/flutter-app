import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sd_campus_app/features/presentation/widgets/video_fullscreen.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/date_formate.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class CourseVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final bool isYoutube;
  final String? videoTitle;
  final bool showPlayPauseButton;
  final bool showForwardRewindButton;
  final bool showProgressButton;
  final bool autoHideControls;
  final bool showFullScreenButton;
  final bool showTimerButton;
  static final FocusNode focusNode = FocusNode();
  const CourseVideoPlayer({super.key, required this.videoUrl, this.videoTitle, this.showPlayPauseButton = true, this.showForwardRewindButton = true, this.showProgressButton = true, this.showFullScreenButton = true, this.showTimerButton = true, this.autoHideControls = true, this.isYoutube = false});

  @override
  State<CourseVideoPlayer> createState() => _CourseVideoPlayerState();
}

class _CourseVideoPlayerState extends State<CourseVideoPlayer> {
  VideoPlayerController controller = VideoPlayerController.networkUrl(Uri.parse(''));
  Timer? _hideControlsTimer;
  bool showcontrols = false;
  bool isloading = true;
  @override
  void initState() {
    super.initState();
    initlializeController();
  }

  initlializeController() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CourseVideoPlayer.focusNode.addListener(_handleFocusChange);
      CourseVideoPlayer.focusNode.requestFocus();
    });
    if (widget.isYoutube) {
      var url = await getvideourl(url: widget.videoUrl);
      controller = VideoPlayerController.networkUrl(Uri.parse(url))
        ..initialize().then((_) {
          safeSetState(() {
            isloading = false;
            showcontrols = true;
            // controller.play();
          });
        });
    } else {
      controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
        ..initialize().then((_) {
          safeSetState(() {
            isloading = false;
            controller.play();
          });
        });
    }
  }

  Future<String> getvideourl({required String url}) async {
    var yt = YoutubeExplode();
    String urls;
    var manifest = await yt.videos.streamsClient.getManifest(VideoId(url), ytClients: [
      YoutubeApiClient.android
    ]);
    urls = manifest.muxed.first.url.toString();
    return urls;
  }

  @override
  void dispose() {
    controller.dispose();
    _hideControlsTimer?.cancel();
    CourseVideoPlayer.focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _showControls() {
    if (mounted) {
      safeSetState(() {
        showcontrols = true;
      });
    }
    _startAutoHideTimer(); // Restart timer on user interaction
  }

  void _startAutoHideTimer() {
    _hideControlsTimer?.cancel(); // Cancel any existing timer
    if (const Duration(seconds: 5) > Duration.zero) {
      _hideControlsTimer = Timer(const Duration(seconds: 5), _hideControls);
    }
  }

  void _hideControls() {
    _hideControlsTimer?.cancel();
    if (mounted) {
      safeSetState(() {
        showcontrols = false;
      });
    }
  }

  void _seekForward() {
    final currentPosition = controller.value.position;
    final duration = controller.value.duration;
    final newPosition = currentPosition + const Duration(seconds: 10);
    if (newPosition < duration) {
      controller.seekTo(newPosition);
    } else {
      controller.seekTo(duration);
    }
  }

  void _seekBackward() {
    final currentPosition = controller.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);
    if (newPosition > Duration.zero) {
      controller.seekTo(newPosition);
    } else {
      controller.seekTo(Duration.zero);
    }
  }

  void _handleFocusChange() {
    if (!CourseVideoPlayer.focusNode.hasFocus && controller.value.isPlaying == true) {
      controller.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Focus(
      focusNode: CourseVideoPlayer.focusNode,
      child: GestureDetector(
        onTap: showcontrols ? _hideControls : _showControls,
        behavior: HitTestBehavior.opaque,
        onDoubleTapDown: (details) {
          final width = MediaQuery.of(context).size.width;
          final dx = details.localPosition.dx;

          if (dx < width / 2) {
            // Left side double-tap: Rewind
            _seekBackward();
          } else {
            // Right side double-tap: Forward
            _seekForward();
          }
        },
        child: Skeletonizer(
          enabled: isloading,
          containersColor: ColorResources.borderColor,
          child: isloading
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.red,
                )
              : Stack(children: [
                  if (controller.value.isInitialized)
                    Skeleton.leaf(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: VideoPlayer(controller),
                      ),
                    ),
                  if (showcontrols)
                    Positioned(
                      top: 10,
                      right: 10,
                      left: 10,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment.center,
                            colors: [
                              Colors.black,
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            if (controller.value.isPlaying) {
                              controller.pause();
                            } else {
                              controller.play();
                            }
                            safeSetState(() {});
                          },
                          child: Icon(
                            controller.value.isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  if (showcontrols)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${controller.value.position.formatDuration()}/${controller.value.duration.formatDuration()}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FullScreenVideoScreen(
                                                  controller: controller,
                                                )));
                                  },
                                  icon: Icon(
                                    Icons.fullscreen_outlined,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            if (controller.value.isInitialized)
                              VideoProgressIndicator(
                                controller,
                                allowScrubbing: true,
                                padding: EdgeInsets.all(0),
                              ),
                          ],
                        ),
                      ),
                    ),
                ]),
        ),
      ),
    ));
  }
}
