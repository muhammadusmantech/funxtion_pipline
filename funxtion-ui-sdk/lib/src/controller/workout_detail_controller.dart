import 'package:flutter/material.dart';
import 'package:funxtion/funxtion_sdk.dart';

import '../../ui_tool_kit.dart';

class WorkoutDetailController {
  static String getFormatTimeFn(value) {
    return Duration(seconds: value).toString();
  }

  static Future<WorkoutModel?> getworkoutDataFn(context,
      {required String id}) async {
    try {
      final fetchedData = await WorkoutRequest.workoutById(id: id);
      if (fetchedData != null) {
        WorkoutModel data = WorkoutModel.fromJson(fetchedData);

        return data;
      }
    } on RequestException catch (e) {
      BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
    }

    return null;
  }

  static Future<BodyPartModel?> getBodyPartFn(context, String id) async {
    try {
      final fetchedData = await BodyPartsRequest.bodyPartById(id: id);
      if (fetchedData != null) {
        BodyPartModel data = BodyPartModel.fromJson(fetchedData);

        return data;
      }
    } on RequestException catch (e) {
      BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
    }
    return null;
  }

  static getWarmUpDataFn(context,
      {required ValueNotifier<bool> warmUpLoader,
      required WorkoutModel? workoutData,
      required Map<ExerciseDetailModel, ExerciseModel> warmupData,
      required List<Map<String, int>> equipmentData}) async {
    warmUpLoader.value = true;

    warmupData.clear();
    await phasesFn(0, workoutData, context, warmupData, equipmentData);

    warmUpLoader.value = false;
  }

  static getTrainingDataFn(context,
      {required ValueNotifier<bool> trainingLoader,
      required WorkoutModel? workoutData,
      required Map<ExerciseDetailModel, ExerciseModel> trainingData,
      required List<Map<String, int>> equipmentIds}) async {
    trainingLoader.value = true;

    trainingData.clear();
    await phasesFn(1, workoutData, context, trainingData, equipmentIds);

    trainingLoader.value = false;
  }

  static getCoolDownDataFn(context,
      {required ValueNotifier<bool> coolDownLoader,
      required WorkoutModel? workoutData,
      required Map<ExerciseDetailModel, ExerciseModel> coolDownData,
      required List<Map<String, int>> equipmentIds}) async {
    coolDownLoader.value = true;

    coolDownData.clear();
    await phasesFn(2, workoutData, context, coolDownData, equipmentIds);

    coolDownLoader.value = false;
  }

  static Future<void> phasesFn(
      int phaseIndex,
      WorkoutModel? workoutData,
      BuildContext context,
      Map<ExerciseDetailModel, ExerciseModel> exerciseList,
      List<Map<String, int>> equipmentIds) async {
    try {
      List<Map<String, ExerciseDetailModel>> data = [];
      if (workoutData == null || workoutData.phases == null) return;
      final phase = workoutData.phases![phaseIndex];

      for (var item in phase.items!) {
        switch (item.type) {
          case ItemType.circuitTime:
            _processCircuitTime(context,
                item: item, data: data, phaseTime: phase.time);
            break;
          case ItemType.circuitRep:
            _processCircuitRep(context,
                item: item, data: data, phaseTime: phase.time);
            break;
          case ItemType.singleExercise:
            _processSingleExercise(context,
                item: item, data: data, phaseTime: phase.time);
            break;
          case ItemType.superSet:
            _processSuperset(context,
                item: item, data: data, phaseTime: phase.time);
            break;
          case ItemType.amrap:
            _processAmrap(context,
                item: item, data: data, phaseTime: phase.time);
            break;
          case ItemType.rft:
            _processRft(context, item: item, data: data, phaseTime: phase.time);
            break;
          case ItemType.emom:
            _processEmom(context,
                item: item, data: data, phaseTime: phase.time);
            break;
          default:
            break;
        }
      }
      await _fetchExerciseData(
          context, phaseIndex, data, exerciseList, equipmentIds);
    } on RequestException catch (e) {
      if (context.mounted) {
        BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
      }
    }
  }

  static void _processEmom(
    BuildContext context, {
    required Item item,
    required List<Map<String, ExerciseDetailModel>> data,
    int? phaseTime,
  }) {
    for (var i = 0; i < item.emomMinutes!.length; i++) {
      if (!context.mounted) {
        break;
      }
      final emomMinute = item.emomMinutes![i];
      for (var l = 0; l < emomMinute.exercises!.length; l++) {
        if (!context.mounted) {
          break;
        }
        final exercise = emomMinute.exercises![l];
        data.add({
          exercise.exerciseId.toString(): ExerciseDetailModel(
            emomMinute: i + 1,
            completePhaseTime: phaseTime ?? 0,
            exerciseCategoryName: ItemType.emom,
            exerciseNo: l,
            goalTargets: exercise.goalTargets?.isNotEmpty ?? false
                ? [exercise.goalTargets!]
                : null,
            resistanceTargets: exercise.resistanceTargets?.isNotEmpty ?? false
                ? [exercise.resistanceTargets!]
                : null,
            mainNotes: item.notes?.trim(),
            exerciseNotes: exercise.notes?.trim(),
          )
        });
      }
    }
  }

