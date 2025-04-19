import 'package:ecommerce_application/models/cart_item_model.dart';
import 'package:ecommerce_application/models/product_model.dart';

class CartItemDetailsModel {
  final CartItem cartItem;
  final ProductModel productModel;

  CartItemDetailsModel({
    required this.cartItem,
    required this.productModel,
  });
}
