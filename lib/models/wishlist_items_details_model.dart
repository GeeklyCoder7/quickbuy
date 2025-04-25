import 'package:ecommerce_application/models/bookmark_model.dart';
import 'package:ecommerce_application/models/product_model.dart';

class WishlistItemDetailsModel {
  final BookmarkModel bookmarkModel;
  final ProductModel productModel;

  WishlistItemDetailsModel({
    required this.bookmarkModel,
    required this.productModel,
  });
}