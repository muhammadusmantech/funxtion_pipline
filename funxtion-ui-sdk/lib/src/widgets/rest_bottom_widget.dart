import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ui_tool_kit/ui_tool_kit.dart';

class RestBottomWidget extends StatelessWidget {
  final ValueNotifier<bool> isRestPlaying;
  final ValueNotifier<int> restLinear;
  final ValueNotifier<int> mainRestNotifier;
  final Timer? restTimer;
  final void Function() prevRestButtonFn;
  const RestBottomWidget(
      {super.key,
      required this.prevRestButtonFn,
      required this.isRestPlaying,
      required this.restLinear,
      required this.mainRestNotifier,
      required this.restTimer});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColor.surfaceBackgroundColor,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, bottom: 20, top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: CustomElevatedButtonWidget(
                          radius: 16,
                          btnColor: AppColor.buttonTertiaryColor,
                          onPressed: () {
                            mainRestNotifier.value = 0;
                            restTimer?.cancel();

                            prevRestButtonFn();
                          },
                          childPadding:
                              const EdgeInsets.symmetric(vertical: 16),
                          child: Text(context.loc.buttonText('previous'),
                              style: AppTypography.label16MD.copyWith(
                                  color: AppColor.buttonSecondaryColor))),
                    ),
                  ),
                  8.width(),
                  Expanded(
                    flex: 2,
                    child: ValueListenableBuilder<bool>(
                        valueListenable: isRestPlaying,
                        builder: (_, value, child) {
                          return CustomElevatedButtonWidget(
                            childPadding:
                                const EdgeInsets.only(top: 12, bottom: 12),
                            btnColor: value == true
                                ? AppColor.buttonTertiaryColor
                                : null,
                            onPressed: () {
                              isRestPlaying.value = !isRestPlaying.value;
                            },
                            child: value == true
                                ? Icon(
                                    Icons.pause,
                                    color: AppColor.buttonSecondaryColor,
                                    size: 32,
                                  )
                                : Icon(
                                    Icons.play_arrow_rounded,
                                    color: AppColor.buttonLabelColor,
                                    size: 32,
                                  ),
                          );
                        }),
                  ),
                  8.width(),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: CustomElevatedButtonWidget(
                          radius: 16,
                          childPadding:
                              const EdgeInsets.symmetric(vertical: 16),
                          onPressed: () {
                            mainRestNotifier.value = 0;
                          },
                          child: Text(
                            "Skip",
                            style: AppTypography.label16MD
                                .copyWith(color: AppColor.textInvertEmphasis),
                          )),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
