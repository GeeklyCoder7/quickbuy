import 'package:ecommerce_application/models/product_model.dart';

class CartItem {
  int cartQuantity;
  String productId;
  String? cartItemId;

  CartItem({
    required this.cartItemId,
    required this.cartQuantity,
    required this.productId
  });

  Map<String, dynamic> toMap() {
    return {
      'cartItemId': cartItemId,
      'cartQuantity': cartQuantity,
      'productId': productId
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      cartItemId: map['cartItemId'],
      cartQuantity: map['cartQuantity'],
      productId: map['productId']
    );
  }
}
