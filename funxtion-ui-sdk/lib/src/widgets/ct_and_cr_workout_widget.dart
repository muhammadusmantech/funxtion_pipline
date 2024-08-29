import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ui_tool_kit/ui_tool_kit.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class CtAndCrWorkoutWidget extends StatefulWidget {
  final String itemTypeTitle;
  final ValueNotifier<bool> isRestPlaying;
  final Map<ExerciseDetailModel, ExerciseModel> currentExerciseData;

  final String mainNotes;
  final String exerciseNotes;

  final ValueNotifier<bool> isSetComplete;
  final ValueNotifier<int> secondsCountDown;
  final ValueNotifier<int> restLinear;
  final Timer? everyTimeExerciseTimer;
  final int totalRounds;
  final int currentRound;
  final ValueNotifier<bool> isPlaying;
  final String nextElementText;
  final int mainWork;
  final ValueNotifier<int> mainRestNotifier;
  final int mainRest;
  final Timer? restTimer;
  final int currentExerciseInBlock;
  final int totalExerciseInBlock;

  final WorkoutModel workoutModel;
  final void Function() onPrevious, onNext;
  final void Function()? timerFnNextElement;
  final void Function(String)? triggerGetReadyFn;
  final bool isCircuitRep;

  const CtAndCrWorkoutWidget(
      {super.key,
      required this.workoutModel,
      required this.onPrevious,
      required this.onNext,
      this.timerFnNextElement,
      this.triggerGetReadyFn,
      required this.isCircuitRep,
      required this.itemTypeTitle,
      required this.currentExerciseData,
      required this.mainNotes,
      required this.exerciseNotes,
      required this.isSetComplete,
      required this.secondsCountDown,
      required this.restLinear,
      this.everyTimeExerciseTimer,
      required this.totalRounds,
      required this.currentRound,
      required this.isPlaying,
      required this.nextElementText,
      required this.mainWork,
      this.restTimer,
      required this.mainRestNotifier,
      required this.mainRest,
      required this.currentExerciseInBlock,
      required this.totalExerciseInBlock,
      required this.isRestPlaying});

  @override
  State<CtAndCrWorkoutWidget> createState() => _CtAndCrWorkoutWidgetState();
}

class _CtAndCrWorkoutWidgetState extends State<CtAndCrWorkoutWidget> {
  BorderRadiusGeometry? border = BorderRadius.circular(20);
  EdgeInsetsGeometry? padding = const EdgeInsets.all(8);
  ValueNotifier<bool> isTrainerNotesOpen = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            8.height(),
            ItemTypeTitleRowWidget(
                itemTypeTitle: widget.itemTypeTitle,
                isPlaying: widget.isPlaying,
                workoutModel: widget.workoutModel),
            Expanded(
              child: SingleExerciseViewWidget(
                  currentExerciseData: widget.currentExerciseData,
                  isPlaying: widget.isPlaying,
                  itemTypeTitle: widget.itemTypeTitle,
                  workoutModel: widget.workoutModel,
                  mainNotes: widget.mainNotes,
                  exerciseNotes: widget.exerciseNotes),
            ),
            if (widget.mainNotes.trim() != "" ||
                widget.exerciseNotes.trim() != "")
              TrainerNoteWidget(
                  isTrainerNotesOpen: isTrainerNotesOpen,
                  top: widget.currentExerciseData.keys.first
                              .currentResistanceTargets !=
                          null
                      ? 18
                      : 20,
                  eventsTriggeredFn: () {
                    if (EveentTriggered.workout_player_trainer_notes != null) {
                      EveentTriggered.workout_player_trainer_notes!(
                          widget.currentExerciseData.values.first.name
                              .toString(),
                          widget.currentExerciseData.values.first.id.toString(),
                          widget.workoutModel.title.toString(),
                          widget.workoutModel.id.toString());
                    }
                  },
                  mainNotes: widget.mainNotes,
                  exerciseNotes: widget.exerciseNotes),
            Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: CircuitTimeGoalTargetWidget(
                  isCircuitRep: widget.isCircuitRep,
                  timerFnNextElement: widget.timerFnNextElement ?? () {},
                  triggerGetReadyFn: widget.triggerGetReadyFn ?? (e) {},
                  mainWork: widget.mainWork,
                  isPlaying: widget.isPlaying,
                  nextElementText: widget.nextElementText,
                  goalTargetsValue:
                      widget.currentExerciseData.keys.first.currentGoalTargets!,
                  currentRound: widget.currentRound,
                  totalRounds: widget.totalRounds,
                  currentExerciseInBlock: widget.currentExerciseInBlock,
                  totalExerciseInBlock: widget.totalExerciseInBlock,
                )),
            CtAndCrBottomWidget(
              workoutModel: widget.workoutModel,
              onPrevious: widget.onPrevious,
              onNext: widget.onNext,
              isCircuitRep: widget.isCircuitRep,
              isPlaying: widget.isPlaying,
              currentExerciseData: widget.currentExerciseData.values.first,
              nextElementText: widget.nextElementText,
            )
          ],
        ),
        RestCountDownWidget(
            restTimer: widget.restTimer,
            bottomWidget: RestBottomWidget(
              prevRestButtonFn: () {
                widget.onPrevious();
              },
              isRestPlaying: widget.isRestPlaying,
              restLinear: widget.restLinear,
              mainRestNotifier: widget.mainRestNotifier,
              restTimer: widget.restTimer,
            ),
            mainRestNotifier: widget.mainRestNotifier,
            restLinear: widget.restLinear,
            mainRest: widget.mainRest,
            totalRounds: widget.totalRounds,
            currentRound: widget.currentRound,
            subtitle: widget.currentExerciseData.values.first.name),
        GetReadyCountDownWidget(
          secondsCountDown: widget.secondsCountDown,
          title: context.loc.getReadyForText,
          subTitle: widget.currentExerciseData.values.first.name,
          everyTimeExerciseTimer: widget.everyTimeExerciseTimer,
        ),
      ],
    );
  }
}

