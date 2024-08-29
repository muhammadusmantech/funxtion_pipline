import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:ui_tool_kit/ui_tool_kit.dart';

class RftWorkoutWidget extends StatefulWidget {
  final ValueNotifier<bool> isRestPlaying;
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
  final void Function() onPrevious, onNext;
  const RftWorkoutWidget({
    super.key,
    required this.workoutModel,
    required this.onPrevious,
    required this.onNext,
    required this.itemTypeTitle,
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
    required this.isRestPlaying,
    required this.listCurrentExerciseData,
  });

  @override
  State<RftWorkoutWidget> createState() => _RftWorkoutWidgetState();
}

class _RftWorkoutWidgetState extends State<RftWorkoutWidget> {
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
                      child: widget.listCurrentExerciseData.length > 3
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
              child: Wrap(
                  children: widget.listCurrentExerciseData.first.keys.first
                      .currentGoalTargets!.entries
                      .map((e) => RFTExerciseGoalTargetWidget(
                            e: e,
                            currentRound: widget.currentRound,
                            isPlaying: widget.isPlaying,
                            isRestPlaying: widget.isRestPlaying,
                            isSetComplete: widget.isSetComplete,
                            totalRounds: widget.totalRounds,
                            goalTargetsValue: widget.listCurrentExerciseData
                                .first.keys.first.currentGoalTargets!,
                          ))
                      .toList()),
            ),
            RftBottomWidget(
              workoutModel: widget.workoutModel,
              onPrevious: widget.onPrevious,
              onNext: widget.onNext,
              isPlaying: widget.isPlaying,
              listCurrentExerciseData: widget.listCurrentExerciseData,
              nextElementText: widget.nextElementText,
              currentRound: widget.currentRound,
              totalRounds: widget.totalRounds,
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
          title: context.loc.getReadyForText,
          subTitle: widget.listCurrentExerciseData
              .map((e) => e.values.first.name)
              .join(','),
          everyTimeExerciseTimer: widget.everyTimeExerciseTimer,
        ),
      ],
    );
  }
}

class TargetsContainerWidget extends StatelessWidget {
  final bool isSingleExercise;
  final String metric, value;
  const TargetsContainerWidget({
    super.key,
    required this.metric,
    required this.value,
    this.isSingleExercise = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: AppColor.surfaceBackgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColor.borderSecondaryColor, width: 2)),
        child: RichText(
            text: TextSpan(children: [
          TextSpan(
              text: value,
              style: isSingleExercise
                  ? AppTypography.title24XL
                      .copyWith(color: AppColor.textEmphasisColor)
                  : AppTypography.title14XS
                      .copyWith(color: AppColor.textEmphasisColor)),
          TextSpan(
              text: " ${metric.removeNumbersFromString}",
              style: isSingleExercise
                  ? AppTypography.label14SM
                      .copyWith(color: AppColor.textSubTitleColor)
                  : AppTypography.label10XXSM
                      .copyWith(color: AppColor.textSubTitleColor))
        ])));
  }
}

class RftBottomWidget extends StatefulWidget {
  final ValueNotifier<bool> isPlaying;
  final List<Map<ExerciseDetailModel, ExerciseModel>> listCurrentExerciseData;
  final String nextElementText;
  final int currentRound;
  final int totalRounds;

  final WorkoutModel workoutModel;
  final void Function() onPrevious;
  final void Function() onNext;
  const RftBottomWidget(
      {super.key,
      required this.workoutModel,
      required this.onPrevious,
      required this.onNext,
      required this.isPlaying,
      required this.listCurrentExerciseData,
      required this.nextElementText,
      required this.currentRound,
      required this.totalRounds});

  @override
  State<RftBottomWidget> createState() => _RftBottomWidgetState();
}

class _RftBottomWidgetState extends State<RftBottomWidget> {
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
                          widget.currentRound == widget.totalRounds &&
                                      widget.nextElementText == '' ||
                                  widget.totalRounds == 1
                              ? context.loc.doneText
                              : context.loc.setDone,
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

class RFTExerciseGoalTargetWidget extends StatefulWidget {
  final Map<String, String> goalTargetsValue;
  final ValueNotifier<bool> isSetComplete;
  final ValueNotifier<bool> isRestPlaying;
  final ValueNotifier<bool> isPlaying;
  final int currentRound;
  final int totalRounds;

  final MapEntry<String, String> e;

  const RFTExerciseGoalTargetWidget({
    super.key,
    required this.e,
    required this.currentRound,
    required this.isPlaying,
    required this.isRestPlaying,
    required this.isSetComplete,
    required this.totalRounds,
    required this.goalTargetsValue,
  });

  @override
  State<RFTExerciseGoalTargetWidget> createState() =>
      _RFTExerciseGoalTargetWidgetState();
}

class _RFTExerciseGoalTargetWidgetState
    extends State<RFTExerciseGoalTargetWidget> {
  Timer? goalDurationTimer;

  ValueNotifier<int> goalProgressDurationNotifier = ValueNotifier(0);

  @override
  void initState() {
    setPrimaryTargets();

    super.initState();
  }

  @override
  void dispose() {
    goalDurationTimer?.cancel();

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant RFTExerciseGoalTargetWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentRound == 1) {
      setPrimaryTargets();
    }
  }

  @override
  void deactivate() {
    goalDurationTimer?.cancel();

    super.deactivate();
  }

  setPrimaryTargets() {
    // if (widget.currentRound == 1) {
    goalDurationTimer?.cancel();
    goalDurationTimer = null;
    goalProgressDurationNotifier.value = 0;
    goalDurationTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (widget.isPlaying.value) {
        goalProgressDurationNotifier.value += 1;
      }
    });
    // }
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
                width: context.dynamicWidth * 0.5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        width: 1.5, color: AppColor.borderSecondaryColor)),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ValueListenableBuilder<bool>(
                      valueListenable: widget.isPlaying,
                      builder: (_, isPlayvalue, child) {
                        return ValueListenableBuilder<int>(
                            valueListenable: goalProgressDurationNotifier,
                            builder: (_, value, child) {
                              return mordernDurationMSTextWidget(
                                  clockTimer: Duration(seconds: value),
                                  color: isPlayvalue
                                      ? AppColor.textEmphasisColor
                                      : AppColor.textPrimaryColor);
                            });
                      }),
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
                    context.loc.titleTargetText("sec"),
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
            time: ValueNotifier(0),
            toShowTimeProgressBar: false,
            totalTime: 0,
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
