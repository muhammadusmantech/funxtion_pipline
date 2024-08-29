import 'dart:async';

import 'package:flutter/material.dart';

import 'package:funxtion/funxtion_sdk.dart';

import '../../ui_tool_kit.dart';

class ListController {
  static Future<List<OnDemandModel>?> getListOnDemandDataFn(
      BuildContext context,
      {String? mainSearch,
      int? limitContentPerPage,
      required int pageNumber,
      required ValueNotifier<List<SelectedFilterModel>>
          confirmedFilter}) async {
    try {
      final fetchedData = await OnDemandRequest.listOnDemand(
        queryParameters: {
          "filter[where][type][eq]": 'virtual-class',
          "filter[offset]": pageNumber,
          "filter[limit]": limitContentPerPage ?? 10,
          if (checkfilterFn('duration', confirmedFilter.value))
            "filter[where][duration][in]":
                searchFilterFn('duration', confirmedFilter.value),
          if (mainSearch != null) "filter[where][q][contains]": mainSearch,
          if (checkfilterFn("level", confirmedFilter.value))
            "filter[where][level][in]":
                searchFilterFn('level', confirmedFilter.value),
          if (checkfilterFn('categories', confirmedFilter.value))
            "filter[where][categories][in]":
                searchFilterFn('categories', confirmedFilter.value),
          if (checkfilterFn('equipment', confirmedFilter.value))
            "filter[where][equipment][in]":
                searchFilterFn('equipment', confirmedFilter.value),
          if (checkfilterFn('instructor', confirmedFilter.value))
            "filter[where][instructor][in]":
                searchFilterFn('instructor', confirmedFilter.value),
        },
      );
      if (fetchedData != null) {
        final List<OnDemandModel> data =
            List.from(fetchedData.map((e) => OnDemandModel.fromJson(e)));

        return data;
      }
    } on RequestException catch (e) {
      if (context.mounted) {
        BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
      }
    }

    return null;
  }

  static Future<List<OnDemandModel>?> getListOnDemandAudioDataFn(context,
      {String? mainSearch,
      int? limitContentPerPage,
      required int pageNumber,
      required ValueNotifier<List<SelectedFilterModel>>
          confirmedFilter}) async {
    try {
      final fetchedData = await OnDemandRequest.listOnDemand(
        queryParameters: {
          "filter[where][type][eq]": 'audio-workout',
          "filter[limit]": limitContentPerPage ?? 10,
          "filter[offset]": pageNumber,
          if (checkfilterFn('duration', confirmedFilter.value))
            "filter[where][duration][in]":
                searchFilterFn('duration', confirmedFilter.value),
          if (mainSearch != null) "filter[where][q][contains]": mainSearch,
          if (checkfilterFn('level', confirmedFilter.value))
            "filter[where][level][in]":
                searchFilterFn('level', confirmedFilter.value),
          if (checkfilterFn('categories', confirmedFilter.value))
            "filter[where][categories][in]":
                searchFilterFn('categories', confirmedFilter.value),
          if (checkfilterFn('equipment', confirmedFilter.value))
            "filter[where][equipment][in]":
                searchFilterFn('equipment', confirmedFilter.value),
          if (checkfilterFn('instructor', confirmedFilter.value))
            "filter[where][instructor][in]":
                searchFilterFn('instructor', confirmedFilter.value),
        },
      );
      if (fetchedData != null) {
        final List<OnDemandModel> data =
            List.from(fetchedData.map((e) => OnDemandModel.fromJson(e)));
        return data;
      }
    } on RequestException catch (e) {
      BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
    }

    return null;
  }

