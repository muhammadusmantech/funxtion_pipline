import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../ui_tool_kit.dart';

class BuildExercisesBodyWidget extends StatelessWidget {
  BuildExercisesBodyWidget({
    super.key,
    required this.currentListData,
    this.goHereTap,
    this.showTrailing = false,
    required this.expandHeaderValueListenable,
    required this.loaderValueListenable,
    required this.ctExpandNew,
    required this.crExpandNew,
    required this.seExpandNew,
    required this.rftExpandNew,
    required this.ssExpandNew,
    required this.amrapExpandNew,
    required this.emomExpandNew,
    this.isSSWorkoutCompleted,
    this.isRFTWorkoutCompleted,
    this.isAMRAPWorkoutCompleted,
  });
  final Map<ExerciseDetailModel, ExerciseModel> currentListData;
  final bool? isSSWorkoutCompleted;
  final bool? isRFTWorkoutCompleted;
  final bool? isAMRAPWorkoutCompleted;

  final ValueNotifier<bool> loaderValueListenable;

  final bool showTrailing;

  final ValueNotifier<bool> expandHeaderValueListenable;
  final void Function(int)? goHereTap;

  final ValueNotifier<bool> ctExpandNew;
  final ValueNotifier<bool> crExpandNew;
  final ValueNotifier<bool> seExpandNew;
  final ValueNotifier<bool> rftExpandNew;
  final ValueNotifier<bool> ssExpandNew;
  final ValueNotifier<bool> amrapExpandNew;
  final ValueNotifier<bool> emomExpandNew;

  Map<ExerciseDetailModel, ExerciseModel> seExercise = {};

  Map<ExerciseDetailModel, ExerciseModel> circuitTimeExercise = {};

  Map<ExerciseDetailModel, ExerciseModel> rftExercise = {};

  Map<ExerciseDetailModel, ExerciseModel> ssExercise = {};

  Map<ExerciseDetailModel, ExerciseModel> circuitRepExercise = {};

  Map<ExerciseDetailModel, ExerciseModel> amrapExercise = {};

  Map<ExerciseDetailModel, ExerciseModel> emomExercise = {};

