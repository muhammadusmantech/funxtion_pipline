import 'package:flutter/material.dart';

import '../../ui_tool_kit.dart';

class DoneWorkoutSheet extends StatelessWidget {
  final String workoutName, type;
  final int totalDuration;
  final FollowTrainingPlanModel? followTrainingPlanModel;
  final Map<ExerciseDetailModel, ExerciseModel> warmUpData;
  final Map<ExerciseDetailModel, ExerciseModel> trainingData;
  final Map<ExerciseDetailModel, ExerciseModel> coolDownData;

  const DoneWorkoutSheet({
    super.key,
    required this.workoutName,
    required this.type,
    required this.totalDuration,
    required this.followTrainingPlanModel,
    required this.warmUpData,
    required this.trainingData,
    required this.coolDownData,
  });
  updateData() async {
    for (var i = 0; i < Boxes.getTrainingPlanBox().values.length; i++) {
      if (Boxes.getTrainingPlanBox().values.toList()[i].trainingPlanId ==
          followTrainingPlanModel?.trainingPlanId) {
        if (followTrainingPlanModel!.workoutCount >
            Boxes.getTrainingPlanBox().values.toList()[i].workoutCount) {
          if (Boxes.getTrainingPlanBox().values.toList()[i].outOfSequence ==
              true) {
            Boxes.getTrainingPlanBox().values.toList()[i].outOfSequence = false;
          }
          Boxes.getTrainingPlanBox().putAt(i, followTrainingPlanModel!);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.surfaceBackgroundBaseColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 30, left: 24, bottom: 20, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.grey,
                    ),
                    Text(
                      context.loc.completeText,
                      style: AppTypography.label14SM
                          .copyWith(color: AppColor.textSubTitleColor),
                    )
                  ],
                ),
                Text(
                  workoutName,
                  style: AppTypography.title28_2XL
                      .copyWith(color: AppColor.textEmphasisColor),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 31),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: BuildCardWidget(
                      checkNum: false,
                      subtitle: totalDuration.mordernDurationTextWidget,
                      title: context.loc.totalDurationText),
                ),
                20.width(),
                Expanded(
                    child: BuildCardWidget(
                        title: context.loc.typeText, subtitle: type))
              ],
            ),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            height: context.dynamicHeight * 0.065,
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
            child: CustomElevatedButtonWidget(
                radius: 16,
                btnColor: AppColor.buttonPrimaryColor,
                onPressed: () async {
                  if (followTrainingPlanModel != null) {
                    updateData();
                    await showModalBottomSheet(
                      useSafeArea: true,
                      isScrollControlled: true,
                      isDismissible: false,
                      enableDrag: false,
                      context: context,
                      builder: (context) {
                        return TrainingPlanDoneSheet(
                            followTrainingPlanModel: followTrainingPlanModel);
                      },
                    );
                  } else {
                    context.navigateToRemovedUntil(
                        const VideoAudioWorkoutListView(
                            categoryName: CategoryName.workouts));
                  }
                },
                child: Text(
                  context.loc.doneText,
                  style: AppTypography.label18LG
                      .copyWith(color: AppColor.textInvertEmphasis),
                )),
          )
        ],
      ),
    );
  }
}

class TrainingPlanDoneSheet extends StatelessWidget {
  const TrainingPlanDoneSheet({
    super.key,
    required this.followTrainingPlanModel,
  });

