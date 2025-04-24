class BookmarkModel {
  String productId;
  String? bookmarkedItemId;

  BookmarkModel({
    required this.productId,
    required this.bookmarkedItemId,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'bookmarkedItemId': bookmarkedItemId,
    };
  }

  factory BookmarkModel.fromMap(Map<String, dynamic> map) {
    return BookmarkModel(
      productId: map['productId'],
      bookmarkedItemId: map['bookmarkedItemId'],
    );
  }
}
