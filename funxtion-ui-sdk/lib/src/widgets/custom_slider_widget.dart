import 'package:flutter/material.dart';

import '../../ui_tool_kit.dart';

class CustomSliderWidget extends StatelessWidget {
  const CustomSliderWidget(
      {super.key,
      required this.sliderValue,
      this.division,
      this.backgroundColor,
      this.valueColor});
  final int? division;
  final double sliderValue;
  final Color? backgroundColor, valueColor;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: LinearProgressIndicator(
          minHeight: 8,
          backgroundColor: backgroundColor ??
              AppColor.surfaceBrandDarkColor.withOpacity(0.1),
          valueColor: AlwaysStoppedAnimation(
            valueColor ?? AppColor.surfaceBrandDarkColor,
          ),
          value: division == null ? sliderValue : sliderValue / division!),
    );
  }
}
