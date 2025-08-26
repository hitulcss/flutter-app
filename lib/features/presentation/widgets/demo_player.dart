import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/cil.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class DemoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool autoplay;
  final bool isLoop;
  final String url;
  final Function(bool isFullScreen) close;
  const DemoPlayerWidget({super.key, required this.videoUrl, required this.autoplay, required this.isLoop, required this.url, required this.close});

  @override
  State<DemoPlayerWidget> createState() => _DemoPlayerWidgetState();
}

class _DemoPlayerWidgetState extends State<DemoPlayerWidget> {
  bool isShowControls = false;
  Timer? _hideControlsTimer;
  VideoPlayerController? _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );
    _controller!.initialize().then((_) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        safeSetState(() {
          _controller!.setLooping(widget.isLoop);
          if (widget.autoplay) {
            _controller!.play();
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _showControls() {
    if (mounted) {
      safeSetState(() {
        isShowControls = true;
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
    _hideControlsTimer?.cancel(); // Cancel any existing timer
    if (mounted) {
      safeSetState(() {
        isShowControls = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("video ${_controller?.value.isInitialized}");
    return _body(isFullScreen: false);
  }

  _body({
    required isFullScreen,
  }) {
    return !(_controller?.value.isInitialized ?? false)
        ? Container(
            height: 100,
            width: 100,
            color: Colors.black,
          )
        : GestureDetector(
            onTap: () => isShowControls ? _hideControls() : _showControls(),
            onDoubleTap: () => _controller!.value.isPlaying ? _controller!.pause() : _controller!.play(),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.3,
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
              ),
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: Stack(
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!),
                        ),
                      ),
                    ),
                    isShowControls
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton.filledTonal(
                                      onPressed: () {
                                        safeSetState(() {
                                          if (_controller!.value.volume > 0) {
                                            _controller!.setVolume(0);
                                          } else {
                                            _controller!.setVolume(100);
                                          }
                                        });
                                      },
                                      style: IconButton.styleFrom(
                                        backgroundColor: ColorResources.textblack.withValues(alpha: 0.4),
                                      ),
                                      icon: Icon(
                                        _controller!.value.volume == 0 ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                                        color: Colors.white,
                                      )),
                                  IconButton.filledTonal(
                                    style: IconButton.styleFrom(
                                      backgroundColor: ColorResources.textblack.withValues(alpha: 0.4),
                                    ),
                                    onPressed: () {
                                      widget.close(isFullScreen);
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black,
                                          offset: Offset(1, 1),
                                          blurRadius: 10,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  if (widget.url.trim().isNotEmpty && isFullScreen)
                                    ElevatedButton(
                                        onPressed: () {
                                          launchUrl(Uri.parse(widget.url), mode: LaunchMode.externalApplication);
                                        },
                                        child: Text(
                                          "Know more",
                                          style: TextStyle(color: ColorResources.textWhite),
                                        )),
                                  IconButton.filledTonal(
                                    onPressed: () {
                                      if (isFullScreen) {
                                        Navigator.pop(context);
                                      } else {
                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => DemoPlayerFullScreen(
                                            close: widget.close,
                                            url: widget.url,
                                            controller: _controller!,
                                          ),
                                        ));
                                      }
                                    },
                                    style: IconButton.styleFrom(
                                      backgroundColor: ColorResources.textblack.withValues(alpha: 0.4),
                                    ),
                                    icon: Iconify(
                                      Cil.fullscreen,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          );
  }
}

class DemoPlayerFullScreen extends StatefulWidget {
  final Function(bool isFullScreen) close;
  final String url;
  final VideoPlayerController controller;
  const DemoPlayerFullScreen({super.key, required this.close, required this.url, required this.controller});

  @override
  State<DemoPlayerFullScreen> createState() => _DemoPlayerFullScreenState();
}

class _DemoPlayerFullScreenState extends State<DemoPlayerFullScreen> {
  bool isFullScreen = true;
  Timer? _hideControlsTimer;
  bool isShowControls = false;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  void _showControls() {
    if (mounted) {
      safeSetState(() {
        isShowControls = true;
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
    _hideControlsTimer?.cancel(); // Cancel any existing timer
    if (mounted) {
      safeSetState(() {
        isShowControls = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => isShowControls ? _hideControls() : _showControls(),
      onDoubleTap: () => _controller.value.isPlaying ? _controller.pause() : _controller.play(),
      child: !_controller.value.isInitialized
          ? SizedBox()
          : Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.3,
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
              ),
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    ),
                    isShowControls
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton.filledTonal(
                                      onPressed: () {
                                        safeSetState(() {
                                          // log("Volume: ${_controller.value.volume}");
                                          if (_controller.value.volume > 0) {
                                            _controller.setVolume(0);
                                          } else {
                                            _controller.setVolume(100);
                                          }
                                        });
                                      },
                                      style: IconButton.styleFrom(
                                        backgroundColor: ColorResources.textblack.withValues(alpha: 0.4),
                                      ),
                                      icon: Icon(
                                        _controller.value.volume == 0 ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                                        color: Colors.white,
                                      )),
                                  IconButton.filledTonal(
                                    style: IconButton.styleFrom(
                                      backgroundColor: ColorResources.textblack.withValues(alpha: 0.4),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black,
                                          offset: Offset(1, 1),
                                          blurRadius: 10,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  if (widget.url.trim().isNotEmpty && isFullScreen)
                                    ElevatedButton(
                                        onPressed: () {
                                          launchUrl(Uri.parse(widget.url), mode: LaunchMode.externalApplication);
                                        },
                                        child: Text(
                                          "Know more",
                                          style: TextStyle(color: ColorResources.textWhite),
                                        )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
    );
  }
}
