import 'package:funxtion/funxtion_sdk.dart';

import '../../ui_tool_kit.dart';

class CommonController {
  static List<ContentProvidersCategoryOnDemandModel> categoryTypeData = [];
  static List<ContentProvidersCategoryOnDemandModel> onDemandCategoryData = [];
  static List<FitnessGoalModel> listOfFitnessGoal = [];
  static List<EquipmentModel> equipmentListData = [];
  static List<BodyPartModel> listBodyPartData = [];

  static getListEquipmentData(context) async {
    try {
      await EquipmentRequest.listOfEquipment(
          queryParameters: {"filter[limit]": "200"}).then((value) async {
        if (value != null) {
          List<EquipmentModel> fetchData =
              List.from(value.map((e) => EquipmentModel.fromJson(e)));

          equipmentListData.addAll(fetchData);
        }
      });
    } on RequestException catch (e) {
      BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
    }
  }

  static getListBodyPartData(context) async {
    try {
      await BodyPartsRequest.bodyParts().then((value) async {
        if (value != null) {
          List<BodyPartModel> fetchData =
              List.from(value.map((e) => BodyPartModel.fromJson(e)));

          listBodyPartData.addAll(fetchData);
        }
      });
    } on RequestException catch (e) {
      BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
    }
  }

  static getEquipmentFilterData(
      {required List<Map<String, int>> equipmentIds,
      required List<Map<String, EquipmentModel>> filterEquipmentData}) {
    final equipmentMap = {
      for (var equipment in equipmentListData) equipment.id: equipment
    };

    for (var equipmentIdMap in equipmentIds) {
      final key = equipmentIdMap.keys.first;
      final id = equipmentIdMap[key];
      if (id != null && equipmentMap.containsKey(id)) {
        filterEquipmentData.add({key: equipmentMap[id]!});
      }
    }
  }

  static getBodyPartFilterData(
      {required Set<int> bodyPartIds,
      required List<BodyPartModel> filterData}) {
    Set<int> newIdsList = {};
    newIdsList.addAll(bodyPartIds);
    for (var i = 0; i < newIdsList.length; i++) {
      for (var j = 0; j < listBodyPartData.length; j++) {
        if (newIdsList.toList()[i] == equipmentListData[j].id) {
          filterData.add(listBodyPartData[j]);
        }
      }
    }
  }

  static Future getListGoalData(
    context,
  ) async {
    try {
      await FitnessGoalRequest.listOfFitnessGoal(
          queryParameters: {"filter[limit]": "200"}).then((value) async {
        if (value != null) {
          List<FitnessGoalModel> fetchData =
              List.from(value.map((e) => FitnessGoalModel.fromJson(e)));
          listOfFitnessGoal.addAll(fetchData);
        }
      });
    } on RequestException catch (e) {
      BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
    }
  }

  static getFilterFitnessGoalData(void Function() breakFn,
      {List<TrainingPlanModel>? trainingPlanData,
      TrainingPlanModel? trainingData,
      WorkoutModel? workoutData,
      required Map<int, String> filterFitnessGoalData}) {
    List<FitnessGoalModel> tempList = [];
    int currentI = filterFitnessGoalData.length;
    if (trainingData != null) {
      for (var i = 0; i < trainingData.goals.length; i++) {
        for (var element in listOfFitnessGoal) {
          if (element.id == trainingData.goals[i]) {
            tempList.add(element);
          }
          breakFn();
        }
        breakFn();

        filterFitnessGoalData
            .addAll({0: tempList.map((e) => e.name).join(',')});
      }
    } else if (trainingPlanData != null) {
      for (var j = 0; j < trainingPlanData.length; j++) {
        tempList.clear();

        for (var i = 0; i < trainingPlanData[j].goals.length; i++) {
          for (var element in listOfFitnessGoal) {
            if (element.id == trainingPlanData[j].goals[i]) {
              tempList.add(element);
            }
          }

          breakFn();
        }

        breakFn();
        filterFitnessGoalData
            .addAll({currentI + j: tempList.map((e) => e.name).join(',')});
      }
    } else if (workoutData != null) {
      if (workoutData.goals != null) {
        for (var i = 0; i < workoutData.goals!.length; i++) {
          for (var element in listOfFitnessGoal) {
            if (element.id == workoutData.goals![i]) {
              tempList.add(element);
            }
            breakFn();
          }
          breakFn();

          filterFitnessGoalData
              .addAll({0: tempList.map((e) => e.name).join(',')});
        }
      }
    }
  }

  static getListCategoryTypeDataFn(
    context,
  ) async {
    if (categoryTypeData.isEmpty) {
      try {
        await ContentProviderCategoryOnDemandRequest.contentCategory()
            .then((value) async {
          if (value != null) {
            List<ContentProvidersCategoryOnDemandModel> fetchData = List.from(
                value.map(
                    (e) => ContentProvidersCategoryOnDemandModel.fromJson(e)));
            categoryTypeData.addAll(fetchData);
          }
        });
      } on RequestException catch (e) {
        BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
      }
    }
  }

  static filterCategoryTypeData(
      {List<WorkoutModel>? listWorkoutData,
      WorkoutModel? workoutData,
      required Map<int, String> categoryFilterTypeData}) {
    List<ContentProvidersCategoryOnDemandModel> data = [];
    int currentI = categoryFilterTypeData.length;

    if (listWorkoutData != null) {
      for (var i = 0; i < listWorkoutData.length; i++) {
        data.clear();
        for (var typeElement in listWorkoutData[i].types!) {
          for (var j = 0; j < categoryTypeData.length; j++) {
            if (categoryTypeData[j].id == typeElement) {
              data.add(categoryTypeData[j]);
            }
          }
        }

        categoryFilterTypeData
            .addAll({currentI + i: data.map((e) => e.name).join(',')});
      }
    } else if (workoutData != null) {
      for (var typeElement in workoutData.types!) {
        for (var j = 0; j < CommonController.categoryTypeData.length; j++) {
          if (CommonController.categoryTypeData[j].id == typeElement) {
            data.add(CommonController.categoryTypeData[j]);
          }
        }
      }
      categoryFilterTypeData.addAll({0: data.map((e) => e.name).join(',')});
    }
  }

  static getOnDemandContentCategoryFn(context) async {
    try {
      await ContentProviderCategoryOnDemandRequest.onDemandCategory()
          .then((data) async {
        if (data != null) {
          List<ContentProvidersCategoryOnDemandModel> fetchCategoryData =
              List.from(data.map(
                  (e) => ContentProvidersCategoryOnDemandModel.fromJson(e)));
          onDemandCategoryData.addAll(fetchCategoryData);
        }
      });
    } on RequestException catch (e) {
      BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
    }
  }

  static getListFilterOnDemandCategoryTypeFn(int count,
      List<OnDemandModel> value, Map<int, String> onDemandCategoryFilterData) {
    for (var i = 0; i < value.length; i++) {
      List<ContentProvidersCategoryOnDemandModel> data = [];
      for (var typeElement in value[i].categories!) {
        for (var j = 0;
            j <
                (onDemandCategoryData.length > 50
                    ? 50
                    : onDemandCategoryData.length);
            j++) {
          if (onDemandCategoryData[j].id.toString() == typeElement) {
            data.add(onDemandCategoryData[j]);
          }
        }
      }

      onDemandCategoryFilterData
          .addAll({count + i: data.map((e) => e.name).join(',')});
    }
  }
}
