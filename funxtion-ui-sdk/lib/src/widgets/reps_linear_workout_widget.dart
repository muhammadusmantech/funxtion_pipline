import 'package:flutter/material.dart';

import '../../ui_tool_kit.dart';

class RepsLinearProgressWidget extends StatelessWidget {
  final int currentRound;
  final ValueNotifier<bool> isSetComplete;
  final int currentIndex;

  const RepsLinearProgressWidget(
      {super.key,
      required this.currentIndex,
      required this.isSetComplete,
      required this.currentRound});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: isSetComplete,
        builder: (_, value, child) {
          return CustomSliderWidget(
            valueColor: currentIndex + 1 <= currentRound
                ? AppColor.linkSecondaryColor
                : AppColor.surfaceBackgroundSecondaryColor,
            sliderValue: currentIndex + 1.toDouble(),
            division: value == true
                ? currentIndex + 1
                : currentIndex + 1 < currentRound
                    ? null
                    : (currentIndex + 1) * 2,
          );
        });
  }
}
