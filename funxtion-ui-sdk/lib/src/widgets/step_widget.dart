
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ui_tool_kit/ui_tool_kit.dart';

class StepWidget extends StatelessWidget {
  final bool isActive;
  final bool isCompleted;
  const StepWidget({
    super.key,
    this.isActive = false,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? AppColor.textInvertEmphasis
                    : isCompleted
                        ? AppColor.borderBrandDarkColor
                        : AppColor.borderSecondaryColor,
                border: Border.all(
                    color: isActive
                        ? AppColor.borderBrandDarkColor
                        : isCompleted
                            ? AppColor.borderBrandDarkColor
                            : AppColor.borderSecondaryColor,
                    width: 2)),
            child: isCompleted
                ? SvgPicture.asset(
                    AppAssets.checkMarkIcon,
                  )
                : null),
      ],
    );
  }
}