  static void _processRft(
    BuildContext context, {
    required Item item,
    required List<Map<String, ExerciseDetailModel>> data,
    int? phaseTime,
  }) {
    for (var i = 0; i < item.rftExercises!.length; i++) {
      if (!context.mounted) {
        break;
      }
      final rftExercise = item.rftExercises![i];
      data.add({
        rftExercise.exerciseId.toString(): ExerciseDetailModel(
            completePhaseTime: phaseTime ?? 0,
            exerciseCategoryName: ItemType.rft,
            exerciseNo: i,
            mainNotes: item.notes?.trim(),
            exerciseNotes: rftExercise.notes?.trim(),
            goalTargets: rftExercise.goalTargets?.isNotEmpty ?? false
                ? [rftExercise.goalTargets!]
                : null,
            resistanceTargets:
                rftExercise.resistanceTargets?.isNotEmpty ?? false
                    ? [rftExercise.resistanceTargets!]
                    : null,
            rftRounds: item.rftRounds)
      });
    }
  }

  static void _processAmrap(
    BuildContext context, {
    required Item item,
    required List<Map<String, ExerciseDetailModel>> data,
    int? phaseTime,
  }) {
    for (var i = 0; i < item.amrapExercises!.length; i++) {
      if (!context.mounted) {
        break;
      }
      final amrapExercise = item.amrapExercises![i];
      data.add({
        amrapExercise.exerciseId.toString(): ExerciseDetailModel(
            completePhaseTime: phaseTime ?? 0,
            exerciseCategoryName: ItemType.amrap,
            exerciseNo: i,
            mainNotes: item.notes?.trim(),
            amrapDuration: item.amrapDuration,
            exerciseNotes: amrapExercise.notes?.trim(),
            goalTargets: amrapExercise.goalTargets?.isNotEmpty ?? false
                ? [amrapExercise.goalTargets!]
                : null,
            resistanceTargets:
                amrapExercise.resistanceTargets?.isNotEmpty ?? false
                    ? [amrapExercise.resistanceTargets!]
                    : null)
      });
    }
  }

  static void _processSuperset(
    BuildContext context, {
    required Item item,
    required List<Map<String, ExerciseDetailModel>> data,
    int? phaseTime,
  }) {
    for (var i = 0; i < item.ssExercises!.length; i++) {
      if (!context.mounted) {
        break;
      }
      final ssExercise = item.ssExercises![i];
      data.add({
        ssExercise.exerciseId.toString(): ExerciseDetailModel(
          completePhaseTime: phaseTime ?? 0,
          exerciseCategoryName: ItemType.superSet,
          exerciseNo: i,
          goalTargets: ssExercise.goalTargets?.isNotEmpty ?? false
              ? [ssExercise.goalTargets!]
              : null,
          resistanceTargets: ssExercise.resistanceTargets?.isNotEmpty ?? false
              ? [ssExercise.resistanceTargets!]
              : null,
          exerciseNotes: ssExercise.notes?.trim(),
          mainNotes: item.notes?.trim(),
          mainSets: item.ssSets,
          mainRest: item.ssRest,
        )
      });

      if (!context.mounted) {
        break;
      }
    }
  }

  static void _processCircuitRep(
    BuildContext context, {
    required Item item,
    required List<Map<String, ExerciseDetailModel>> data,
    int? phaseTime,
  }) {
    for (var i = 0; i < item.crRounds!.length; i++) {
      final crRound = item.crRounds![i];
      var setsCount = i + 1;
      for (var k = 0; k < crRound.exercises!.length; k++) {
        if (!context.mounted) break;
        final exercise = crRound.exercises![k];
        String key = exercise.exerciseId.toString();

        data.add({
          key: ExerciseDetailModel(
              completePhaseTime: phaseTime ?? 0,
              setsCount: setsCount,
              exerciseCategoryName: ItemType.circuitRep,
              exerciseNo: k,
              mainRestRound: crRound.restRound,
              mainRest: crRound.rest,
              mainNotes: item.notes?.trim(),
              exerciseNotes: exercise.notes?.trim(),
              goalTargets: exercise.goalTargets?.isNotEmpty ?? false
                  ? [exercise.goalTargets!]
                  : null,
              resistanceTargets: exercise.resistanceTargets?.isNotEmpty ?? false
                  ? [exercise.resistanceTargets!]
                  : null)
        });
      }
    }
  }