  addData() {
    for (var element in currentListData.entries) {
      if (element.key.exerciseCategoryName == ItemType.circuitTime) {
        circuitTimeExercise.addEntries({element});
      }
      if (element.key.exerciseCategoryName == ItemType.rft) {
        rftExercise.addEntries({element});
      }
      if (element.key.exerciseCategoryName == ItemType.singleExercise) {
        seExercise.addEntries({element});
      }
      if (element.key.exerciseCategoryName == ItemType.superSet) {
        ssExercise.addEntries({element});
      }
      if (element.key.exerciseCategoryName == ItemType.amrap) {
        amrapExercise.addEntries({element});
      }
      if (element.key.exerciseCategoryName == ItemType.circuitRep) {
        circuitRepExercise.addEntries({element});
      }
      if (element.key.exerciseCategoryName == ItemType.emom) {
        emomExercise.addEntries({element});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 0, right: 20),
      color: AppColor.surfaceBackgroundColor,
      child: ValueListenableBuilder(
          valueListenable: expandHeaderValueListenable,
          builder: (_, value, child) {
            return ExpandedSection(
              expand: value,
              child: ValueListenableBuilder(
                valueListenable: loaderValueListenable,
                builder: (_, value, child) {
                  return value == true
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: BaseHelper.loadingWidget(),
                          ),
                        )
                      : currentListData.isEmpty
                          ? const Center(
                              child: Text('No Data'),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(0),
                              itemCount: currentListData.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  addData();
                                }

                                return currentListData.keys
                                            .toList()[index]
                                            .exerciseCategoryName ==
                                        ItemType.circuitTime
                                    ? Column(
                                        children: [
                                          header2CheckWidget(
                                              index: index,
                                              expandVar: ctExpandNew),
                                          ValueListenableBuilder<bool>(
                                              valueListenable: ctExpandNew,
                                              builder: (_, value, child) {
                                                return ExpandedSection(
                                                  expand: value,
                                                  child: Column(children: [
                                                    roundCheckWidget(index),
                                                    showExerciseTileWidget(
                                                      context,
                                                      index,
                                                    ),
                                                    cutomDiviDerWidget(index)
                                                  ]),
                                                );
                                              })
                                        ],
                                      )
                                    : currentListData.keys
                                                .toList()[index]
                                                .exerciseCategoryName ==
                                            ItemType.singleExercise
                                        ? Column(
                                            children: [
                                              header2CheckWidget(
                                                index: index,
                                              ),
                                              Column(children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 12),
                                                  child: showExerciseTileWidget(
                                                    context,
                                                    index,
                                                  ),
                                                ),
                                                cutomDiviDerWidget(index)
                                              ])
                                            ],
                                          )
                                        : currentListData.keys
                                                    .toList()[index]
                                                    .exerciseCategoryName ==
                                                ItemType.superSet
                                            ? Column(
                                                children: [
                                                  header2CheckWidget(
                                                      index: index,
                                                      expandVar: ssExpandNew),
                                                  ValueListenableBuilder<bool>(
                                                      valueListenable:
                                                          ssExpandNew,
                                                      builder:
                                                          (_, value, child) {
                                                        return ExpandedSection(
                                                            expand: value,
                                                            child:
                                                                repetationStackWidget(
                                                              index,
                                                              ItemType.superSet,
                                                              ssExercise.length,
                                                              isSSWorkoutCompleted ==
                                                                      true
                                                                  ? AppColor
                                                                      .textEmphasisColor
                                                                  : isSSWorkoutCompleted ==
                                                                          false
                                                                      ? AppColor
                                                                          .borderSecondaryColor
                                                                      : AppColor
                                                                          .textSubTitleColor,
                                                            ));
                                                      }),
                                                ],
                                              )
                                            : currentListData.keys
                                                        .toList()[index]
                                                        .exerciseCategoryName ==
                                                    ItemType.circuitRep
                                                ? Column(
                                                    children: [
                                                      header2CheckWidget(
                                                          index: index,
                                                          expandVar:
                                                              crExpandNew),
                                                      ValueListenableBuilder<
                                                              bool>(
                                                          valueListenable:
                                                              crExpandNew,
                                                          builder: (_, value,
                                                              child) {
                                                            return ExpandedSection(
                                                              expand: value,
                                                              child: Column(
                                                                  children: [
                                                                    roundCheckWidget(
                                                                        index),
                                                                    showExerciseTileWidget(
                                                                      context,
                                                                      index,
                                                                    ),
                                                                    cutomDiviDerWidget(
                                                                        index)
                                                                  ]),
                                                            );
                                                          })
                                                    ],
                                                  )
                                                : currentListData.keys
                                                            .toList()[index]
                                                            .exerciseCategoryName ==
                                                        ItemType.rft
                                                    ? Column(
                                                        children: [
                                                          header2CheckWidget(
                                                              index: index,
                                                              expandVar:
                                                                  rftExpandNew),
                                                          ValueListenableBuilder<
                                                                  bool>(
                                                              valueListenable:
                                                                  rftExpandNew,
                                                              builder: (_,
                                                                  value,
                                                                  child) {
                                                                return ExpandedSection(
                                                                  expand: value,
                                                                  child:
                                                                      repetationStackWidget(
                                                                    index,
                                                                    ItemType
                                                                        .rft,
                                                                    rftExercise
                                                                        .length,
                                                                    isRFTWorkoutCompleted ==
                                                                            true
                                                                        ? AppColor
                                                                            .textEmphasisColor
                                                                        : isRFTWorkoutCompleted ==
                                                                                false
                                                                            ? AppColor.borderSecondaryColor
                                                                            : AppColor.textSubTitleColor,
                                                                  ),
                                                                );
                                                              })
                                                        ],
                                                      )
                                                    : currentListData.keys
                                                                .toList()[index]
                                                                .exerciseCategoryName ==
                                                            ItemType.emom
                                                        ? Column(
                                                            children: [
                                                              header2CheckWidget(
                                                                  index: index,
                                                                  expandVar:
                                                                      emomExpandNew),
                                                              ValueListenableBuilder<
                                                                      bool>(
                                                                  valueListenable:
                                                                      emomExpandNew,
                                                                  builder: (_,
                                                                      value,
                                                                      child) {
                                                                    return ExpandedSection(
                                                                      expand:
                                                                          value,
                                                                      child: Column(
                                                                          children: [
                                                                            roundCheckWidget(index),
                                                                            showExerciseTileWidget(
                                                                              context,
                                                                              index,
                                                                            ),
                                                                            cutomDiviDerWidget(index)
                                                                          ]),
                                                                    );
                                                                  })
                                                            ],
                                                          )
                                                        : currentListData.keys
                                                                    .toList()[
                                                                        index]
                                                                    .exerciseCategoryName ==
                                                                ItemType.amrap
                                                            ? Column(
                                                                children: [
                                                                  header2CheckWidget(
                                                                      index:
                                                                          index,
                                                                      expandVar:
                                                                          amrapExpandNew),
                                                                  ValueListenableBuilder<
                                                                          bool>(
                                                                      valueListenable:
                                                                          amrapExpandNew,
                                                                      builder: (_,
                                                                          value,
                                                                          child) {
                                                                        return ExpandedSection(
                                                                          expand:
                                                                              value,
                                                                          child:
                                                                              repetationStackWidget(
                                                                            index,
                                                                            ItemType.amrap,
                                                                            amrapExercise.length,
                                                                            isAMRAPWorkoutCompleted == true
                                                                                ? AppColor.textEmphasisColor
                                                                                : isAMRAPWorkoutCompleted == false
                                                                                    ? AppColor.borderSecondaryColor
                                                                                    : AppColor.textSubTitleColor,
                                                                          ),
                                                                        );
                                                                      }),
                                                                ],
                                                              )
                                                            : Container();
                              });
                },
              ),
            );
          }),
    );
  }

  LayoutBuilder repetationStackWidget(
      int index, ItemType type, int length, Color svgColor) {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: EdgeInsets.only(left: goHereTap != null ? 16 : 20),
        child: Stack(clipBehavior: Clip.none, children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: showExerciseTileWidget(
                  context,
                  index,
                ),
              ),
              cutomDiviDerWidget(index)
            ]),
          ),
          Positioned(
              top: currentListData.entries.toList()[index].key.exerciseNo == 0
                  ? constraints.minHeight + 35
                  : 0,
              left: constraints.minHeight + 45,
              bottom: currentListData.entries.toList()[index].key.exerciseNo ==
                      length - 1
                  ? constraints.minHeight + 30
                  : 0,
              child: Stack(
                children: [
                  if (currentListData.entries.toList()[index].key.exerciseNo ==
                      0)
                    Transform.translate(
                      offset: Offset(constraints.minWidth - 22,
                          constraints.minHeight - 15),
                      child: SizedBox(
                        height: 25,
                        width: 37,
                        child: SvgPicture.asset(AppAssets.endIcon,
                            color: svgColor),
                      ),
                    ),
                  if (currentListData.entries.toList()[index].key.exerciseNo ==
                      length - 1)
                    Transform.translate(
                      offset: Offset(
                          constraints.minWidth - 23,
                          length == 1
                              ? constraints.minHeight + 30
                              : constraints.minHeight + 70),
                      child: Transform.rotate(
                        angle: 180 * math.pi / 180,
                        child: SizedBox(
                          height: 26,
                          width: 26,
                          child: SvgPicture.asset(AppAssets.arrowIcon,
                              color: svgColor),
                        ),
                      ),
                    ),
                  Container(
                    height: currentListData.entries
                                .toList()[index]
                                .key
                                .exerciseNo ==
                            length - 1
                        ? 75
                        : null,
                    decoration: BoxDecoration(color: svgColor),
                    width: 3,
                  ),
                ],
              )),
          Positioned(
              top: currentListData.entries.toList()[index].key.exerciseNo == 0
                  ? constraints.minHeight + 45
                  : 0,
              left: constraints.minHeight + 2,
              bottom: currentListData.entries.toList()[index].key.exerciseNo ==
                      length - 1
                  ? constraints.minHeight + 30
                  : 0,
              child: Stack(
                children: [
                  if (currentListData.entries.toList()[index].key.exerciseNo ==
                      0)
                    Transform.translate(
                      offset: Offset(constraints.minWidth - 0.2,
                          constraints.minHeight - 26),
                      child: SizedBox(
                        height: 26,
                        width: 26,
                        child: SvgPicture.asset(AppAssets.arrowIcon,
                            color: svgColor),
                      ),
                    ),
                  if (currentListData.entries.toList()[index].key.exerciseNo ==
                      length - 1)
                    Transform.translate(
                      offset: Offset(
                          constraints.minWidth - 5.5,
                          length == 1
                              ? constraints.minHeight + 17
                              : constraints.minHeight + 67),
                      child: Transform.rotate(
                        angle: 180 * math.pi / 180,
                        child: SizedBox(
                          height: 26,
                          width: 26,
                          child: SvgPicture.asset(AppAssets.endIcon,
                              color: svgColor),
                        ),
                      ),
                    ),
                  Container(
                    height: currentListData.entries
                                .toList()[index]
                                .key
                                .exerciseNo ==
                            length - 1
                        ? 75
                        : null,
                    decoration: BoxDecoration(color: svgColor),
                    width: 3,
                  ),
                ],
              )),
          if (currentListData.entries.toList()[index].key.exerciseNo == 0 &&
              type != ItemType.amrap)
            Positioned(
              top: constraints.minHeight + 37,
              left: constraints.minHeight + 20,
              child: Text(
                type == ItemType.rft
                    ? currentListData.entries
                        .toList()[index]
                        .key
                        .rftRounds
                        .toString()
                    : currentListData.entries
                        .toList()[index]
                        .key
                        .mainSets
                        .toString(),
                style: AppTypography.label14SM.copyWith(color: svgColor),
              ),
            ),
          Positioned(
              top: constraints.minHeight + 50,
              left: constraints.minWidth + 39,
              child: Container(
                height: 16,
                width: 16,
                decoration:
                    BoxDecoration(color: svgColor, shape: BoxShape.circle),
              )),
        ]),
      );
    });
  }

  header2CheckWidget({required int index, ValueNotifier<bool>? expandVar}) {
    return index == 0
        ? Padding(
            padding: const EdgeInsets.only(left: 20),
            child: BuildHeader2(
                subtitle: currentListData.header2SubTitle(
                  index: index,
                  amrapExercise: amrapExercise,
                  circuitRepExercise: circuitRepExercise,
                  circuitTimeExercise: circuitTimeExercise,
                  emomExercise: emomExercise,
                  rftExercise: rftExercise,
                  seExercise: seExercise,
                  ssExercise: ssExercise,
                ),
                expandValueListenable: expandVar,
                exerciseWorkoutData: WorkoutDetailController.addCurrentList(
                    index, currentListData),
                title: currentListData.keys
                    .toList()[index]
                    .exerciseCategoryName
                    .itemTypeTitleFn(),
                onExpand: () {
                  expandVar?.value = !expandVar.value;
                }),
          )
        : index <= currentListData.length - 1
            ? currentListData.entries
                        .toList()[index]
                        .key
                        .exerciseCategoryName !=
                    currentListData.entries
                        .toList()[index - 1]
                        .key
                        .exerciseCategoryName
                ? Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: BuildHeader2(
                        subtitle: currentListData.header2SubTitle(
                          index: index,
                          amrapExercise: amrapExercise,
                          circuitRepExercise: circuitRepExercise,
                          circuitTimeExercise: circuitTimeExercise,
                          emomExercise: emomExercise,
                          rftExercise: rftExercise,
                          seExercise: seExercise,
                          ssExercise: ssExercise,
                        ),
                        expandValueListenable: expandVar,
                        exerciseWorkoutData:
                            WorkoutDetailController.addCurrentList(
                                index, currentListData),
                        title: currentListData.keys
                            .toList()[index]
                            .exerciseCategoryName
                            .itemTypeTitleFn(),
                        onExpand: () {
                          expandVar?.value = !expandVar.value;
                        }),
                  )
                : Container()
            : Container();
  }

  StatelessWidget roundCheckWidget(int i) {
    if (i == 0) {
      return RoundWidget(
        i: i,
        listData: currentListData,
      );
    } else if (i <= currentListData.length - 1) {
      if (ItemType.emom ==
          currentListData.entries.toList()[i].key.exerciseCategoryName) {
        if (currentListData.entries.toList()[i].key.emomMinute !=
            currentListData.entries.toList()[i - 1].key.emomMinute) {
          return RoundWidget(
            i: i,
            listData: currentListData,
          );
        } else {
          return Container();
        }
      } else {
        if (currentListData.entries.toList()[i].key.exerciseCategoryName ==
            currentListData.entries.toList()[i - 1].key.exerciseCategoryName) {
          if (currentListData.entries.toList()[i].key.setsCount !=
              currentListData.entries.toList()[i - 1].key.setsCount) {
            return RoundWidget(
              i: i,
              listData: currentListData,
            );
          } else {
            return Container();
          }
        } else {
          return RoundWidget(
            i: i,
            listData: currentListData,
          );
        }
      }
    } else {
      return Container();
    }
  }

  Widget cutomDiviDerWidget(int i) {
    if (i == 0) {
      if (currentListData.entries.toList()[i].key.exerciseCategoryName ==
          ItemType.emom) {
        if (currentListData.entries.toList()[i].key.emomMinute ==
                currentListData.entries.toList()[i + 1].key.emomMinute ||
            currentListData.entries.toList()[i].key.exerciseCategoryName !=
                currentListData.entries
                    .toList()[i + 1]
                    .key
                    .exerciseCategoryName) {
          return const Padding(
              padding: EdgeInsets.only(top: 12, bottom: 12),
              child: CustomDividerWidget(
                indent: 145,
              ));
        } else {
          return Container();
        }
      } else {
        if (i != currentListData.length - 1) {
          return Padding(
              padding: EdgeInsets.only(
                  top: 12,
                  bottom: currentListData.entries
                                  .toList()[i]
                                  .key
                                  .exerciseCategoryName ==
                              ItemType.superSet ||
                          currentListData.entries
                                  .toList()[i]
                                  .key
                                  .exerciseCategoryName ==
                              ItemType.singleExercise
                      ? 0
                      : 12),
              child: const CustomDividerWidget(
                indent: 145,
              ));
        } else {
          return Container();
        }
      }
    } else if (i < currentListData.length - 1) {
      if (currentListData.entries.toList()[i].key.exerciseCategoryName ==
              ItemType.circuitTime ||
          currentListData.entries.toList()[i].key.exerciseCategoryName ==
              ItemType.circuitRep ||
          currentListData.entries.toList()[i].key.exerciseCategoryName ==
              ItemType.rft ||
          currentListData.entries.toList()[i].key.exerciseCategoryName ==
              ItemType.amrap ||
          currentListData.entries.toList()[i].key.exerciseCategoryName ==
              ItemType.superSet) {
        if (currentListData.entries.toList()[i + 1].key.setsCount ==
                currentListData.entries.toList()[i].key.setsCount ||
            currentListData.entries.toList()[i].key.exerciseCategoryName !=
                currentListData.entries
                    .toList()[i + 1]
                    .key
                    .exerciseCategoryName) {
          return const Padding(
              padding: EdgeInsets.only(top: 12, bottom: 12),
              child: CustomDividerWidget(
                indent: 145,
              ));
        } else {
          return Container();
        }
      } else if (currentListData.entries.toList()[i].key.exerciseCategoryName ==
          ItemType.emom) {
        if (currentListData.entries.toList()[i + 1].key.emomMinute ==
                currentListData.entries.toList()[i].key.emomMinute ||
            currentListData.entries.toList()[i].key.exerciseCategoryName !=
                currentListData.entries
                    .toList()[i + 1]
                    .key
                    .exerciseCategoryName) {
          return const Padding(
              padding: EdgeInsets.only(top: 12, bottom: 12),
              child: CustomDividerWidget(
                indent: 145,
              ));
        } else {
          return Container();
        }
      } else if (currentListData.entries.toList()[i].key.exerciseCategoryName ==
          ItemType.singleExercise) {
        return const Padding(
            padding: EdgeInsets.only(top: 12, bottom: 12),
            child: CustomDividerWidget(
              indent: 145,
            ));
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  Widget showExerciseTileWidget(
    BuildContext context,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 45,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  color: AppColor.surfaceBackgroundBaseColor,
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        color: AppColor.surfaceBackgroundColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: cacheNetworkWidget(
                        height: 80,
                        width: 80,
                        context,
                        imageUrl: currentListData.values
                            .toList()[index]
                            .image
                            .toString()),
                  ),
                ),
                12.width(),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentListData.values.toList()[index].name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.label16MD
                            .copyWith(color: AppColor.textEmphasisColor),
                      ),
                      Text(
                          currentListData.keys
                              .toList()[index]
                              .getExerciseSubtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.paragraph14MD.copyWith(
                            color: AppColor.textPrimaryColor,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          showTrailing == true
              ? PopupMenuButton(
                  onSelected: (value) {
                    if (value == 1) {
                      showModalBottomSheet(
                          isDismissible: false,
                          isScrollControlled: true,
                          useSafeArea: true,
                          backgroundColor: AppColor.surfaceBackgroundBaseColor,
                          context: context,
                          builder: (context) => DetailWorkoutBottomSheet(
                                id: currentListData.values.toList()[index].id,
                                itemType: currentListData.entries
                                    .toList()[index]
                                    .key
                                    .exerciseCategoryName,
                                exerciseDetailModel:
                                    currentListData.keys.toList()[index],
                              ));
                    } else if (value == 2) {
                      if (goHereTap != null) {
                        goHereTap!(index);
                      }
                    }
                  },
                  padding: const EdgeInsets.all(16),
                  constraints: const BoxConstraints(minWidth: 228),
                  elevation: 20,
                  surfaceTintColor: AppColor.surfaceBackgroundBaseColor,
                  offset: const Offset(-2, 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  color: AppColor.surfaceBackgroundBaseColor,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(context.loc.popupText("show"),
                                style: AppTypography.label16MD.copyWith(
                                  color: AppColor.textEmphasisColor,
                                )),
                            SvgPicture.asset(AppAssets.infoIcon),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(context.loc.popupText("here"),
                                style: AppTypography.label16MD.copyWith(
                                  color: AppColor.textEmphasisColor,
                                )),
                            SvgPicture.asset(AppAssets.returnIcon),
                          ],
                        ),
                      )
                    ];
                  },
                  child: SvgPicture.asset(
                    AppAssets.horizontalVertIcon,
                    color: AppColor.surfaceBrandDarkColor,
                  ))
              : Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: InkWell(
                      onTap: () {
                        if (EveentTriggered.workout_preview_exercise_info !=
                            null) {
                          EveentTriggered.workout_preview_exercise_info!(
                              currentListData.values.toList()[index].name);
                        }
                        showModalBottomSheet(
                            isDismissible: false,
                            isScrollControlled: true,
                            useSafeArea: true,
                            backgroundColor:
                                AppColor.surfaceBackgroundBaseColor,
                            context: context,
                            builder: (context) => DetailWorkoutBottomSheet(
                                exerciseDetailModel:
                                    currentListData.keys.toList()[index],
                                itemType: currentListData.entries
                                    .toList()[index]
                                    .key
                                    .exerciseCategoryName,
                                id: currentListData.values.toList()[index].id));
                      },
                      child: SvgPicture.asset(AppAssets.infoIcon)),
                ),
        ],
      ),
    );
  }
}

