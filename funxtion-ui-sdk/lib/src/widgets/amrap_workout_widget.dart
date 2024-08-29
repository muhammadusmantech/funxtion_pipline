import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ui_tool_kit/ui_tool_kit.dart';

class AmrapWorkoutWidget extends StatefulWidget {
  final String itemTypeTitle;

  final List<Map<ExerciseDetailModel, ExerciseModel>> listCurrentExerciseData;

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
  const AmrapWorkoutWidget(
      {super.key,
      required this.workoutModel,
      required this.onPrevious,
      required this.onNext,
      required this.timerFnNextElement,
      required this.triggerGetReadyFn,
      required this.itemTypeTitle,
      required this.listCurrentExerciseData,
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
      required this.exerciseNotes});

  @override
  State<AmrapWorkoutWidget> createState() => _AmrapWorkoutWidgetState();
}

class _AmrapWorkoutWidgetState extends State<AmrapWorkoutWidget> {
  ValueNotifier<bool> isTrainerNotesOpen = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  8.height(),
                               ItemTypeTitleRowWidget(
                      itemTypeTitle: widget.itemTypeTitle,
                      isPlaying: widget.isPlaying,
                      workoutModel: widget.workoutModel),
                  Flexible(
                      child: widget.listCurrentExerciseData.length == 1
                          ? SingleExerciseViewWidget(
                              isShowGoalTarget: true,
                              currentExerciseData:
                                  widget.listCurrentExerciseData.first,
                              isPlaying: widget.isPlaying,
                              itemTypeTitle: widget.itemTypeTitle,
                              workoutModel: widget.workoutModel,
                              mainNotes: widget.mainNotes,
                              exerciseNotes: widget.exerciseNotes)
                          : widget.listCurrentExerciseData.length > 3
                              ? GridExerciseView(
                                  listCurrentExerciseData:
                                      widget.listCurrentExerciseData,
                                  isPlaying: widget.isPlaying,
                                  itemTypeTitle: widget.itemTypeTitle,
                                  workoutModel: widget.workoutModel)
                              : ListExerciseViewWidget(
                                  listCurrentExerciseData:
                                      widget.listCurrentExerciseData,
                                  isPlaying: widget.isPlaying,
                                  itemTypeTitle: widget.itemTypeTitle,
                                  workoutModel: widget.workoutModel)),
                  if (widget.mainNotes.trim() != "" ||
                      widget.exerciseNotes.trim() != "")
                    TrainerNoteWidget(
                        isTrainerNotesOpen: isTrainerNotesOpen,
                        eventsTriggeredFn: () {
                          if (EveentTriggered.workout_player_trainer_notes !=
                              null) {
                            EveentTriggered.workout_player_trainer_notes!(
                                widget.listCurrentExerciseData
                                    .map((e) => e.values.first.name)
                                    .join(',')
                                    .toString(),
                                widget.listCurrentExerciseData
                                    .map((e) => e.values.first.id)
                                    .join(',')
                                    .toString(),
                                widget.workoutModel.title.toString(),
                                widget.workoutModel.id.toString());
                          }
                        },
                        mainNotes: widget.mainNotes,
                        exerciseNotes: widget.exerciseNotes)
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: AmrapTargetWidget(
                  timerFnNextElement: widget.timerFnNextElement,
                  triggerGetReadyFn: widget.triggerGetReadyFn,
                  mainWork: widget.mainWork,
                  isPlaying: widget.isPlaying,
                  nextElementText: widget.nextElementText,
                )),
            AmrapBottomWidget(
              workoutModel: widget.workoutModel,
              onPrevious: widget.onPrevious,
              onNext: widget.onNext,
              isPlaying: widget.isPlaying,
              nextElementText: widget.nextElementText,
              listCurrentExerciseData: widget.listCurrentExerciseData,
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
        GetReadyCountDownWidget(
          secondsCountDown: widget.secondsCountDown,
          title:
              "${context.loc.getReadyForText} ${widget.totalRounds > 1 ? "set ${widget.currentRound} of" : ""}",
          subTitle: widget.listCurrentExerciseData
              .map((e) => e.values.first.name)
              .join(','),
          everyTimeExerciseTimer: widget.everyTimeExerciseTimer,
        ),
      ],
    );
  }
}

