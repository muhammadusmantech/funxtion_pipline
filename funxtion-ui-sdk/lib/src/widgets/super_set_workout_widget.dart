import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../ui_tool_kit.dart';

class SuperSetWorkoutWidget extends StatefulWidget {
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
  final ValueNotifier<bool> isRestPlaying;
  final String nextElementText;
  final int mainWork;
  final ValueNotifier<int> mainRestNotifier;
  final int mainRest;
  final Timer? restTimer;
  final WorkoutModel workoutModel;
  final void Function() onPrevious;
  final void Function()? onNext;
  const SuperSetWorkoutWidget(
      {super.key,
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
      required this.listCurrentExerciseData,
      required this.mainRestNotifier,
      required this.mainRest,
      this.restTimer,
      required this.isRestPlaying});

  @override
  State<SuperSetWorkoutWidget> createState() => _SuperSetWorkoutWidgetState();
}

class _SuperSetWorkoutWidgetState extends State<SuperSetWorkoutWidget> {
  late ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

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
                    child: RawScrollbar(
                        controller: _scrollController,
                        thumbColor: AppColor.surfaceBrandDarkColor,
                        trackColor: AppColor.surfaceBackgroundSecondaryColor,
                        radius: const Radius.circular(26),
                        thickness: 8,
                        interactive: true,
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: ListExerciseViewWidget(
                            scrollController: _scrollController,
                            listCurrentExerciseData:
                                widget.listCurrentExerciseData,
                            isPlaying: widget.isPlaying,
                            itemTypeTitle: widget.itemTypeTitle,
                            workoutModel: widget.workoutModel)),
                  ),
                  if (widget.mainNotes.trim() != "" ||
                      widget.exerciseNotes.trim() != "")
                    TrainerNoteWidget(
                        isTrainerNotesOpen: isTrainerNotesOpen,
                        eventsTriggeredFn: () {
                          if (EveentTriggered.workout_player_trainer_notes !=
                              null) {
                            EveentTriggered.workout_player_trainer_notes!(
                                widget.listCurrentExerciseData
                                    .map(
                                      (e) => e.values.first.name,
                                    )
                                    .join(','),
                                widget.listCurrentExerciseData
                                    .map(
                                      (e) => e.values.first.id,
                                    )
                                    .join(','),
                                widget.workoutModel.title.toString(),
                                widget.workoutModel.id.toString());
                          }
                        },
                        mainNotes: widget.mainNotes,
                        exerciseNotes: widget.exerciseNotes)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
              child: LinearProgressBarWidget(
                time: ValueNotifier(0),
                toShowTimeProgressBar: false,
                totalTime: 0,
                totalRounds: widget.totalRounds,
                currentRound: widget.currentRound,
                isSetComplete: widget.isSetComplete,
              ),
            ),
            SuperSetBottomWidget(
              onNext: widget.onNext,
              onPrevious: widget.onPrevious,
              isPlaying: widget.isPlaying,
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
          subtitle: widget.listCurrentExerciseData
              .map((e) => e.values.first.name)
              .join(','),
        ),
      ],
    );
  }
}

class SuperSetBottomWidget extends StatefulWidget {
  final ValueNotifier<bool> isPlaying;

  final String nextElementText;
  final int currentRound;
  final int totalRounds;

  final void Function()? onPrevious;
  final void Function()? onNext;
  const SuperSetBottomWidget(
      {super.key,
      this.onPrevious,
      this.onNext,
      required this.isPlaying,
      required this.nextElementText,
      required this.currentRound,
      required this.totalRounds});

  @override
  State<SuperSetBottomWidget> createState() => _SuperSetBottomWidgetState();
}

class _SuperSetBottomWidgetState extends State<SuperSetBottomWidget> {
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