  static Future<List<WorkoutModel>?> getListWorkoutDataFn(context,
      {String? mainSearch,
      int? limitContentPerPage,
      required int pageNumber,
      required ValueNotifier<List<SelectedFilterModel>>
          confirmedFilter}) async {
    try {
      final fetchedData = await WorkoutRequest.listOfWorkout(
        queryParameters: {
          "filter[limit]": limitContentPerPage ?? 10,
          "filter[offset]": pageNumber,
          if (mainSearch != null) "filter[where][q][contains]": mainSearch,
          if (checkfilterFn('goals', confirmedFilter.value))
            "filter[where][goals][in]":
                searchFilterFn('goals', confirmedFilter.value),
          if (checkfilterFn('body_parts', confirmedFilter.value))
            "filter[where][body_parts][in]":
                searchFilterFn('body_parts', confirmedFilter.value),
          if (checkfilterFn('level', confirmedFilter.value))
            "filter[where][level][in]":
                searchFilterFn('level', confirmedFilter.value),
          if (checkfilterFn('duration', confirmedFilter.value))
            "filter[where][duration][in]":
                searchFilterFn('duration', confirmedFilter.value),
          if (checkfilterFn('types', confirmedFilter.value))
            "filter[where][types][in]":
                searchFilterFn('types', confirmedFilter.value),
          if (checkfilterFn('locations', confirmedFilter.value))
            "filter[where][locations][in]":
                searchFilterFn('locations', confirmedFilter.value),
        },
      );
      if (fetchedData != null) {
        final List<WorkoutModel> data =
            List.from(fetchedData.map((e) => WorkoutModel.fromJson(e)));

        return data;
      }
    } on RequestException catch (e) {
      BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
    }

    return null;
  }

  static Future<List<TrainingPlanModel>?> getListTrainingPlanDataFn(context,
      {String? mainSearch,
      int? limitContentPerPage,
      required int pageNumber,
      required ValueNotifier<List<SelectedFilterModel>>
          confirmedFilter}) async {
    try {
      final fetchedData = await TrainingPlanRequest.listOfTrainingPlan(
        queryParameters: {
          "filter[limit]": limitContentPerPage ?? 10,
          "filter[offset]": pageNumber,
          if (mainSearch != null) "filter[where][q][contains]": mainSearch,
          if (checkfilterFn('goals', confirmedFilter.value))
            "filter[where][goals][in]":
                searchFilterFn('goals', confirmedFilter.value),
          if (checkfilterFn('level', confirmedFilter.value))
            "filter[where][level][in]":
                searchFilterFn('level', confirmedFilter.value),
          if (checkfilterFn('locations', confirmedFilter.value))
            "filter[where][locations][in]":
                searchFilterFn('locations', confirmedFilter.value),
          if (checkfilterFn('max_days_per_week', confirmedFilter.value))
            "filter[where][max_days_per_week][in]":
                searchFilterFn('max_days_per_week', confirmedFilter.value),
        },
      );
      if (fetchedData != null) {
        final List<TrainingPlanModel> data =
            List.from(fetchedData.map((e) => TrainingPlanModel.fromJson(e)));

        return data;
      }
    } on RequestException catch (e) {
      BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
    }

    return null;
  }

  static Future<List<TrainingPlanModel>?> getLocalTrainingPlanDataFn(context,
      {String? mainSearch,
      required List<String> ids,
      required ValueNotifier<List<SelectedFilterModel>>
          confirmedFilter}) async {
    try {
      final fetchedData = await TrainingPlanRequest.listOfTrainingPlan(
        queryParameters: {
          "filter[where][id][in]": ids.join(','),
          if (mainSearch != null) "filter[where][q][contains]": mainSearch,
          if (checkfilterFn('goals', confirmedFilter.value))
            "filter[where][goals][in]":
                searchFilterFn('goals', confirmedFilter.value),
          if (checkfilterFn('level', confirmedFilter.value))
            "filter[where][level][in]":
                searchFilterFn('level', confirmedFilter.value),
          if (checkfilterFn('locations', confirmedFilter.value))
            "filter[where][locations][in]":
                searchFilterFn('locations', confirmedFilter.value),
          if (checkfilterFn('max_days_per_week', confirmedFilter.value))
            "filter[where][max_days_per_week][in]":
                searchFilterFn('max_days_per_week', confirmedFilter.value),
        },
      );
      if (fetchedData != null) {
        final List<TrainingPlanModel> data =
            List.from(fetchedData.map((e) => TrainingPlanModel.fromJson(e)));

        return data;
      }
    } on RequestException catch (e) {
      BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
    }

    return null;
  }

