import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:sd_campus_app/features/data/remote/models/shorts/get_short_video.dart';
import 'package:sd_campus_app/main.dart';
import 'package:video_player/video_player.dart';

class VideoControllerManager {
  final Map<int, VideoPlayerController> _controllers = {};
  List<Short> shortdata = [];
  final Queue<_QueueItem> _initializationQueue = Queue();
  bool _isInitializing = false;
  final int maxConcurrentControllers = 5;
  final ValueNotifier<void> initializationNotifier = ValueNotifier<void>(null);

  int get length => _controllers.length;
  Map<int, VideoPlayerController> get controllers => _controllers;
  ShortData getShortData(int index) {
    return ShortData(index: index, short: shortdata[index], videoPlayerController: _controllers[index]);
  }

  VideoPlayerController? getController(int index) {
    // _pauseAllVideos();
    // log("Retrieving controller for index: $index");
    return _controllers[index];
  }

  /// Pauses all currently active video controllers.
  void _pauseAllVideos() {
    for (var controller in _controllers.values) {
      if (controller.value.isPlaying) {
        controller.seekTo(Duration.zero);
        // log("Paused video for controller.");
      }
    }
  }

  Future<void> initializeController(int index, String url) async {
    // log("Initializing controller for index: $index");
    if (_controllers.containsKey(index)) {
      final controller = _controllers[index];
      if (controller != null && controller.value.isInitialized) {
        await controller.pause();
        await controller.seekTo(Duration.zero);
        return;
      } else {
        if (_initializationQueue.any((item) => item.index == index)) {
          // log("Controller already queued for index: $index");
          return;
        }
        _initializationQueue.addFirst(_QueueItem(index, url));
        _processQueue();
      }
      return;
    }

    if (_initializationQueue.any((item) => item.index == index)) {
      // log("Controller already queued for index: $index");
      return;
    }

    _initializationQueue.addFirst(_QueueItem(index, url));
    _processQueue();
  }

  Future<void> _processQueue() async {
    if (_isInitializing) return;
    _isInitializing = true;

    while (_initializationQueue.isNotEmpty) {
      final item = _initializationQueue.removeFirst();
      if (_controllers.containsKey(item.index)) continue;

      // log("Initializing video controller for index: ${item.index}");
      try {
        await _retryInitializeController(item, retryCount: 3);
      } catch (e) {
        // log("Error initializing controller for index ${item.index}: $e");
        _cleanupFailedController(item.index);
      }

      _cleanupExtraControllers();
    }

    _isInitializing = false;
  }

  Future<void> _retryInitializeController(_QueueItem item, {int retryCount = 3}) async {
    for (int attempt = 0; attempt < retryCount; attempt++) {
      try {
        analytics.logEvent(
          name: "VideoControllerErorr",
          parameters: {
            "shortid": shortdata[item.index].id.toString(),
            "index": item.index,
            "url": item.url
          },
        );
        final controller = VideoPlayerController.networkUrl(Uri.parse(item.url));
        await controller.initialize();
        controller.setLooping(true);
        _controllers[item.index] = controller;
        initializationNotifier.notifyListeners();
        // log("Controller initialized for index: ${item.index}");
        return;
      } catch (e) {
        // log("Retry ${attempt + 1} failed for index ${item.index}: $e");
        if (attempt == retryCount - 1) throw e;
      }
    }
  }

  void _cleanupFailedController(int index) {
    if (_controllers.containsKey(index)) {
      _controllers[index]?.dispose();
      _controllers.remove(index);
      // log("Controller removed for index: $index due to initialization failure");
    }
  }

  void _cleanupExtraControllers() {
    while (_controllers.length > maxConcurrentControllers) {
      final oldestIndex = _controllers.keys.first;
      // log("Disposing controller for index: $oldestIndex to free resources");
      disposeController(oldestIndex);
    }
  }

  void disposeController(int index) {
    if (_controllers.containsKey(index)) {
      _controllers[index]?.dispose();
      _controllers.remove(index);
      initializationNotifier.notifyListeners();
      // log("Controller disposed for index: $index");
    }
  }

  void disposeAll() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    _initializationQueue.clear();
    initializationNotifier.dispose();
    // log("Disposed all controllers and cleared the queue");
  }
}

class _QueueItem {
  final int index;
  final String url;
  _QueueItem(this.index, this.url);
}

class ShortData {
  int index;
  Short short;
  VideoPlayerController? videoPlayerController;
  ShortData({required this.index, required this.short, required this.videoPlayerController});
}
