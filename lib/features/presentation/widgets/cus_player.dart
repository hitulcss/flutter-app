import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sd_campus_app/features/presentation/widgets/video_fullscreen.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/date_formate.dart';
import 'package:sd_campus_app/util/enum/playertype.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class CuPlayerScreen extends StatefulWidget {
  final bool canpop;
  final String url;
  final bool isLive;
  final PlayerType playerType;
  final String wallpaper;
  final List<Widget> children;
  final bool autoPLay;
  const CuPlayerScreen({
    super.key,
    required this.url,
    required this.isLive,
    required this.playerType,
    this.wallpaper = "",
    required this.canpop,
    required this.children,
    required this.autoPLay,
  });

  @override
  State<CuPlayerScreen> createState() => _CuPlayerScreenState();
}

class _CuPlayerScreenState extends State<CuPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isLoading = true;
  bool isError = false;
  List<ListFormat> _qualities = [];
  String _selectedQualityUrl = '';
  String _selectedQualityLabel = '';
  Timer? _hideControlsTimer;
  bool isLive = false;
  bool _showcontrols = false;
  String wallpaper = SvgImages.aboutLogo;

  Duration _time = Duration.zero;

  @override
  void initState() {
    if (widget.playerType == PlayerType.youtube) {
      if (widget.wallpaper.isNotEmpty) {
        if (mounted) {
          safeSetState(() {
            wallpaper = widget.wallpaper;
          });
        }
      } else {
        youtubeThumblineurl(videoId: widget.url).then((value) {
          if (mounted) {
            safeSetState(() {
              wallpaper = widget.wallpaper;
            });
          }
        });
      }
      isVideoLive(widget.url).then((value) {
        if (value) {
          _fetchYoutubeLiveHlsStreamUrl(id: widget.url);
        } else {
          _fetchYoutubeRecordedVideo(id: widget.url);
        }
      });
    } else if (widget.playerType == PlayerType.hLS) {
      _playhlsvideoPlayer(url: widget.url);
    } else if (widget.playerType == PlayerType.network) {
      _playNetworkVideoPlayer(url: widget.url);
    }
    super.initState();
  }

  @override
  void dispose() {
    try {
      _controller.dispose();
    } catch (e) {
      // print(e);
    }
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _isLoading
          ? emptyWidget()
          : isError
              ? AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (widget.canpop)
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton.filled(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 50,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 10),
                            const Text("Error Loading Video"),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio < 16 / 9 ? 16 / 9 : _controller.value.aspectRatio,
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: GestureDetector(
                          onTap: _showcontrols ? _hideControls : _showControls,
                          // onDoubleTap: _hideControls,
                          child: Stack(
                            children: [
                              VideoPlayer(_controller),
                              _showcontrols
                                  ? Container(
                                      color: Colors.black.withValues(alpha: 0.6),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              if (widget.canpop)
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
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      if (mounted) {
                                                        safeSetState(() {
                                                          _controller.seekTo(Duration(seconds: _controller.value.position.inSeconds - 10));
                                                        });
                                                      }
                                                    },
                                                    icon: const Icon(
                                                      CupertinoIcons.gobackward_10,
                                                      color: Colors.white,
                                                      size: 40,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 30,
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      if (mounted) {
                                                        safeSetState(() {
                                                          _controller.value.isPlaying ? _controller.pause() : _controller.play();
                                                        });
                                                      }
                                                    },
                                                    icon: Icon(
                                                      _controller.value.isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
                                                      color: Colors.white,
                                                      size: 45,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 30,
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
                                                      size: 40,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (!widget.isLive)
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: CusPlayerProgressBar(
                                                      controller: _controller,
                                                      colors: VideoProgressColors(
                                                        playedColor: const Color(0xFF9603F2),
                                                        bufferedColor: Colors.white,
                                                        backgroundColor: Colors.grey.withValues(alpha: 0.3),
                                                      ),
                                                      allowScrubbing: true,
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
                                                    if (!widget.isLive)
                                                      ValueListenableBuilder(
                                                          valueListenable: _controller,
                                                          builder: (context, value, child) {
                                                            return Text(
                                                              "${_controller.value.position.formatDuration()} / ${_controller.value.duration.formatDuration()}",
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
                                                        if (mounted) {
                                                          safeSetState(() {});
                                                        }
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
                                                            builder: (context) => SizedBox(
                                                              child: Dialog(
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
                                                                              if (mounted) {
                                                                                safeSetState(() {
                                                                                  _controller.setPlaybackSpeed(value);
                                                                                });
                                                                              }
                                                                            },
                                                                            onChangeEnd: (value) => safeSetState(() {
                                                                                  _controller.setPlaybackSpeed(value);
                                                                                }),
                                                                            onChanged: (value) {
                                                                              if (mounted) {
                                                                                safeSetState(() {
                                                                                  _controller.setPlaybackSpeed(value);
                                                                                });
                                                                              }
                                                                            }),
                                                                      ],
                                                                    ),
                                                                  );
                                                                }),
                                                              ),
                                                            ),
                                                          ).then((value) {
                                                            if (mounted) {
                                                              safeSetState(() {});
                                                            }
                                                          });
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
                                                                                  _controller.position.then((value) {
                                                                                    _time = value ?? Duration.zero;
                                                                                  });
                                                                                  disposeController();
                                                                                  _controller = VideoPlayerController.networkUrl(Uri.parse(_selectedQualityUrl));
                                                                                  _controller.initialize().then((_) {
                                                                                    // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                                                                                    if (_time != Duration.zero) {
                                                                                      _controller.seekTo(_time);
                                                                                    }
                                                                                    _controller.play();
                                                                                    if (mounted) {
                                                                                      safeSetState(() {
                                                                                        _isLoading = false;
                                                                                      });
                                                                                    }
                                                                                    Navigator.of(context).pop();
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
                                                                  )).then((value) {
                                                            if (mounted) {
                                                              safeSetState(() {});
                                                            }
                                                          });
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
                                                        Navigator.of(context).push(MaterialPageRoute(
                                                          builder: (context) => FullScreenVideoScreen(controller: _controller, qualities: _qualities, selectedQualityUrl: _selectedQualityUrl, selectedQualityLabel: _selectedQualityLabel),
                                                        ));
                                                      },
                                                      icon: const Icon(
                                                        Icons.fullscreen,
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
                                  : Container(),
                              ...widget.children
                            ],
                          ),
                        ),
                      ),
                    )
                  : emptyWidget(),
    );
  }

  Widget emptyWidget() {
    return AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          children: [
            if (wallpaper.isNotEmpty)
              CachedNetworkImage(
                height: double.infinity,
                width: double.infinity,
                imageUrl: wallpaper,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            const Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              right: 0,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ));
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
        _showcontrols = false;
      });
    }
  }

  void _handleDoubleTap(Offset position) {
    final halfWidth = MediaQuery.of(context).size.width / 2;
    if (position.dx < halfWidth) {
      // Rewind
      _controller.seekTo(Duration(seconds: _controller.value.position.inSeconds - 10));
    } else {
      // Fast forward
      _controller.seekTo(Duration(seconds: _controller.value.position.inSeconds + 10));
    }
  }

  void _showControls() {
    if (mounted) {
      safeSetState(() {
        _showcontrols = true;
      });
    }
    _startAutoHideTimer(); // Restart timer on user interaction
  }

  _fetchYoutubeRecordedVideo({id = "9bZkp7q19f0"}) async {
    List<ListFormat> qualities = [];
    final yt = YoutubeExplode();
    // print(id);
    try {
      final video = await yt.videos.streamsClient.getManifest(VideoId(id), ytClients: [
        YoutubeApiClient.android,
        YoutubeApiClient.ios,
        YoutubeApiClient.androidVr,
      ]);
      for (var element in video.muxed) {
        qualities.add(ListFormat.fromJson({
          'label': element.qualityLabel,
          'url': element.url.toString(),
        }));
      }
      _qualities = qualities;
      // print(_qualities);
      if (qualities.isNotEmpty) {
        _selectedQualityUrl = qualities.first.url ?? "";
        _selectedQualityLabel = qualities.first.label ?? "";

        disposeController();
        _controller = VideoPlayerController.networkUrl(Uri.parse(_selectedQualityUrl));
        _controller.initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          safeSetState(() {
            _isLoading = false;
          });
          if (widget.autoPLay) {
            _controller.play();
          }
        }).onError((error, stackTrace) {
          // print(object);
          if (mounted) {
            safeSetState(() {
              isError = true;
              _isLoading = false;
            });
          }
        });
      }
    } catch (e) {
      if (mounted) {
        safeSetState(() {
          isError = true;
          _isLoading = false;
        });
      }
    }
  }

  void disposeController() {
    try {
      if (_controller.value.isInitialized) {
        _controller.dispose();
        if (mounted) {
          safeSetState(() {
            _isLoading = true;
          });
        }
      }
    } catch (e) {
      // print(e);
    }
  }

  Future<void> _fetchYoutubeLiveHlsStreamUrl({String id = 'II_m28Bm-iM'}) async {
    final yt = YoutubeExplode(); // Initialize YoutubeExplode
    final videoId = VideoId(id); // Replace with your actual VideoId

    try {
      var hlsUrl = await yt.videos.streamsClient.getHttpLiveStreamUrl(videoId);
      // Assuming the URL is valid, fetch qualities
      final qualities = await getHlsQualities(hlsUrl);
      _qualities = qualities;
      if (qualities.isNotEmpty && mounted) {
        safeSetState(() {
          _selectedQualityUrl = qualities.first.url ?? "";
          _selectedQualityLabel = qualities.first.label ?? "";
        });
        disposeController();
        Future.delayed(const Duration(seconds: 1), () {
          _controller = VideoPlayerController.networkUrl(Uri.parse(_selectedQualityUrl));
          _controller.initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            safeSetState(() {
              _isLoading = false;
            });
            if (widget.autoPLay) {
              _controller.play();
            }
          });
        });
      }
    } catch (error) {
      // print(error);
    } finally {
      yt.close(); // Close the YoutubeExplode client
    }
  }

  Future<bool> isVideoLive(String videoId) async {
    final yt = YoutubeExplode();
    try {
      final video = await yt.videos.get(VideoId(videoId));
      return video.isLive;
    } catch (error) {
      // print('Error fetching video details: $error');
      return false;
    } finally {
      yt.close();
    }
  }

  void clear() {
    _qualities = [];
    _selectedQualityLabel = "";
    _selectedQualityUrl = "";
  }

  _playNetworkVideoPlayer({required String url}) async {
    clear();
    disposeController();
    _controller = VideoPlayerController.networkUrl(Uri.parse(url));
    _controller.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      if (mounted) {
        safeSetState(() {
          _isLoading = false;
        });
      }
      if (widget.autoPLay) {
        _controller.play();
      }
    }).onError((error, stackTrace) {
      analytics.logEvent(name: "app_network_video_error", parameters: {
        "error": error.toString()
      });
    });
  }

  void _playhlsvideoPlayer({required String url}) async {
    clear();
    // if (_controller.value.isInitialized) {
    disposeController();

    List<ListFormat> qualities = await getHlsQualities(url);
    _qualities = qualities;
    _selectedQualityLabel = qualities.first.label ?? "";
    _selectedQualityUrl = qualities.first.url ?? "";
    _controller = VideoPlayerController.networkUrl(Uri.parse(qualities.first.url ?? ""));
    _controller.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      if (mounted) {
        safeSetState(() {
          _isLoading = false;
        });
      }
      if (widget.autoPLay) {
        _controller.play();
      }
    }).onError((error, stackTrace) {
      // print(error);
    });
  }
}