  static bool checkfilterFn(
      String type, List<SelectedFilterModel>? confirmedFilter) {
    if (confirmedFilter != null) {
      for (var element in confirmedFilter) {
        if (element.filterType.toLowerCase() == type) {
          return true;
        }
      }
    }
    return false;
  }

  static String? searchFilterFn(
      String type, List<SelectedFilterModel>? confirmedFilter) {
    List<String> filters = [];

    if (confirmedFilter != null) {
      for (var element in confirmedFilter) {
        if (element.filterType.toLowerCase() == type) {
          if (element.filterId.toString() != "null") {
            filters.add(element.filterId.toString());
          } else {
            filters.add(element.filterName);
          }
        }
      }

      if (filters.isNotEmpty) {
        return filters.map((e) => e.toLowerCase().trim()).join(",");
      }
    }
    return null;
  }

  static List<FiltersModel> filterListData = [];
  static Future<List<FiltersModel>> runComplexTask(
    context,
    CategoryName name,
    ValueNotifier<bool> filterLoader,
  ) async {
    filterLoader.value = true;
    if (filterListData.isEmpty) {
      filterListData.clear();
      if (name == CategoryName.videoClasses ||
          name == CategoryName.audioClasses) {
        try {
          await OnDemandRequest.onDemandFilter().then((value) async {
            for (var element in value!) {
              if (element['key'] == "q" ||
                  element['key'] == "type" ||
                  element['key'] == "content_package") {
              } else if (element['values'].length > 2) {
                FiltersModel value = FiltersModel.fromJson(element);
                filterListData.add(value);
              }
            }
          });
        } on RequestException catch (e) {
          BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
        }
      } else if (name == CategoryName.workouts) {
        try {
          await WorkoutRequest.workoutFilters().then((value) async {
            for (var element in value!) {
              if (element['key'] == "q" ||
                  element['key'] == "content_package") {
              } else if (element['values'].length > 2) {
                FiltersModel value = FiltersModel.fromJson(element);
                filterListData.add(value);
              }
            }
          });
        } on RequestException catch (e) {
          BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
        }
      } else if (name == CategoryName.trainingPlans) {
        try {
          await TrainingPlanRequest.trainingPlanFilters().then((value) {
            for (var element in value!) {
              if (element['key'] == "q" ||
                  element['key'] == "type" ||
                  element['key'] == "content_package" ||
                  element['key'] == "max_days_per_week") {
              } else if (element['values'].length > 2) {
                FiltersModel value = FiltersModel.fromJson(element);
                filterListData.add(value);
              }
            }
          });
        } on RequestException catch (e) {
          BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
        }
      }
    }
    filterLoader.value = false;
    return filterListData;
  }

  static void deleteAFilterFn(context, String e,
      ValueNotifier<List<SelectedFilterModel>> confirmedFilter) {
    confirmedFilter.value.removeWhere((element) => element.filterName == e);
  }

  static void addFilterFn(
      SelectedFilterModel value,
      List<SelectedFilterModel> selectedFilter,
      ValueNotifier<List<SelectedFilterModel>> confirmedFilter) {
    if (selectedFilter.any((element) =>
        element.filterName == value.filterName &&
        element.filterType == value.filterType)) {
      selectedFilter.removeWhere((element) =>
          element.filterName == value.filterName &&
          element.filterType == value.filterType);

      return;
    } else {
      selectedFilter.add(value);

      return;
    }
  }

