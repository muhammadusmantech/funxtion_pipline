import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ui_tool_kit/ui_tool_kit.dart';

class GetReadyCountDownWidget extends StatelessWidget {
  final Timer? everyTimeExerciseTimer;
  final ValueNotifier<int> secondsCountDown;
  final String title, subTitle;
  const GetReadyCountDownWidget(
      {super.key,
      required this.secondsCountDown,
      required this.title,
      required this.subTitle,
      required this.everyTimeExerciseTimer});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: secondsCountDown,
        builder: (_, value, child) {
          return value > 0 && everyTimeExerciseTimer?.isActive == true
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                      child: ModalBarrier(
                          dismissible: false,
                          color: Colors.black.withOpacity(0.8)),
                    ),
                    Column(
                      children: [
                        20.height(),
                        Text(
                          context.loc.getReadyText,
                          style: AppTypography.title40_4XL
                              .copyWith(color: AppColor.textInvertEmphasis),
                        ),
                        SizedBox(
                          height: context.dynamicHeight * 0.1,
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 150,
                              width: 150,
                              child: TweenAnimationBuilder(
                                duration: const Duration(seconds: 5),
                                tween: Tween(begin: 0.0, end: 1),
                                builder: (_, value, child) =>
                                    CircularProgressIndicator(
                                        backgroundColor: AppColor
                                            .surfaceBackgroundSecondaryColor,
                                        valueColor: AlwaysStoppedAnimation(
                                          AppColor.surfaceBrandDarkColor,
                                        ),
                                        strokeWidth: 8,
                                        value: value.toDouble()),
                              ),
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
                          title,
                          style: AppTypography.title14XS
                              .copyWith(color: AppColor.textInvertSubtitle),
                        ),
                        10.height(),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            subTitle,
                            style: AppTypography.title24XL
                                .copyWith(color: AppColor.textInvertEmphasis),
                            maxLines: 7,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Container();
        });
  }
}
