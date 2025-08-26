import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sd_campus_app/features/presentation/widgets/cus_player.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:video_player/video_player.dart';
import "package:flutter/cupertino.dart";

class FullScreenVideoScreen extends StatefulWidget {
  final VideoPlayerController controller;
  final List<ListFormat> qualities;
  final String? selectedQualityUrl;
  final String? selectedQualityLabel;
  final Timer? hideControlsTimer;
  final bool isLive = false;
  const FullScreenVideoScreen({
    super.key,
    required this.controller,
    this.qualities = const [],
    this.selectedQualityUrl,
    this.selectedQualityLabel,
    this.hideControlsTimer,
  });

  @override
  State<FullScreenVideoScreen> createState() => _FullScreenVideoScreenState();
}

class _FullScreenVideoScreenState extends State<FullScreenVideoScreen> {
  late VideoPlayerController _controller;
  List<ListFormat> _qualities = [];
  String _selectedQualityUrl = '';
  String _selectedQualityLabel = '';
  Timer? _hideControlsTimer;
  bool isLive = false;

  bool _showcontrols = false;
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: [
      SystemUiOverlay.bottom,
      SystemUiOverlay.top
    ]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft
    ]);
    _controller = widget.controller;
    _selectedQualityUrl = widget.selectedQualityUrl ?? '';
    _selectedQualityLabel = widget.selectedQualityLabel ?? '';
    _qualities = widget.qualities;
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.bottom,
      SystemUiOverlay.top
    ]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _controller.value.isInitialized
            ? Container(
                color: Colors.black,
                width: double.infinity,
                height: double.infinity,
                child: GestureDetector(
                  onTap: _showControls,
                  onDoubleTap: _hideControls,
                  child: Stack(
                    children: [
                      Center(child: AspectRatio(aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller))),
                      _showcontrols
                          ? Container(
                              color: Colors.black.withValues(alpha: 0.6),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: const Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        // mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              safeSetState(() {
                                                _controller.seekTo(Duration(seconds: _controller.value.position.inSeconds - 10));
                                              });
                                            },
                                            icon: const Icon(
                                              CupertinoIcons.gobackward_10,
                                              color: Colors.white,
                                              size: 55,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              safeSetState(() {
                                                _controller.value.isPlaying ? _controller.pause() : _controller.play();
                                              });
                                            },
                                            icon: Icon(
                                              _controller.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                                              color: Colors.white,
                                              size: 55,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              safeSetState(() {
                                                _controller.seekTo(Duration(seconds: _controller.value.position.inSeconds + 10));
                                              });
                                            },
                                            icon: const Icon(
                                              CupertinoIcons.goforward_10,
                                              color: Colors.white,
                                              size: 55,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (!isLive)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: VideoProgressIndicator(
                                              _controller,
                                              allowScrubbing: true,
                                              colors: VideoProgressColors(
                                                playedColor: const Color(0xFF9603F2),
                                                bufferedColor: Colors.white,
                                                backgroundColor: Colors.grey.withValues(alpha: 0.3),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            if (!isLive)
                                              ValueListenableBuilder(
                                                  valueListenable: _controller,
                                                  builder: (context, value, child) {
                                                    return Text(
                                                      "${_controller.value.position.toString().split('.').first} / ${_controller.value.duration.toString().split('.').first}",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    );
                                                  }),
                                            IconButton(
                                              icon: Icon(
                                                _controller.value.volume == 0 ? Icons.volume_off : Icons.volume_up,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                if (_controller.value.volume == 0) {
                                                  _controller.setVolume(1);
                                                } else {
                                                  _controller.setVolume(0);
                                                }
                                                safeSetState(() {});
                                              },
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            PopupMenuButton(
                                              color: Colors.black.withValues(alpha: 0.8),
                                              surfaceTintColor: Colors.grey.withValues(alpha: 0.6),
                                              icon: const Icon(Icons.settings, color: Colors.white),
                                              useRootNavigator: true,
                                              popUpAnimationStyle: AnimationStyle.noAnimation,
                                              onCanceled: () {
                                                _hideControls();
                                              },
                                              offset: const Offset(0, -100),
                                              onSelected: (value) {
                                                if (value == "speed") {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => Dialog(
                                                      child: StatefulBuilder(builder: (context, safeSetState) {
                                                        return FittedBox(
                                                          fit: BoxFit.fitWidth,
                                                          child: Column(
                                                            children: [
                                                              const Text(
                                                                "Speed",
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                              Slider(
                                                                  min: 0,
                                                                  max: 2.0,
                                                                  divisions: 8,
                                                                  value: _controller.value.playbackSpeed,
                                                                  label: "${_controller.value.playbackSpeed}x",
                                                                  onChangeStart: (value) {
                                                                    safeSetState(() {
                                                                      _controller.setPlaybackSpeed(value);
                                                                    });
                                                                  },
                                                                  onChangeEnd: (value) => safeSetState(() {
                                                                        _controller.setPlaybackSpeed(value);
                                                                      }),
                                                                  onChanged: (value) {
                                                                    safeSetState(() {
                                                                      _controller.setPlaybackSpeed(value);
                                                                    });
                                                                  }),
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                  );
                                                } else if (value == "quality") {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) => Dialog(
                                                            child: StatefulBuilder(
                                                              builder: (context, safeSetState) => FittedBox(
                                                                fit: BoxFit.scaleDown,
                                                                child: Center(
                                                                  child: Row(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      const Text("Quality: "),
                                                                      DropdownButton<String>(
                                                                        value: _selectedQualityLabel,
                                                                        onChanged: (value) {
                                                                          final selectedQuality = _qualities.firstWhere((quality) => quality.label == value);
                                                                          safeSetState(() {
                                                                            _selectedQualityLabel = value ?? "";
                                                                            _selectedQualityUrl = selectedQuality.url ?? "";
                                                                          });
                                                                          _controller = VideoPlayerController.networkUrl(Uri.parse(_selectedQualityUrl));
                                                                          _controller.initialize().then((_) {
                                                                            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                                                                            safeSetState(() {});
                                                                          });
                                                                        },
                                                                        items: _qualities.map((quality) {
                                                                          return DropdownMenuItem<String>(
                                                                            value: quality.label,
                                                                            child: Text(quality.label ?? ""),
                                                                          );
                                                                        }).toList(),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ));
                                                }
                                              },
                                              onOpened: () => _hideControlsTimer?.isActive ?? false ? _hideControlsTimer?.cancel() : null,
                                              itemBuilder: (_) => [
                                                if (_qualities.isNotEmpty)
                                                  PopupMenuItem<String>(
                                                    value: 'quality',
                                                    child: Row(
                                                      children: [
                                                        const Text(
                                                          'Quality ',
                                                          style: TextStyle(color: Colors.white),
                                                        ),
                                                        const Spacer(),
                                                        Text("${_controller.value.size.height.toInt()}p", style: const TextStyle(color: Colors.white)),
                                                      ],
                                                    ),
                                                  ),
                                                PopupMenuItem<String>(
                                                  value: "speed",
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        'Speed',
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                      const Spacer(),
                                                      Text("${_controller.value.playbackSpeed}x", style: const TextStyle(color: Colors.white)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              icon: const Icon(
                                                Icons.fullscreen_exit_outlined,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              )
            : Container(),
      ),
    );
  }

  void _startAutoHideTimer() {
    _hideControlsTimer?.cancel(); // Cancel any existing timer
    if (const Duration(seconds: 5) > Duration.zero) {
      _hideControlsTimer = Timer(const Duration(seconds: 5), _hideControls);
    }
  }

  void _hideControls() {
    _hideControlsTimer?.cancel();
    safeSetState(() {
      _showcontrols = false;
    });
  }

  void _showControls() {
    safeSetState(() {
      _showcontrols = true;
    });
    _startAutoHideTimer(); // Restart timer on user interaction
  }
}