  static bool restConfirmFilterAlso = false;
  static void resetFilterFn(context, List<SelectedFilterModel> selectedFilter,
      ValueNotifier<List<SelectedFilterModel>> confirmedFilter) {
    if (confirmedFilter.value.isNotEmpty) {
      restConfirmFilterAlso = true;
      confirmedFilter.value.clear();
    }
    selectedFilter.clear();
  }

  static void clearAppliedFilterFn(
    ValueNotifier<List<SelectedFilterModel>> confirmedFilter,
  ) {
    confirmedFilter.value.clear();
  }

  static void confirmFilterFn({
    required ValueNotifier<List<SelectedFilterModel>> confirmedFilter,
    required List<SelectedFilterModel> selectedFilter,
  }) {
    confirmedFilter.value = selectedFilter;
  }

  static Map<int, String> workoutDataType = {};
  static Map<int, String> videoDataType = {};
  static Map<int, String> audioDataType = {};

  static Timer? timer;
  static void deBouncerFn({
    required VoidCallback fn,
  }) async {
    if (timer != null) {
      timer!.cancel();
    }

    timer = Timer(const Duration(milliseconds: 950), fn);
  }

  static int getCurrentItemCountFn({
    required CategoryName categoryName,
    required List<OnDemandModel> listOndemandData,
    required List<WorkoutModel> listWorkoutData,
  }) {
    return categoryName == CategoryName.videoClasses
        ? listOndemandData.length
        : categoryName == CategoryName.workouts
            ? listWorkoutData.length
            : listOndemandData.length;
  }

  static List? getCurrentListFn({
    required CategoryName categoryName,
    required List<OnDemandModel> listOndemandData,
    required List<WorkoutModel> listWorkoutData,
  }) {
    switch (categoryName) {
      case CategoryName.videoClasses:
        return listOndemandData;

      case CategoryName.audioClasses:
        return listOndemandData;

      case CategoryName.workouts:
        return listWorkoutData;

      default:
        return [];
    }
  }

  static String getTitleFn({
    required int index,
    required CategoryName categoryName,
    required List<OnDemandModel> listOndemandData,
    required List<WorkoutModel> listWorkoutData,
  }) {
    return categoryName == CategoryName.videoClasses
        ? listOndemandData[index].title.toString()
        : categoryName == CategoryName.workouts
            ? listWorkoutData[index].title.toString()
            : listOndemandData[index].title.toString();
  }

  static String getSubtitleFn(
    BuildContext context, {
    required int index,
    required CategoryName categoryName,
    required List<OnDemandModel> listOndemandData,
    required List<WorkoutModel> listWorkoutData,
    required Map<int, String> categoryTypeData,
    required Map<int, String> onDemandCategoryVideoData,
    required Map<int, String> onDemandCategoryAudioData,
  }) {
    return categoryName == CategoryName.videoClasses
        ? "${listOndemandData[index].duration} ${context.loc.minText} • ${onDemandCategoryVideoData[index] == "" ? "" : "${onDemandCategoryVideoData[index]} • "}${listOndemandData[index].level.toString()}"
        : categoryName == CategoryName.workouts
            ? "${listWorkoutData[index].duration} ${context.loc.minText} • ${categoryTypeData[index] == "" ? "" : "${categoryTypeData[index]} • "}${listWorkoutData[index].level.toString()}"
            : "${listOndemandData[index].duration} ${context.loc.minText} • ${onDemandCategoryAudioData[index] == "" ? "" : "${onDemandCategoryAudioData[index]} • "}${listOndemandData[index].level}";
  }

  static String getImageUrlFn({
    required int index,
    required CategoryName categoryName,
    required List<OnDemandModel> listOndemandData,
    required List<WorkoutModel> listWorkoutData,
  }) {
    return categoryName == CategoryName.videoClasses
        ? listOndemandData[index].image.toString()
        : categoryName == CategoryName.workouts
            ? listWorkoutData[index].image.toString()
            : listOndemandData[index].image.toString();
  }
}