class RoundWidget extends StatelessWidget {
  const RoundWidget({super.key, required this.i, required this.listData});

  final int i;
  final Map<ExerciseDetailModel, ExerciseModel> listData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 45, top: 12, bottom: 12),
      child: Row(children: [
        Text(
          listData.entries.toList()[i].key.exerciseCategoryName == ItemType.emom
              ? 'Minute ${listData.entries.toList()[i].key.emomMinute!.toInt()}'
              : "Round ${listData.entries.toList()[i].key.setsCount!.toInt()}",
          style: AppTypography.label14SM
              .copyWith(color: AppColor.textPrimaryColor),
        ),
        const Expanded(
          child: CustomDividerWidget(
            indent: 31,
          ),
        )
      ]),
    );
  }
}

class BuildHeader extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final Map<ExerciseDetailModel, ExerciseModel> dataList;
  final ValueNotifier<bool> expandHeaderValueListenable, loaderListenAble;

  const BuildHeader(
      {super.key,
      this.onTap,
      required this.title,
      required this.dataList,
      required this.expandHeaderValueListenable,
      required this.loaderListenAble});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColor.surfaceBackgroundColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 20, right: 20),
        title: Text(
          title,
          style: AppTypography.title14XS
              .copyWith(color: AppColor.textEmphasisColor),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: ValueListenableBuilder(
              valueListenable: loaderListenAble,
              builder: (_, value, child) {
                return value == true
                    ? Text(
                        "0 exercise",
                        style: AppTypography.paragraph14MD
                            .copyWith(color: AppColor.textPrimaryColor),
                      )
                    : Text(
                        "${dataList.length} exercises",
                        style: AppTypography.paragraph14MD
                            .copyWith(color: AppColor.textPrimaryColor),
                      );
              }),
        ),
        trailing: InkWell(
            onTap: onTap,
            child: ValueListenableBuilder(
                valueListenable: expandHeaderValueListenable,
                builder: (_, value, child) {
                  return value == true
                      ? Icon(
                          Icons.keyboard_arrow_up,
                          color: AppColor.textPrimaryColor,
                          size: 32,
                        )
                      : Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColor.textPrimaryColor,
                          size: 32,
                        );
                })),
      ),
    );
  }
}

