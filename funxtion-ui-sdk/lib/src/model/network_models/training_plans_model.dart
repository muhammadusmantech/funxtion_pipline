import 'package:funxtion/funxtion_sdk.dart';
import 'package:ui_tool_kit/ui_tool_kit.dart';

class TrainingPlanModel {
  String id;
  String title;
  dynamic description;
  List<int> goals;
  List<int> types;
  String level;
  List<String> locations;
  List<dynamic> contentPackages;
  DateTime createdAt;
  DateTime updatedAt;
  String? image;
  Img? mapImage;
  int? weeksTotal;
  int? daysTotal;
  List<Week>? weeks;
  int? maxDaysPerWeek;

  TrainingPlanModel({
    required this.weeks,
    required this.id,
    required this.title,
    required this.description,
    required this.goals,
    required this.types,
    required this.level,
    required this.locations,
    required this.contentPackages,
    required this.createdAt,
    required this.updatedAt,
    this.image,
    this.mapImage,
    required this.weeksTotal,
    required this.daysTotal,
    required this.maxDaysPerWeek,
  });

  factory TrainingPlanModel.fromJson(Map<String, dynamic> json) =>
      TrainingPlanModel(
          id: json["id"],
          title: json["title"] is Map
              ? json['title'].containsKey('_${AppLanguage.getLanguageCode}')
                  ? json['title']["_${AppLanguage.getLanguageCode}"]
                  : json['title']['en']
              : json['title'],
          description: json["description"] is Map
              ? json['description']
                      .containsKey('_${AppLanguage.getLanguageCode}')
                  ? json['description']["_${AppLanguage.getLanguageCode}"]
                  : json['description']['en'].toString().capitalizeFirst()
              : json["description"].toString().capitalizeFirst(),
          goals: List<int>.from(json["goals"].map((x) => x)),
          types: List<int>.from(json["types"].map((x) => x)),
          level: json["level"].toString().capitalizeFirst(),
          locations: List<String>.from(json["locations"].map((x) => x)),
          contentPackages:
              List<dynamic>.from(json["content_packages"].map((x) => x)),
          createdAt: DateTime.parse(json["created_at"]),
          updatedAt: DateTime.parse(json["updated_at"]),
          image: json['image'] is Map ? null : json['image'],
          mapImage: json['image'] is Map ? Img.fromJson(json['image']) : null,
          weeks: json.containsKey("weeks")
              ? List<Week>.from(json["weeks"].map((x) => Week.fromJson(x)))
              : null,
          weeksTotal:
              json.containsKey('weeks_total') ? json["weeks_total"] : null,
          daysTotal: json.containsKey('days_total') ? json["days_total"] : null,
          maxDaysPerWeek: json.containsKey("max_days_per_week")
              ? json["max_days_per_week"]
              : null);
}
