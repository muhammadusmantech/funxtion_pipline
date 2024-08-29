import 'package:flutter/material.dart';

import '../../ui_tool_kit.dart';

class ProgressBarWidget extends StatelessWidget {
  ProgressBarWidget(
      {super.key,
      required this.isActive,
      required this.currentList,
      required this.current,
      required this.ctExpand,
      required this.crExpand,
      required this.seExpand,
      required this.rftExpand,
      required this.ssExpand,
      required this.amrapExpand,
      required this.emomExpand,
      required this.currentExpand,
      required this.workoutCompleted,
      required this.currentRound});
  final Map<ExerciseDetailModel, ExerciseModel> currentList;
  final int current;
  final ValueNotifier<bool> currentExpand;
  final ValueNotifier<bool> ctExpand;
  final ValueNotifier<bool> crExpand;
  final ValueNotifier<bool> seExpand;
  final ValueNotifier<bool> rftExpand;
  final ValueNotifier<bool> ssExpand;
  final ValueNotifier<bool> amrapExpand;
  final ValueNotifier<bool> emomExpand;
  final bool isActive, workoutCompleted;
  final int currentRound;
  bool onEmomCurrent = false;
  bool check(List<ExerciseDetailModel> data, ItemType type, int index) {
    bool value = false;
    for (var i = 0; i < data.length; i++) {
      if (data[i].exerciseCategoryName == type) {
        if (index > i) {
          value = true;
        } else {
          value = false;
        }
      }
    }
    return value;
  }

