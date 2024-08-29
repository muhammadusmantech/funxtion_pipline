import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:ui_tool_kit/ui_tool_kit.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class StartWorkoutView extends StatefulWidget {
  final bool cancelTimer;
  final WorkoutModel workoutModel;
  final Map<ExerciseDetailModel, ExerciseModel> warmUpData;
  final Map<ExerciseDetailModel, ExerciseModel> trainingData;
  final Map<ExerciseDetailModel, ExerciseModel> coolDownData;
  final Map<int, String> fitnessGoalModel;
  final ValueNotifier<int> durationNotifier;

  final List<Map<String, EquipmentModel>> equipmentData;
  final FollowTrainingPlanModel? followTrainingPlanModel;

  const StartWorkoutView({
    super.key,
    required this.workoutModel,
    required this.warmUpData,
    required this.trainingData,
    required this.coolDownData,
    required this.fitnessGoalModel,
    required this.durationNotifier,
    required this.equipmentData,
    required this.followTrainingPlanModel,
    required this.cancelTimer,
  });

  @override
  State<StartWorkoutView> createState() => _StartWorkoutViewState();
}

class _StartWorkoutViewState extends State<StartWorkoutView> {
  int toPreviousPage = 0;
  bool _isButtonDisabled = false;

  String nextElementText = '';
  ValueNotifier<bool> isSetComplete = ValueNotifier(false);
  String mainNotes = '';
  String exerciseNotes = '';
  int totalExerciseInBlock = 1;
  int currentExerciseInBlock = 1;
  String itemTypeTitle = '';

  int mainWork = 0;
  ValueNotifier<int> mainRestNotifier = ValueNotifier(0);
  int mainRest = 0;
  int mainRestRound = 0;

  ValueNotifier<bool> isPlaying = ValueNotifier(true);
  ValueNotifier<bool> isRestPlaying = ValueNotifier(true);
  int totalRounds = 1;
  int currentRound = 1;

  ValueNotifier<double> sliderWarmUp = ValueNotifier(0);
  ValueNotifier<double> sliderTraining = ValueNotifier(0);
  ValueNotifier<double> sliderCoolDown = ValueNotifier(0);

  Map<ExerciseDetailModel, ExerciseModel> currentExerciseData = {};
  List<Map<ExerciseDetailModel, ExerciseModel>> listCurrentExerciseData = [];
  ValueNotifier<int> secondsCountDown = ValueNotifier(0);
  ValueNotifier<int> restLinear = ValueNotifier(5);
  Timer? restTimer;
  Timer? everyTimeExerciseTimer;

  late PageController pageController;

  Map<ExerciseDetailModel, ExerciseModel> seExercise = {};

  Map<ExerciseDetailModel, ExerciseModel> circuitTimeExercise = {};

  Map<ExerciseDetailModel, ExerciseModel> rftExercise = {};

  Map<ExerciseDetailModel, ExerciseModel> ssExercise = {};

  Map<ExerciseDetailModel, ExerciseModel> circuitRepExercise = {};

  Map<ExerciseDetailModel, ExerciseModel> amrapExercise = {};

  Map<ExerciseDetailModel, ExerciseModel> emomExercise = {};
  Timer? newTimer;

  addData(Map<ExerciseDetailModel, ExerciseModel> currentBlock) {
    for (var element in currentBlock.entries) {
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
  void initState() {
    WakelockPlus.enable();
    super.initState();
    if (widget.cancelTimer == false) {
      _startTimer();
    }
    if (EveentTriggered.workout_started != null) {
      final DateTime now = DateTime.now();
      final String formatTime = WorkoutDetailController.getFormatTimeFn(
          widget.durationNotifier.value);
      DateTime dateType = DateFormat("HH:mm:ss").parse(formatTime);
      DateTime newDate = DateTime(now.year, now.month, now.day, dateType.hour,
          dateType.minute, dateType.second);

      EveentTriggered.workout_started!(
          widget.workoutModel.title.toString(),
          newDate,
          widget.followTrainingPlanModel != null ? true : false,
          widget.followTrainingPlanModel?.trainingPlanTitle);
    }

    pageController = PageController(initialPage: 0);

    getCurrentExerciseViewFn(pageController.initialPage);
  }

  void _startTimer() {
    WakelockPlus.enable();
    if (newTimer == null && widget.durationNotifier.value == 0) {
      newTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        widget.durationNotifier.value += 1;
      });
    }
  }

  void _cancelTimer() {
    newTimer?.cancel();
    newTimer = null;
  }

  getCurrentExerciseViewFn(int index) {
    everyTimeExerciseTimer?.cancel();
    restTimer?.cancel();

    totalRounds = 1;
    circuitTimeExercise.clear();
    seExercise.clear();
    ssExercise.clear();
    circuitRepExercise.clear();
    amrapExercise.clear();
    emomExercise.clear();
    rftExercise.clear();
    totalExerciseInBlock = 1;
    currentExerciseInBlock = 1;
    listCurrentExerciseData.clear();
    mainRestNotifier.value = 0;
    mainRest = 0;
    mainRestRound = 0;
    currentExerciseData.clear();
    mainNotes = "";
    exerciseNotes = "";

    isPlaying.value = true;
    if (widget.warmUpData.isNotEmpty && index < widget.warmUpData.length) {
      addData(widget.warmUpData);
      detailOfWorkoutFn(
          currentPageIndex: index,
          currentBlockIndex: index,
          currentBlock: widget.warmUpData,
          phaseType: "Warm Up");
    } else if (widget.trainingData.isNotEmpty &&
        index - widget.warmUpData.length < widget.trainingData.length) {
      addData(widget.trainingData);
      detailOfWorkoutFn(
          currentPageIndex: index,
          currentBlockIndex: index - widget.warmUpData.length,
          currentBlock: widget.trainingData,
          phaseType: 'Training');
    } else if (widget.coolDownData.isNotEmpty &&
        index - widget.trainingData.length - widget.warmUpData.length <
            widget.coolDownData.length) {
      addData(widget.coolDownData);
      detailOfWorkoutFn(
          currentPageIndex: index,
          currentBlockIndex:
              index - widget.warmUpData.length - widget.trainingData.length,
          currentBlock: widget.coolDownData,
          phaseType: 'Cool Down');
    }
  }