Future<List<ListFormat>> getHlsQualities(String url) async {
  final response = await Dio().get(url);

  if (response.statusCode == 200) {
    final lines = response.data.split('\n');
    final qualities = <ListFormat>[];
    qualities.add(
      ListFormat.fromJson({
        'label': 'auto',
        'url': url
      }),
    );
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.startsWith('#EXT-X-STREAM-INF')) {
        final resolutionMatch = RegExp(r'RESOLUTION=(\d+x\d+)').firstMatch(line);
        final resolution = resolutionMatch != null ? resolutionMatch.group(1) : 'Unknown';
        final label = '${resolution!.split('x').last}p';
        final uriLineIndex = i + 1;
        if (uriLineIndex < lines.length) {
          // print(label);
          if (qualities.any((q) => q.label == label)) {
            // print("found");
            continue;
          } else {
            qualities.add(
              ListFormat.fromJson({
                'label': label,
                'url': lines[uriLineIndex]
              }),
            );
          }
        }
      }
    }
    return qualities.toSet().toList();
  } else {
    throw Exception('Failed to load playlist');
  }
}

Future<String> youtubeThumblineurl({required String videoId}) async {
  final yt = YoutubeExplode();
  try {
    final video = await yt.videos.get(VideoId(videoId));
    // print(video.thumbnails.highResUrl);
    return video.thumbnails.highResUrl;
  } catch (error) {
    // print('Error fetching video details: $error');
    return "";
  } finally {
    yt.close();
  }
}

