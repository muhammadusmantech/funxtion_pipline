import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ui_tool_kit/ui_tool_kit.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class SeWorkoutWidget extends StatefulWidget {
  final String itemTypeTitle;
  final ValueNotifier<bool> isRestPlaying;
  final ValueNotifier<int> mainRestNotifier;
  final int mainRest;
  final Timer? restTimer;
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

  final WorkoutModel workoutModel;
  final void Function() onPrevious, onNext, timerFnNextElement;
  final void Function(String) triggerGetReadyFn;

  const SeWorkoutWidget(
      {super.key,
      required this.workoutModel,
      required this.onPrevious,
      required this.onNext,
      required this.timerFnNextElement,
      required this.triggerGetReadyFn,
      required this.itemTypeTitle,
      required this.mainNotes,
      required this.isSetComplete,
      required this.secondsCountDown,
      required this.restLinear,
      this.everyTimeExerciseTimer,
      required this.totalRounds,
      required this.currentRound,
      required this.isPlaying,
      required this.nextElementText,
      required this.mainWork,
      required this.exerciseNotes,
      required this.currentExerciseData,
      required this.isRestPlaying,
      required this.mainRestNotifier,
      required this.mainRest,
      this.restTimer});

  @override
  State<SeWorkoutWidget> createState() => _SeWorkoutWidgetState();
}

class _SeWorkoutWidgetState extends State<SeWorkoutWidget> {
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
                child: SingleExerciseGoalTargetWidget(
                  e: widget.currentExerciseData.keys.first.currentGoalTargets!
                      .entries.first,
                  timerFnNextElement: widget.timerFnNextElement,
                  triggerGetReadyFn: widget.triggerGetReadyFn,
                  mainWork: widget.mainWork,
                  isPlaying: widget.isPlaying,
                  nextElementText: widget.nextElementText,
                  goalTargetsValue:
                      widget.currentExerciseData.keys.first.currentGoalTargets!,
                  isSetComplete: widget.isSetComplete,
                  currentRound: widget.currentRound,
                  totalRounds: widget.totalRounds,
                )),
            SeBottomWidget(
              workoutModel: widget.workoutModel,
              onPrevious: widget.onPrevious,
              onNext: widget.onNext,
              isPlaying: widget.isPlaying,
              currentExerciseData: widget.currentExerciseData,
              nextElementText: widget.nextElementText,
              totalRounds: widget.totalRounds,
              currentRound: widget.currentRound,
            )
          ],
        ),
        ValueListenableBuilder(
          valueListenable: widget.isSetComplete,
          builder: (_, value, child) {
            return Positioned(
              top: 0,
              bottom: 150,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedContainer(
                    alignment: Alignment.center,
                    height: value == true ? 200 : 0,
                    width: value == true ? 200 : 0,
                    curve: Curves.bounceInOut,
                    duration: const Duration(milliseconds: 650),
                    child: Image.asset(AppAssets.completeSetCheckIcon)),
              ),
            );
          },
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

class SeBottomWidget extends StatelessWidget {
  final ValueNotifier<bool> isPlaying;
  final Map<ExerciseDetailModel, ExerciseModel> currentExerciseData;

  final String nextElementText;
  final int totalRounds;
  final int currentRound;

  final WorkoutModel workoutModel;
  final void Function() onPrevious;
  final void Function() onNext;

  const SeBottomWidget(
      {super.key,
      required this.workoutModel,
      required this.onPrevious,
      required this.onNext,
      required this.isPlaying,
      required this.currentExerciseData,
      required this.nextElementText,
      required this.totalRounds,
      required this.currentRound});

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
                      onPressed: onPrevious,
                      childPadding: const EdgeInsets.symmetric(vertical: 16),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(context.loc.buttonText('previous'),
                            style: AppTypography.label16MD.copyWith(
                                color: AppColor.buttonSecondaryColor)),
                      )),
                ),
              ),
              if (currentExerciseData.keys.first.currentGoalTargets!.entries
                  .toList()[0]
                  .key
                  .contains("sec")) ...[
                8.width(),
                Expanded(
                  flex: 2,
                  child: ValueListenableBuilder<bool>(
                      valueListenable: isPlaying,
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
                            isPlaying.value = !isPlaying.value;
                            if (EveentTriggered.workout_player_pause != null) {
                              EveentTriggered.workout_player_pause!(
                                  workoutModel.title.toString(),
                                  workoutModel.id.toString(),
                                  currentExerciseData.values.first.name
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
                ),
                8.width(),
              ],
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: CustomElevatedButtonWidget(
                      radius: 16,
                      childPadding: const EdgeInsets.symmetric(vertical: 16),
                      onPressed: onNext,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          currentRound == totalRounds &&
                                      nextElementText == '' ||
                                  totalRounds == 1
                              ? context.loc.doneText
                              : currentExerciseData
                                      .keys.first.currentGoalTargets!.entries
                                      .toList()[0]
                                      .key
                                      .contains("sec")
                                  ? context.loc.skip
                                  : context.loc.setDone,
                          style: AppTypography.label16MD
                              .copyWith(color: AppColor.textInvertEmphasis),
                        ),
                      )),
                ),
              )
            ],
          ),
          if (nextElementText != '')
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                '${context.loc.upNext}: $nextElementText',
                style: AppTypography.label12XSM
                    .copyWith(color: AppColor.textPrimaryColor),
              ),
            )
        ],
      ),
    );
  }
}

class SingleExerciseGoalTargetWidget extends StatefulWidget {
  final Map<String, String> goalTargetsValue;
  final ValueNotifier<bool> isSetComplete;
  final int currentRound;
  final int totalRounds;
  final int mainWork;
  final ValueNotifier<bool> isPlaying;
  final String nextElementText;

