import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ui_tool_kit/ui_tool_kit.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class VideoPlayerView extends StatefulWidget {
  final String videoURL, thumbNail, title;
  const VideoPlayerView({
    super.key,
    required this.videoURL,
    required this.thumbNail,
    required this.title,
  });

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView>
    with WidgetsBindingObserver {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoURL))
          ..initialize().then((_) {
            if (context.mounted) {
              WakelockPlus.enable();
              _videoPlayerController.play();
              if (EveentTriggered.video_class_player_open != null) {
                final DateTime now = DateTime.now();
                final currentTime = VideoDetailController.getFormatPosition(
                    _videoPlayerController.value.position.inMilliseconds
                        .toDouble());
                DateTime dateType = DateFormat("HH:mm:ss").parse(currentTime);
                DateTime newDate = DateTime(now.year, now.month, now.day,
                    dateType.hour, dateType.minute, dateType.second);
                EveentTriggered.video_class_player_open!(
                    widget.title, widget.videoURL, newDate);
              }
              if (EveentTriggered.audio_class_player_open != null) {
                final DateTime now = DateTime.now();
                final currentTime = VideoDetailController.getFormatPosition(
                    _videoPlayerController.value.position.inMilliseconds
                        .toDouble());
                DateTime dateType = DateFormat("HH:mm:ss").parse(currentTime);
                DateTime newDate = DateTime(now.year, now.month, now.day,
                    dateType.hour, dateType.minute, dateType.second);
                EveentTriggered.audio_class_player_open!(
                    widget.title, widget.videoURL, newDate);
              }

              setState(() {});
            }
          });

    setLandScapeAutoRotation();
  }

  @override
  void dispose() {
    super.dispose();
    if (EveentTriggered.video_class_player_close != null) {
      final DateTime now = DateTime.now();

      final duration = VideoDetailController.getFormatPosition(
          _videoPlayerController.value.position.inMilliseconds.toDouble());

      DateTime dateType = DateFormat("HH:mm:ss").parse(duration);
      DateTime newDate = DateTime(now.year, now.month, now.day, dateType.hour,
          dateType.minute, dateType.second);

      EveentTriggered.video_class_player_close!(
          widget.title, widget.videoURL, newDate);
    }
    if (EveentTriggered.audio_class_player_close != null) {
      final DateTime now = DateTime.now();
      final duration = VideoDetailController.getFormatPosition(
          _videoPlayerController.value.position.inMilliseconds.toDouble());
      DateTime dateType = DateFormat("HH:mm:ss").parse(duration);
      DateTime newDate = DateTime(now.year, now.month, now.day, dateType.hour,
          dateType.minute, dateType.second);
      EveentTriggered.audio_class_player_close!(
        widget.title,
        widget.videoURL,
        newDate,
      );
    }
    WakelockPlus.disable();
    _videoPlayerController.dispose();

    WidgetsBinding.instance.removeObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VideoDetailController.showControls.value = false;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!_videoPlayerController.value.isPlaying && context.mounted) {
        WakelockPlus.enable();
        _videoPlayerController.play();
      }
    } else if (state == AppLifecycleState.inactive && context.mounted) {
      if (_videoPlayerController.value.isPlaying) {
        WakelockPlus.disable();
        _videoPlayerController.pause();
      }
    }
  }

  Future setLandScapeAutoRotation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp
    ]);
  }

  Future<bool> restoreOrientation() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    bool rotated = false;
    return WillPopScope(
      onWillPop: () async {
        await restoreOrientation().then((value) {
          rotated = true;
        });

        return Future.value(rotated);
      },
      child: _videoPlayerController.value.isInitialized
          ? VideoPlayerWidget(
              videoPlayerController: _videoPlayerController,
              title: widget.title,
              videoUrl: widget.videoURL,
            )
          : Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppColor.surfaceBrandDarkColor,
                  image: DecorationImage(
                      image: cachedNetworkImageProvider(
                        imageUrl: widget.thumbNail,
                      ),
                      fit: BoxFit.contain)),
              child: BaseHelper.loadingWidget()),
    );
  }
}