  final FollowTrainingPlanModel? followTrainingPlanModel;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColor.surfaceBackgroundBaseColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 30, left: 24, bottom: 20, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                followTrainingPlanModel!.workoutCount.toInt() ==
                        followTrainingPlanModel!.totalWorkoutLength.toInt()
                    ? Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.grey,
                          ),
                          Text(
                            context.loc.completeText,
                            style: AppTypography.label14SM
                                .copyWith(color: AppColor.textSubTitleColor),
                          )
                        ],
                      )
                    : Text(
                        context.loc.progressUpdateText,
                        style: AppTypography.label14SM
                            .copyWith(color: AppColor.textSubTitleColor),
                      ),
                Text(
                  followTrainingPlanModel!.trainingPlanTitle,
                  style: AppTypography.title28_2XL
                      .copyWith(color: AppColor.textEmphasisColor),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColor.surfaceBackgroundColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.loc.workoutCompletedText,
                  style: AppTypography.label14SM
                      .copyWith(color: AppColor.textSubTitleColor),
                ),
                8.height(),
                Text(
                  "${followTrainingPlanModel!.workoutCount} / ${followTrainingPlanModel!.totalWorkoutLength}",
                  style: AppTypography.title18LG
                      .copyWith(color: AppColor.textEmphasisColor),
                ),
                4.height(),
                FollowedBorderWidget(
                    color2:
                        AppColor.surfaceBrandSecondaryColor.withOpacity(0.3),
                    color: AppColor.surfaceBrandDarkColor,
                    followTrainingData: followTrainingPlanModel!)
              ],
            ),
          ),
          if (followTrainingPlanModel!.workoutCount ==
              followTrainingPlanModel!.totalWorkoutLength)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColor.surfaceBackgroundColor),
              child: Text(context.loc.completedFollowPlan),
            ),
          const Spacer(),
          Container(
            width: double.infinity,
            height: context.dynamicHeight * 0.065,
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (followTrainingPlanModel!.workoutCount ==
                    followTrainingPlanModel!.totalWorkoutLength) ...[
                  Expanded(
                    child: CustomElevatedButtonWidget(
                        radius: 16,
                        btnColor: AppColor.buttonTertiaryColor,
                        onPressed: () async {
                          FollowTrainingPlanModel newData =
                              FollowTrainingPlanModel(
                            trainingPlanId:
                                followTrainingPlanModel!.trainingPlanId,
                            workoutData: followTrainingPlanModel!.workoutData,
                            workoutCount: 0,
                            totalWorkoutLength:
                                followTrainingPlanModel!.totalWorkoutLength,
                            outOfSequence:
                                followTrainingPlanModel!.outOfSequence,
                            trainingPlanImg:
                                followTrainingPlanModel!.trainingPlanImg,
                            trainingPlanTitle:
                                followTrainingPlanModel!.trainingPlanTitle,
                          );
                          for (var i = 0;
                              i < Boxes.getTrainingPlanBox().length;
                              i++) {
                            if (Boxes.getTrainingPlanBox()
                                    .values
                                    .toList()[i]
                                    .trainingPlanId ==
                                followTrainingPlanModel!.trainingPlanId) {
                              await Boxes.getTrainingPlanBox()
                                  .putAt(i, newData);
                            }
                          }
                          if (context.mounted) {
                            context
                                .navigateToRemovedUntil(TrainingPlanDetailView(
                              id: followTrainingPlanModel!.trainingPlanId,
                            ));
                          }
                        },
                        child: Text(
                          context.loc.startAgainText,
                          style: AppTypography.label18LG
                              .copyWith(color: AppColor.buttonSecondaryColor),
                        )),
                  ),
                  20.width(),
                ],
                Expanded(
                  child: CustomElevatedButtonWidget(
                      radius: 16,
                      btnColor: AppColor.buttonPrimaryColor,
                      onPressed: () async {
                        if (followTrainingPlanModel!.workoutCount ==
                            followTrainingPlanModel!.totalWorkoutLength) {
                          for (var i = 0;
                              i < Boxes.getTrainingPlanBox().length;
                              i++) {
                            if (Boxes.getTrainingPlanBox()
                                    .values
                                    .toList()[i]
                                    .trainingPlanId ==
                                followTrainingPlanModel!.trainingPlanId) {
                              await Boxes.getTrainingPlanBox().deleteAt(i);
                            }
                          }
                          if (context.mounted) {
                            context.navigateToRemovedUntil(
                                const TrainingPlanListView(initialIndex: 0));
                          }
                        } else {
                          context.navigateToRemovedUntil(TrainingPlanDetailView(
                            id: followTrainingPlanModel!.trainingPlanId,
                          ));
                        }
                      },
                      child: Text(
                        context.loc.doneText,
                        style: AppTypography.label18LG
                            .copyWith(color: AppColor.textInvertEmphasis),
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
