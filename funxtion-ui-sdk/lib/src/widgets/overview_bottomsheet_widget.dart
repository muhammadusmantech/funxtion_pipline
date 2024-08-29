import 'package:flutter/material.dart';

import '../../ui_tool_kit.dart';

class OverviewBottomSheet extends StatefulWidget {
  final WorkoutModel workoutModel;
  final Map<ExerciseDetailModel, ExerciseModel> warmUpData;
  final Map<ExerciseDetailModel, ExerciseModel> trainingData;
  final Map<ExerciseDetailModel, ExerciseModel> coolDownData;
  final int? warmupBody;
  final int? trainingBody;
  final int? coolDownBody;
  final void Function(int)? goHereTapWarmUp;
  final void Function(int)? goHereTapTraining;
  final void Function(int)? goHereTapCoolDown;
  final int currentRound;
  const OverviewBottomSheet({
    super.key,
    required this.workoutModel,
    required this.warmUpData,
    required this.trainingData,
    required this.coolDownData,
    this.warmupBody,
    this.trainingBody,
    this.coolDownBody,
    this.goHereTapWarmUp,
    this.goHereTapTraining,
    this.goHereTapCoolDown,
    required this.currentRound,
  });

  @override
  State<OverviewBottomSheet> createState() => _OverviewBottomSheetState();
}

class _OverviewBottomSheetState extends State<OverviewBottomSheet> {
  bool isCompleted = false;
  ValueNotifier<bool> warmUpExpand = ValueNotifier(true);

  ValueNotifier<bool> trainingExpand = ValueNotifier(true);
  ValueNotifier<bool> coolDownExpand = ValueNotifier(true);
  ValueNotifier<bool> ctExpandWarmup = ValueNotifier(true);
  ValueNotifier<bool> crExpandWarmup = ValueNotifier(true);
  ValueNotifier<bool> seExpandWarmup = ValueNotifier(true);
  ValueNotifier<bool> rftExpandWarmup = ValueNotifier(true);
  ValueNotifier<bool> ssExpandWarmup = ValueNotifier(true);
  ValueNotifier<bool> amrapExpandWarmup = ValueNotifier(true);
  ValueNotifier<bool> emomExpandWarmup = ValueNotifier(true);

  ValueNotifier<bool> ctExpandTraining = ValueNotifier(true);
  ValueNotifier<bool> crExpandTraining = ValueNotifier(true);
  ValueNotifier<bool> seExpandTraining = ValueNotifier(true);
  ValueNotifier<bool> rftExpandTraining = ValueNotifier(true);
  ValueNotifier<bool> ssExpandTraining = ValueNotifier(true);
  ValueNotifier<bool> amrapExpandTraining = ValueNotifier(true);
  ValueNotifier<bool> emomExpandTraining = ValueNotifier(true);

