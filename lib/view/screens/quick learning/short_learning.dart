import 'package:flutter/material.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/shorts/get_short_video.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/enum/short_type.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/view/screens/quick%20learning/video_controller.dart';
import 'package:sd_campus_app/view/screens/quick%20learning/video_reel_widget.dart';

class ShortLearningScreen extends StatefulWidget {
  final List<Short>? shorts;
  final int? page;
  final int? index;
  final ShortType shortType;
  const ShortLearningScreen({
    super.key,
    required this.shortType,
    this.page,
    this.shorts,
    this.index,
  });

  @override
  State<ShortLearningScreen> createState() => _ShortLearningScreenState();
}

class _ShortLearningScreenState extends State<ShortLearningScreen> {
  final VideoControllerManager _controllerManager = VideoControllerManager();
  final PageController _pageController = PageController();
  final List<Short> _videos = [];
  int page = 1;
  bool isShortFirst = true;
  bool _isLoading = false;
  bool isReachedMax = false;

  @override
  void initState() {
    super.initState();
    analytics.logScreenView(
      screenName: "app_short_learning",
      parameters: {
        "short_type": widget.shortType.name,
        "index": widget.index.toString(),
        "page": widget.page.toString(),
      },
    );
    if (widget.shorts != null) {
      _videos.addAll(widget.shorts!);
      _controllerManager.shortdata.addAll(widget.shorts!);
      if (widget.index != null) {
        _preloadVideos(widget.index ?? 0);
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _pageController.jumpToPage(widget.index ?? 0);
        });
      }
    }
    if (widget.page != null && widget.page! > 0) {
      page = widget.page ?? 1;
    } else {
      _loadVideos(shortType: widget.shortType);
    }
  }

  Future<void> _loadVideos({required ShortType shortType}) async {
    safeSetState(() => _isLoading = true);

    GetShortVideos newVideos;
    if (widget.shortType == ShortType.channel) {
      newVideos = await RemoteDataSourceImpl().getShortVideosByChannelId(
        channelId: _videos.first.channel?.id ?? "",
        page: page,
      );
    } else if (widget.shortType == ShortType.saved) {
      newVideos = await RemoteDataSourceImpl().getMySavedShort(
        page: page,
      );
    } else {
      newVideos = await RemoteDataSourceImpl().getShortVideos(
        page: page,
      );
    }

    if ((newVideos.status ?? false)) {
      safeSetState(() {
        _videos.addAll(newVideos.data?.shorts ?? []);
        _controllerManager.shortdata.addAll(newVideos.data?.shorts ?? []);
        _isLoading = false;
        if (page == 1) {
          _preloadVideos(0);
        }
        page++;
        isReachedMax = _videos.length == newVideos.data?.totalCounts;
      });
    } else {
      flutterToast(newVideos.msg ?? "");
      safeSetState(() {
        _isLoading = false;
      });
    }
  }

  void _preloadVideos(int index) {
    for (var i = index - 1; i <= index + 1; i++) {
      if (i >= 0 && i < _videos.length) {
        _controllerManager.initializeController(i, _videos[i].urls?.first.url ?? "");
      }
    }
  }

  void _postViewShort({required String shortId}) async {
    analytics.logEvent(name: "PostViewShort", parameters: {
      "shortId": shortId,
      "shortType": widget.shortType.name
    });
    RemoteDataSourceImpl().postViewShort(shortId: shortId);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controllerManager.disposeAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            ValueListenableBuilder(
                valueListenable: _controllerManager.initializationNotifier,
                builder: (context, _, __) {
                  return PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    itemCount: _videos.length,
                    onPageChanged: (value) {
                      // log(_videos[value].id.toString());
                      _preloadVideos(value);
                      _postViewShort(shortId: _videos[value].id ?? "");
                      if (value == _videos.length - 1 && !_isLoading) {
                        _loadVideos(shortType: widget.shortType).then((_) {
                          _preloadVideos(value);
                        });
                      }
                      var controller = _controllerManager.getController(value);
                      controller?.play();
                      controller?.setVolume(100);
                    },
                    itemBuilder: (context, index) {
                      final controller = _controllerManager.getController(index);
                      if (controller != null && controller.value.isInitialized) {
                        if (isShortFirst) {
                          isShortFirst = false;
                          _postViewShort(shortId: _videos[index].id ?? "");
                          controller.play();
                        }
                        return Center(
                          child: VideoReelWidget(
                            shortData: _controllerManager.getShortData(index),
                          ),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  );
                }),
            Positioned(
              top: 5,
              left: 5,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  shadows: [
                    Shadow(blurRadius: 5)
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
