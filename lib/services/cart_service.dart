import 'package:ecommerce_application/models/cart_item_model.dart';
import 'package:ecommerce_application/utils/colors/app_colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CartService {
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  //Method to add item to the cart
  Future<void> addToCart({
    required String userId,
    required String productId,
    required int quantity,
    required BuildContext context,
  }) async {
    DatabaseReference cartItemsNodeRef =
        databaseReference.child("users").child(userId).child("cart_items");
    DatabaseReference newCartItemNodeRef = cartItemsNodeRef.push();
    String? cartItemId = newCartItemNodeRef.key;

    CartItem newCartItem = CartItem(
      cartItemId: cartItemId,
      cartQuantity: quantity,
      productId: productId,
    );

    await newCartItemNodeRef.set(newCartItem.toMap());
    showSuccessAnimation(context);
  }

  //Method to show the animation when the item is successfully added to the cart
  void showSuccessAnimation(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          Future.delayed(Duration(milliseconds: 2350), () {
            Navigator.of(context).pop();
          });

          return Padding(
            padding: const EdgeInsets.all(15),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              backgroundColor: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Success animation
                  Lottie.asset(
                    'assets/animations/added_to_cart_success_animation.json',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //Success text
                  Text(
                    'Item added to cart successfully',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          );
        });
  }
}