class BuildHeader2 extends StatefulWidget {
  final String title, subtitle;
  final Map<ExerciseDetailModel, ExerciseModel> exerciseWorkoutData;
  final ValueNotifier<bool>? expandValueListenable;
  final VoidCallback? onExpand;
  const BuildHeader2(
      {super.key,
      required this.onExpand,
      required this.title,
      this.expandValueListenable,
      required this.exerciseWorkoutData,
      required this.subtitle});

  @override
  State<BuildHeader2> createState() => _BuildHeader2State();
}

class _BuildHeader2State extends State<BuildHeader2> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColor.surfaceBackgroundColor,
      child: Row(
        children: [
          SizedBox(
              height: 80,
              width: 80,
              child: Card(
                  color: AppColor.surfaceBackgroundBaseColor,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 1, vertical: 1),
                        child: Column(
                          children: [
                            if (widget.exerciseWorkoutData.isNotEmpty) ...[
                              Expanded(
                                  child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color:
                                              AppColor.surfaceBackgroundColor,
                                          borderRadius: BorderRadius.only(
                                              topRight: widget
                                                          .exerciseWorkoutData
                                                          .length >
                                                      3
                                                  ? const Radius.circular(0)
                                                  : const Radius.circular(12),
                                              topLeft:
                                                  const Radius.circular(12))),
                                      child: cacheNetworkWidget(
                                          height: 61,
                                          width: 61,
                                          context,
                                          imageUrl: widget
                                              .exerciseWorkoutData.values
                                              .toList()[0]
                                              .image
                                              .toString()),
                                    ),
                                  ),
                                  if (widget.exerciseWorkoutData.length >
                                      3) ...[
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 1),
                                        decoration: BoxDecoration(
                                            color:
                                                AppColor.surfaceBackgroundColor,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(12),
                                            )),
                                        child: cacheNetworkWidget(
                                            height: 80,
                                            width: 80,
                                            context,
                                            imageUrl: widget
                                                .exerciseWorkoutData.values
                                                .toList()[3]
                                                .image
                                                .toString()),
                                      ),
                                    )
                                  ]
                                ],
                              )),
                              if (widget.exerciseWorkoutData.length > 1) ...[
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.only(top: 1),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                                AppColor.surfaceBackgroundColor,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(12))),
                                        child: cacheNetworkWidget(
                                            height: 80,
                                            width: 80,
                                            context,
                                            imageUrl: widget
                                                .exerciseWorkoutData.values
                                                .toList()[1]
                                                .image
                                                .toString()),
                                      )),
                                      if (widget.exerciseWorkoutData.length >
                                          2) ...[
                                        Expanded(
                                            child: Container(
                                          margin: const EdgeInsets.only(
                                            left: 1,
                                          ),
                                          decoration: BoxDecoration(
                                              color: AppColor
                                                  .surfaceBackgroundColor,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(12))),
                                          child: cacheNetworkWidget(
                                              height: 80,
                                              width: 80,
                                              context,
                                              imageUrl: widget
                                                  .exerciseWorkoutData.values
                                                  .toList()[2]
                                                  .image
                                                  .toString()),
                                        ))
                                      ]
                                    ],
                                  ),
                                ))
                              ]
                            ]
                          ],
                        ),
                      ),
                      if (widget.exerciseWorkoutData.length > 4)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            alignment: Alignment.center,
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                color: AppColor.surfaceBackgroundBaseColor),
                            child: FittedBox(
                                child: Text(
                              "+${widget.exerciseWorkoutData.length - 4}",
                              style: AppTypography.label10XXSM
                                  .copyWith(color: AppColor.textEmphasisColor),
                            )),
                          ),
                        )
                    ],
                  ))),
          12.width(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: AppTypography.label18LG
                            .copyWith(color: AppColor.textEmphasisColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          widget.subtitle,
                          style: AppTypography.paragraph14MD
                              .copyWith(color: AppColor.textPrimaryColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.expandValueListenable != null)
                  InkWell(
                      onTap: () {
                        if (EveentTriggered.workout_preview_expanded != null) {
                          EveentTriggered
                              .workout_preview_expanded!(widget.title);
                        }
                        widget.onExpand!();
                      },
                      child: ValueListenableBuilder(
                        valueListenable: widget.expandValueListenable!,
                        builder: (_, value, child) {
                          return value == true
                              ? Icon(
                                  Icons.keyboard_arrow_up,
                                  color: AppColor.textPrimaryColor,
                                  size: 32,
                                )
                              : Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColor.textPrimaryColor,
                                  size: 32,
                                );
                        },
                      )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