  detailOfWorkoutFn(
      {required int currentBlockIndex,
      required String phaseType,
      required int currentPageIndex,
      required Map<ExerciseDetailModel, ExerciseModel> currentBlock}) {
    toPreviousPage = 0;

    switch (currentBlock.entries
        .toList()[currentBlockIndex]
        .key
        .exerciseCategoryName) {
      case ItemType.singleExercise:
        Map<String, String> goalTargetsValue = {};
        Map<String, String> resistanceTargetsValue = {};
        oneExerciseSliderFn(phaseType, currentBlockIndex, currentPageIndex);

        itemTypeTitle = "Single Exercise";
        if (currentRound > 1) {
          mainRestNotifier.value = currentBlock.entries
              .toList()[currentBlockIndex]
              .key
              .inSetRest![currentRound - 1];
          mainRest = currentBlock.entries
              .toList()[currentBlockIndex]
              .key
              .inSetRest![currentRound - 1];
        }
        mainNotes = currentBlock.entries
            .toList()[currentBlockIndex]
            .key
            .mainNotes
            .toString();
        exerciseNotes = currentBlock.entries
            .toList()[currentBlockIndex]
            .key
            .exerciseNotes
            .toString();
        if (currentBlock.entries
                .toList()[currentBlockIndex]
                .key
                .setsCount!
                .toInt() >
            10) {
          totalRounds = 10;
        } else {
          totalRounds = currentBlock.entries
              .toList()[currentBlockIndex]
              .key
              .setsCount!
              .toInt();
        }
        if (currentBlock.entries.toList()[currentBlockIndex].key.goalTargets !=
            null) {
          goalTargetsValue = currentBlock.entries
              .toList()[currentBlockIndex]
              .key
              .goalTargets![currentRound - 1]
              .getGoalTarget();
        }
        if (currentBlock.entries
                .toList()[currentBlockIndex]
                .key
                .resistanceTargets !=
            null) {
          resistanceTargetsValue = currentBlock.entries
              .toList()[currentBlockIndex]
              .key
              .resistanceTargets![currentRound - 1]
              .getResistanceTarget();
        }
        currentExerciseData.addAll({
          ExerciseDetailModel(
                  exerciseCategoryName: ItemType.singleExercise,
                  exerciseNo: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .exerciseNo,
                  completePhaseTime: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .completePhaseTime,
                  exerciseNotes: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .exerciseNotes,
                  inSetRest: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .inSetRest,
                  mainNotes: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .mainNotes,
                  mainRest: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .mainRest,
                  mainRestRound: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .mainRestRound,
                  setsCount: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .setsCount,
                  mainWork: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .mainWork,
                  mainSets: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .mainSets,
                  goalTargets: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .goalTargets,
                  resistanceTargets: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .resistanceTargets,
                  currentGoalTargets: goalTargetsValue,
                  currentResistanceTargets: resistanceTargetsValue):
              currentBlock.entries.toList()[currentBlockIndex].value
        });

        restTimerFn(
          timerCallback: () {
            if (goalTargetsValue.entries.first.key.contains("sec")) {
              timerFn(
                context,
              );
            }
          },
        );

        break;
      case ItemType.circuitTime:
        Map<String, String> goalTargetsValue = {};
        Map<String, String> resistanceTargetsValue = {};
        oneExerciseSliderFn(phaseType, currentBlockIndex, currentPageIndex);

        itemTypeTitle = "Time Circuit";

        currentExerciseInBlock =
            currentBlock.entries.toList()[currentBlockIndex].key.exerciseNo + 1;

        totalRounds = circuitTimeExercise.keys.last.setsCount!;
        currentRound =
            currentBlock.entries.toList()[currentBlockIndex].key.setsCount!;
        var exerciseInBlock = circuitTimeExercise.keys.lastWhere(
          (element) => element.setsCount == currentRound,
        );
        totalExerciseInBlock = exerciseInBlock.exerciseNo + 1;
        mainRest =
            currentBlock.entries.toList()[currentBlockIndex].key.mainRest!;
        mainRestRound =
            currentBlock.entries.toList()[currentBlockIndex].key.mainRestRound!;
        mainWork =
            currentBlock.entries.toList()[currentBlockIndex].key.mainWork!;
        exerciseNotes = currentBlock.entries
            .toList()[currentBlockIndex]
            .key
            .exerciseNotes
            .toString();

        if (currentBlock.entries
                    .toList()[currentBlockIndex]
                    .key
                    .resistanceTargets !=
                null &&
            currentBlock.entries
                .toList()[currentBlockIndex]
                .key
                .resistanceTargets!
                .isNotEmpty) {
          resistanceTargetsValue = currentBlock.entries
              .toList()[currentBlockIndex]
              .key
              .resistanceTargets!
              .first
              .getResistanceTarget();
        }

        currentExerciseData.addAll({
          ExerciseDetailModel(
                  exerciseCategoryName: ItemType.circuitTime,
                  exerciseNo: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .exerciseNo,
                  completePhaseTime: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .completePhaseTime,
                  exerciseNotes: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .exerciseNotes,
                  inSetRest: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .inSetRest,
                  mainNotes: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .mainNotes,
                  mainRest: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .mainRest,
                  mainRestRound: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .mainRestRound,
                  setsCount: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .setsCount,
                  mainWork: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .mainWork,
                  mainSets: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .mainSets,
                  goalTargets: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .goalTargets,
                  resistanceTargets: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .resistanceTargets,
                  currentGoalTargets: goalTargetsValue,
                  currentResistanceTargets: resistanceTargetsValue):
              currentBlock.entries.toList()[currentBlockIndex].value
        });
        if (currentExerciseInBlock == 1 && currentRound > 1) {
          mainRestNotifier.value = currentBlock.entries
              .toList()[currentBlockIndex - 1]
              .key
              .mainRestRound!;
          mainRest = currentBlock.entries
              .toList()[currentBlockIndex - 1]
              .key
              .mainRestRound!;
        } else {
          mainRestNotifier.value = mainRest;
        }
        if (currentRound == 1 && currentExerciseInBlock == 1) {
          mainRestNotifier.value = 0;
        }
        restTimerFn(timerCallback: () {
          timerFn(context);
        });
        break;

      case ItemType.circuitRep:
        Map<String, String> goalTargetsValue = {};
        Map<String, String> resistanceTargetsValue = {};
        oneExerciseSliderFn(phaseType, currentBlockIndex, currentPageIndex);
        itemTypeTitle = "Reps Circuit";

        currentExerciseInBlock =
            currentBlock.entries.toList()[currentBlockIndex].key.exerciseNo + 1;

        totalRounds = circuitRepExercise.keys.last.setsCount!;
        currentRound =
            currentBlock.entries.toList()[currentBlockIndex].key.setsCount!;
        var exerciseInBlock = circuitRepExercise.keys.lastWhere(
          (element) => element.setsCount == currentRound,
        );
        totalExerciseInBlock = exerciseInBlock.exerciseNo + 1;
        mainRest =
            currentBlock.entries.toList()[currentBlockIndex].key.mainRest!;

        mainRestRound =
            currentBlock.entries.toList()[currentBlockIndex].key.mainRestRound!;
        mainNotes = currentBlock.entries
            .toList()[currentBlockIndex]
            .key
            .mainNotes
            .toString();
        exerciseNotes = currentBlock.entries
            .toList()[currentBlockIndex]
            .key
            .exerciseNotes
            .toString();
        if (currentBlock.entries.toList()[currentBlockIndex].key.goalTargets !=
                null &&
            currentBlock.entries
                .toList()[currentBlockIndex]
                .key
                .goalTargets!
                .isNotEmpty) {
          goalTargetsValue = currentBlock.entries
              .toList()[currentBlockIndex]
              .key
              .goalTargets!
              .first
              .getGoalTarget();
        }
        if (currentBlock.entries
                    .toList()[currentBlockIndex]
                    .key
                    .resistanceTargets !=
                null &&
            currentBlock.entries
                .toList()[currentBlockIndex]
                .key
                .resistanceTargets!
                .isNotEmpty) {
          resistanceTargetsValue = currentBlock.entries
              .toList()[currentBlockIndex]
              .key
              .resistanceTargets!
              .first
              .getResistanceTarget();
        }

        currentExerciseData.addAll({
          ExerciseDetailModel(
                  exerciseCategoryName: ItemType.circuitRep,
                  exerciseNo: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .exerciseNo,
                  completePhaseTime: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .completePhaseTime,
                  exerciseNotes: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .exerciseNotes,
                  inSetRest: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .inSetRest,
                  mainNotes: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .mainNotes,
                  mainRest: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .mainRest,
                  mainRestRound: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .mainRestRound,
                  setsCount: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .setsCount,
                  mainWork: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .mainWork,
                  mainSets: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .mainSets,
                  goalTargets: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .goalTargets,
                  resistanceTargets: currentBlock.entries
                      .toList()[currentBlockIndex]
                      .key
                      .resistanceTargets,
                  currentGoalTargets: goalTargetsValue,
                  currentResistanceTargets: resistanceTargetsValue):
              currentBlock.entries.toList()[currentBlockIndex].value
        });
        if (currentExerciseInBlock == 1 && currentRound > 1) {
          mainRestNotifier.value = currentBlock.entries
              .toList()[currentBlockIndex - 1]
              .key
              .mainRestRound!;
          mainRest = currentBlock.entries
              .toList()[currentBlockIndex - 1]
              .key
              .mainRestRound!;
        } else {
          mainRestNotifier.value = mainRest;
        }
        if (currentRound == 1 && currentExerciseInBlock == 1) {
          mainRestNotifier.value = 0;
        }

        restTimerFn();

        break;

      case ItemType.superSet:
        itemTypeTitle = "Superset";

        multipleExerciseIterativeFn(
            currentBlock, currentBlockIndex, ssExercise, ItemType.superSet);
        multipleExerciseSliderFn(phaseType, currentBlockIndex, ssExercise);

        mainRest =
            currentBlock.entries.toList()[currentBlockIndex].key.mainRest!;
        mainRestNotifier.value =
            currentBlock.entries.toList()[currentBlockIndex].key.mainRest!;
        mainNotes = currentBlock.entries
            .toList()[currentBlockIndex]
            .key
            .mainNotes
            .toString();
        exerciseNotes = currentBlock.entries
            .toList()[currentBlockIndex]
            .key
            .exerciseNotes
            .toString();
        if (currentBlock.entries
                .toList()[currentBlockIndex]
                .key
                .mainSets!
                .toInt() >
            10) {
          totalRounds = 10;
        } else {
          totalRounds = currentBlock.entries
              .toList()[currentBlockIndex]
              .key
              .mainSets!
              .toInt();
        }
        if (currentRound > 1) {
          restTimerFn();
        }

        break;
      case ItemType.rft:
        itemTypeTitle = "Rounds For Time";

        multipleExerciseIterativeFn(
            currentBlock, currentBlockIndex, rftExercise, ItemType.rft);
        multipleExerciseSliderFn(phaseType, currentBlockIndex, rftExercise);

        mainNotes = currentBlock.entries
            .toList()[currentBlockIndex]
            .key
            .mainNotes
            .toString();
        exerciseNotes = currentBlock.entries
            .toList()[currentBlockIndex]
            .key
            .exerciseNotes
            .toString();
        if (currentBlock.entries
                .toList()[currentBlockIndex]
                .key
                .rftRounds!
                .toInt() >
            10) {
          totalRounds = 10;
        } else {
          totalRounds = currentBlock.entries
              .toList()[currentBlockIndex]
              .key
              .rftRounds!
              .toInt();
        }

        break;
      case ItemType.amrap:
        itemTypeTitle = "As Many Reps As Possible";

        multipleExerciseIterativeFn(
            currentBlock, currentBlockIndex, amrapExercise, ItemType.amrap);
        multipleExerciseSliderFn(phaseType, currentBlockIndex, amrapExercise);
        mainWork =
            currentBlock.entries.toList()[currentBlockIndex].key.amrapDuration!;

        mainNotes = currentBlock.entries
            .toList()[currentBlockIndex]
            .key
            .mainNotes
            .toString();
        exerciseNotes = currentBlock.entries
            .toList()[currentBlockIndex]
            .key
            .exerciseNotes
            .toString();
        timerFn(context);
        break;
      case ItemType.emom:
        itemTypeTitle = "Every Minute On the Minute";

        multipleExerciseIterativeFn(
            currentBlock, currentBlockIndex, emomExercise, ItemType.emom);

        multipleExerciseSliderFn(phaseType, currentBlockIndex, emomExercise);
        exerciseNotes = currentBlock.entries
            .toList()[currentBlockIndex]
            .key
            .exerciseNotes
            .toString();
        mainNotes = currentBlock.entries
            .toList()[currentBlockIndex]
            .key
            .mainNotes
            .toString();
        totalRounds = emomExercise.keys.last.emomMinute!.toInt();
        timerFn(context);
        break;
    }
  }