  final MapEntry<String, String> e;

  final void Function() timerFnNextElement;
  final void Function(String) triggerGetReadyFn;

  const SingleExerciseGoalTargetWidget({
    super.key,
    required this.timerFnNextElement,
    required this.triggerGetReadyFn,
    required this.e,
    required this.mainWork,
    required this.isPlaying,
    required this.nextElementText,
    required this.goalTargetsValue,
    required this.isSetComplete,
    required this.currentRound,
    required this.totalRounds,
  });

  @override
  State<SingleExerciseGoalTargetWidget> createState() =>
      _SingleExerciseGoalTargetWidgetState();
}

class _SingleExerciseGoalTargetWidgetState
    extends State<SingleExerciseGoalTargetWidget> {
  Timer? goalDurationTimer;

  ValueNotifier<int> goalDurationNotifier = ValueNotifier(0);
  ValueNotifier<int> goalProgressDurationNotifier = ValueNotifier(0);
  int totalTime = 0;
  int min = 0;
  int max = 0;

  @override
  void initState() {
    setPrimaryTargets();

    super.initState();
  }

  @override
  void deactivate() {
    goalDurationTimer?.cancel();

    super.deactivate();
  }

  setPrimaryTargets() {
    goalDurationTimer?.cancel();
    goalDurationTimer = null;
    goalProgressDurationNotifier.value = 0;
    if (widget.e.key.contains('sec')) {
      if (widget.e.value.contains("-")) {
        int atIndex = widget.e.value.indexOf("-");
        min = int.parse(widget.e.value.substring(0, atIndex - 1));
        max = int.parse(widget.e.value.substring(atIndex + 1));
        goalDurationNotifier.value = max;
        goalDurationTimer =
            Timer.periodic(const Duration(seconds: 1), (timer) async {
          if (widget.isPlaying.value && goalDurationNotifier.value > 0) {
            goalDurationNotifier.value -= 1;
            goalProgressDurationNotifier.value += 1;
          } else if (widget.isPlaying.value &&
              goalDurationNotifier.value == 0) {
            if (widget.nextElementText == "Training") {
              widget.triggerGetReadyFn(widget.nextElementText);
            } else if (widget.nextElementText == "CoolDown") {
              widget.triggerGetReadyFn(widget.nextElementText);
            } else if (widget.nextElementText != "") {
              widget.timerFnNextElement();
            }
            goalDurationTimer?.cancel();
          }
        });
      } else {
        totalTime = int.parse(widget.e.value);
        goalDurationNotifier.value = int.parse(widget.e.value);
        goalDurationTimer =
            Timer.periodic(const Duration(seconds: 1), (timer) async {
          if (widget.isPlaying.value && goalDurationNotifier.value > 0) {
            goalDurationNotifier.value -= 1;
            goalProgressDurationNotifier.value += 1;
          } else if (widget.isPlaying.value &&
              goalDurationNotifier.value == 0) {
            if (widget.nextElementText == "Training") {
              widget.triggerGetReadyFn(widget.nextElementText);
            } else if (widget.nextElementText == "Cool Down") {
              widget.triggerGetReadyFn(widget.nextElementText);
            } else if (widget.nextElementText == "" &&
                widget.currentRound < widget.totalRounds &&
                widget.totalRounds > 1) {
              widget.timerFnNextElement();
            } else if (widget.nextElementText != "") {
              widget.timerFnNextElement();
            }
            goalDurationTimer?.cancel();
          }
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant SingleExerciseGoalTargetWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setPrimaryTargets();
  }

  @override
  void dispose() {
    goalDurationTimer?.cancel();

    super.dispose();
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
          clipBehavior: Clip.none,
          children: [
            Container(
                padding: widget.e.key.contains("sec")
                    ? const EdgeInsets.all(8)
                    : const EdgeInsets.only(
                        left: 20, right: 20, top: 8, bottom: 8),
                width: widget.e.key.contains("sec")
                    ? context.dynamicWidth * 0.52
                    : null,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        width: 1.5, color: AppColor.borderSecondaryColor)),
                child: widget.e.key.contains("sec")
                    ? ValueListenableBuilder<bool>(
                        valueListenable: widget.isPlaying,
                        builder: (_, isPlayvalue, child) {
                          return ValueListenableBuilder<int>(
                              valueListenable: goalDurationNotifier,
                              builder: (_, value, child) {
                                return mordernDurationMSTextWidget(
                                    clockTimer: Duration(seconds: value),
                                    color: isPlayvalue
                                        ? AppColor.textEmphasisColor
                                        : AppColor.textPrimaryColor);
                              });
                        })
                    : Text(
                        widget.e.value.toString(),
                        style: AppTypography.title60_6XL
                            .copyWith(color: AppColor.textEmphasisColor),
                      )),
            Positioned(
              top: -8,
              left: 0,
              right: 0,
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
                    context.loc.titleTargetText(
                        widget.e.key.removeNumbersFromString.trim()),
                    style: AppTypography.label10XXSM
                        .copyWith(color: AppColor.textPrimaryColor),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: LinearProgressBarWidget(
            time: goalProgressDurationNotifier,
            toShowTimeProgressBar: true,
            totalTime: max == 0 ? totalTime : max,
            totalRounds: widget.totalRounds,
            currentRound: widget.currentRound,
            goalTargetsValue: widget.goalTargetsValue,
            isSetComplete: widget.isSetComplete,
          ),
        ),
      ],
    );
  }
}
