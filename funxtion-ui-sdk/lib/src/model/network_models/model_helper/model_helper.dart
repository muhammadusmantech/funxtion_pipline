class Img {
  String id;
  String name;
  String mime;
  String url;
  DateTime createdAt;

  Img({
    required this.id,
    required this.name,
    required this.mime,
    required this.url,
    required this.createdAt,
  });

  factory Img.fromJson(Map<String, dynamic> json) => Img(
        id: json["id"],
        name: json["name"],
        mime: json["mime"],
        url: json["url"],
        createdAt: DateTime.parse(json["created_at"]),
      );


}



class Week {
  List<Day> days;

  Week({
    required this.days,
  });

  factory Week.fromJson(Map<String, dynamic> json) => Week(
        days: List<Day>.from(json["days"].map((x) => Day.fromJson(x))),
      );


}

class Day {
  List<Activity> activities;

  Day({
    required this.activities,
  });

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        activities: List<Activity>.from(
            json["activities"].map((x) => Activity.fromJson(x))),
      );

}

class Activity {
  String type;
  String id;

  Activity({
    required this.type,
    required this.id,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        type: json["type"],
        id: json["id"],
      );


}

class Field {
  String key;
  String type;

  Field({
    required this.key,
    required this.type,
  });

  factory Field.fromJson(Map<String, dynamic> json) => Field(
        key: json["key"],
        type: json["type"],
      );
}
