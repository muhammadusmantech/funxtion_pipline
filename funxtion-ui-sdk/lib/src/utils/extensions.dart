import 'package:flutter/material.dart';
import 'package:ui_tool_kit/l10n/app_localizations.dart';

import '../../ui_tool_kit.dart';

extension SpaceExtension on num {
  height() {
    return SizedBox(
      height: toDouble(),
    );
  }

  width() {
    return SizedBox(
      width: toDouble(),
    );
  }
}

extension NavigationExtensions on BuildContext {
  void popPage({Object? result}) {
    return Navigator.of(this).pop(result);
  }

  void multiPopPage({required int popPageCount, Object? result}) {
    switch (popPageCount) {
      case 2:
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        break;
      case 3:
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        break;
      case 4:
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        break;
      case 5:
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        break;
      case 6:
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        break;
      case 7:
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        break;
      default:
        return;
    }
  }

  Future<bool> maybePopPage({Object? result}) {
    return Navigator.of(this).maybePop(result);
  }

  void navigateTo(
    Widget screen,
  ) {
    Navigator.of(this).push(
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  void navigatepushReplacement(Widget screen) {
    Navigator.of(this).pushReplacement(MaterialPageRoute(
      builder: (context) => screen,
    ));
  }

  void navigateToRemovedUntil(Widget screen) {
    Navigator.of(this).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => screen,
      ),
      (route) => route.isFirst,
    );
  }
}

extension DynanicSizeExtension on BuildContext {
  double get dynamicHeight => MediaQuery.of(this).size.height;

  double get dynamicWidth => MediaQuery.of(this).size.width;
  Size get dynamicSize => MediaQuery.of(this).size;
}

extension HideKeypad on BuildContext {
  void hideKeypad() => FocusScope.of(this).unfocus();
}

extension OmitSymbolText on String {
  String get removeNumbersFromString => replaceAll(RegExp(r'\d+'), '');

