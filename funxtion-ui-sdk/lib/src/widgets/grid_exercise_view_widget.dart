import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../ui_tool_kit.dart';

class GridExerciseView extends StatelessWidget {
  final List<Map<ExerciseDetailModel, ExerciseModel>> listCurrentExerciseData;
  final ValueNotifier<bool> isPlaying;
  final String itemTypeTitle;
  final WorkoutModel workoutModel;
  const GridExerciseView(
      {super.key,
      required this.listCurrentExerciseData,
      required this.isPlaying,
    required this.itemTypeTitle,
      required this.workoutModel});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: listCurrentExerciseData.length,
      shrinkWrap: true,
      padding: const EdgeInsets.only(left: 22, right: 22, top: 8, bottom: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(width: 1.5, color: AppColor.borderSecondaryColor)),
          child: Stack(
            children: [
              Column(
                children: [
                  Flexible(
                      flex: 3,
                      child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: NetworkImageWidget(
                              url: listCurrentExerciseData[index]
                                  .values
                                  .first
                                  .gif
                                  .toString(),
                              height: 100,
                              width: 100))),
                  4.height(),
                  Flexible(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(left: 12, right: 12),
                      child: Text(
                        listCurrentExerciseData[index].values.first.name,
                        style: AppTypography.title18LG
                            .copyWith(color: AppColor.textEmphasisColor),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
              8.height(),
              Positioned(
                top: 0,
                bottom: 0,
                left: 12,
                right: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            .value,
                      ),
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
                            .value,
                      )
                  ],
                ),
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
                            width: 1.5, color: AppColor.borderSecondaryColor))),
                child: Text(
                  "${index + 1}",
                  style: AppTypography.title14XS
                      .copyWith(color: AppColor.textSubTitleColor),
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: SizedBox(
                  height: 14,
                  width: 14,
                  child: InkWell(
                      onTap: () async {
                        isPlaying.value = false;
                        if (EveentTriggered.workout_player_exercise_info !=
                            null) {
                          EveentTriggered.workout_player_exercise_info!(
                              listCurrentExerciseData
                                  .map((e) => e.values.first.name)
                                  .join(',')
                                  .toString(),
                              listCurrentExerciseData
                                  .map((e) => e..values.first.id)
                                  .join(',')
                                  .toString(),
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
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
