import 'package:hive_flutter/hive_flutter.dart';

import '../../ui_tool_kit.dart';

class HiveLocalController {
  static openTrainingBox() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(FollowTrainingPlanModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(LocalWorkoutAdapter());
    }
    if (!Hive.isBoxOpen("trainingPlan")) {
      await Hive.openBox<FollowTrainingPlanModel>("trainingPlan");
    }
  }

  static closeHive() async {
    await Hive.close();
  }

  static openSearchBox() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(LocalResultAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(LocalCategoryNameAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(RecentSearchLocalModelAdapter());
    }
    if (!Hive.isBoxOpen("recentSearch")) {
      await Hive.openBox<RecentSearchLocalModel>("recentSearch");
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(
        RecentlyVisitedLocalModelAdapter(),
      );
    }

    if (!Hive.isBoxOpen("recentlyVisited")) {
      await Hive.openBox<RecentlyVisitedLocalModel>("recentlyVisited");
    }
  }
}
