import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../ui_tool_kit.dart';

class PlayButtonWidget extends StatelessWidget {
  const PlayButtonWidget({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: CustomElevatedButtonWidget(
          onPressed: onPressed,
          child: FittedBox(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  AppAssets.playArrowIcon,
                  color: AppColor.textInvertEmphasis,
                ),
                5.width(),
                Text(
                  context.loc.buttonText("play"),
                  style: AppTypography.label18LG
                      .copyWith(color: AppColor.textInvertEmphasis),
                )
              ],
            ),
          )),
    );
  }
}

class StartWorkoutButtonWidget extends StatelessWidget {
  const StartWorkoutButtonWidget(
      {super.key,
      required this.onPressed,
      required this.btnChild,
      this.btnColor});

  final VoidCallback? onPressed;
  final Widget btnChild;
  final Color? btnColor;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: CustomElevatedButtonWidget(
          elevation: 0,
          btnColor: btnColor ?? AppColor.buttonTertiaryColor,
          onPressed: onPressed,
          child: FittedBox(child: btnChild)),
    );
  }
}

class ScheduletButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Widget? child;
  const ScheduletButtonWidget(
      {super.key, this.onPressed, required this.text, this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: CustomElevatedButtonWidget(
          elevation: 0,
          btnColor: AppColor.buttonPrimaryColor,
          onPressed: onPressed,
          child: FittedBox(
            child: child ??
                Text(
                  text.toString(),
                  style: AppTypography.label16MD
                      .copyWith(color: AppColor.textInvertEmphasis),
                ),
          )),
    );
  }
}
