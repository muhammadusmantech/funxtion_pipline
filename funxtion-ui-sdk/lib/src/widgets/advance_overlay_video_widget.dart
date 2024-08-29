import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:ui_tool_kit/ui_tool_kit.dart';
import 'package:video_player/video_player.dart';

class AdvancedOverlayWidget extends StatefulWidget {
  final String title, videoUrl;

  final VideoPlayerController controller;
  final VoidCallback onClickedFullScreen;

  final bool isPortrait;

  const AdvancedOverlayWidget({
    super.key,
    required this.controller,
    required this.onClickedFullScreen,
    required this.isPortrait,
    required this.title,
    required this.videoUrl,
  });

  @override
  State<AdvancedOverlayWidget> createState() => _AdvancedOverlayWidgetState();
}

class _AdvancedOverlayWidgetState extends State<AdvancedOverlayWidget> {
  static const allSpeeds = <double>[0.25, 0.5, 1, 1.5, 2.0];
   ValueNotifier<double> positionMiliSecond = ValueNotifier(0.0);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.controller,
        builder: (_, value, child) {
          return Stack(
            clipBehavior: Clip.hardEdge,
            fit: StackFit.expand,
            children: [
              value.isBuffering
                  ? Center(child: BaseHelper.loadingWidget())
                  : playButton(),
              Positioned(
                left: 16,
                top: widget.isPortrait == false ? 18 : 0,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    context.maybePopPage();
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColor.surfaceBrandDarkColor,
                        borderRadius: BorderRadius.circular(8)),
                    child:
                        Icon(Icons.close, color: AppColor.textInvertEmphasis),
                  ),
                ),
              ),
              Positioned(
                right: 16,
                top: widget.isPortrait == false ? 18 : 0,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: widget.onClickedFullScreen,
                  child: Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColor.surfaceBrandDarkColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: widget.isPortrait
                        ? SvgPicture.asset(AppAssets.openFullScreenIcon)
                        : SvgPicture.asset(AppAssets.exitFullScreenIcon),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                bottom: 50,
                child: Text(
                  "${VideoDetailController.getPosition(value)}/${VideoDetailController.getVideoDuration(value)}",
                  style: AppTypography.label14SM
                      .copyWith(color: AppColor.surfaceBackgroundBaseColor),
                ),
              ),
              Positioned(
                  bottom: 12,
                  left: 14,
                  right: 12,
                  child: Row(
                    children: [
                      Expanded(child: buildIndicator(value)),
                      const SizedBox(width: 12),
                      buildSpeed(),
                    ],
                  )),
            ],
          );
        });
  }

  Widget buildIndicator(VideoPlayerValue value) =>
      ValueListenableBuilder<double>(
          valueListenable: positionMiliSecond,
          builder: (_, currentValue, child) {
            return SliderTheme(
              data: SliderThemeData(
                  thumbColor: AppColor.redColor,
                  trackHeight: 7.0,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 9),
                  activeTrackColor: AppColor.redColor,
                  trackShape: CustomTrackShape()),
              child: Slider(
                min: 0,
                max: value.duration.inMilliseconds.toDouble(),
                value: value.position.inMilliseconds.toDouble(),
                onChanged: (positonValue) async {
                  positionMiliSecond.value = positonValue;
                  await widget.controller
                      .seekTo(Duration(milliseconds: positonValue.toInt()));
                  if (EveentTriggered.video_class_player_scrub != null) {
                    final DateTime now = DateTime.now();

                    final duration = VideoDetailController.getFormatPosition(
                        value.position.inMilliseconds.toDouble());
                    final duration2 =
                        VideoDetailController.getFormatPosition(positonValue);
                    DateTime dateType1 = DateFormat("HH:mm:ss").parse(duration);
                    DateTime dateType2 =
                        DateFormat("HH:mm:ss").parse(duration2);
                    DateTime newDate1 = DateTime(now.year, now.month, now.day,
                        dateType1.hour, dateType1.minute, dateType1.second);
                    DateTime newDate2 = DateTime(now.year, now.month, now.day,
                        dateType2.hour, dateType2.minute, dateType2.second);
                    EveentTriggered.video_class_player_scrub!(
                        widget.title, widget.videoUrl, newDate1, newDate2);
                  }
                  if (EveentTriggered.audio_class_player_scrub != null) {
                    final DateTime now = DateTime.now();

                    final duration = VideoDetailController.getFormatPosition(
                        value.position.inMilliseconds.toDouble());
                    final duration2 =
                        VideoDetailController.getFormatPosition(positonValue);
                    DateTime dateType1 = DateFormat("HH:mm:ss").parse(duration);
                    DateTime dateType2 =
                        DateFormat("HH:mm:ss").parse(duration2);
                    DateTime newDate1 = DateTime(now.year, now.month, now.day,
                        dateType1.hour, dateType1.minute, dateType1.second);
                    DateTime newDate2 = DateTime(now.year, now.month, now.day,
                        dateType2.hour, dateType2.minute, dateType2.second);
                    EveentTriggered.audio_class_player_scrub!(
                        widget.title, widget.videoUrl, newDate1, newDate2);
                  }
                },
              ),
            );
          });

  Widget buildSpeed() => PopupMenuButton<double>(
        initialValue: widget.controller.value.playbackSpeed,
        tooltip: 'Playback speed',
        onSelected: (value) {
          widget.controller.setPlaybackSpeed(value);
        },
        itemBuilder: (context) => allSpeeds
            .map<PopupMenuEntry<double>>((speed) => PopupMenuItem(
                  value: speed,
                  child: Text('${speed}x'),
                ))
            .toList(),
        child: Container(
          decoration: BoxDecoration(
              color: AppColor.surfaceBackgroundBaseColor,
              borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Text('${widget.controller.value.playbackSpeed}x'),
        ),
      );

  Widget playButton() {
    return widget.controller.value.isPlaying
        ? Center(
            child: IconButton(
                iconSize: 40,
                onPressed: () {
                  VideoDetailController.showControls.value = true;

                  widget.controller.pause();
                  if (EveentTriggered.video_class_player_pause != null) {
                    final DateTime now = DateTime.now();
                    final duration = VideoDetailController.getFormatPosition(
                        widget.controller.value.position.inMilliseconds
                            .toDouble());

                    DateTime dateType = DateFormat("HH:mm:ss").parse(duration);
                    DateTime newDate = DateTime(now.year, now.month, now.day,
                        dateType.hour, dateType.minute, dateType.second);

                    EveentTriggered.video_class_player_pause!(
                        widget.title, widget.videoUrl, newDate);
                  }
                  if (EveentTriggered.audio_class_player_pause != null) {
                    final DateTime now = DateTime.now();
                    final duration = VideoDetailController.getFormatPosition(
                        widget.controller.value.position.inMilliseconds
                            .toDouble());
                    DateTime dateType = DateFormat("HH:mm:ss").parse(duration);
                    DateTime newDate = DateTime(now.year, now.month, now.day,
                        dateType.hour, dateType.minute, dateType.second);
                    EveentTriggered.audio_class_player_pause!(
                        widget.title, widget.videoUrl, newDate);
                  }
                },
                icon: Icon(
                  Icons.pause,
                  color: AppColor.textInvertEmphasis,
                )))
        : Center(
            child: IconButton(
                iconSize: 40,
                onPressed: () {
                  widget.controller.play();
                  Future.delayed(
                    const Duration(milliseconds: 250),
                    () {
                      VideoDetailController.showControls.value = false;
                    },
                  );
                  if (EveentTriggered.video_class_player_pause != null) {
                    final duration = VideoDetailController.getFormatPosition(
                        widget.controller.value.position.inMilliseconds
                            .toDouble());
                    EveentTriggered.video_class_player_pause!(
                        widget.title,
                        widget.videoUrl,
                        DateFormat("HH:mm:ss").parse(duration));
                  }
                },
                icon: Icon(
                  Icons.play_arrow,
                  color: AppColor.textInvertEmphasis,
                )),
          );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