  String capitalizeFirst() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

extension HMSextension on int {
  String get mordernDurationTextWidget =>
      "${Duration(seconds: this).inHours.remainder(60).toString()}:${Duration(seconds: this).inMinutes.remainder(60).toString().padLeft(2, '0')}:${Duration(seconds: this).inSeconds.remainder(60).toString().padLeft(2, '0')}";
}

extension ToItemtypeExtension on String {
  get convertStringToItemType => this == "Single Exercise"
      ? ItemType.singleExercise
      : this == "Time Circuit"
          ? ItemType.circuitTime
          : this == "Reps Circuit"
              ? ItemType.circuitRep
              : this == "Superset"
                  ? ItemType.superSet
                  : this == "Rounds For Time"
                      ? ItemType.rft
                      : this == "Every Minute On the Minute"
                          ? ItemType.emom
                          : ItemType.amrap;
}

extension ItemTypeTitle on ItemType {
  String itemTypeTitleFn() {
    switch (this) {
      case ItemType.singleExercise:
        return "Single Exercise";
      case ItemType.circuitTime:
        return 'Time Circuit';
      case ItemType.circuitRep:
        return "Reps Circuit";
      case ItemType.rft:
        return "Rounds For Time";
      case ItemType.superSet:
        return "Superset";
      case ItemType.amrap:
        return "AMRAP";
      case ItemType.emom:
        return "EMOM";

      default:
        return "";
    }
  }
}

extension HeaderTitle on Map<ExerciseDetailModel, ExerciseModel> {
  String header2SubTitle({
    required int index,
    required Map<ExerciseDetailModel, ExerciseModel> seExercise,
    required Map<ExerciseDetailModel, ExerciseModel> circuitTimeExercise,
    required Map<ExerciseDetailModel, ExerciseModel> rftExercise,
    required Map<ExerciseDetailModel, ExerciseModel> ssExercise,
    required Map<ExerciseDetailModel, ExerciseModel> circuitRepExercise,
    required Map<ExerciseDetailModel, ExerciseModel> amrapExercise,
    required Map<ExerciseDetailModel, ExerciseModel> emomExercise,
  }) =>
      entries.toList()[index].key.exerciseCategoryName ==
              ItemType.singleExercise
          ? "${seExercise.length} exercises"
          : entries.toList()[index].key.exerciseCategoryName ==
                  ItemType.circuitTime
              ? "${circuitTimeExercise.entries.toList()[circuitTimeExercise.length - 1].key.setsCount!.toInt()} ${circuitTimeExercise.entries.toList()[circuitTimeExercise.length - 1].key.setsCount!.toInt() == 1 ? "round" : "rounds"} • ${circuitTimeExercise.length} exercises"
              : entries.toList()[index].key.exerciseCategoryName == ItemType.rft
                  ? "${rftExercise.entries.toList()[rftExercise.length - 1].key.rftRounds} ${rftExercise.entries.toList()[rftExercise.length - 1].key.rftRounds! == 1 ? "round" : "rounds"} • ${rftExercise.length} exercises"
                  : entries.toList()[index].key.exerciseCategoryName ==
                          ItemType.superSet
                      ? "${ssExercise.entries.toList()[ssExercise.length - 1].key.mainSets} ${ssExercise.entries.toList()[ssExercise.length - 1].key.mainSets! == 1 ? "set" : "sets"} • ${ssExercise.length} exercises"
                      : entries.toList()[index].key.exerciseCategoryName ==
                              ItemType.circuitRep
                          ? "${circuitRepExercise.entries.toList()[circuitRepExercise.length - 1].key.setsCount!.toInt()} ${circuitRepExercise.entries.toList()[circuitRepExercise.length - 1].key.setsCount!.toInt() == 1 ? "round" : "rounds"} • ${circuitRepExercise.length} exercises"
                          : entries.toList()[index].key.exerciseCategoryName ==
                                  ItemType.amrap
                              ? "${amrapExercise.entries.toList()[0].key.amrapDuration ?? ""} ${amrapExercise.entries.toList()[0].key.amrapDuration != null ? (amrapExercise.entries.toList()[amrapExercise.length - 1].key.amrapDuration! < 60 ? "seconds •" : "minutes •") : ""} ${amrapExercise.length} exercises"
                              : entries
                                          .toList()[index]
                                          .key
                                          .exerciseCategoryName ==
                                      ItemType.emom
                                  ? "${emomExercise.entries.toList()[emomExercise.length - 1].key.emomMinute!.toInt()} ${emomExercise.entries.toList()[emomExercise.length - 1].key.emomMinute! == 1 ? "minute" : "minutes"} • ${emomExercise.length} exercises"
                                  : '';
}

extension Targets on List<SetGoalTargetAndResistentTarget> {
  String get getTargets {
    if (isNotEmpty) {
      return map((element) {
        if (element.type == GoalTargetType.value) {
          if (element.metric == Metric.weight) {
            return "${element.value?.toInt()} kg";
          }
          if (element.metric == Metric.angle) {
            return "${element.value?.toInt()} angle";
          }
          if (element.metric == Metric.distance) {
            return "${element.value?.toInt()} distance";
          }
          if (element.metric == Metric.duration) {
            return "${element.value?.toInt()} duration";
          }
          if (element.metric == Metric.height) {
            return "${element.value?.toInt()} height";
          }
          if (element.metric == Metric.irm) {
            return "${element.value?.toInt()} irm";
          }
          if (element.metric == Metric.level) {
            return "${element.value?.toInt()} level";
          }
          if (element.metric == Metric.repetitions) {
            return "${element.value?.toInt()} repetitions";
          }
          if (element.metric == Metric.watt) {
            return "${element.value?.toInt()} watt";
          }
          if (element.metric == Metric.calories) {
            return "${element.value?.toInt()} cal";
          }
          if (element.metric == Metric.speed) {
            return "${element.value?.toInt()} speed";
          }
          if (element.metric == Metric.rpm) {
            return "${element.value?.toInt()} rpm";
          }
        } else {
          if (element.metric == Metric.weight) {
            return "${element.min?.toInt()} - ${element.max?.toInt()} kg";
          }
          if (element.metric == Metric.angle) {
            return "${element.min?.toInt()} - ${element.max?.toInt()} angle";
          }
          if (element.metric == Metric.distance) {
            return "${element.min?.toInt()} - ${element.max?.toInt()} distance";
          }
          if (element.metric == Metric.duration) {
            return "${element.min?.toInt()} - ${element.max?.toInt()} duration";
          }
          if (element.metric == Metric.height) {
            return "${element.min?.toInt()} - ${element.max?.toInt()} height";
          }
          if (element.metric == Metric.irm) {
            return "${element.min?.toInt()} - ${element.max?.toInt()} irm";
          }
          if (element.metric == Metric.level) {
            return "${element.min?.toInt()} - ${element.max?.toInt()} level";
          }
          if (element.metric == Metric.repetitions) {
            return "${element.min?.toInt()} - ${element.max?.toInt()} repetitions";
          }
          if (element.metric == Metric.watt) {
            return "${element.min?.toInt()} - ${element.max?.toInt()} watt";
          }
          if (element.metric == Metric.calories) {
            return "${element.min?.toInt()} - ${element.max?.toInt()} cal";
          }
          if (element.metric == Metric.speed) {
            return "${element.min?.toInt()} - ${element.max?.toInt()} speed";
          }
          if (element.metric == Metric.rpm) {
            return "${element.min?.toInt()} - ${element.max?.toInt()} rpm";
          }
        }
      }).join(" • ");
    }
    return "";
  }
}

extension ExerciseSubtitle on ExerciseDetailModel {
  String get getExerciseSubtitle {
    if (exerciseCategoryName == ItemType.singleExercise) {
      if (setsCount! > 1) {
        return "$setsCount sets";
      } else {
        return goalTargets?.map((e) => e.getTargets).join(' • ') ?? "";
      }
    } else if (exerciseCategoryName == ItemType.superSet) {
      return goalTargets?.map((e) => e.getTargets).join(' • ') ?? "";
    } else if (exerciseCategoryName == ItemType.rft) {
      return goalTargets?.map((e) => e.getTargets).join(' • ') ?? "";
    } else if (exerciseCategoryName == ItemType.circuitTime) {
      return goalTargets?.map((e) => e.getTargets).join(' • ') ?? "";
    } else if (exerciseCategoryName == ItemType.circuitRep) {
      return goalTargets?.map((e) => e.getTargets).join(' • ') ?? "";
    } else if (exerciseCategoryName == ItemType.amrap) {
      return goalTargets?.map((e) => e.getTargets).join(' • ') ?? "";
    } else if (exerciseCategoryName == ItemType.emom) {
      return goalTargets?.map((e) => e.getTargets).join(' • ') ?? "";
    }
    return "";
  }
}

extension ResistanceTarget on List<SetGoalTargetAndResistentTarget> {
  Map<String, String> getResistanceTarget() {
    Map<String, String> data = {};
    if (isNotEmpty) {
      for (var i = 0; i < length; i++) {
        if (this[i].type == GoalTargetType.value) {
          if (this[i].metric == Metric.weight) {
            data.addAll({"kg $i": "${this[i].value?.toInt()}"});
          }
          if (this[i].metric == Metric.angle) {
            data.addAll({"deg $i": "${this[i].value?.toInt()}°"});
          }
          if (this[i].metric == Metric.distance) {
            if (this[i].value! >= 1000) {
              double kmValue = this[i].value! / 1000;
              data.addAll({"km $i": kmValue.toStringAsFixed(1)});
            } else {
              data.addAll({"m $i": "${this[i].value?.toInt()}"});
            }
          }
          if (this[i].metric == Metric.duration) {
            if (this[i].value! >= 60) {
              double minValue = this[i].value! / 60;
              data.addAll({"min $i": minValue.toStringAsFixed(1)});
            } else {
              data.addAll({"sec $i": "${this[i].value?.toInt()}"});
            }
          }
          if (this[i].metric == Metric.height) {
            if (this[i].value! >= 100) {
              double mValue = this[i].value! / 100;
              data.addAll({"m $i": mValue.toStringAsFixed(2)});
            } else {
              data.addAll({"cm $i": this[i].value!.toString()});
            }
          }
          if (this[i].metric == Metric.irm) {
            data.addAll({"irm $i": "${this[i].value?.toInt()}"});
          }
          if (this[i].metric == Metric.level) {
            data.addAll({"lvl $i": "${this[i].value?.toInt()}"});
          }
          if (this[i].metric == Metric.repetitions) {
            data.addAll({"reps $i": "${this[i].value?.toInt()}"});
          }

          if (this[i].metric == Metric.watt) {
            data.addAll({"w $i": "${this[i].value?.toInt()}"});
          }
          if (this[i].metric == Metric.calories) {
            data.addAll({"kcal $i": "${this[i].value?.toInt()}"});
          }
          if (this[i].metric == Metric.speed) {
            data.addAll({"km/h $i": "${this[i].value?.toInt()}"});
          }
          if (this[i].metric == Metric.rpm) {
            data.addAll({"rpm $i": "${this[i].value?.toInt()}"});
          }
        } else {
          if (this[i].metric == Metric.weight) {
            data.addAll(
                {"kg $i": "${this[i].min?.toInt()} - ${this[i].max?.toInt()}"});
          }
          if (this[i].metric == Metric.angle) {
            data.addAll({
              "deg $i": "${this[i].min?.toInt()}° - ${this[i].max?.toInt()}°"
            });
          }
          if (this[i].metric == Metric.distance) {
            data.addAll(
                {"m $i": "${this[i].min?.toInt()} - ${this[i].max?.toInt()}"});
          }
          if (this[i].metric == Metric.duration) {
            data.addAll({
              "sec $i": "${this[i].min?.toInt()} - ${this[i].max?.toInt()}"
            });
          }
          if (this[i].metric == Metric.height) {
            data.addAll(
                {"m $i": "${this[i].min?.toInt()} - ${this[i].max?.toInt()}"});
          }
          if (this[i].metric == Metric.irm) {
            data.addAll({
              "irm $i": "${this[i].min?.toInt()} - ${this[i].max?.toInt()}"
            });
          }
          if (this[i].metric == Metric.level) {
            data.addAll({
              "lvl $i": "${this[i].min?.toInt()} - ${this[i].max?.toInt()}"
            });
          }
          if (this[i].metric == Metric.repetitions) {
            data.addAll({
              "reps $i": "${this[i].min?.toInt()} - ${this[i].max?.toInt()}"
            });
          }
          if (this[i].metric == Metric.watt) {
            data.addAll(
                {"w $i": "${this[i].min?.toInt()} - ${this[i].max?.toInt()}"});
          }
          if (this[i].metric == Metric.calories) {
            data.addAll({
              "kcal $i": "${this[i].min?.toInt()} - ${this[i].max?.toInt()}"
            });
          }
          if (this[i].metric == Metric.speed) {
            data.addAll({
              "km/h $i": "${this[i].min?.toInt()} - ${this[i].max?.toInt()}"
            });
          }
          if (this[i].metric == Metric.rpm) {
            data.addAll({
              "rpm $i": "${this[i].min?.toInt()} - ${this[i].max?.toInt()}"
            });
          }
        }
      }
    }
    return data;
  }

