import 'dart:io';

import 'package:ecommerce_application/models/cart_item_details_model.dart';
import 'package:ecommerce_application/utils/colors/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/bookmark_service.dart';

class CartItemWidget extends StatefulWidget {
  final List<CartItemDetailsModel> cartItems;
  final Function onQuantityChanged;

  const CartItemWidget({
    super.key,
    required this.cartItems,
    required this.onQuantityChanged,
  });

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  final BookmarkService bookmarkService = BookmarkService();
  List<String> bookmarkedProductIds = [];

  //Method for changing the cart item quantity
  Future<void> changeQuantity(String cartItemId, int quantity) async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid.toString();
      DatabaseReference databaseReference = FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(currentUserId)
          .child("cart_items")
          .child(cartItemId);

      await databaseReference.update({'cartQuantity': quantity});

      setState(() {
        widget
            .cartItems[widget.cartItems.indexWhere(
                (element) => element.cartItem.cartItemId == cartItemId)]
            .cartItem
            .cartQuantity = quantity;
      });
      widget.onQuantityChanged();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$e"),
        ),
      );
    }
  }

  //Method for removing the cart item
  Future<void> removeCartItem(String cartItemId) async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid.toString();
      DatabaseReference databaseReference = FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(currentUserId)
          .child("cart_items")
          .child(cartItemId);

      await databaseReference.remove();

      setState(() {
        widget.cartItems.removeWhere(
            (element) => element.cartItem.cartItemId == cartItemId);
      });
      widget.onQuantityChanged();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$e"),
        ),
      );
    }
  }

  // UPDATED METHOD: Load all bookmarked product ids at once
  Future<void> loadBookmarkedProductIds() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final userBookmarksRef = FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(userId)
          .child("bookmarks");

      final event = await userBookmarksRef.once();
      final snapshot = event.snapshot;

      if (snapshot.exists) {
        final Map<dynamic, dynamic> data = snapshot.value as Map;
        final ids =
            data.values.map((value) => value['productId'] as String).toList();

        setState(() {
          bookmarkedProductIds = ids;
        });
      }
    } catch (e) {
      debugPrint("Error loading bookmarks: $e");
    }
  }

  //Method for toggling the bookmark
  void toggleBookmark(String productId) async {
    await bookmarkService.toggleBookmark(productId, context);

    if (bookmarkedProductIds.contains(productId)) {
      bookmarkedProductIds.remove(productId);
    } else {
      bookmarkedProductIds.add(productId);
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadBookmarkedProductIds();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: showCartItems(),
    );
  }

  //Widget for showing the cart items
  Widget showCartItems() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.cartItems.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {},
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Product image
                  SizedBox(
                    height: 220,
                    width: 100,
                    child: Image.network(
                      widget.cartItems[index].productModel.productImageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(width: 20),

                  Expanded(
                    child: Container(
                      height: 220,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.cartItems[index].productModel.productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.text,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "₹${widget.cartItems[index].productModel.productPrice}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "(₹${widget.cartItems[index].productModel.productPrice} / count)",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.text,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text("In stock",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.green.shade600,
                              )),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  removeCartItem(widget
                                      .cartItems[index].cartItem.cartItemId
                                      .toString());
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  minimumSize: Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  "Remove",
                                  style: TextStyle(
                                      color: AppColors.text, fontSize: 13),
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  String productId = widget
                                      .cartItems[index].productModel.productId;
                                  toggleBookmark(productId);
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  minimumSize: Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  side: BorderSide(
                                    color: bookmarkedProductIds.contains(widget
                                            .cartItems[index]
                                            .productModel
                                            .productId)
                                        ? Colors.green
                                        : AppColors.text,
                                  ),
                                ),
                                child: Text(
                                  bookmarkedProductIds.contains(widget
                                          .cartItems[index]
                                          .productModel
                                          .productId)
                                      ? "Saved"
                                      : "Save for later",
                                  style: TextStyle(
                                    color: bookmarkedProductIds.contains(widget
                                            .cartItems[index]
                                            .productModel
                                            .productId)
                                        ? Colors.green
                                        : AppColors.text,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 110,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.buy_button_color,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          int currentQuantity = widget
                                              .cartItems[index]
                                              .cartItem
                                              .cartQuantity;
                                          if (currentQuantity > 1) {
                                            int newQuantity =
                                                currentQuantity - 1;
                                            changeQuantity(
                                                widget.cartItems[index].cartItem
                                                    .cartItemId
                                                    .toString(),
                                                newQuantity);
                                          }
                                        },
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.black,
                                          size: 25,
                                        ),
                                      ),
                                      Text(
                                        widget.cartItems[index].cartItem
                                            .cartQuantity
                                            .toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          int newQuantity = widget
                                                  .cartItems[index]
                                                  .cartItem
                                                  .cartQuantity +
                                              1;
                                          changeQuantity(
                                              widget.cartItems[index].cartItem
                                                  .cartItemId
                                                  .toString(),
                                              newQuantity);
                                        },
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.black,
                                          size: 25,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
