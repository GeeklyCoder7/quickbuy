class ProductModel {
  final String productId;
  String productName;
  String productCategory;
  String productDescription;
  String productImageUrl;
  double productPrice;

  ProductModel({
    required this.productId,
    required this.productName,
    required this.productCategory,
    required this.productDescription,
    required this.productImageUrl,
    required this.productPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productCategory': productCategory,
      'productDescription': productDescription,
      'productImageUrl': productImageUrl,
      'productPrice': productPrice,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productId: map['productId'],
      productName: map['productName'],
      productCategory: map['productCategory'],
      productDescription: map['productDescription'],
      productImageUrl: map['productImageUrl'],
      productPrice: (map['productPrice'] is int)
          ? (map['productPrice'] as int).toDouble()
          : map['productPrice'],
    );
  }
}
