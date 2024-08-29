import 'package:flutter/material.dart';
import 'package:funxtion/funxtion_sdk.dart';

import '../../ui_tool_kit.dart';

class TrainingPlanDetailController {
  static Future<TrainingPlanModel?> getATrainingPlanDataFn(context,
      {required String id}) async {
    try {
      Map<String, dynamic>? fetchedData =
          await TrainingPlanRequest.trainingPlanById(id: id);
      if (fetchedData != null) {
        return TrainingPlanModel.fromJson(fetchedData);
      }
    } on RequestException catch (e) {
      BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
    }

    return null;
  }

  static schedulePlanFn(BuildContext context,
      {required ValueNotifier<bool> schedulePlanLoader,
      required List<WorkoutModel> listScheduleWorkoutData,
      required TrainingPlanModel? trainingPlanData,
      required Map<int, String> categoryFilterTypeData,
      required ValueNotifier<int> weekIndex}) async {
    schedulePlanLoader.value = true;
    listScheduleWorkoutData.clear();
    List<String> workoutIds = [];
    Map<String, WorkoutModel> scheduleWorkouts = {};
    try {
      for (var week in trainingPlanData!.weeks!) {
        for (var day in week.days) {
          workoutIds.add(day.activities.first.id.toString());
        }
      }
      final scheduleData = await WorkoutRequest.listOfWorkout(
        queryParameters: {
          "filter[limit]": 250,
          "filter[offset]": 0,
          "filter[where][id]": workoutIds.toSet().toList().join(",")
        },
      );

      if (scheduleData != null) {
        final List<WorkoutModel> workoutList =
            List.from(scheduleData.map((e) => WorkoutModel.fromJson(e)));

        scheduleWorkouts = {for (var (item) in workoutList) item.id!: item};

        for (var week in trainingPlanData!.weeks!) {
          for (var day in week.days) {
            final String workoutId = day.activities.first.id.toString();
            listScheduleWorkoutData.add(scheduleWorkouts[workoutId]!);
          }
        }
      }

      CommonController.filterCategoryTypeData(
          listWorkoutData: listScheduleWorkoutData,
          categoryFilterTypeData: categoryFilterTypeData);
    } finally {
      schedulePlanLoader.value = false;
    }
  }
}
