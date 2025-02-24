class CategoryModel {
  final String categoryId;
  String categoryName;
  String categoryImageUrl;

  CategoryModel({
    required this.categoryId,
    required this.categoryName,
    required this.categoryImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryImageUrl': categoryImageUrl,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      categoryId: map['categoryId'],
      categoryName: map['categoryName'],
      categoryImageUrl: map['categoryImageUrl'],
    );
  }
}
