import 'package:flutter/material.dart';
import 'package:ui_tool_kit/ui_tool_kit.dart';

class LinearProgressBarWidget extends StatelessWidget {
  final ValueNotifier<bool> isSetComplete;
  final int totalRounds;
  final int currentRound;
  final ValueNotifier<int> time;
  final int totalTime;
  final Map<String, String>? goalTargetsValue;

  final bool toShowTimeProgressBar;

  const LinearProgressBarWidget(
      {super.key,
      required this.time,
      required this.totalTime,
      required this.toShowTimeProgressBar,
      required this.totalRounds,
      required this.currentRound,
      this.goalTargetsValue,
      required this.isSetComplete});

  @override
  Widget build(BuildContext context) {
    return Row(
        children: List.generate(
      totalRounds,
      (index) => Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (totalRounds > 1)
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 2, top: 2),
                  child: Text(
                    "${index + 1}",
                    style: AppTypography.title14XS.copyWith(
                        color: currentRound == index + 1
                            ? AppColor.surfaceBrandPrimaryColor
                            : AppColor.textPrimaryColor),
                  ),
                ),
              ),
            if (totalRounds == 1) 20.height(),
            if (totalRounds > 1)
              Flexible(
                child: Container(
                  height: 8,
                  margin: EdgeInsets.only(
                    top: totalRounds == 1 ? 12 : 0,
                    left: index == 0 ? 0 : 2,
                    right: index == totalRounds - 1 ? 0 : 2,
                  ),
                  child: toShowTimeProgressBar == false
                      ? RepsLinearProgressWidget(
                          currentIndex: index,
                          isSetComplete: isSetComplete,
                          currentRound: currentRound,
                        )
                      : goalTargetsValue!.entries
                              .toList()[0]
                              .key
                              .contains("sec")
                          ? TimeLinearProgressWidget(
                              time: time,
                              totalTime: totalTime,
                              currentIndex: index,
                              currentRound: currentRound,
                            )
                          : RepsLinearProgressWidget(
                              currentIndex: index,
                              isSetComplete: isSetComplete,
                              currentRound: currentRound,
                            ),
                ),
              ),
          ],
        ),
      ),
    ));
  }
}

class TimeLinearProgressWidget extends StatelessWidget {
  final int currentRound;
  final int currentIndex;
  final ValueNotifier<int> time;
  final int totalTime;
  const TimeLinearProgressWidget(
      {super.key,
      required this.time,
      required this.totalTime,
      required this.currentIndex,
      required this.currentRound});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: currentRound == currentIndex + 1
            ? time
            : currentRound >= currentIndex + 1
                ? ValueNotifier(totalTime)
                : ValueNotifier(0),
        builder: (_, value1, child) {
          return TweenAnimationBuilder(
            duration: const Duration(seconds: 1),
            tween: Tween(begin: 0.0, end: value1),
            builder: (_, value, child) => CustomSliderWidget(
              backgroundColor: AppColor.surfaceBackgroundSecondaryColor,
              valueColor: AppColor.linkSecondaryColor,
              sliderValue: value.toDouble(),
              division: totalTime,
            ),
          );
        });
  }
}