class AmrapBottomWidget extends StatefulWidget {
  final ValueNotifier<bool> isPlaying;
  final List<Map<ExerciseDetailModel, ExerciseModel>> listCurrentExerciseData;
  final String nextElementText;

  final WorkoutModel workoutModel;

  final void Function() onPrevious;
  final void Function() onNext;
  const AmrapBottomWidget(
      {super.key,
      required this.workoutModel,
      required this.onPrevious,
      required this.onNext,
      required this.isPlaying,
      required this.nextElementText,
      required this.listCurrentExerciseData});

  @override
  State<AmrapBottomWidget> createState() => _AmrapBottomWidgetState();
}

class _AmrapBottomWidgetState extends State<AmrapBottomWidget> {
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
              Expanded(
                flex: 2,
                child: ValueListenableBuilder<bool>(
                    valueListenable: widget.isPlaying,
                    builder: (_, value, child) {
                      return CustomElevatedButtonWidget(
                        childPadding:
                            const EdgeInsets.only(top: 12, bottom: 12),
                        btnColor:
                            value == true ? AppColor.buttonTertiaryColor : null,
                        onPressed: () {
                          widget.isPlaying.value = !widget.isPlaying.value;
                          if (EveentTriggered.workout_player_pause != null) {
                            EveentTriggered.workout_player_pause!(
                                widget.workoutModel.title.toString(),
                                widget.workoutModel.id.toString(),
                                widget.listCurrentExerciseData
                                    .map((e) => e.values.first.name)
                                    .join(',')
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
                          context.loc.doneText,
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

class AmrapTargetWidget extends StatefulWidget {
  final int mainWork;
  final ValueNotifier<bool> isPlaying;
  final void Function() timerFnNextElement;
  final void Function(String) triggerGetReadyFn;
  final String nextElementText;
  const AmrapTargetWidget({
    super.key,
    required this.triggerGetReadyFn,
    required this.timerFnNextElement,
    required this.mainWork,
    required this.isPlaying,
    required this.nextElementText,
  });

  @override
  State<AmrapTargetWidget> createState() => _AmrapTargetWidgetState();
}

class _AmrapTargetWidgetState extends State<AmrapTargetWidget> {
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

  @override
  void didUpdateWidget(covariant AmrapTargetWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setPrimaryTargets();
  }

  @override
  void dispose() {
    goalDurationTimer?.cancel();

    super.dispose();
  }

  setPrimaryTargets() {
    goalDurationTimer?.cancel();
    goalDurationTimer = null;
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
        } else if (widget.nextElementText == "") {
          widget.timerFnNextElement();
        } else if (widget.nextElementText != "") {
          widget.timerFnNextElement();
        }
        goalDurationTimer?.cancel();
      }
    });
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
                padding: const EdgeInsets.all(8),
                width: context.dynamicWidth * 0.5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        width: 1.5, color: AppColor.borderSecondaryColor)),
                child: ValueListenableBuilder<bool>(
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
                    })),
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
                    context.loc.titleTargetText('sec'),
                    style: AppTypography.label10XXSM
                        .copyWith(color: AppColor.textPrimaryColor),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
            child: ValueListenableBuilder<int>(
                valueListenable: goalProgressDurationNotifier,
                builder: (_, value1, child) {
                  return TweenAnimationBuilder(
                    duration: const Duration(seconds: 1),
                    tween: Tween(begin: 0.0, end: value1),
                    builder: (_, value, child) => CustomSliderWidget(
                      backgroundColor: AppColor.surfaceBackgroundSecondaryColor,
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