  static void _processSingleExercise(
    BuildContext context, {
    required Item item,
    required List<Map<String, ExerciseDetailModel>> data,
    int? phaseTime,
  }) {
    for (var i = 0; i < item.seExercises!.length; i++) {
      final seExercise = item.seExercises![i];
      List<int> restAfterSet = [];
      List<List<SetGoalTargetAndResistentTarget>> goalTargets = [];
      List<List<SetGoalTargetAndResistentTarget>> resistanceTargets = [];
      for (var s = 0; s < seExercise.sets!.length; s++) {
        final set = seExercise.sets![s];
        restAfterSet.add(set.rest!);
        resistanceTargets.insert(s, set.resistanceTargets!);

        goalTargets.insert(s, set.goalTargets!);
      }
      data.add({
        seExercise.exerciseId.toString(): ExerciseDetailModel(
            completePhaseTime: phaseTime ?? 0,
            exerciseCategoryName: ItemType.singleExercise,
            exerciseNo: i,
            goalTargets: goalTargets,
            resistanceTargets: resistanceTargets,
            exerciseNotes: seExercise.notes?.trim(),
            mainNotes: item.notes?.trim(),
            setsCount: seExercise.sets!.length,
            inSetRest: restAfterSet)
      });

      if (!context.mounted) {
        break;
      }
    }
  }

  static void _processCircuitTime(
    BuildContext context, {
    required Item item,
    required List<Map<String, ExerciseDetailModel>> data,
    int? phaseTime,
  }) {
    for (var i = 0; i < item.ctRounds!.length; i++) {
      if (!context.mounted) break;
      final ctRound = item.ctRounds![i];
      var setsCount = i + 1;

      for (var k = 0; k < ctRound.exercises!.length; k++) {
        if (!context.mounted) break;

        final exercise = ctRound.exercises![k];
        String key = exercise.exerciseId.toString();

        data.add({
          key: ExerciseDetailModel(
            completePhaseTime: phaseTime ?? 0,
            setsCount: setsCount,
            exerciseCategoryName: ItemType.circuitTime,
            exerciseNo: k,
            mainRestRound: ctRound.restRound,
            mainNotes: item.notes?.trim(),
            mainRest: ctRound.rest,
            mainWork: ctRound.work,
            exerciseNotes: exercise.notes?.trim(),
            resistanceTargets: exercise.resistanceTargets?.isNotEmpty ?? false
                ? [exercise.resistanceTargets!]
                : null,
          ),
        });
      }
    }
  }

  static List<ExerciseModel> _sortExercisesById(
      List<ExerciseModel> exercises, List<String> ids) {
    List<ExerciseModel> sortedExercises = [];
    for (var id in ids) {
      ExerciseModel? exercise =
          exercises.firstWhere((element) => element.id == id);

      sortedExercises.add(exercise);
    }
    return sortedExercises;
  }

  static _fetchExerciseData(
      context,
      int phaseIndex,
      List<Map<String, ExerciseDetailModel>> idData,
      Map<ExerciseDetailModel, ExerciseModel> exerciseData,
      List<Map<String, int>> equipmentIds) async {
    try {
      List<String> ids = idData.map((map) => map.keys.first).toList();
      await ExerciseRequest.listOfExercise(
              queryParameters: {"filter[where][id][in]": ids.join(',')})
          .then((value) async {
        List<ExerciseModel>? fetchData;
        if (value != null) {
          fetchData = List.from(value.map((e) => ExerciseModel.fromJson(e)));

          List<ExerciseModel> newData = _sortExercisesById(fetchData, ids);

          for (var i = 0; i < newData.length; i++) {
            var exerciseElement = newData[i];
            var element = idData[i];
            if (exerciseElement.id.toString() == element.keys.first) {
              exerciseData[element.values.first] = exerciseElement;
            }

            for (var equipment in exerciseElement.equipment) {
              var data = equipmentIds.where(
                (element) =>
                    element.values.first == equipment &&
                    element.keys.first ==
                        (phaseIndex == 0
                            ? "warmUp"
                            : phaseIndex == 1
                                ? "training"
                                : "coolDown"),
              );
              if (data.isEmpty) {
                equipmentIds.add({
                  phaseIndex == 0
                      ? "warmUp"
                      : phaseIndex == 1
                          ? "training"
                          : "coolDown": equipment
                });
              }
            }
          }
        }
      });
    } on RequestException catch (e) {
      BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
    }
  }

  static Map<ExerciseDetailModel, ExerciseModel> addCurrentList(
      int index, Map<ExerciseDetailModel, ExerciseModel> currentListData) {
    Map<ExerciseDetailModel, ExerciseModel> data = {};

    for (var element in currentListData.entries) {
      if (element.key.exerciseCategoryName ==
          currentListData.entries.toList()[index].key.exerciseCategoryName) {
        data.addEntries({element});
      }
    }

    return data;
  }
}