  ValueNotifier<bool> ctExpandCoolDown = ValueNotifier(true);
  ValueNotifier<bool> crExpandCoolDown = ValueNotifier(true);
  ValueNotifier<bool> seExpandCoolDown = ValueNotifier(true);
  ValueNotifier<bool> rftExpandCoolDown = ValueNotifier(true);
  ValueNotifier<bool> ssExpandCoolDown = ValueNotifier(true);
  ValueNotifier<bool> amrapExpandCoolDown = ValueNotifier(true);
  ValueNotifier<bool> emomExpandCoolDown = ValueNotifier(true);
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Colors.transparent, shape: BoxShape.circle),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: Colors.transparent,
                ),
              ),
              Text(
                context.loc.overviewText,
                style: AppTypography.title18LG
                    .copyWith(color: AppColor.textEmphasisColor),
              ),
              InkWell(
                onTap: () {
                  context.maybePopPage();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColor.surfaceBackgroundSecondaryColor,
                      shape: BoxShape.circle),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.close,
                    size: 18,
                  ),
                ),
              )
            ],
          ),
        ),
        const CustomDividerWidget(thickness: 2.5),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, top: 40, bottom: 20, right: 24),
                  child: Text(
                    widget.workoutModel.title.toString(),
                    style: AppTypography.title28_2XL
                        .copyWith(color: AppColor.textEmphasisColor),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  decoration: BoxDecoration(
                      color: AppColor.surfaceBackgroundColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                        ),
                        child: Column(
                          children: [
                            30.height(),
                            if (widget.warmUpData.isNotEmpty) ...[
                              ProgressBarWidget(
                                currentRound: widget.currentRound,
                                workoutCompleted: widget.warmupBody! >=
                                    widget.warmUpData.length,
                                isActive: widget.warmUpData.isNotEmpty,
                                currentList: widget.warmUpData,
                                current: widget.warmupBody?.toInt() ?? -1,
                                amrapExpand: amrapExpandWarmup,
                                crExpand: crExpandWarmup,
                                ctExpand: ctExpandWarmup,
                                emomExpand: emomExpandWarmup,
                                rftExpand: rftExpandWarmup,
                                seExpand: seExpandWarmup,
                                ssExpand: ssExpandWarmup,
                                currentExpand: warmUpExpand,
                              ),
                            ],
                            if (widget.warmUpData.isNotEmpty &&
                                widget.trainingData.isNotEmpty)
                              LineWidget(
                                  height: 70,
                                  color: widget.trainingBody! >= 0
                                      ? AppColor.surfaceBrandDarkColor
                                      : null),
                            if (widget.trainingData.isNotEmpty)
                              ProgressBarWidget(
                                currentRound: widget.currentRound,
                                workoutCompleted: widget.trainingBody! >=
                                    widget.trainingData.length,
                                isActive: widget.warmUpData.isEmpty &&
                                        widget.trainingData.isNotEmpty ||
                                    widget.trainingBody! >= 0,
                                currentList: widget.trainingData,
                                current: widget.trainingBody?.toInt() ?? -1,
                                amrapExpand: amrapExpandTraining,
                                crExpand: crExpandTraining,
                                ctExpand: ctExpandTraining,
                                emomExpand: emomExpandTraining,
                                rftExpand: rftExpandTraining,
                                seExpand: seExpandTraining,
                                ssExpand: ssExpandTraining,
                                currentExpand: trainingExpand,
                              ),
                            if (widget.coolDownData.isNotEmpty)
                              if (widget.trainingData.isNotEmpty ||
                                  widget.warmUpData.isNotEmpty)
                                LineWidget(
                                    height: 70,
                                    color: widget.coolDownBody! >= 0
                                        ? AppColor.borderBrandDarkColor
                                        : null),
                            if (widget.coolDownData.isNotEmpty)
                              ProgressBarWidget(
                                workoutCompleted: widget.coolDownBody! >=
                                    widget.coolDownData.length,
                                isActive: widget.coolDownBody! >= 0,
                                currentList: widget.coolDownData,
                                current: widget.coolDownBody?.toInt() ?? -1,
                                amrapExpand: amrapExpandCoolDown,
                                crExpand: crExpandCoolDown,
                                ctExpand: ctExpandCoolDown,
                                emomExpand: emomExpandCoolDown,
                                rftExpand: rftExpandCoolDown,
                                seExpand: seExpandCoolDown,
                                ssExpand: ssExpandCoolDown,
                                currentExpand: coolDownExpand,
                                currentRound: widget.currentRound,
                              ),
                            30.height(),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(children: [
                          if (widget.warmUpData.isNotEmpty)
                            Column(
                              children: [
                                BuildHeader(
                                  loaderListenAble: ValueNotifier(false),
                                  dataList: widget.warmUpData,
                                  title: "Warmup",
                                  expandHeaderValueListenable: warmUpExpand,
                                  onTap: () {
                                    warmUpExpand.value = !warmUpExpand.value;
                                  },
                                ),
                                BuildExercisesBodyWidget(
                                  isAMRAPWorkoutCompleted: widget.warmupBody! <=
                                          0
                                      ? false
                                      : widget.warmupBody! >=
                                              widget.warmUpData.length
                                          ? true
                                          : widget.warmUpData.keys
                                                  .toList()[
                                                      widget.warmupBody! - 1]
                                                  .exerciseCategoryName ==
                                              ItemType.amrap,
                                  isRFTWorkoutCompleted: widget.warmupBody! <= 0
                                      ? false
                                      : widget.warmupBody! >=
                                              widget.warmUpData.length
                                          ? true
                                          : widget.warmupBody! > 0 &&
                                              check(
                                                  widget.warmUpData.keys
                                                      .toList(),
                                                  ItemType.rft,
                                                  widget.warmupBody!),
                                  isSSWorkoutCompleted: widget.warmupBody! <= 0
                                      ? false
                                      : widget.warmupBody! >=
                                              widget.warmUpData.length
                                          ? true
                                          : widget.warmUpData.keys
                                                  .toList()[
                                                      widget.warmupBody! - 1]
                                                  .exerciseCategoryName ==
                                              ItemType.superSet,
                                  goHereTap: widget.goHereTapWarmUp,
                                  showTrailing: widget.goHereTapWarmUp != null
                                      ? true
                                      : false,
                                  currentListData: widget.warmUpData,
                                  expandHeaderValueListenable: warmUpExpand,
                                  loaderValueListenable: ValueNotifier(false),
                                  amrapExpandNew: amrapExpandWarmup,
                                  crExpandNew: crExpandWarmup,
                                  ctExpandNew: ctExpandWarmup,
                                  emomExpandNew: emomExpandWarmup,
                                  rftExpandNew: rftExpandWarmup,
                                  seExpandNew: seExpandWarmup,
                                  ssExpandNew: ssExpandWarmup,
                                ),
                                8.height(),
                              ],
                            ),
                          if (widget.trainingData.isNotEmpty)
                            Column(
                              children: [
                                BuildHeader(
                                  loaderListenAble: ValueNotifier(false),
                                  dataList: widget.trainingData,
                                  title: "Training",
                                  expandHeaderValueListenable: trainingExpand,
                                  onTap: () {
                                    trainingExpand.value =
                                        !trainingExpand.value;
                                  },
                                ),
                                BuildExercisesBodyWidget(
                                  isAMRAPWorkoutCompleted:
                                      widget.trainingBody! <= 0
                                          ? false
                                          : widget.trainingBody! >=
                                                  widget.trainingData.length
                                              ? true
                                              : check(
                                                  widget.trainingData.keys
                                                      .toList(),
                                                  ItemType.amrap,
                                                  widget.trainingBody!.toInt()),
                                  isRFTWorkoutCompleted: widget.trainingBody! <=
                                          0
                                      ? false
                                      : widget.trainingBody! >=
                                              widget.trainingData.length
                                          ? true
                                          : widget.trainingData.keys
                                                  .toList()[
                                                      widget.trainingBody! - 1]
                                                  .exerciseCategoryName ==
                                              ItemType.rft,
                                  isSSWorkoutCompleted: widget.trainingBody! <=
                                          0
                                      ? false
                                      : widget.trainingBody! >=
                                              widget.trainingData.length
                                          ? true
                                          : widget.trainingData.keys
                                                  .toList()[
                                                      widget.trainingBody! - 1]
                                                  .exerciseCategoryName ==
                                              ItemType.superSet,
                                  goHereTap: widget.goHereTapTraining,
                                  showTrailing: widget.goHereTapTraining != null
                                      ? true
                                      : false,
                                  currentListData: widget.trainingData,
                                  expandHeaderValueListenable: trainingExpand,
                                  loaderValueListenable: ValueNotifier(false),
                                  amrapExpandNew: amrapExpandTraining,
                                  crExpandNew: crExpandTraining,
                                  ctExpandNew: ctExpandTraining,
                                  emomExpandNew: emomExpandTraining,
                                  rftExpandNew: rftExpandTraining,
                                  seExpandNew: seExpandTraining,
                                  ssExpandNew: ssExpandTraining,
                                ),
                                8.height(),
                              ],
                            ),
                          if (widget.coolDownData.isNotEmpty)
                            Column(
                              children: [
                                BuildHeader(
                                  loaderListenAble: ValueNotifier(false),
                                  dataList: widget.coolDownData,
                                  title: "Cooldown",
                                  expandHeaderValueListenable: coolDownExpand,
                                  onTap: () {
                                    coolDownExpand.value =
                                        !coolDownExpand.value;
                                  },
                                ),
                                BuildExercisesBodyWidget(
                                  isAMRAPWorkoutCompleted:
                                      widget.coolDownBody! <= 0
                                          ? false
                                          : widget.coolDownBody! >=
                                                  widget.coolDownData.length
                                              ? true
                                              : widget.coolDownData.keys
                                                      .toList()[
                                                          widget.coolDownBody! -
                                                              1]
                                                      .exerciseCategoryName ==
                                                  ItemType.amrap,
                                  isRFTWorkoutCompleted: widget.coolDownBody! <=
                                          0
                                      ? false
                                      : widget.coolDownBody! >=
                                              widget.coolDownData.length
                                          ? true
                                          : widget.coolDownData.keys
                                                  .toList()[
                                                      widget.coolDownBody! - 1]
                                                  .exerciseCategoryName ==
                                              ItemType.rft,
                                  isSSWorkoutCompleted: widget.coolDownBody! <=
                                          0
                                      ? false
                                      : widget.coolDownBody! >=
                                              widget.coolDownData.length
                                          ? true
                                          : widget.coolDownData.keys
                                                  .toList()[
                                                      widget.coolDownBody! - 1]
                                                  .exerciseCategoryName ==
                                              ItemType.superSet,
                                  showTrailing: widget.goHereTapCoolDown != null
                                      ? true
                                      : false,
                                  goHereTap: widget.goHereTapCoolDown,
                                  currentListData: widget.coolDownData,
                                  expandHeaderValueListenable: coolDownExpand,
                                  loaderValueListenable: ValueNotifier(false),
                                  amrapExpandNew: amrapExpandCoolDown,
                                  crExpandNew: crExpandCoolDown,
                                  ctExpandNew: ctExpandCoolDown,
                                  emomExpandNew: emomExpandCoolDown,
                                  rftExpandNew: rftExpandCoolDown,
                                  seExpandNew: seExpandCoolDown,
                                  ssExpandNew: ssExpandCoolDown,
                                )
                              ],
                            )
                        ]),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