  void multipleExerciseIterativeFn(
      Map<ExerciseDetailModel, ExerciseModel> currentBlock,
      int currentBlockIndex,
      Map<ExerciseDetailModel, ExerciseModel> currentExercise,
      ItemType itemType) {
    for (var entry in currentExercise.entries) {
      Map<String, String> currentGoalTargets = {};
      Map<String, String> currentResistanceTargets = {};

      // var exerciseDetail = entry.key;
      var exerciseDetail = entry.key;
      var exerciseModel = entry.value;
      // var blockEntryPair = currentBlock.entries.firstWhere(
      //   (e) {
      //     if (itemType == ItemType.emom) {
      //       return e.key.exerciseNo == exerciseDetail.exerciseNo &&
      //           e.key.emomMinute == exerciseDetail.emomMinute;
      //     } else {
      //       return e.key.exerciseNo == exerciseDetail.exerciseNo;
      //     }
      //   },
      //   orElse: () => throw Exception('Block entry not found'),
      // );
      ExerciseDetailModel? newBlockExerciseDetail;
      ExerciseModel? newBlockExerciseModel;
      if (itemType == ItemType.emom) {
        if (exerciseDetail.emomMinute == currentRound) {
          newBlockExerciseDetail = exerciseDetail;
          newBlockExerciseModel = exerciseModel;
        }
      } else {
        newBlockExerciseDetail = exerciseDetail;
        newBlockExerciseModel = exerciseModel;
      }

      if (newBlockExerciseDetail != null && newBlockExerciseModel != null) {
        if (newBlockExerciseDetail.goalTargets != null &&
            newBlockExerciseDetail.goalTargets!.isNotEmpty) {
          currentGoalTargets.addAll(
              newBlockExerciseDetail.goalTargets!.first.getGoalTarget());
        }

        if (newBlockExerciseDetail.resistanceTargets != null &&
            newBlockExerciseDetail.resistanceTargets!.isNotEmpty) {
          currentResistanceTargets.addAll(newBlockExerciseDetail
              .resistanceTargets!.first
              .getResistanceTarget());
        }

        Map<ExerciseDetailModel, ExerciseModel> data = {
          ExerciseDetailModel(
            exerciseCategoryName: itemType,
            exerciseNo: newBlockExerciseDetail.exerciseNo,
            completePhaseTime: newBlockExerciseDetail.completePhaseTime,
            exerciseNotes: newBlockExerciseDetail.exerciseNotes,
            inSetRest: newBlockExerciseDetail.inSetRest,
            mainNotes: newBlockExerciseDetail.mainNotes,
            mainRest: newBlockExerciseDetail.mainRest,
            mainRestRound: newBlockExerciseDetail.mainRestRound,
            setsCount: newBlockExerciseDetail.setsCount,
            mainWork: newBlockExerciseDetail.mainWork,
            mainSets: newBlockExerciseDetail.mainSets,
            goalTargets: newBlockExerciseDetail.goalTargets,
            resistanceTargets: newBlockExerciseDetail.resistanceTargets,
            currentGoalTargets: currentGoalTargets,
            currentResistanceTargets: currentResistanceTargets,
          ): newBlockExerciseModel,
        };
        listCurrentExerciseData.add(data);
      }
    }

    for (int i = 0; i < currentBlock.length; i++) {
      if (currentBlock.entries.toList()[i].key.exerciseCategoryName ==
          itemType) {
        if (currentBlockIndex > i) {
          toPreviousPage = currentBlockIndex - i;
        }
        break;
      }
    }
  }

  void multipleExerciseSliderFn(String phaseType, int currentBlockIndex,
      Map<ExerciseDetailModel, ExerciseModel> currentExercise) {
    if (phaseType.contains("Warm Up")) {
      sliderWarmUp.value =
          (currentBlockIndex - toPreviousPage + currentExercise.length)
              .toDouble();

      sliderTraining.value = 0;
      sliderCoolDown.value = 0;
      if (currentBlockIndex - toPreviousPage + currentExercise.length <
          widget.warmUpData.length) {
        nextElementText = widget.warmUpData.values
            .toList()[
                currentBlockIndex - toPreviousPage + currentExercise.length]
            .name;
      } else if (currentBlockIndex - toPreviousPage + currentExercise.length ==
              widget.warmUpData.length &&
          widget.trainingData.isNotEmpty) {
        nextElementText = 'Training';
      } else if (currentBlockIndex - toPreviousPage + currentExercise.length ==
              widget.warmUpData.length &&
          widget.coolDownData.isNotEmpty &&
          widget.trainingData.isEmpty) {
        nextElementText = 'Cool Down';
      } else if (currentBlockIndex - toPreviousPage + currentExercise.length ==
          widget.warmUpData.length) {
        nextElementText = '';
      }
    } else if (phaseType.contains("Training")) {
      sliderWarmUp.value = widget.warmUpData.length.toDouble();
      sliderTraining.value =
          (currentBlockIndex - toPreviousPage + currentExercise.length)
              .toDouble();

      sliderCoolDown.value = 0;
      if (currentBlockIndex - toPreviousPage + currentExercise.length <
          widget.trainingData.length) {
        nextElementText = widget.trainingData.values
            .toList()[
                currentBlockIndex - toPreviousPage + currentExercise.length]
            .name;
      } else if (currentBlockIndex - toPreviousPage + currentExercise.length ==
              widget.trainingData.length &&
          widget.coolDownData.isNotEmpty) {
        nextElementText = 'Cool Down';
      } else if (currentBlockIndex - toPreviousPage + currentExercise.length ==
          widget.trainingData.length) {
        nextElementText = '';
      }
    } else if (phaseType.contains("Cool Down")) {
      sliderWarmUp.value = widget.warmUpData.length.toDouble();
      sliderTraining.value = widget.trainingData.length.toDouble();

      sliderCoolDown.value =
          (currentBlockIndex - toPreviousPage + currentExercise.length)
              .toDouble();
      if (currentBlockIndex - toPreviousPage + currentExercise.length <
          widget.coolDownData.length) {
        nextElementText = widget.coolDownData.values
            .toList()[
                currentBlockIndex - toPreviousPage + currentExercise.length]
            .name;
      } else if (currentBlockIndex - toPreviousPage + currentExercise.length ==
          widget.coolDownData.length) {
        nextElementText = '';
      }
    }
  }

