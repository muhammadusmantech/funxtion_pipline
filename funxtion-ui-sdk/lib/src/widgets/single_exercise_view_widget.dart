import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ui_tool_kit/ui_tool_kit.dart';

class SingleExerciseViewWidget extends StatelessWidget {
  final Map<ExerciseDetailModel, ExerciseModel> currentExerciseData;
  final ValueNotifier<bool> isPlaying;
  final String itemTypeTitle;
  final WorkoutModel workoutModel;
  final String mainNotes, exerciseNotes;
  final bool isShowGoalTarget;
  const SingleExerciseViewWidget(
      {super.key,
      required this.currentExerciseData,
      required this.isPlaying,
      required this.itemTypeTitle,
      required this.workoutModel,
      required this.mainNotes,
      required this.exerciseNotes,
      this.isShowGoalTarget = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: ValueListenableBuilder<bool>(
              valueListenable: isPlaying,
              builder: (_, value, child) {
                return value == true
                    ? Container(
                        margin: const EdgeInsets.only(
                            left: 45, right: 45, top: 8, bottom: 16),
                        child: NetworkImageWidget(
                            url:
                                currentExerciseData.values.first.gif.toString(),
                            height: 200,
                            width: context.dynamicWidth.toInt()))
                    : Container(
                        foregroundDecoration: value == false
                            ? const BoxDecoration(
                                color: Colors.grey,
                                backgroundBlendMode: BlendMode.saturation,
                              )
                            : null,
                        margin: const EdgeInsets.only(
                            left: 45, right: 45, top: 8, bottom: 16),
                        child: NetworkImageWidget(
                            url: currentExerciseData.values.first.image
                                .toString(),
                            height: 200,
                            width: context.dynamicWidth.toInt()),
                      );
              }),
        ),
        Padding(
          padding:
              currentExerciseData.keys.first.currentResistanceTargets != null &&
                          currentExerciseData.keys.first
                              .currentResistanceTargets!.isNotEmpty &&
                          mainNotes == "" ||
                      exerciseNotes == ""
                  ? EdgeInsets.only(
                      bottom: context.dynamicHeight * 0.001,
                      left: 20,
                      right: 20)
                  : currentExerciseData.keys.first.currentResistanceTargets ==
                                  null &&
                              currentExerciseData.keys.first
                                  .currentResistanceTargets!.isEmpty &&
                              mainNotes != "" ||
                          exerciseNotes != ""
                      ? const EdgeInsets.only(bottom: 87, left: 20, right: 20)
                      : const EdgeInsets.only(bottom: 90, left: 20, right: 20),
          child: FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentExerciseData.values.first.name,
                  style: AppTypography.title24XL
                      .copyWith(color: AppColor.textEmphasisColor),
                ),
                8.width(),
                InkWell(
                    onTap: () async {
                      isPlaying.value = false;
                      if (EveentTriggered.workout_player_exercise_info !=
                          null) {
                        EveentTriggered.workout_player_exercise_info!(
                            currentExerciseData.values.first.name.toString(),
                            currentExerciseData.values.first.id.toString(),
                            itemTypeTitle,
                            workoutModel.title.toString());
                      }
                      await showModalBottomSheet(
                        backgroundColor: AppColor.surfaceBackgroundColor,
                        useSafeArea: true,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => PopScope(
                          onPopInvoked: (didPop) => isPlaying.value = true,
                          child: DetailWorkoutBottomSheet(
                              itemType: itemTypeTitle.convertStringToItemType,
                              id: currentExerciseData.values.first.id,
                              exerciseDetailModel:
                                  currentExerciseData.keys.first),
                        ),
                      );
                    },
                    child: SvgPicture.asset(
                      AppAssets.infoIcon,
                      color: AppColor.textEmphasisColor,
                    ))
              ],
            ),
          ),
        ),
        if (isShowGoalTarget &&
            (currentExerciseData.keys.first.currentGoalTargets?.isNotEmpty ==
                    true ||
                currentExerciseData
                        .keys.first.currentResistanceTargets?.isNotEmpty ==
                    true))
          Padding(
              padding: EdgeInsets.only(
                  top: 8,
                  bottom: mainNotes != "" || exerciseNotes != "" ? 0 : 100),
              child: Wrap(
                children: [
                  Wrap(
                      children: currentExerciseData
                          .keys.first.currentGoalTargets!.entries
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: TargetsContainerWidget(
                                isSingleExercise: true,
                                metric: e.key,
                                value: e.value,
                              ),
                            ),
                          )
                          .toList()),
                  Wrap(
                      children: currentExerciseData.keys.first
                                  .currentResistanceTargets!.entries.length >
                              2
                          ? currentExerciseData
                              .keys.first.currentResistanceTargets!.entries
                              .toList()
                              .sublist(0, 2)
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: TargetsContainerWidget(
                                    isSingleExercise: true,
                                    metric: e.key,
                                    value: e.value,
                                  ),
                                ),
                              )
                              .toList()
                          : currentExerciseData
                              .keys.first.currentResistanceTargets!.entries
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: TargetsContainerWidget(
                                    isSingleExercise: true,
                                    metric: e.key,
                                    value: e.value,
                                  ),
                                ),
                              )
                              .toList()),
                ],
              )),
        if (isShowGoalTarget == false &&
            (currentExerciseData.keys.first.currentGoalTargets?.isNotEmpty ==
                    true ||
                currentExerciseData
                        .keys.first.currentResistanceTargets?.isNotEmpty ==
                    true))
          Padding(
            padding: EdgeInsets.only(
                top: 8,
                bottom: mainNotes != "" || exerciseNotes != "" ? 0 : 100),
            child: Wrap(
                children: currentExerciseData.keys.first
                            .currentResistanceTargets!.entries.length >
                        2
                    ? currentExerciseData
                        .keys.first.currentResistanceTargets!.entries
                        .toList()
                        .sublist(0, 2)
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: TargetsContainerWidget(
                              isSingleExercise: true,
                              metric: e.key,
                              value: e.value,
                            ),
                          ),
                        )
                        .toList()
                    : currentExerciseData
                        .keys.first.currentResistanceTargets!.entries
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: TargetsContainerWidget(
                              isSingleExercise: true,
                              metric: e.key,
                              value: e.value,
                            ),
                          ),
                        )
                        .toList()),
          ),
      ],
    );
  }
}
