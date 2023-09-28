// ignore_for_file: public_member_api_docs, sort_constructors_first
class Recipe {
  final String name;
  final String images;
  final double rating;
  final String totalTime;

  Recipe({
    required this.name,
    required this.images,
    required this.rating,
    required this.totalTime,
  });

  factory Recipe.fromJson(dynamic json) {
    return Recipe(
      name: json['name'] as String,
      images: json['images'][0]['hostedLargeUrl'] as String,
      rating: json['rating'] as double,
      totalTime: json['totalTime'] as String,
    );
  }

  static Future<String> recipesFromSnapshot(List snapshot) async {
    return snapshot.map((data) {
      return Recipe.fromJson(data);
    }).toString();
  }
}