  int addRoundInCurrent(int current, int currentIndex) {
    int value = -1;
    int index = currentList.entries.toList().indexWhere(
      (element) {
        return element.key.emomMinute == currentRound;
      },
    );
    int lastIndex = currentList.entries.toList().lastIndexWhere(
      (element) {
        return element.key.exerciseCategoryName == ItemType.emom;
      },
    );

    if (current > lastIndex) {
      value = current;
    } else {
      if (current >= currentIndex || onEmomCurrent == true) {
        onEmomCurrent = true;
        value = index - current;
      } else {
        onEmomCurrent = false;
      }
    }

    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      StepWidget(
        isActive: workoutCompleted ? false : isActive,
        isCompleted: workoutCompleted,
      ),
      ValueListenableBuilder<bool>(
          valueListenable: currentExpand,
          builder: (_, value, child) {
            return ExpandedSection(
              expand: value,
              child: Column(
                children: [
                  LineWidget(
                      height: 60,
                      color: workoutCompleted
                          ? AppColor.borderBrandDarkColor
                          : isActive == true
                              ? AppColor.borderBrandDarkColor
                              : null),
                  SizedBox(
                    width: 25,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: currentList.length,
                        itemBuilder: (context, i) {
                          switch (currentList.keys
                              .toList()[i]
                              .exerciseCategoryName) {
                            case ItemType.singleExercise:
                              return buildExerciseColumn(i, seExpand);
                            case ItemType.circuitTime:
                              return buildCircuitTimeColumn(i, ctExpand);
                            case ItemType.circuitRep:
                              return buildCircuitRepColumn(i, crExpand);
                            case ItemType.rft:
                              return buildRFTColumn(i, rftExpand);
                            case ItemType.superSet:
                              return buildSuperSetColumn(i, ssExpand);
                            case ItemType.amrap:
                              return buildAMRAPColumn(i, amrapExpand);
                            case ItemType.emom:
                              return buildEMOMColumn(
                                i,
                                emomExpand,
                              );
                            default:
                              return Container();
                          }
                        }),
                  )
                ],
              ),
            );
          })
    ]);
  }

  Widget buildRFTColumn(int i, ValueNotifier<bool> expandNotifier) {
    return Column(
      children: [
        headerCheckWidget(
          i: i,
          header2Expand: expandNotifier,
          lineColor: workoutCompleted
              ? AppColor.surfaceBrandDarkColor
              : check(currentList.keys.toList(), ItemType.rft, current)
                  ? AppColor.surfaceBrandDarkColor
                  : null,
        ),
        ValueListenableBuilder<bool>(
          valueListenable: expandNotifier,
          builder: (_, value, child) {
            return ExpandedSection(
              expand: value,
              child: Column(
                children: [
                  if (i == 0)
                    LineWidget(
                      height: 85,
                      color: workoutCompleted
                          ? AppColor.surfaceBrandDarkColor
                          : current > 0 &&
                                  check(currentList.keys.toList(), ItemType.rft,
                                      current)
                              ? AppColor.surfaceBrandDarkColor
                              : null,
                    ),
                  if (i != currentList.length - 1 &&
                      currentList.entries
                              .toList()[i]
                              .key
                              .exerciseCategoryName ==
                          currentList.entries
                              .toList()[i + 1]
                              .key
                              .exerciseCategoryName)
                    Center(
                      child: LineWidget(
                        height: 140,
                        color: workoutCompleted
                            ? AppColor.surfaceBrandDarkColor
                            : current > 0 &&
                                    check(currentList.keys.toList(),
                                        ItemType.rft, current)
                                ? AppColor.surfaceBrandDarkColor
                                : null,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildSuperSetColumn(int i, ValueNotifier<bool> expandNotifier) {
    return Column(
      children: [
        headerCheckWidget(
          i: i,
          header2Expand: expandNotifier,
          lineColor: workoutCompleted
              ? AppColor.surfaceBrandDarkColor
              : check(currentList.keys.toList(), ItemType.superSet, current)
                  ? AppColor.surfaceBrandDarkColor
                  : null,
        ),
        ValueListenableBuilder<bool>(
          valueListenable: expandNotifier,
          builder: (_, value, child) {
            return ExpandedSection(
              expand: value,
              child: Column(
                children: [
                  if (i == 0)
                    LineWidget(
                      height: 105,
                      color: workoutCompleted
                          ? AppColor.surfaceBrandDarkColor
                          : current > 0 &&
                                  check(currentList.keys.toList(),
                                      ItemType.superSet, current)
                              ? AppColor.surfaceBrandDarkColor
                              : null,
                    ),
                  if (i != currentList.length - 1 &&
                      currentList.entries
                              .toList()[i]
                              .key
                              .exerciseCategoryName ==
                          currentList.entries
                              .toList()[i + 1]
                              .key
                              .exerciseCategoryName)
                    Center(
                      child: LineWidget(
                        height: 122,
                        color: workoutCompleted
                            ? AppColor.surfaceBrandDarkColor
                            : current > 0 &&
                                    check(currentList.keys.toList(),
                                        ItemType.superSet, current)
                                ? AppColor.surfaceBrandDarkColor
                                : null,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildAMRAPColumn(int i, ValueNotifier<bool> expandNotifier) {
    return Column(
      children: [
        headerCheckWidget(
          i: i,
          header2Expand: expandNotifier,
          lineColor: workoutCompleted
              ? AppColor.surfaceBrandDarkColor
              : check(currentList.keys.toList(), ItemType.amrap, current)
                  ? AppColor.surfaceBrandDarkColor
                  : null,
        ),
        ValueListenableBuilder<bool>(
          valueListenable: expandNotifier,
          builder: (_, value, child) {
            return ExpandedSection(
              expand: value,
              child: Column(
                children: [
                  if (i == 0)
                    LineWidget(
                      height: 105,
                      color: workoutCompleted
                          ? AppColor.surfaceBrandDarkColor
                          : current > 0 &&
                                  check(currentList.keys.toList(),
                                      ItemType.amrap, current)
                              ? AppColor.surfaceBrandDarkColor
                              : null,
                    ),
                  if (i != currentList.length - 1 &&
                      currentList.entries
                              .toList()[i]
                              .key
                              .exerciseCategoryName ==
                          currentList.entries
                              .toList()[i + 1]
                              .key
                              .exerciseCategoryName)
                    Center(
                      child: LineWidget(
                        height: 112,
                        color: workoutCompleted
                            ? AppColor.surfaceBrandDarkColor
                            : current > 0 &&
                                    check(currentList.keys.toList(),
                                        ItemType.amrap, current)
                                ? AppColor.surfaceBrandDarkColor
                                : null,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildEMOMColumn(
    int i,
    ValueNotifier<bool> expandNotifier,
  ) {
    return Column(
      children: [
        headerCheckWidget(
          i: i,
          header2Expand: expandNotifier,
          lineColor: workoutCompleted
              ? AppColor.surfaceBrandDarkColor
              : current >= i
                  ? AppColor.surfaceBrandDarkColor
                  : null,
        ),
        ValueListenableBuilder<bool>(
          valueListenable: expandNotifier,
          builder: (_, value, child) {
            return ExpandedSection(
              expand: value,
              child: Column(
                children: [
                  if (i == 0)
                    LineWidget(
                      height: 105,
                      color: workoutCompleted
                          ? AppColor.surfaceBrandDarkColor
                          : current + addRoundInCurrent(current, i) >= i
                              ? AppColor.surfaceBrandDarkColor
                              : null,
                    ),
                  if (currentList.entries.toList()[i].key.exerciseNo == 0)
                    StepWidget(
                      isActive: workoutCompleted
                          ? false
                          : i == current + addRoundInCurrent(current, i),
                      isCompleted: workoutCompleted
                          ? true
                          : current + addRoundInCurrent(current, i) > i,
                    ),
                  roundCheckWidget(i: i, height: 13.2),
                  if (i != currentList.length - 1 &&
                      currentList.entries
                              .toList()[i]
                              .key
                              .exerciseCategoryName ==
                          currentList.entries
                              .toList()[i + 1]
                              .key
                              .exerciseCategoryName)
                    LineWidget(
                      height: 108,
                      color: workoutCompleted
                          ? AppColor.surfaceBrandDarkColor
                          : current + addRoundInCurrent(current, i) > i
                              ? AppColor.surfaceBrandDarkColor
                              : null,
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildExerciseColumn(int i, ValueNotifier<bool> expandNotifier) {
    return Column(
      children: [
        headerCheckWidget(
          i: i,
          header2Expand: expandNotifier,
          lineColor: workoutCompleted
              ? AppColor.surfaceBrandDarkColor
              : current >= i
                  ? AppColor.surfaceBrandDarkColor
                  : null,
        ),
        ValueListenableBuilder<bool>(
          valueListenable: expandNotifier,
          builder: (_, value, child) {
            return ExpandedSection(
              expand: value,
              child: Column(
                children: [
                  if (i == 0)
                    LineWidget(
                      height: 72,
                      color: workoutCompleted
                          ? AppColor.surfaceBrandDarkColor
                          : current >= i
                              ? AppColor.borderBrandDarkColor
                              : null,
                    ),
                  StepWidget(
                    isActive: workoutCompleted ? false : i == current,
                    isCompleted: workoutCompleted ? true : current > i,
                  ),
                  if (i != currentList.length - 1 &&
                      currentList.entries
                              .toList()[i]
                              .key
                              .exerciseCategoryName ==
                          currentList.entries
                              .toList()[i + 1]
                              .key
                              .exerciseCategoryName)
                    LineWidget(
                      height: 105,
                      color: workoutCompleted
                          ? AppColor.surfaceBrandDarkColor
                          : current > i
                              ? AppColor.surfaceBrandDarkColor
                              : null,
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildCircuitTimeColumn(int i, ValueNotifier<bool> expandNotifier) {
    return Column(
      children: [
        headerCheckWidget(
          i: i,
          header2Expand: expandNotifier,
          lineColor: workoutCompleted
              ? AppColor.surfaceBrandDarkColor
              : current >= i
                  ? AppColor.surfaceBrandDarkColor
                  : null,
        ),
        ValueListenableBuilder<bool>(
          valueListenable: expandNotifier,
          builder: (_, value, child) {
            return ExpandedSection(
              expand: value,
              child: Column(
                children: [
                  if (i == 0)
                    LineWidget(
                      height: 105,
                      color: workoutCompleted
                          ? AppColor.surfaceBrandDarkColor
                          : current >= i
                              ? AppColor.surfaceBrandDarkColor
                              : null,
                    ),
                  StepWidget(
                    isActive: workoutCompleted ? false : i == current,
                    isCompleted: workoutCompleted ? true : current > i,
                  ),
                  roundCheckWidget(i: i),
                  if (i != currentList.length - 1 &&
                      currentList.entries
                              .toList()[i]
                              .key
                              .exerciseCategoryName ==
                          currentList.entries
                              .toList()[i + 1]
                              .key
                              .exerciseCategoryName)
                    LineWidget(
                      height: 96,
                      color: workoutCompleted
                          ? AppColor.surfaceBrandDarkColor
                          : current > i
                              ? AppColor.surfaceBrandDarkColor
                              : null,
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildCircuitRepColumn(int i, ValueNotifier<bool> expandNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        headerCheckWidget(
          i: i,
          header2Expand: expandNotifier,
          lineColor: workoutCompleted
              ? AppColor.surfaceBrandDarkColor
              : current >= i
                  ? AppColor.surfaceBrandDarkColor
                  : null,
        ),
        ValueListenableBuilder<bool>(
          valueListenable: expandNotifier,
          builder: (_, value, child) {
            return ExpandedSection(
              expand: value,
              child: Column(
                children: [
                  if (i == 0)
                    LineWidget(
                      height: 105,
                      color: workoutCompleted
                          ? AppColor.surfaceBrandDarkColor
                          : current >= i
                              ? AppColor.borderBrandDarkColor
                              : null,
                    ),
                  StepWidget(
                    isActive: workoutCompleted ? false : i == current,
                    isCompleted: workoutCompleted ? true : current > i,
                  ),
                  roundCheckWidget(i: i),
                  if (i != currentList.length - 1 &&
                      currentList.entries
                              .toList()[i]
                              .key
                              .exerciseCategoryName ==
                          currentList.entries
                              .toList()[i + 1]
                              .key
                              .exerciseCategoryName)
                    LineWidget(
                      height: 96,
                      color: workoutCompleted
                          ? AppColor.surfaceBrandDarkColor
                          : current > i
                              ? AppColor.surfaceBrandDarkColor
                              : null,
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget roundCheckWidget({required int i, double? height}) {
    if (i == 0) {
      return Container();
    } else if (i == currentList.length - 1) {
      return Container();
    } else {
      if (currentList.entries.toList()[i].key.exerciseCategoryName ==
          ItemType.emom) {
        if (currentList.entries.toList()[i].key.emomMinute !=
                currentList.entries.toList()[i + 1].key.emomMinute &&
            currentList.entries.toList()[i + 1].key.emomMinute != null) {
          return LineWidget(
              height: height ?? 0.0,
              color: workoutCompleted
                  ? AppColor.surfaceBrandDarkColor
                  : current + addRoundInCurrent(current, i) > i
                      ? AppColor.borderBrandDarkColor
                      : null);
        } else {
          return Container();
        }
      } else if (currentList.entries.toList()[i].key.exerciseCategoryName ==
              ItemType.circuitTime ||
          currentList.entries.toList()[i].key.exerciseCategoryName ==
              ItemType.circuitRep) {
        if (currentList.entries.toList()[i].key.setsCount !=
                currentList.entries.toList()[i + 1].key.setsCount &&
            currentList.entries.toList()[i + 1].key.setsCount != null) {
          return LineWidget(
              height: 23,
              color: workoutCompleted
                  ? AppColor.surfaceBrandDarkColor
                  : current > i
                      ? AppColor.borderBrandDarkColor
                      : null);
        } else {
          return Container();
        }
      } else {
        return Container();
      }
    }
  }

  Widget headerCheckWidget(
      {required int i,
      required ValueNotifier<bool> header2Expand,
      required Color? lineColor}) {
    return i == 0
        ? StepWidget(
            isActive: workoutCompleted ? false : isActive,
            isCompleted: workoutCompleted,
          )
        : i > currentList.length - 1
            ? Container()
            : currentList.entries.toList()[i].key.exerciseCategoryName !=
                    currentList.entries.toList()[i - 1].key.exerciseCategoryName
                ? Column(
                    children: [
                      LineWidget(
                          height: 85,
                          color: workoutCompleted
                              ? AppColor.surfaceBrandDarkColor
                              : current >= i
                                  ? AppColor.borderBrandDarkColor
                                  : null),
                      StepWidget(
                        isActive: workoutCompleted
                            ? false
                            : current >= i
                                ? true
                                : false,
                        isCompleted: workoutCompleted,
                      ),
                      ValueListenableBuilder<bool>(
                          valueListenable: header2Expand,
                          builder: (_, value, child) {
                            return ExpandedSection(
                              expand: value,
                              child: Center(
                                  child: LineWidget(
                                height: currentList.entries
                                            .toList()[i]
                                            .key
                                            .exerciseCategoryName ==
                                        ItemType.singleExercise
                                    ? 80
                                    : 107,
                                color: lineColor,
                              )),
                            );
                          }),
                    ],
                  )
                : Container();
  }
}
