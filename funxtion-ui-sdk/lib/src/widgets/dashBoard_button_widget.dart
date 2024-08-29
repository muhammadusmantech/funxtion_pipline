import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../ui_tool_kit.dart';

class DashBoardButtonWidget extends StatelessWidget {
  final String text;
  final int index;
  const DashBoardButtonWidget(
      {super.key, required this.text, required this.index});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomElevatedButtonWidget(
          childPadding: const EdgeInsets.symmetric(vertical: 12),
          elevation: 0,
          btnColor: AppColor.buttonTertiaryColor,
          onPressed: () {
            index == 1
                ? context.navigateTo(const VideoAudioWorkoutListView(
                    categoryName: CategoryName.videoClasses))
                : index == 2
                    ? context.navigateTo(const VideoAudioWorkoutListView(
                        categoryName: CategoryName.workouts))
                    : index == 3
                        ? context.navigateTo(const TrainingPlanListView(
                            initialIndex: 0,
                          ))
                        : context.navigateTo(const VideoAudioWorkoutListView(
                            categoryName: CategoryName.audioClasses));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                index == 1
                    ? AppAssets.videoPlayIcon
                    : index == 2
                        ? AppAssets.workoutHeaderIcon
                        : index == 3
                            ? AppAssets.calendarIcon
                            : AppAssets.headPhoneIcon,
                color: AppColor.buttonSecondaryColor,
              ),
              4.width(),
              Flexible(
                child: FittedBox(
                  child: Text(
                    text,
                    style: AppTypography.label14SM
                        .copyWith(color: AppColor.buttonSecondaryColor),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