class ListFormat {
  String? label;
  String? url;

  ListFormat({this.label, this.url});

  ListFormat.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['url'] = url;
    return data;
  }
}

class CusPlayerProgressBar extends StatefulWidget {
  final VideoPlayerController controller;
  final bool allowScrubbing;

  /// The default colors used throughout the indicator.
  ///
  /// See [VideoProgressColors] for default values.
  final VideoProgressColors colors;

  const CusPlayerProgressBar({
    super.key,
    required this.controller,
    required this.allowScrubbing,
    required this.colors,
  });
  @override
  State<CusPlayerProgressBar> createState() => _CusPlayerProgressBarState();
}

class _CusPlayerProgressBarState extends State<CusPlayerProgressBar> {
  _CusPlayerProgressBarState() {
    listener = () {
      if (mounted) {
        safeSetState(() {});
      }
    };
  }
  VideoPlayerController get controller => widget.controller;
  VideoProgressColors get colors => widget.colors;
  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  void deactivate() {
    controller.removeListener(listener);
    super.deactivate();
  }

  late VoidCallback listener;
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CusPlayerProgressBarPainter(widget.controller.value, context, colors),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragUpdate: widget.allowScrubbing
            ? (details) {
                if (widget.controller.value.isInitialized) {
                  final box = context.findRenderObject() as RenderBox;
                  final offset = details.localPosition.dx;
                  final position = offset / box.size.width * widget.controller.value.duration.inMilliseconds;
                  widget.controller.seekTo(Duration(milliseconds: position.round()));
                }
              }
            : null,
        onTapDown: widget.allowScrubbing
            ? (details) {
                if (widget.controller.value.isInitialized) {
                  final box = context.findRenderObject() as RenderBox;
                  final offset = details.localPosition.dx;
                  final position = offset / box.size.width * widget.controller.value.duration.inMilliseconds;
                  widget.controller.seekTo(Duration(milliseconds: position.round()));
                }
              }
            : null,
        child: Container(
          height: 5,
        ),
      ),
    );
  }
}

