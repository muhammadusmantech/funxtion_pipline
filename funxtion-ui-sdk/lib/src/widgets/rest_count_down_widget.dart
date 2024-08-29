import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ui_tool_kit/ui_tool_kit.dart';

class RestCountDownWidget extends StatelessWidget {
  final Timer? restTimer;
  final Widget bottomWidget;
  final ValueNotifier<int> mainRestNotifier;
  final ValueNotifier<int> restLinear;
  final int mainRest, totalRounds, currentRound;
  final String subtitle;
  const RestCountDownWidget(
      {super.key,
      required this.bottomWidget,
      required this.mainRestNotifier,
      required this.restTimer,
      required this.restLinear,
      required this.mainRest,
      required this.totalRounds,
      required this.currentRound,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: mainRestNotifier,
        builder: (_, value, child) {
          return value > 0 && restTimer?.isActive == true
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                      child: ModalBarrier(
                          dismissible: false,
                          color: Colors.black.withOpacity(0.8)),
                    ),
                    Column(children: [
                      20.height(),
                      Text(
                        "Rest",
                        style: AppTypography.title40_4XL
                            .copyWith(color: AppColor.textInvertEmphasis),
                      ),
                      SizedBox(
                        height: context.dynamicHeight * 0.09,
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 150,
                            width: 150,
                            child: ValueListenableBuilder(
                                valueListenable: restLinear,
                                builder: (_, linearValue, child) {
                                  int value1 = linearValue + 1;
                                  return TweenAnimationBuilder(
                                    duration: const Duration(seconds: 1),
                                    tween: Tween(begin: 0.0, end: value1),
                                    builder: (_, value, child) =>
                                        CircularProgressIndicator(
                                            backgroundColor: AppColor
                                                .surfaceBackgroundSecondaryColor,
                                            valueColor: AlwaysStoppedAnimation(
                                              AppColor.surfaceBrandDarkColor,
                                            ),
                                            strokeWidth: 8,
                                            value: value.toDouble() / mainRest),
                                  );
                                }),
                          ),
                          Text(
                            value.toString(),
                            style: AppTypography.title40_4XL.copyWith(
                                color:
                                    AppColor.surfaceBackgroundSecondaryColor),
                          )
                        ],
                      ),
                      40.height(),
                      Text(
                        "${context.loc.getReadyForText} ${totalRounds > 1 ? "set $currentRound of" : ""}",
                        style: AppTypography.title14XS
                            .copyWith(color: AppColor.textInvertSubtitle),
                      ),
                      10.height(),
                      Padding(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        child: Text(
                          subtitle,
                          style: AppTypography.title24XL
                              .copyWith(color: AppColor.textInvertEmphasis),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      bottomWidget
                    ]),
                  ],
                )
              : Container();
        });
  }
}
