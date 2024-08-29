import 'package:funxtion/funxtion_sdk.dart';

class ContentProvidersCategoryOnDemandModel {
  dynamic id;
  String name;
  dynamic slug;
  List<String>? entities;

  ContentProvidersCategoryOnDemandModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.entities,
  });

  factory ContentProvidersCategoryOnDemandModel.fromJson(
          Map<String, dynamic> json) =>
      ContentProvidersCategoryOnDemandModel(
          id: json["id"],
          name: json["name"] is Map ? json['name'].containsKey('_${AppLanguage.getLanguageCode}')
              ? json['name']["_${AppLanguage.getLanguageCode}"]
              : json['name']['en'] : json['name'],
          slug: json["slug"],
          entities: json.containsKey('entities')
              ? List<String>.from(json["entities"].map((x) => x))
              : null);
}
