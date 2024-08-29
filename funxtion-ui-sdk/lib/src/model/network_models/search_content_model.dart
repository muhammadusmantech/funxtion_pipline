import 'package:ui_tool_kit/ui_tool_kit.dart';

class SearchContentModel {
  List<Result>? results;
  List<Suggestion>? suggestions;
  List<Cursor>? cursors;

  SearchContentModel({
    this.results,
    this.suggestions,
    this.cursors,
  });

  factory SearchContentModel.fromJson(Map<String, dynamic> json) =>
      SearchContentModel(
        results: json["results"] == null
            ? []
            : List<Result>.from(
                json["results"]!.map((x) => Result.fromJson(x))),
        suggestions: json["suggestions"] == null
            ? []
            : List<Suggestion>.from(
                json["suggestions"]!.map((x) => Suggestion.fromJson(x))),
        cursors: json["cursors"] == null
            ? []
            : List<Cursor>.from(
                json["cursors"]!.map((x) => Cursor.fromJson(x))),
      );


}

class Suggestion {
  String? q;
  double? popularity;

  Suggestion({
    this.q,
    this.popularity,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) => Suggestion(
        q: json["q"],
        popularity: json["popularity"]?.toDouble(),
      );

}

class Cursor {
  CategoryName? collection;
  int? offset;
  int? limit;
  int? total;

  Cursor({
    this.collection,
    this.offset,
    this.limit,
    this.total,
  });

  factory Cursor.fromJson(Map<String, dynamic> json) => Cursor(
        collection: collectionValues.map[json["collection"]]!,
        offset: json["offset"],
        limit: json["limit"],
        total: json["total"],
      );


}

final collectionValues = EnumValue({
  "audio": CategoryName.audioClasses,
  "training-plans": CategoryName.trainingPlans,
  "video": CategoryName.videoClasses,
  "workouts": CategoryName.workouts
});

class Result {
  CategoryName? collection;
  double? matchScore;
  String? entityId;
  String? title;
  int? duration;
  List<Category>? categories;
  List<Category>? goals;
  String? level;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;

  Result({
    this.collection,
    this.matchScore,
    this.entityId,
    this.title,
    this.duration,
    this.categories,
    this.goals,
    this.level,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        collection: collectionValues.map[json["collection"]]!,
        matchScore: json["match_score"]?.toDouble(),
        entityId: json["entity_id"],
        title: json["title"],
        duration: json["duration"].toInt(),
        categories: json["categories"] == null
            ? []
            : List<Category>.from(
                json["categories"]!.map((x) => Category.fromJson(x))),
        goals: json["goals"] == null
            ? []
            : List<Category>.from(
                json["goals"]!.map((x) => Category.fromJson(x))),
        level: json["level"].toString().capitalizeFirst(),
        image: json["image"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

}

class Category {
  String? id;
  String? label;

  Category({
    this.id,
    this.label,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        label: json["label"],
      );

}

class EnumValue<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValue(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