class CtAndCrBottomWidget extends StatefulWidget {
  final ValueNotifier<bool> isPlaying;
  final ExerciseModel currentExerciseData;

  final String nextElementText;
  final bool isCircuitRep;
  final WorkoutModel workoutModel;
  final void Function() onPrevious;
  final void Function() onNext;

  const CtAndCrBottomWidget(
      {super.key,
      required this.workoutModel,
      required this.onPrevious,
      required this.onNext,
      required this.isCircuitRep,
      required this.isPlaying,
      required this.currentExerciseData,
      required this.nextElementText});

  @override
  State<CtAndCrBottomWidget> createState() => _CtAndCrBottomWidgetState();
}

class _CtAndCrBottomWidgetState extends State<CtAndCrBottomWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CustomElevatedButtonWidget(
                      radius: 16,
                      btnColor: AppColor.buttonTertiaryColor,
                      onPressed: widget.onPrevious,
                      childPadding: const EdgeInsets.symmetric(vertical: 16),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(context.loc.buttonText('previous'),
                            style: AppTypography.label16MD.copyWith(
                                color: AppColor.buttonSecondaryColor)),
                      )),
                ),
              ),
              8.width(),
              widget.isCircuitRep == false
                  ? Expanded(
                      flex: 2,
                      child: ValueListenableBuilder<bool>(
                          valueListenable: widget.isPlaying,
                          builder: (_, value, child) {
                            if (value == true) {
                              WakelockPlus.enable();
                            }
                            return CustomElevatedButtonWidget(
                              childPadding:
                                  const EdgeInsets.only(top: 12, bottom: 12),
                              btnColor: value == true
                                  ? AppColor.buttonTertiaryColor
                                  : null,
                              onPressed: () {
                                widget.isPlaying.value =
                                    !widget.isPlaying.value;
                                if (EveentTriggered.workout_player_pause !=
                                    null) {
                                  EveentTriggered.workout_player_pause!(
                                      widget.workoutModel.title.toString(),
                                      widget.workoutModel.id.toString(),
                                      widget.currentExerciseData.name
                                          .toString());
                                }
                              },
                              child: value == true
                                  ? Icon(
                                      Icons.pause,
                                      color: AppColor.buttonSecondaryColor,
                                      size: 32,
                                    )
                                  : Icon(
                                      Icons.play_arrow_rounded,
                                      color: AppColor.buttonLabelColor,
                                      size: 32,
                                    ),
                            );
                          }),
                    )
                  : const SizedBox.shrink(),
              8.width(),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: CustomElevatedButtonWidget(
                      radius: 16,
                      childPadding: const EdgeInsets.symmetric(vertical: 16),
                      onPressed: widget.onNext,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.nextElementText == ""
                              ? context.loc.doneText
                              : context.loc.nextText,
                          style: AppTypography.label16MD
                              .copyWith(color: AppColor.textInvertEmphasis),
                        ),
                      )),
                ),
              )
            ],
          ),
          if (widget.nextElementText != '')
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                '${context.loc.upNext}: ${widget.nextElementText}',
                style: AppTypography.label12XSM
                    .copyWith(color: AppColor.textPrimaryColor),
              ),
            )
        ],
      ),
    );
  }
}

