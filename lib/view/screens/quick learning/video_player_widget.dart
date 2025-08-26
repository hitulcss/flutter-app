import 'dart:async';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  const VideoPlayerWidget({super.key, required this.videoPlayerController});

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _showUIMuit = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = widget.videoPlayerController;
    //  VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
    //   ..initialize().then((_) {
    //     safeSetState(() {});
    //     _controller.play();
    //     _controller.setLooping(true);
    //   });
  }

  @override
  void dispose() {
    // _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      // mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: _controller.value.isInitialized
              ? GestureDetector(
                  onTap: () {
                    safeSetState(() {
                      _showUIMuit = !_showUIMuit;
                      _timer?.cancel(); // Cancel any existing timer
                      _timer = Timer(const Duration(seconds: 2), () {
                        safeSetState(() {
                          _timer = null;
                        });
                      });
                    });

                    _controller.setVolume(_controller.value.volume == 0 ? 100 : 0);
                  },
                  onLongPress: () {
                    _controller.pause();
                  },
                  onLongPressEnd: (details) {
                    _controller.play();
                  },
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                )
              : Center(child: CircularProgressIndicator()),
        ),
        Center(
          child: AnimatedSize(
            duration: Duration(milliseconds: 100),
            child: CircleAvatar(
                radius: _timer == null ? 0 : 30,
                backgroundColor: Colors.black.withValues(alpha: 0.6),
                child: _timer == null
                    ? null
                    : Icon(
                        _controller.value.volume != 0 ? Icons.volume_up : Icons.volume_off,
                        color: Colors.white,
                      )),
          ),
        )
      ],
    );
  }
}
