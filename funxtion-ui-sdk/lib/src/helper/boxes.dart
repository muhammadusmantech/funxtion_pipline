import 'package:hive/hive.dart';

import 'package:ui_tool_kit/ui_tool_kit.dart';

class Boxes {
  static Box<FollowTrainingPlanModel> getTrainingPlanBox() =>
      Hive.box<FollowTrainingPlanModel>('trainingPlan');
  static Box<RecentSearchLocalModel> getRecentSearchBox() =>
      Hive.box<RecentSearchLocalModel>('recentSearch');
  static Box<RecentlyVisitedLocalModel> getRecentlyVisitedBox() =>
      Hive.box<RecentlyVisitedLocalModel>('recentlyVisited');
}
