import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../ui_tool_kit.dart';

class ListExerciseViewWidget extends StatelessWidget {
  final List<Map<ExerciseDetailModel, ExerciseModel>> listCurrentExerciseData;
  final ValueNotifier<bool> isPlaying;
  final String itemTypeTitle;
  final WorkoutModel workoutModel;
  final ScrollController? scrollController;
  const ListExerciseViewWidget(
      {super.key,
      required this.listCurrentExerciseData,
      required this.isPlaying,
      required this.itemTypeTitle,
      required this.workoutModel,  this.scrollController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
        padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
        shrinkWrap: true,
        itemCount: listCurrentExerciseData.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(
              top: index == 0 ? 0 : 16,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    width: 1.5, color: AppColor.borderSecondaryColor)),
            child: Stack(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: NetworkImageWidget(
                              url: listCurrentExerciseData[index]
                                  .values
                                  .first
                                  .gif
                                  .toString(),
                              height: 100,
                              width: 100)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 12, top: 12, right: 25, bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 35),
                              child: Text(
                                listCurrentExerciseData[index]
                                    .values
                                    .first
                                    .name,
                                style: AppTypography.title18LG.copyWith(
                                    color: AppColor.textEmphasisColor),
                              ),
                            ),
                            8.height(),
                            Row(
                              children: [
                                if (listCurrentExerciseData[index]
                                            .keys
                                            .first
                                            .currentGoalTargets !=
                                        null &&
                                    listCurrentExerciseData[index]
                                        .keys
                                        .first
                                        .currentGoalTargets!
                                        .isNotEmpty)
                                  TargetsContainerWidget(
                                      metric: listCurrentExerciseData[index]
                                          .keys
                                          .first
                                          .currentGoalTargets!
                                          .entries
                                          .first
                                          .key,
                                      value: listCurrentExerciseData[index]
                                          .keys
                                          .first
                                          .currentGoalTargets!
                                          .entries
                                          .first
                                          .value),
                                if (listCurrentExerciseData[index]
                                            .keys
                                            .first
                                            .currentResistanceTargets !=
                                        null &&
                                    listCurrentExerciseData[index]
                                        .keys
                                        .first
                                        .currentResistanceTargets!
                                        .isNotEmpty &&
                                    listCurrentExerciseData[index]
                                            .keys
                                            .first
                                            .currentGoalTargets !=
                                        null &&
                                    listCurrentExerciseData[index]
                                        .keys
                                        .first
                                        .currentGoalTargets!
                                        .isNotEmpty)
                                  8.width(),
                                if (listCurrentExerciseData[index]
                                            .keys
                                            .first
                                            .currentResistanceTargets !=
                                        null &&
                                    listCurrentExerciseData[index]
                                        .keys
                                        .first
                                        .currentResistanceTargets!
                                        .isNotEmpty)
                                  TargetsContainerWidget(
                                      metric: listCurrentExerciseData[index]
                                          .keys
                                          .first
                                          .currentResistanceTargets!
                                          .entries
                                          .first
                                          .key,
                                      value: listCurrentExerciseData[index]
                                          .keys
                                          .first
                                          .currentResistanceTargets!
                                          .entries
                                          .first
                                          .value)
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  height: 26,
                  width: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(8)),
                      border: Border(
                          right: BorderSide(
                              width: 1.5, color: AppColor.borderSecondaryColor),
                          bottom: BorderSide(
                              width: 1.5,
                              color: AppColor.borderSecondaryColor))),
                  child: Text(
                    "${index + 1}",
                    style: AppTypography.title14XS
                        .copyWith(color: AppColor.textSubTitleColor),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: InkWell(
                      onTap: () async {
                        isPlaying.value = false;
                        if (EveentTriggered.workout_player_exercise_info !=
                            null) {
                          EveentTriggered.workout_player_exercise_info!(
                              listCurrentExerciseData
                                  .map(
                                    (e) => e.values.first.name,
                                  )
                                  .join(','),
                              listCurrentExerciseData
                                  .map(
                                    (e) => e.values.first.id,
                                  )
                                  .join(','),
                              itemTypeTitle,
                              workoutModel.title.toString());
                        }
                        await showModalBottomSheet(
                          backgroundColor: AppColor.surfaceBackgroundColor,
                          useSafeArea: true,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => PopScope(
                            onPopInvoked: (didPop) {
                              isPlaying.value = true;
                            },
                            child: DetailWorkoutBottomSheet(
                              itemType: itemTypeTitle.convertStringToItemType,
                              id: listCurrentExerciseData[index]
                                  .values
                                  .first
                                  .id,
                              exerciseDetailModel:
                                  listCurrentExerciseData[index].keys.first,
                            ),
                          ),
                        );
                      },
                      child: SvgPicture.asset(
                        AppAssets.infoIcon,
                        color: AppColor.textEmphasisColor,
                      )),
                )
              ],
            ),
          );
        });
  }
}