class CircuitTimeGoalTargetWidget extends StatefulWidget {
  final Map<String, String> goalTargetsValue;
  final int totalRounds;
  final int currentRound;
  final int currentExerciseInBlock;
  final int totalExerciseInBlock;
  final int mainWork;
  final ValueNotifier<bool> isPlaying;
  final String nextElementText;
  final bool isCircuitRep;
  final void Function() timerFnNextElement;
  final void Function(String) triggerGetReadyFn;

  const CircuitTimeGoalTargetWidget({
    super.key,
    required this.timerFnNextElement,
    required this.triggerGetReadyFn,
    required this.isCircuitRep,
    required this.mainWork,
    required this.isPlaying,
    required this.nextElementText,
    required this.goalTargetsValue,
    required this.totalRounds,
    required this.currentRound,
    required this.currentExerciseInBlock,
    required this.totalExerciseInBlock,
  });

  @override
  State<CircuitTimeGoalTargetWidget> createState() =>
      _CircuitTimeGoalTargetWidgetState();
}

class _CircuitTimeGoalTargetWidgetState
    extends State<CircuitTimeGoalTargetWidget> {
  Timer? goalDurationTimer;

  ValueNotifier<int> goalDurationNotifier = ValueNotifier(0);
  ValueNotifier<int> goalProgressDurationNotifier = ValueNotifier(0);
  dynamic totalTime;
  int min = 0;
  int max = 0;

  @override
  void initState() {
    WakelockPlus.enable();
    setPrimaryTargets();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant CircuitTimeGoalTargetWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setPrimaryTargets();
  }

  @override
  void dispose() {
    goalDurationTimer?.cancel();

    super.dispose();
  }

  @override
  void deactivate() {
    goalDurationTimer?.cancel();

    super.deactivate();
  }

  setPrimaryTargets() {
    goalDurationTimer?.cancel();
    goalDurationTimer = null;
    if (widget.isCircuitRep) {
      totalTime = widget.goalTargetsValue.entries.first.value.toString();
    } else {
      totalTime = widget.mainWork.toInt();
      goalDurationNotifier.value = widget.mainWork.toInt();
      goalProgressDurationNotifier.value = 0;
      goalDurationTimer =
          Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (widget.isPlaying.value && goalDurationNotifier.value > 0) {
          goalDurationNotifier.value -= 1;
          goalProgressDurationNotifier.value += 1;
        } else if (widget.isPlaying.value && goalDurationNotifier.value == 0) {
          if (widget.nextElementText == "Training") {
            widget.triggerGetReadyFn(widget.nextElementText);
          } else if (widget.nextElementText == "Cool Down") {
            widget.triggerGetReadyFn(widget.nextElementText);
          } else if (widget.nextElementText != "") {
            widget.timerFnNextElement();
          }
          goalDurationTimer?.cancel();
        }
      });
    }
  }

  Widget mordernDurationMSTextWidget(
      {required Duration clockTimer, Color? color}) {
    final formatTime =
        "${clockTimer.inMinutes.toString().padLeft(2, '0')}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}";
    return DurationFormatWidget(
      formatTime: formatTime,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          fit: StackFit.loose,
          clipBehavior: Clip.none,
          children: [
            Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                width: context.dynamicWidth * 0.85,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        width: 1.5, color: AppColor.borderSecondaryColor)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: context.dynamicWidth * 0.2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.currentRound.toString(),
                            style: AppTypography.title24XL
                                .copyWith(color: AppColor.textEmphasisColor),
                          ),
                          1.width(),
                          Text(
                            '/',
                            style: AppTypography.title18LG
                                .copyWith(color: AppColor.textSubTitleColor),
                          ),
                          1.width(),
                          Text(
                            widget.totalRounds.toString(),
                            style: AppTypography.title24XL
                                .copyWith(color: AppColor.textEmphasisColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: VerticalDivider(
                        color: AppColor.borderSecondaryColor,
                        thickness: 1.5,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: widget.isCircuitRep == false
                            ? ValueListenableBuilder<bool>(
                                valueListenable: widget.isPlaying,
                                builder: (_, isPlayvalue, child) {
                                  return ValueListenableBuilder<int>(
                                      valueListenable: goalDurationNotifier,
                                      builder: (_, value, child) {
                                        if (isPlayvalue == true) {
                                          WakelockPlus.enable();
                                        }
                                        return mordernDurationMSTextWidget(
                                            clockTimer:
                                                Duration(seconds: value),
                                            color: isPlayvalue
                                                ? AppColor.textEmphasisColor
                                                : AppColor.textPrimaryColor);
                                      });
                                })
                            : FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Center(
                                  child: Text(
                                    totalTime.toString(),
                                    style: AppTypography.title60_6XL.copyWith(
                                        color: AppColor.textEmphasisColor),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: VerticalDivider(
                        color: AppColor.borderSecondaryColor,
                        thickness: 1.5,
                      ),
                    ),
                    SizedBox(
                      width: context.dynamicWidth * 0.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(widget.currentExerciseInBlock.toString(),
                              style: AppTypography.title24XL
                                  .copyWith(color: AppColor.textEmphasisColor)),
                          1.width(),
                          Text('/',
                              style: AppTypography.title18LG
                                  .copyWith(color: AppColor.textSubTitleColor)),
                          1.width(),
                          Text(widget.totalExerciseInBlock.toString(),
                              style: AppTypography.title24XL.copyWith(
                                color: AppColor.textEmphasisColor,
                              ))
                        ],
                      ),
                    ),
                  ],
                )),
            Positioned(
              top: -8,
              left: 22,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                    color: AppColor.surfaceBackgroundColor,
                    border: Border.all(
                      color: AppColor.borderSecondaryColor,
                    ),
                    borderRadius: BorderRadius.circular(4)),
                child: Text(
                  context.loc.roundText,
                  style: AppTypography.label10XXSM
                      .copyWith(color: AppColor.textPrimaryColor),
                ),
              ),
            ),
            Positioned(
              top: -8,
              left: 12,
              right: 12,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                      color: AppColor.surfaceBackgroundColor,
                      border: Border.all(
                        color: AppColor.borderSecondaryColor,
                      ),
                      borderRadius: BorderRadius.circular(4)),
                  child: Text(
                    widget.isCircuitRep
                        ? context.loc.titleTargetText('reps')
                        : context.loc.titleTargetText("sec"),
                    style: AppTypography.label10XXSM
                        .copyWith(color: AppColor.textPrimaryColor),
                  ),
                ),
              ),
            ),
            Positioned(
              top: -8,
              right: 22,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                    color: AppColor.surfaceBackgroundColor,
                    border: Border.all(
                      color: AppColor.borderSecondaryColor,
                    ),
                    borderRadius: BorderRadius.circular(4)),
                child: Text(
                  context.loc.exerciseText,
                  style: AppTypography.label10XXSM
                      .copyWith(color: AppColor.textPrimaryColor),
                ),
              ),
            )
          ],
        ),
        if (widget.isCircuitRep == false)
          Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
              child: ValueListenableBuilder<int>(
                  valueListenable: goalProgressDurationNotifier,
                  builder: (_, value1, child) {
                    return TweenAnimationBuilder(
                      duration: const Duration(seconds: 1),
                      tween: Tween(begin: 0.0, end: value1),
                      builder: (_, value, child) => CustomSliderWidget(
                        backgroundColor:
                            AppColor.surfaceBackgroundSecondaryColor,
                        valueColor: AppColor.linkSecondaryColor,
                        sliderValue: value.toDouble(),
                        division: totalTime,
                      ),
                    );
                  })),
      ],
    );
  }
}
