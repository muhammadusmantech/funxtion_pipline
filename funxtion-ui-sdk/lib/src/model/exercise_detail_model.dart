import 'package:ui_tool_kit/ui_tool_kit.dart';

class ExerciseDetailModel {
  int? completePhaseTime;
  ItemType exerciseCategoryName;
  int exerciseNo;
  int? setsCount;
  String? exerciseNotes;
  String? mainNotes;
  List<List<SetGoalTargetAndResistentTarget>>? goalTargets;
  List<List<SetGoalTargetAndResistentTarget>>? resistanceTargets;
  int? mainRest;
  int? mainSets;
  int? mainRestRound;
  int? mainWork;
  List<int>? inSetRest;
  int? rftRounds;
  int? amrapDuration;
  int? emomMinute;
  Map<String, String>? currentGoalTargets;
  Map<String, String>? currentResistanceTargets;
  String? itemTypeTitle;
  int? currentRound;
  String? nextExerciseText;
  int? totalExerciseInBlock;
  int? currentExerciseInBlock;
  ExerciseDetailModel({
    required this.exerciseCategoryName,
    required this.exerciseNo,
    this.completePhaseTime,
    this.mainNotes,
    this.setsCount,
    this.exerciseNotes,
    this.rftRounds,
    this.inSetRest,
    this.mainRest,
    this.mainRestRound,
    this.mainSets,
    this.mainWork,
    this.goalTargets,
    this.resistanceTargets,
    this.amrapDuration,
    this.emomMinute,
    this.currentGoalTargets,
    this.currentResistanceTargets,
    this.itemTypeTitle,
    this.currentRound,
    this.nextExerciseText,
    this.currentExerciseInBlock,
    this.totalExerciseInBlock,
  });
}