  void oneExerciseSliderFn(
      String phaseType, int currentBlockIndex, int currentPageIndex) {
    if (phaseType.contains("Warm Up")) {
      sliderWarmUp.value = currentBlockIndex + 1.toDouble();
      sliderTraining.value = 0;
      sliderCoolDown.value = 0;
      if (currentPageIndex < widget.warmUpData.length - 1) {
        nextElementText =
            widget.warmUpData.values.toList()[currentBlockIndex + 1].name;
      } else if (currentBlockIndex == widget.warmUpData.length - 1 &&
          widget.trainingData.isNotEmpty) {
        nextElementText = 'Training';
      } else if (currentBlockIndex == widget.warmUpData.length - 1 &&
          widget.coolDownData.isNotEmpty &&
          widget.trainingData.isEmpty) {
        nextElementText = 'Cool Down';
      } else if (currentBlockIndex == widget.warmUpData.length - 1) {
        nextElementText = '';
      }
    } else if (phaseType.contains("Training")) {
      sliderWarmUp.value = widget.warmUpData.length.toDouble();
      sliderTraining.value = currentBlockIndex + 1.toDouble();
      sliderCoolDown.value = 0;
      if (currentBlockIndex < widget.trainingData.length - 1) {
        nextElementText =
            widget.trainingData.values.toList()[currentBlockIndex + 1].name;
      } else if (currentBlockIndex == widget.trainingData.length - 1 &&
          widget.coolDownData.isNotEmpty) {
        nextElementText = 'Cool Down';
      } else if (currentBlockIndex == widget.trainingData.length - 1) {
        nextElementText = '';
      }
    } else if (phaseType.contains("Cool Down")) {
      sliderWarmUp.value = widget.warmUpData.length.toDouble();
      sliderTraining.value = widget.trainingData.length.toDouble();

      sliderCoolDown.value = currentBlockIndex + 1.toDouble();
      if (currentBlockIndex < widget.coolDownData.length - 1) {
        nextElementText =
            widget.coolDownData.values.toList()[currentBlockIndex + 1].name;
      } else if (currentBlockIndex == widget.coolDownData.length - 1) {
        nextElementText = '';
      }
    }
  }

  @override
  void dispose() {
    _cancelTimer();
    restTimer?.cancel();
    everyTimeExerciseTimer?.cancel();
    restTimer = null;
    everyTimeExerciseTimer = null;
    isPlaying.value = true;
    currentRound = 1;
    currentExerciseInBlock = 1;
    pageController.dispose();
    super.dispose();
  }

