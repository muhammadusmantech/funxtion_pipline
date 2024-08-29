import 'package:flutter/material.dart';
import 'package:funxtion/funxtion_sdk.dart';
import 'package:ui_tool_kit/ui_tool_kit.dart';

class DashBoardController {
  static getData(BuildContext context,
      {required ValueNotifier<bool> isLoading,
      required Map<int, String> workoutDataType,
      required Map<int, String> videoDataType,
      required Map<int, String> audioDataType,
      required List<OnDemandModel> onDemandDataVideo,
      required List<OnDemandModel> audioData,
      required List<WorkoutModel> workoutData,
      required List<TrainingPlanModel> trainingPlanData,
      required Map<int, String> filterFitnessGoalData}) async {
    isLoading.value = true;

    await CommonController.getListCategoryTypeDataFn(
      context,
    );
    if (context.mounted) {
      await CommonController.getListGoalData(context);
    }
    if (context.mounted) {
      await CommonController.getOnDemandContentCategoryFn(context);
    }
    try {
      if (context.mounted) {
        await ListController.getListTrainingPlanDataFn(context,
                pageNumber: 0,
                confirmedFilter: ValueNotifier([]),
                limitContentPerPage: 4)
            .then((value) {
          if (value != null && context.mounted) {
            trainingPlanData.addAll(value);
          }
        });
      }
    } on RequestException catch (e) {
      if (context.mounted) {
        BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
      }
    }
    try {
      if (context.mounted) {
        await ListController.getListOnDemandDataFn(context,
                pageNumber: 0,
                confirmedFilter: ValueNotifier([]),
                limitContentPerPage: 4)
            .then((value) async {
          if (value != null && context.mounted) {
            onDemandDataVideo.addAll(value);
          }
        });
      }
    } on RequestException catch (e) {
      if (context.mounted) {
        BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
      }
    }

    try {
      if (context.mounted) {
        await ListController.getListOnDemandAudioDataFn(context,
                pageNumber: 0,
                confirmedFilter: ValueNotifier([]),
                limitContentPerPage: 4)
            .then((value) async {
          if (value != null && context.mounted) {
            audioData.addAll(value);
          }
        });
      }
    } on RequestException catch (e) {
      if (context.mounted) {
        BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
      }
    }

    try {
      if (context.mounted) {
        await ListController.getListWorkoutDataFn(context,
                pageNumber: 0,
                confirmedFilter: ValueNotifier([]),
                limitContentPerPage: 4)
            .then((value) async {
          if (value != null && context.mounted) {
            workoutData.addAll(value);
          }
        });
      }
    } on RequestException catch (e) {
      if (context.mounted) {
        BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
      }
    }
    if (context.mounted) {
      CommonController.getFilterFitnessGoalData(() {
        if (!context.mounted) {
          return;
        }
      },
          trainingPlanData: trainingPlanData,
          filterFitnessGoalData: filterFitnessGoalData);
    }

    CommonController.getListFilterOnDemandCategoryTypeFn(
        0, audioData, audioDataType);
    CommonController.getListFilterOnDemandCategoryTypeFn(
        0, onDemandDataVideo, videoDataType);
    CommonController.filterCategoryTypeData(
        listWorkoutData: workoutData, categoryFilterTypeData: workoutDataType);
    if (CommonController.equipmentListData.isEmpty) {
      if (context.mounted) {
        CommonController.getListEquipmentData(context);
      }
    }
    if (CommonController.listBodyPartData.isEmpty) {
      if (context.mounted) {
        CommonController.getListBodyPartData(context);
      }
    }
    isLoading.value = false;
  }
}