  Map<String, String> getGoalTarget() {
    Map<String, String> data = {};
    if (isNotEmpty) {
      for (var i = 0; i < length; i++) {
        if (this[i].type == GoalTargetType.value) {
          if (this[i].metric == Metric.weight) {
            data.addAll({"kg $i": "${this[i].value?.toInt()}"});
          }
          if (this[i].metric == Metric.angle) {
            data.addAll({"deg $i": "${this[i].value?.toInt()}"});
          }
          if (this[i].metric == Metric.distance) {
            data.addAll({"m $i": "${this[i].value?.toInt()}"});
          }
          if (this[i].metric == Metric.duration) {
            data.addAll({"sec $i": "${this[i].value?.toInt()}"});
          }
          if (this[i].metric == Metric.height) {
            data.addAll({"cm $i": "${this[i].value?.toInt()}"});
          }
          if (this[i].metric == Metric.irm) {
            data.addAll({"irm $i": "${this[i].value?.toInt()}"});
          }
          if (this[i].metric == Metric.level) {
            data.addAll({"lvl $i": "${this[i].value?.toInt()}"});
          }
          if (this[i].metric == Metric.repetitions) {
            data.addAll({"reps $i": "${this[i].value?.toInt()}"});
          }

          if (this[i].metric == Metric.watt) {
            data.addAll({"w $i": "${this[i].value?.toInt()}"});
          }
          if (this[i].metric == Metric.calories) {
            data.addAll({"kcal $i": "${this[i].value?.toInt()}"});
          }
          if (this[i].metric == Metric.speed) {
            data.addAll({"km/h $i": "${this[i].value?.toInt()}"});
          }
          if (this[i].metric == Metric.rpm) {
            data.addAll({"rpm $i": "${this[i].value?.toInt()}"});
          }
        } else {
          if (this[i].metric == Metric.weight) {
            data.addAll(
                {"kg $i": "${this[i].min?.toInt()} - ${this[i].max?.toInt()}"});
          }
          if (this[i].metric == Metric.angle) {
            data.addAll({
              "deg $i": "${this[i].min?.toInt()}° - ${this[i].max?.toInt()}°"
            });
          }
          if (this[i].metric == Metric.distance) {
            data.addAll(
                {"m $i": "${this[i].min?.toInt()} - ${this[i].max?.toInt()}"});
          }
          if (this[i].metric == Metric.duration) {
            data.addAll({
              "sec $i": "${this[i].min?.toInt()} - ${this[i].max?.toInt()}"
            });
          }
          if (this[i].metric == Metric.height) {
            data.addAll(
                {"cm $i": "${this[i].min?.toInt()} - ${this[i].max?.toInt()}"});
          }
          if (this[i].metric == Metric.irm) {
            data.addAll({
              "irm $i": "${this[i].min?.toInt()} - ${this[i].max?.toInt()}"
            });
          }
          if (this[i].metric == Metric.level) {
            data.addAll({
              "lvl $i": "${this[i].min?.toInt()} - ${this[i].max?.toInt()}"
            });
          }
          if (this[i].metric == Metric.repetitions) {
            data.addAll({
              "reps $i": "${this[i].min?.toInt()} - ${this[i].max?.toInt()}"
            });
          }
          if (this[i].metric == Metric.watt) {
            data.addAll(
                {"w $i": "${this[i].min?.toInt()} - ${this[i].max?.toInt()}"});
          }
          if (this[i].metric == Metric.calories) {
            data.addAll({
              "kcal $i": "${this[i].min?.toInt()} - ${this[i].max?.toInt()}"
            });
          }
          if (this[i].metric == Metric.speed) {
            data.addAll({
              "km/h $i": "${this[i].min?.toInt()} - ${this[i].max?.toInt()}"
            });
          }
          if (this[i].metric == Metric.rpm) {
            data.addAll({
              "rpm $i": "${this[i].min?.toInt()} - ${this[i].max?.toInt()}"
            });
          }
        }
      }
    }
    return data;
  }
}

extension ExtensionCategoryName on LocalCategoryName? {
  CategoryName getCategoryName() {
    if (this == LocalCategoryName.audioClasses) {
      return CategoryName.audioClasses;
    } else if (this == LocalCategoryName.videoClasses) {
      return CategoryName.videoClasses;
    } else if (this == LocalCategoryName.workouts) {
      return CategoryName.workouts;
    } else {
      return CategoryName.trainingPlans;
    }
  }
}

extension ExtensionLocalCategoryName on CategoryName? {
  LocalCategoryName getLocalCategoryName() {
    if (this == CategoryName.audioClasses) {
      return LocalCategoryName.audioClasses;
    } else if (this == CategoryName.videoClasses) {
      return LocalCategoryName.videoClasses;
    } else if (this == CategoryName.workouts) {
      return LocalCategoryName.workouts;
    } else {
      return LocalCategoryName.trainingPlans;
    }
  }
}

extension LocalizedBuildContext on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this)!;
}