  restTimerFn({void Function()? timerCallback}) {
    if (context.mounted) {
      restLinear.value = 0;
      isRestPlaying.value = true;
      isPlaying.value = false;
      restTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (isRestPlaying.value && mainRestNotifier.value > 0) {
          restLinear.value += 1;
          mainRestNotifier.value -= 1;
        } else if (mainRestNotifier.value == 0) {
          restTimer?.cancel();
          isPlaying.value = true;
          setState(() {});
          if (timerCallback != null) {
            timerCallback();
          }
        }
      });
    }
  }

  void timerFn(BuildContext context) {
    if (context.mounted) {
      secondsCountDown.value = 5;
      isPlaying.value = false;
      everyTimeExerciseTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (secondsCountDown.value > 0 &&
            everyTimeExerciseTimer?.isActive == true) {
          secondsCountDown.value -= 1;
        } else if (secondsCountDown.value == 0) {
          isPlaying.value = true;
          everyTimeExerciseTimer?.cancel();
          restTimer?.cancel();
        }
      });
    }
  }

  bool checkIsListExercises(
      int index, Map<ExerciseDetailModel, ExerciseModel> currentexerciseList) {
    return currentexerciseList.entries
                .toList()[index]
                .key
                .exerciseCategoryName ==
            ItemType.emom ||
        currentexerciseList.entries.toList()[index].key.exerciseCategoryName ==
            ItemType.rft ||
        currentexerciseList.entries.toList()[index].key.exerciseCategoryName ==
            ItemType.superSet ||
        currentexerciseList.entries.toList()[index].key.exerciseCategoryName ==
            ItemType.amrap;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (e) async {
        if (e) {
          return;
        }
        bool? sholdPop = await showAdaptiveDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return ShowAlertDialogWidget(
                title: context.loc.alertBoxTitle2,
                body: context.loc.alertBoxBody2,
                btnText1: context.loc.alertBoxButton1,
                btnText2: context.loc.alertBox2Button2);
          },
        );

        if (sholdPop == true) {
          if (EveentTriggered.workout_cancelled != null) {
            final DateTime now = DateTime.now();

            final formatTime = WorkoutDetailController.getFormatTimeFn(
                widget.durationNotifier.value);
            DateTime dateType = DateFormat("HH:mm:ss").parse(formatTime);
            DateTime newDate = DateTime(now.year, now.month, now.day,
                dateType.hour, dateType.minute, dateType.second);
            EveentTriggered.workout_cancelled!(
                widget.workoutModel.title.toString(),
                widget.workoutModel.id.toString(),
                pageController.page!.toInt() + 1,
                widget.warmUpData.length +
                    widget.trainingData.length +
                    widget.coolDownData.length,
                newDate);
          }
          if (widget.warmUpData.isEmpty &&
              widget.trainingData.isNotEmpty &&
              widget.coolDownData.isEmpty) {
            if (context.mounted) {
              context.multiPopPage(popPageCount: 2);
            }
          } else if (widget.warmUpData.isNotEmpty &&
              widget.trainingData.isEmpty &&
              widget.coolDownData.isEmpty) {
            if (context.mounted) {
              context.multiPopPage(popPageCount: 2);
            }
          } else if (widget.warmUpData.isEmpty &&
              widget.trainingData.isEmpty &&
              widget.coolDownData.isNotEmpty) {
            if (context.mounted) {
              context.multiPopPage(popPageCount: 2);
            }
          } else {
            if (context.mounted) {
              context.multiPopPage(popPageCount: 3);
            }
          }
        }
      },
      child: PageView.builder(
          clipBehavior: Clip.none,
          pageSnapping: false,
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          itemCount: widget.warmUpData.length +
              widget.trainingData.length +
              widget.coolDownData.length,
          itemBuilder: (_, index) {
            return Scaffold(
              backgroundColor: AppColor.surfaceBackgroundColor,
              appBar: StartWorkoutHeaderWidget(
                isCancel: widget.cancelTimer,
                warmUpData: widget.warmUpData,
                coolDownData: widget.coolDownData,
                trainingData: widget.trainingData,
                workoutModel: widget.workoutModel,
                sliderCoolDown: sliderCoolDown,
                sliderTraining: sliderTraining,
                sliderWarmUp: sliderWarmUp,
                actionWidget: InkWell(
                    onTap: () async {
                      if (EveentTriggered.workout_player_overview != null) {
                        EveentTriggered.workout_player_overview!(
                            widget.workoutModel.title.toString(),
                            widget.workoutModel.id.toString());
                      }
                      isPlaying.value = false;

                      await showModalBottomSheet(
                        backgroundColor: AppColor.surfaceBackgroundBaseColor,
                        useSafeArea: true,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => PopScope(
                          onPopInvoked: (didPop) {
                            isPlaying.value = true;
                          },
                          child: OverviewBottomSheet(
                            warmUpData: widget.warmUpData,
                            coolDownData: widget.coolDownData,
                            trainingData: widget.trainingData,
                            workoutModel: widget.workoutModel,
                            warmupBody:
                                pageController.page!.toInt() - toPreviousPage,
                            trainingBody: pageController.page!.toInt() -
                                toPreviousPage -
                                widget.warmUpData.length,
                            coolDownBody: pageController.page!.toInt() -
                                toPreviousPage -
                                widget.trainingData.length -
                                widget.warmUpData.length,
                            goHereTapCoolDown: (index) async {
                              context.maybePopPage();

                              bool isList = checkIsListExercises(
                                  index, widget.coolDownData);
                              ItemType currentExerciseType = widget
                                  .coolDownData.entries
                                  .toList()[index]
                                  .key
                                  .exerciseCategoryName;

                              if (isList) {
                                if (ItemType.emom == currentExerciseType) {
                                  currentRound = widget.coolDownData.entries
                                      .toList()[index]
                                      .key
                                      .emomMinute!;
                                } else {
                                  currentRound = 1;
                                }

                                int currentListFirstIndex = widget
                                    .coolDownData.entries
                                    .toList()
                                    .indexWhere(
                                      (element) =>
                                          element.key.exerciseCategoryName ==
                                          currentExerciseType,
                                    );

                                await pageController.animateToPage(
                                    widget.warmUpData.length +
                                        widget.trainingData.length +
                                        currentListFirstIndex,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.easeIn);
                                getCurrentExerciseViewFn(
                                    pageController.page!.toInt());
                                setState(() {});
                                String current = listCurrentExerciseData
                                    .map(
                                      (e) => e.values.first.name,
                                    )
                                    .join(',')
                                    .toString();
                                if (EveentTriggered
                                        .workout_player_overview_navigate !=
                                    null) {
                                  EveentTriggered
                                          .workout_player_overview_navigate!(
                                      current,
                                      currentExerciseData.values.first.name
                                          .toString(),
                                      widget.workoutModel.id.toString(),
                                      widget.workoutModel.title.toString());
                                }
                              } else {
                                currentRound = 1;

                                await pageController.animateToPage(
                                    index +
                                        widget.warmUpData.length +
                                        widget.trainingData.length,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.easeIn);

                                getCurrentExerciseViewFn(
                                    pageController.page!.toInt());
                                String current = currentExerciseData
                                    .values.first.name
                                    .toString();
                                setState(() {});
                                if (EveentTriggered
                                        .workout_player_overview_navigate !=
                                    null) {
                                  EveentTriggered
                                          .workout_player_overview_navigate!(
                                      current,
                                      currentExerciseData.values.first.name
                                          .toString(),
                                      widget.workoutModel.id.toString(),
                                      widget.workoutModel.title.toString());
                                }
                              }
                            },
                            goHereTapTraining: (index) async {
                              context.maybePopPage();

                              bool isList = checkIsListExercises(
                                  index, widget.trainingData);
                              ItemType currentExerciseType = widget
                                  .trainingData.entries
                                  .toList()[index]
                                  .key
                                  .exerciseCategoryName;

                              if (isList) {
                                if (ItemType.emom == currentExerciseType) {
                                  currentRound = widget.trainingData.entries
                                      .toList()[index]
                                      .key
                                      .emomMinute!;
                                } else {
                                  currentRound = 1;
                                }

                                int currentListFirstIndex = widget
                                    .trainingData.entries
                                    .toList()
                                    .indexWhere(
                                      (element) =>
                                          element.key.exerciseCategoryName ==
                                          currentExerciseType,
                                    );

                                await pageController.animateToPage(
                                    widget.trainingData.length +
                                        currentListFirstIndex,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.easeIn);
                                getCurrentExerciseViewFn(
                                    pageController.page!.toInt());
                                setState(() {});
                                String current = listCurrentExerciseData
                                    .map(
                                      (e) => e.values.first.name,
                                    )
                                    .join(',')
                                    .toString();
                                if (EveentTriggered
                                        .workout_player_overview_navigate !=
                                    null) {
                                  EveentTriggered
                                          .workout_player_overview_navigate!(
                                      current,
                                      currentExerciseData.values.first.name
                                          .toString(),
                                      widget.workoutModel.id.toString(),
                                      widget.workoutModel.title.toString());
                                }
                              } else {
                                currentRound = 1;
                                await pageController.animateToPage(
                                    index + widget.warmUpData.length,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.easeIn);
                                getCurrentExerciseViewFn(
                                    pageController.page!.toInt());
                                String current = currentExerciseData
                                    .values.first.name
                                    .toString();
                                setState(() {});

                                if (EveentTriggered
                                        .workout_player_overview_navigate !=
                                    null) {
                                  EveentTriggered
                                          .workout_player_overview_navigate!(
                                      current,
                                      currentExerciseData.values.first.name
                                          .toString(),
                                      widget.workoutModel.id.toString(),
                                      widget.workoutModel.title.toString());
                                }
                              }
                            },
                            goHereTapWarmUp: (index) async {
                              context.maybePopPage();

                              bool isList = checkIsListExercises(
                                  index, widget.warmUpData);
                              ItemType currentExerciseType = widget
                                  .warmUpData.entries
                                  .toList()[index]
                                  .key
                                  .exerciseCategoryName;

                              if (isList) {
                                if (ItemType.emom == currentExerciseType) {
                                  currentRound = widget.warmUpData.entries
                                      .toList()[index]
                                      .key
                                      .emomMinute!;
                                } else {
                                  currentRound = 1;
                                }

                                int currentListFirstIndex = widget
                                    .warmUpData.entries
                                    .toList()
                                    .indexWhere(
                                      (element) =>
                                          element.key.exerciseCategoryName ==
                                          currentExerciseType,
                                    );

                                await pageController.animateToPage(
                                    currentListFirstIndex,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.easeIn);
                                getCurrentExerciseViewFn(
                                    pageController.page!.toInt());
                                String current = listCurrentExerciseData
                                    .map(
                                      (e) => e.values.first.name,
                                    )
                                    .join(',')
                                    .toString();
                                setState(() {});

                                if (EveentTriggered
                                        .workout_player_overview_navigate !=
                                    null) {
                                  EveentTriggered
                                          .workout_player_overview_navigate!(
                                      current,
                                      currentExerciseData.values.first.name
                                          .toString(),
                                      widget.workoutModel.id.toString(),
                                      widget.workoutModel.title.toString());
                                }
                              } else {
                                currentRound = 1;

                                await pageController.animateToPage(index,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.easeIn);

                                getCurrentExerciseViewFn(
                                    pageController.page!.toInt());
                                String current = currentExerciseData
                                    .values.first.name
                                    .toString();
                                setState(() {});
                                if (EveentTriggered
                                        .workout_player_overview_navigate !=
                                    null) {
                                  EveentTriggered
                                          .workout_player_overview_navigate!(
                                      current,
                                      currentExerciseData.values.first.name
                                          .toString(),
                                      widget.workoutModel.id.toString(),
                                      widget.workoutModel.title.toString());
                                }
                              }
                            },
                            currentRound: currentRound,
                          ),
                        ),
                      );
                    },
                    child: SvgPicture.asset(AppAssets.exploreIcon)),
                durationNotifier: widget.durationNotifier,
                closeButton: () {
                  context.maybePopPage();
                },
              ),
              body: currentItembodyWidget(context, index),
            );
          }),
    );
  }

  Widget currentItembodyWidget(BuildContext context, int index) {
    if (listCurrentExerciseData.isNotEmpty) {
      if (ItemType.superSet ==
          listCurrentExerciseData.first.keys.first.exerciseCategoryName) {
        return SuperSetWorkoutWidget(
          workoutModel: widget.workoutModel,
          onNext: () async {
            if (_isButtonDisabled) return;

            _isButtonDisabled = true;

            if (nextElementText != '' || currentRound < totalRounds) {
              if (nextElementText == "Training" &&
                  totalRounds == currentRound) {
                _isButtonDisabled = false;
                currentRound = 1;

                await getReadyFn(
                    context,
                    "Training",
                    widget.trainingData,
                    pageController.page!.toInt() -
                        toPreviousPage +
                        ssExercise.length);
              } else if (nextElementText == "Cool Down" &&
                  totalRounds == currentRound) {
                currentRound = 1;
                _isButtonDisabled = false;
                await getReadyFn(
                    context,
                    "Cool Down",
                    widget.coolDownData,
                    pageController.page!.toInt() -
                        toPreviousPage +
                        ssExercise.length);
              } else {
                if (totalRounds > 1 && currentRound < totalRounds) {
                  isSetComplete.value = true;
                  Future.delayed(const Duration(milliseconds: 900), () {
                    isSetComplete.value = false;
                    currentRound += 1;
                    getCurrentExerciseViewFn(pageController.page!.toInt());

                    setState(() {
                      _isButtonDisabled = false;
                    });
                  });
                } else {
                  currentRound = 1;
                  await pageController.animateToPage(
                      pageController.page!.toInt() -
                          toPreviousPage +
                          ssExercise.length,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeIn);
                  getCurrentExerciseViewFn(pageController.page!.toInt());

                  setState(() {
                    _isButtonDisabled = false;
                  });

                  if (EveentTriggered.workout_player_skip != null) {
                    EveentTriggered.workout_player_skip!(
                        widget.workoutModel.title.toString(),
                        widget.workoutModel.id.toString(),
                        listCurrentExerciseData
                            .map(
                              (e) => e.values.first.name,
                            )
                            .join(',')
                            .toString());
                  }
                }
              }
            } else {
              await doneSheetFn(context);
            }
          },
          onPrevious: () async {
            if (_isButtonDisabled) return;

            _isButtonDisabled = true;

            if (totalRounds > 1 && currentRound != 1) {
              currentRound -= 1;
              getCurrentExerciseViewFn(pageController.page!.toInt());
              setState(() {
                _isButtonDisabled = false;
              });
            } else {
              await pageController.animateToPage(
                  pageController.page!.toInt() - toPreviousPage - 1,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeOut);
              getCurrentExerciseViewFn(pageController.page!.toInt());
              setState(() {
                _isButtonDisabled = false;
              });
              if (EveentTriggered.workout_player_previous != null) {
                EveentTriggered.workout_player_previous!(
                    widget.workoutModel.title.toString(),
                    widget.workoutModel.id.toString(),
                    listCurrentExerciseData
                        .map(
                          (e) => e.values.first.name,
                        )
                        .join(',')
                        .toString());
              }
            }
          },
          itemTypeTitle: itemTypeTitle,
          isSetComplete: isSetComplete,
          exerciseNotes: exerciseNotes,
          secondsCountDown: secondsCountDown,
          currentRound: currentRound,
          nextElementText: nextElementText,
          isPlaying: isPlaying,
          totalRounds: totalRounds,
          everyTimeExerciseTimer: everyTimeExerciseTimer,
          mainWork: mainWork,
          mainNotes: mainNotes,
          restLinear: restLinear,
          listCurrentExerciseData: listCurrentExerciseData,
          mainRestNotifier: mainRestNotifier,
          mainRest: mainRest,
          restTimer: restTimer,
          isRestPlaying: isRestPlaying,
        );
      } else if (ItemType.rft ==
          listCurrentExerciseData.first.keys.first.exerciseCategoryName) {
        return RftWorkoutWidget(
          workoutModel: widget.workoutModel,
          onPrevious: () async {
            if (_isButtonDisabled) return;

            _isButtonDisabled = true;

            if (totalRounds > 1 && currentRound != 1) {
              currentRound -= 1;
              getCurrentExerciseViewFn(pageController.page!.toInt());
              setState(() {
                _isButtonDisabled = false;
              });
            } else {
              await pageController.animateToPage(
                  pageController.page!.toInt() - toPreviousPage - 1,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeOut);
              getCurrentExerciseViewFn(pageController.page!.toInt());
              setState(() {
                _isButtonDisabled = false;
              });
              if (EveentTriggered.workout_player_previous != null) {
                EveentTriggered.workout_player_previous!(
                    widget.workoutModel.title.toString(),
                    widget.workoutModel.id.toString(),
                    currentExerciseData.values.first.name.toString());
              }
            }
          },
          onNext: () async {
            if (_isButtonDisabled) return;

            _isButtonDisabled = true;

            if (nextElementText != '' || currentRound < totalRounds) {
              if (nextElementText == "Training" &&
                  totalRounds == currentRound) {
                currentRound = 1;
                _isButtonDisabled = false;
                await getReadyFn(
                    context,
                    "Training",
                    widget.trainingData,
                    pageController.page!.toInt() -
                        toPreviousPage +
                        rftExercise.length);
              } else if (nextElementText == "Cool Down" &&
                  totalRounds == currentRound) {
                currentRound = 1;
                _isButtonDisabled = false;
                await getReadyFn(
                    context,
                    "Cool Down",
                    widget.coolDownData,
                    pageController.page!.toInt() -
                        toPreviousPage +
                        rftExercise.length);
              } else {
                if (totalRounds > 1 && currentRound < totalRounds) {
                  isSetComplete.value = true;
                  Future.delayed(const Duration(milliseconds: 900), () {
                    isSetComplete.value = false;
                    currentRound += 1;
                    getCurrentExerciseViewFn(pageController.page!.toInt());
                    setState(() {
                      _isButtonDisabled = false;
                    });
                  });
                } else {
                  currentRound = 1;

                  await pageController.animateToPage(
                      pageController.page!.toInt() -
                          toPreviousPage +
                          rftExercise.length,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeIn);
                  getCurrentExerciseViewFn(pageController.page!.toInt());
                  setState(() {
                    _isButtonDisabled = false;
                  });
                  if (EveentTriggered.workout_player_skip != null) {
                    EveentTriggered.workout_player_skip!(
                        widget.workoutModel.title.toString(),
                        widget.workoutModel.id.toString(),
                        currentExerciseData.values.first.name.toString());
                  }
                }
              }
            } else {
              await doneSheetFn(context);
            }
          },
          itemTypeTitle: itemTypeTitle,
          isSetComplete: isSetComplete,
          exerciseNotes: exerciseNotes,
          secondsCountDown: secondsCountDown,
          currentRound: currentRound,
          nextElementText: nextElementText,
          isPlaying: isPlaying,
          totalRounds: totalRounds,
          everyTimeExerciseTimer: everyTimeExerciseTimer,
          mainWork: mainWork,
          mainNotes: mainNotes,
          restLinear: restLinear,
          listCurrentExerciseData: listCurrentExerciseData,
          isRestPlaying: isRestPlaying,
        );
      } else if (ItemType.emom ==
          listCurrentExerciseData.first.keys.first.exerciseCategoryName) {
        return EmomWorkoutWidget(
          workoutModel: widget.workoutModel,
          onPrevious: () async {
            if (_isButtonDisabled) return;

            _isButtonDisabled = true;

            if (totalRounds > 1 && currentRound != 1) {
              currentRound -= 1;
              getCurrentExerciseViewFn(pageController.page!.toInt());
              _isButtonDisabled = false;
              setState(() {});
            } else {
              await pageController.animateToPage(
                  pageController.page!.toInt() - toPreviousPage - 1,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeOut);
              getCurrentExerciseViewFn(pageController.page!.toInt());
              _isButtonDisabled = false;
              setState(() {});
              if (EveentTriggered.workout_player_previous != null) {
                EveentTriggered.workout_player_previous!(
                    widget.workoutModel.title.toString(),
                    widget.workoutModel.id.toString(),
                    currentExerciseData.values.first.name.toString());
              }
            }
          },
          onNext: () async {
            if (_isButtonDisabled) return;

            _isButtonDisabled = true;

            if (nextElementText != '' || currentRound < totalRounds) {
              if (nextElementText == "Training" &&
                  totalRounds == currentRound) {
                currentRound = 1;
                _isButtonDisabled = false;
                await getReadyFn(
                    context,
                    "Training",
                    widget.trainingData,
                    pageController.page!.toInt() -
                        toPreviousPage +
                        emomExercise.length);
              } else if (nextElementText == "Cool Down" &&
                  totalRounds == currentRound) {
                currentRound = 1;
                _isButtonDisabled = false;
                await getReadyFn(
                    context,
                    "Cool Down",
                    widget.coolDownData,
                    pageController.page!.toInt() -
                        toPreviousPage +
                        emomExercise.length);
              } else {
                if (totalRounds > 1 && currentRound < totalRounds) {
                  isSetComplete.value = true;
                  Future.delayed(const Duration(milliseconds: 900), () {
                    isSetComplete.value = false;
                    currentRound += 1;
                    getCurrentExerciseViewFn(pageController.page!.toInt());
                    _isButtonDisabled = false;
                    setState(() {});
                  });
                } else {
                  currentRound = 1;

                  await pageController.animateToPage(
                      pageController.page!.toInt() -
                          toPreviousPage +
                          emomExercise.length,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeIn);
                  getCurrentExerciseViewFn(pageController.page!.toInt());
                  _isButtonDisabled = false;
                  setState(() {});
                  if (EveentTriggered.workout_player_skip != null) {
                    EveentTriggered.workout_player_skip!(
                        widget.workoutModel.title.toString(),
                        widget.workoutModel.id.toString(),
                        currentExerciseData.values.first.name.toString());
                  }
                }
              }
            } else {
              await doneSheetFn(context);
            }
          },
          timerFnNextElement: () async {
            if (nextElementText != "" || currentRound < totalRounds) {
              if (totalRounds > 1 && currentRound < totalRounds) {
                isSetComplete.value = true;
                Future.delayed(const Duration(milliseconds: 900), () {
                  isSetComplete.value = false;
                  currentRound += 1;
                  getCurrentExerciseViewFn(pageController.page!.toInt());
                  setState(() {});
                });
              } else {
                currentRound = 1;

                await pageController.animateToPage(
                    pageController.page!.toInt() -
                        toPreviousPage +
                        emomExercise.length,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeIn);
                getCurrentExerciseViewFn(pageController.page!.toInt());
                setState(() {});
                if (EveentTriggered.workout_player_skip != null) {
                  EveentTriggered.workout_player_skip!(
                      widget.workoutModel.title.toString(),
                      widget.workoutModel.id.toString(),
                      currentExerciseData.values.first.name.toString());
                }
              }
            } else {
              doneSheetFn(context);
            }
          },
          triggerGetReadyFn: (e) {
            if (e.toLowerCase().contains("training")) {
              getReadyFn(
                  context,
                  e,
                  widget.trainingData,
                  pageController.page!.toInt() -
                      toPreviousPage +
                      emomExercise.length);
            } else {
              getReadyFn(
                  context,
                  e,
                  widget.coolDownData,
                  pageController.page!.toInt() -
                      toPreviousPage +
                      emomExercise.length);
            }
          },
          itemTypeTitle: itemTypeTitle,
          isSetComplete: isSetComplete,
          exerciseNotes: exerciseNotes,
          secondsCountDown: secondsCountDown,
          currentRound: currentRound,
          nextElementText: nextElementText,
          isPlaying: isPlaying,
          totalRounds: totalRounds,
          everyTimeExerciseTimer: everyTimeExerciseTimer,
          mainWork: mainWork,
          mainNotes: mainNotes,
          restLinear: restLinear,
          listCurrentExerciseData: listCurrentExerciseData,
        );
      } else if (ItemType.amrap ==
          listCurrentExerciseData.first.keys.first.exerciseCategoryName) {
        return AmrapWorkoutWidget(
          workoutModel: widget.workoutModel,
          onPrevious: () async {
            await pageController.animateToPage(
                pageController.page!.toInt() - toPreviousPage - 1,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeOut);
            getCurrentExerciseViewFn(pageController.page!.toInt());

            setState(() {});
            if (EveentTriggered.workout_player_previous != null) {
              EveentTriggered.workout_player_previous!(
                  widget.workoutModel.title.toString(),
                  widget.workoutModel.id.toString(),
                  currentExerciseData.values.first.name.toString());
            }
          },
          onNext: () async {
            if (nextElementText != '') {
              if (nextElementText == "Training") {
                await getReadyFn(
                    context,
                    "Training",
                    widget.trainingData,
                    pageController.page!.toInt() -
                        toPreviousPage +
                        amrapExercise.length);
              } else if (nextElementText == "Cool Down") {
                _isButtonDisabled = false;
                await getReadyFn(
                    context,
                    "Cool Down",
                    widget.coolDownData,
                    pageController.page!.toInt() -
                        toPreviousPage +
                        amrapExercise.length);
              } else {
                currentRound = 1;

                await pageController.animateToPage(
                    pageController.page!.toInt() -
                        toPreviousPage +
                        amrapExercise.length,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeIn);
                getCurrentExerciseViewFn(pageController.page!.toInt());

                setState(() {});
                if (EveentTriggered.workout_player_skip != null) {
                  EveentTriggered.workout_player_skip!(
                      widget.workoutModel.title.toString(),
                      widget.workoutModel.id.toString(),
                      currentExerciseData.values.first.name.toString());
                }
              }
            } else {
              await doneSheetFn(context);
            }
          },
          timerFnNextElement: () async {
            if (nextElementText != "") {
              await pageController.animateToPage(
                  pageController.page!.toInt() -
                      toPreviousPage +
                      amrapExercise.length,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeIn);
              getCurrentExerciseViewFn(pageController.page!.toInt());

              setState(() {});
            } else {
              doneSheetFn(context);
            }

            if (EveentTriggered.workout_player_skip != null) {
              EveentTriggered.workout_player_skip!(
                  widget.workoutModel.title.toString(),
                  widget.workoutModel.id.toString(),
                  currentExerciseData.values.first.name.toString());
            }
          },
          triggerGetReadyFn: (e) {
            if (e.toLowerCase().contains("training")) {
              getReadyFn(
                  context,
                  e,
                  widget.trainingData,
                  pageController.page!.toInt() -
                      toPreviousPage +
                      amrapExercise.length);
            } else {
              getReadyFn(
                  context,
                  e,
                  widget.coolDownData,
                  pageController.page!.toInt() -
                      toPreviousPage +
                      amrapExercise.length);
            }
          },
          itemTypeTitle: itemTypeTitle,
          isSetComplete: isSetComplete,
          exerciseNotes: exerciseNotes,
          secondsCountDown: secondsCountDown,
          currentRound: currentRound,
          nextElementText: nextElementText,
          isPlaying: isPlaying,
          totalRounds: totalRounds,
          everyTimeExerciseTimer: everyTimeExerciseTimer,
          mainWork: mainWork,
          mainNotes: mainNotes,
          restLinear: restLinear,
          listCurrentExerciseData: listCurrentExerciseData,
        );
      }
    } else {
      if (ItemType.singleExercise ==
          currentExerciseData.keys.first.exerciseCategoryName) {
        return SeWorkoutWidget(
          isRestPlaying: isRestPlaying,
          mainRest: mainRest,
          mainRestNotifier: mainRestNotifier,
          restTimer: restTimer,
          workoutModel: widget.workoutModel,
          onPrevious: () async {
            if (_isButtonDisabled) return;

            _isButtonDisabled = true;

            if (totalRounds > 1 && currentRound != 1) {
              currentRound -= 1;
              getCurrentExerciseViewFn(pageController.page!.toInt());
              _isButtonDisabled = false;
              setState(() {});
            } else {
              await pageController.animateToPage(
                  pageController.page!.toInt() - 1,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeOut);
              getCurrentExerciseViewFn(pageController.page!.toInt());
              _isButtonDisabled = false;
              setState(() {});
              if (EveentTriggered.workout_player_previous != null) {
                EveentTriggered.workout_player_previous!(
                    widget.workoutModel.title.toString(),
                    widget.workoutModel.id.toString(),
                    currentExerciseData.entries.first.value.name);
              }
            }
          },
          onNext: () async {
            if (_isButtonDisabled) return;

            _isButtonDisabled = true;

            if (nextElementText != '' || currentRound < totalRounds) {
              if (nextElementText == "Training" &&
                  totalRounds == currentRound) {
                currentRound = 1;
                _isButtonDisabled = false;
                await getReadyFn(context, "Training", widget.trainingData,
                    pageController.page!.toInt() + 1);
              } else if (nextElementText == "Cool Down" &&
                  totalRounds == currentRound) {
                currentRound = 1;
                _isButtonDisabled = false;
                await getReadyFn(context, "Cool Down", widget.coolDownData,
                    pageController.page!.toInt() + 1);
              } else {
                if (totalRounds > 1 && currentRound < totalRounds) {
                  isSetComplete.value = true;
                  Future.delayed(const Duration(milliseconds: 900), () {
                    isSetComplete.value = false;
                    currentRound += 1;
                    getCurrentExerciseViewFn(pageController.page!.toInt());

                    _isButtonDisabled = false;
                  });
                } else {
                  currentRound = 1;

                  await pageController.animateToPage(
                      pageController.page!.toInt() + 1,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeIn);
                  getCurrentExerciseViewFn(pageController.page!.toInt());
                  _isButtonDisabled = false;
                  setState(() {});
                  if (EveentTriggered.workout_player_skip != null) {
                    EveentTriggered.workout_player_skip!(
                        widget.workoutModel.title.toString(),
                        widget.workoutModel.id.toString(),
                        currentExerciseData.entries.first.value.name);
                  }
                }
              }
            } else {
              await doneSheetFn(context);
            }
          },
          timerFnNextElement: () async {
            if (nextElementText != "" || currentRound < totalRounds) {
              if (totalRounds > 1 && currentRound < totalRounds) {
                isSetComplete.value = true;
                Future.delayed(const Duration(milliseconds: 900), () {
                  isSetComplete.value = false;
                  currentRound += 1;
                  getCurrentExerciseViewFn(pageController.page!.toInt());
                  setState(() {});
                });
              } else {
                currentRound = 1;
                getCurrentExerciseViewFn(pageController.page!.toInt() + 1);
                await pageController.animateToPage(
                    pageController.page!.toInt() + 1,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeIn);

                setState(() {});
                if (EveentTriggered.workout_player_skip != null) {
                  EveentTriggered.workout_player_skip!(
                      widget.workoutModel.title.toString(),
                      widget.workoutModel.id.toString(),
                      currentExerciseData.entries.first.value.name);
                }
              }
            } else {
              doneSheetFn(context);
            }
          },
          triggerGetReadyFn: (e) {
            if (e.toLowerCase().contains("training")) {
              getReadyFn(context, e, widget.trainingData,
                  pageController.page!.toInt() + 1);
            } else {
              getReadyFn(context, e, widget.coolDownData,
                  pageController.page!.toInt() + 1);
            }
          },
          itemTypeTitle: itemTypeTitle,
          mainNotes: mainNotes,
          isSetComplete: isSetComplete,
          secondsCountDown: secondsCountDown,
          restLinear: restLinear,
          totalRounds: totalRounds,
          currentRound: currentRound,
          isPlaying: isPlaying,
          nextElementText: nextElementText,
          mainWork: mainWork,
          exerciseNotes: exerciseNotes,
          currentExerciseData: currentExerciseData,
          everyTimeExerciseTimer: everyTimeExerciseTimer,
        );
      } else if (ItemType.circuitTime ==
          currentExerciseData.keys.first.exerciseCategoryName) {
        return CtAndCrWorkoutWidget(
          workoutModel: widget.workoutModel,
          onPrevious: () async {
            currentRound = 1;
            await pageController.animateToPage(pageController.page!.toInt() - 1,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeOut);
            getCurrentExerciseViewFn(pageController.page!.toInt());
            setState(() {});
            if (EveentTriggered.workout_player_previous != null) {
              EveentTriggered.workout_player_previous!(
                  widget.workoutModel.title.toString(),
                  widget.workoutModel.id.toString(),
                  currentExerciseData.values.first.name.toString());
            }
          },
          onNext: () async {
            currentRound = 1;
            if (nextElementText != '') {
              if (nextElementText == "Training") {
                await getReadyFn(context, "Training", widget.trainingData,
                    pageController.page!.toInt() + 1);
              } else if (nextElementText == "Cool Down") {
                await getReadyFn(context, "Cool Down", widget.coolDownData,
                    pageController.page!.toInt() + 1);
              } else {
                await pageController.animateToPage(
                    pageController.page!.toInt() + 1,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeIn);

                getCurrentExerciseViewFn(pageController.page!.toInt());

                setState(() {});

                if (EveentTriggered.workout_player_skip != null) {
                  EveentTriggered.workout_player_skip!(
                      widget.workoutModel.title.toString(),
                      widget.workoutModel.id.toString(),
                      currentExerciseData.values.first.name.toString());
                }
              }
            } else {
              await doneSheetFn(context);
            }
          },
          timerFnNextElement: () async {
            if (nextElementText != "") {
              await pageController.animateToPage(index + 1,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeIn);
              getCurrentExerciseViewFn(pageController.page!.toInt());
              setState(() {});
            } else {
              doneSheetFn(context);
            }
          },
          triggerGetReadyFn: (e) {
            if (e.toLowerCase().contains("training")) {
              getReadyFn(context, e, widget.trainingData,
                  pageController.page!.toInt() + 1);
            } else {
              getReadyFn(context, e, widget.coolDownData,
                  pageController.page!.toInt() + 1);
            }
          },
          isCircuitRep: false,
          currentExerciseInBlock: currentExerciseInBlock,
          isRestPlaying: isRestPlaying,
          mainRest: mainRest,
          mainRestNotifier: mainRestNotifier,
          totalExerciseInBlock: totalExerciseInBlock,
          restTimer: restTimer,
          itemTypeTitle: itemTypeTitle,
          mainNotes: mainNotes,
          isSetComplete: isSetComplete,
          secondsCountDown: secondsCountDown,
          restLinear: restLinear,
          totalRounds: totalRounds,
          currentRound: currentRound,
          isPlaying: isPlaying,
          nextElementText: nextElementText,
          mainWork: mainWork,
          exerciseNotes: exerciseNotes,
          currentExerciseData: currentExerciseData,
          everyTimeExerciseTimer: everyTimeExerciseTimer,
        );
      } else if (ItemType.circuitRep ==
          currentExerciseData.keys.first.exerciseCategoryName) {
        return CtAndCrWorkoutWidget(
          workoutModel: widget.workoutModel,
          onPrevious: () async {
            currentRound = 1;
            await pageController.animateToPage(pageController.page!.toInt() - 1,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeOut);
            getCurrentExerciseViewFn(pageController.page!.toInt());
            setState(() {});
            if (EveentTriggered.workout_player_previous != null) {
              EveentTriggered.workout_player_previous!(
                  widget.workoutModel.title.toString(),
                  widget.workoutModel.id.toString(),
                  currentExerciseData.values.first.name.toString());
            }
          },
          onNext: () async {
            currentRound = 1;
            if (nextElementText != '') {
              if (nextElementText == "Training") {
                await getReadyFn(context, "Training", widget.trainingData,
                    pageController.page!.toInt() + 1);
              } else if (nextElementText == "Cool Down") {
                await getReadyFn(context, "Cool Down", widget.coolDownData,
                    pageController.page!.toInt() + 1);
              } else {
                await pageController.animateToPage(
                    pageController.page!.toInt() + 1,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeIn);

                getCurrentExerciseViewFn(pageController.page!.toInt());

                setState(() {});

                if (EveentTriggered.workout_player_skip != null) {
                  EveentTriggered.workout_player_skip!(
                      widget.workoutModel.title.toString(),
                      widget.workoutModel.id.toString(),
                      currentExerciseData.values.first.name.toString());
                }
              }
            } else {
              await doneSheetFn(context);
            }
          },
          isCircuitRep: true,
          currentExerciseInBlock: currentExerciseInBlock,
          isRestPlaying: isRestPlaying,
          mainRest: mainRest,
          mainRestNotifier: mainRestNotifier,
          totalExerciseInBlock: totalExerciseInBlock,
          restTimer: restTimer,
          itemTypeTitle: itemTypeTitle,
          mainNotes: mainNotes,
          isSetComplete: isSetComplete,
          secondsCountDown: secondsCountDown,
          restLinear: restLinear,
          totalRounds: totalRounds,
          currentRound: currentRound,
          isPlaying: isPlaying,
          nextElementText: nextElementText,
          mainWork: mainWork,
          exerciseNotes: exerciseNotes,
          currentExerciseData: currentExerciseData,
          everyTimeExerciseTimer: everyTimeExerciseTimer,
        );
      }
    }
    return Container();
  }

  Future<void> doneSheetFn(BuildContext context) async {
    int totalTime = widget.durationNotifier.value;

    isPlaying.value = false;
    if (EveentTriggered.workout_completed != null) {
      final DateTime now = DateTime.now();
      final String formatTime = WorkoutDetailController.getFormatTimeFn(
          widget.durationNotifier.value);
      DateTime dateType = DateFormat("HH:mm:ss").parse(formatTime);
      DateTime newDate = DateTime(now.year, now.month, now.day, dateType.hour,
          dateType.minute, dateType.second);

      EveentTriggered.workout_completed!(widget.workoutModel.title.toString(),
          widget.workoutModel.id.toString(), newDate);
    }
    if (widget.followTrainingPlanModel != null) {
      if (EveentTriggered.plan_completed != null) {
        EveentTriggered.plan_completed!(
            widget.followTrainingPlanModel!.trainingPlanTitle,
            widget.followTrainingPlanModel!.trainingPlanId);
      }
    }

    await showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) => PopScope(
        canPop: false,
        onPopInvoked: (value) {
          isPlaying.value = true;
        },
        child: DoneWorkoutSheet(
            type: widget.fitnessGoalModel.entries.first.value,
            workoutName: widget.workoutModel.title.toString(),
            totalDuration: totalTime,
            followTrainingPlanModel: widget.followTrainingPlanModel,
            trainingData: widget.trainingData,
            warmUpData: widget.warmUpData,
            coolDownData: widget.coolDownData),
      ),
    );
  }

  Future<void> getReadyFn(
      BuildContext context,
      String title,
      Map<ExerciseDetailModel, ExerciseModel> currentListData,
      int toNext) async {
    isPlaying.value = false;
    await showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return PopScope(
          onPopInvoked: (didPop) {
            if (isPlaying.value == false) {
              isPlaying.value = true;
            }
          },
          child: UpNextSheetWidget(
            isFromNext: true,
            workoutModel: widget.workoutModel,
            warmUpData: widget.warmUpData,
            trainingData: widget.trainingData,
            coolDownData: widget.coolDownData,
            equipmentData: widget.equipmentData,
            durationNotifier: widget.durationNotifier,
            fitnessGoalModel: widget.fitnessGoalModel,
            title: title,
            currentListData: currentListData,
            sliderWarmUp: sliderWarmUp,
            sliderTraining: sliderTraining,
            sliderCoolDown: sliderCoolDown,
            warmupBody: pageController.page!.toInt(),
            trainingBody:
                pageController.page!.toInt() - widget.warmUpData.length,
            coolDownBody: pageController.page!.toInt() -
                widget.trainingData.length -
                widget.warmUpData.length,
            followTrainingPlanModel: widget.followTrainingPlanModel,
          ),
        );
      },
    ).then((value) async {
      if (value == false) {
        await pageController.animateToPage(0,
            duration: const Duration(milliseconds: 100), curve: Curves.easeIn);

        getCurrentExerciseViewFn(0);
        setState(() {});
      } else if (value == true) {
        await pageController.animateToPage(toNext,
            duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
        getCurrentExerciseViewFn(pageController.page!.toInt());
        setState(() {});
      }
    });
  }
}