class _CusPlayerProgressBarPainter extends CustomPainter {
  final VideoPlayerValue value;
  final BuildContext context;
  final VideoProgressColors colors;

  _CusPlayerProgressBarPainter(this.value, this.context, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final paintBackground = Paint()
      ..color = colors.backgroundColor
      ..style = PaintingStyle.fill;

    final paintBuffered = Paint()
      ..color = colors.bufferedColor
      ..style = PaintingStyle.fill;

    final paintPlayed = Paint()
      ..color = colors.playedColor
      ..style = PaintingStyle.fill;

    final paintCircle = Paint()
      ..color = colors.playedColor
      ..style = PaintingStyle.fill;

    final double height = size.height;
    final double width = size.width;

    if (value.duration.inMilliseconds == 0) {
      // If the duration is zero (e.g., video not loaded), draw only the background
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, width, height),
          const Radius.circular(10),
        ),
        paintBackground,
      );
      return;
    }

    // Calculate played and buffered parts
    final bool isCompleted = value.position >= value.duration;
    final double playedPart = isCompleted ? width : (value.position.inMilliseconds.clamp(0, value.duration.inMilliseconds).toDouble() / value.duration.inMilliseconds) * width;

    final double bufferedPart = value.buffered.isNotEmpty ? (value.buffered.last.end.inMilliseconds.clamp(0, value.duration.inMilliseconds).toDouble() / value.duration.inMilliseconds) * width : 0;

    // Draw background
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, width, height),
        const Radius.circular(10),
      ),
      paintBackground,
    );

    // Draw buffered part
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, bufferedPart, height),
        const Radius.circular(10),
      ),
      paintBuffered,
    );

    // Draw played part
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, playedPart, height),
        const Radius.circular(10),
      ),
      paintPlayed,
    );

    // Draw progress circle
    if (!isCompleted) {
      canvas.drawCircle(Offset(playedPart, height / 2), 8, paintCircle);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
