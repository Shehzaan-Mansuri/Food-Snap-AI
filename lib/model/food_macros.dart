import 'dart:convert';

class FoodMacros {
  final String? title;
  final Nutrition? nutrition;
  const FoodMacros({this.title, this.nutrition});
  FoodMacros copyWith({String? title, Nutrition? nutrition}) {
    return FoodMacros(
        title: title ?? this.title, nutrition: nutrition ?? this.nutrition);
  }

  Map<String, Object?> toJson() {
    return {'title': title, 'nutrition': nutrition?.toJson()};
  }

  static FoodMacros fromJson(String data) {
    try {
      final json = jsonDecode(data);
      return FoodMacros(
        title: json['title'] as String?,
        nutrition: json['nutrition'] == null
            ? null
            : Nutrition.fromJson(json['nutrition'] as Map<String, dynamic>),
      );
    } catch (e) {
      return const FoodMacros();
    }
  }

  @override
  String toString() {
    return '''FoodMacros(
                title:$title,
nutrition:${nutrition.toString()}
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is FoodMacros &&
        other.runtimeType == runtimeType &&
        other.title == title &&
        other.nutrition == nutrition;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, title, nutrition);
  }
}

class Nutrition {
  final String? servingSize;
  final num? calories;
  final num? carbohydrates;
  final num? fiber;
  final num? protein;
  final num? fat;
  const Nutrition(
      {this.servingSize,
      this.calories,
      this.carbohydrates,
      this.fiber,
      this.protein,
      this.fat});
  Nutrition copyWith(
      {String? servingSize,
      num? calories,
      num? carbohydrates,
      num? fiber,
      num? protein,
      num? fat}) {
    return Nutrition(
        servingSize: servingSize ?? this.servingSize,
        calories: calories ?? this.calories,
        carbohydrates: carbohydrates ?? this.carbohydrates,
        fiber: fiber ?? this.fiber,
        protein: protein ?? this.protein,
        fat: fat ?? this.fat);
  }

  Map<String, Object?> toJson() {
    return {
      'serving_size': servingSize,
      'calories': calories,
      'carbohydrates': carbohydrates,
      'fiber': fiber,
      'protein': protein,
      'fat': fat
    };
  }

  static Nutrition fromJson(Map<String, Object?> json) {
    return Nutrition(
        servingSize: json['serving_size'] == null
            ? null
            : json['serving_size'] as String,
        calories: json['calories'] == null ? null : json['calories'] as num,
        carbohydrates:
            json['carbohydrates'] == null ? null : json['carbohydrates'] as num,
        fiber: json['fiber'] == null ? null : json['fiber'] as num,
        protein: json['protein'] == null ? null : json['protein'] as num,
        fat: json['fat'] == null ? null : json['fat'] as num);
  }

  @override
  String toString() {
    return '''Nutrition(
                servingSize:$servingSize,
calories:$calories,
carbohydrates:$carbohydrates,
fiber:$fiber,
protein:$protein,
fat:$fat
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is Nutrition &&
        other.runtimeType == runtimeType &&
        other.servingSize == servingSize &&
        other.calories == calories &&
        other.carbohydrates == carbohydrates &&
        other.fiber == fiber &&
        other.protein == protein &&
        other.fat == fat;
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, servingSize, calories, carbohydrates, fiber, protein, fat);
  }
}
