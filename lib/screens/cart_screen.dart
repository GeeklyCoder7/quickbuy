import 'package:ecommerce_application/models/cart_item_details_model.dart';
import 'package:ecommerce_application/models/cart_item_model.dart';
import 'package:ecommerce_application/models/product_model.dart';
import 'package:ecommerce_application/widgets/cart_item_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/order_service.dart';
import '../utils/colors/app_colors.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  //Variables to handle database
  String currentUserId = FirebaseAuth.instance.currentUser!.uid.toString();
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  //Lists to store fetched data
  List<CartItemDetailsModel> cartItems = [];

  //Variables for handling the state of the app
  double subtotal = 0;

  //Method for fetching cart items from the database
  Future<void> fetchCartItems() async {
    try {
      DatabaseReference cartItemsNodeReference = databaseReference
          .child("users")
          .child(currentUserId)
          .child("cart_items");
      DatabaseEvent event = await cartItemsNodeReference.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists && snapshot.value != null) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(snapshot.value as Map);
        List<CartItemDetailsModel> temporaryCartItemsList = [];

        for (var item in data.values) {
          Map<String, dynamic> cartMap = Map<String, dynamic>.from(item);
          CartItem cartItem = CartItem.fromMap(cartMap);

          //Fetching product details using the product id
          DatabaseReference productNodeReference =
              databaseReference.child("products").child(cartItem.productId);
          DatabaseEvent productEvent = await productNodeReference.once();

          if (productEvent.snapshot.exists &&
              productEvent.snapshot.value != null) {
            Map<String, dynamic> productMap =
                Map<String, dynamic>.from(productEvent.snapshot.value as Map);
            ProductModel product = ProductModel.fromMap(productMap);

            temporaryCartItemsList.add(CartItemDetailsModel(
                cartItem: cartItem, productModel: product));
          }
        }
        setState(() {
          cartItems = temporaryCartItemsList;
          calculateSubtotal();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$e"),
        ),
      );
    }
  }

  //Method for calculating the subtotal
  void calculateSubtotal() {
    double newSubtotal = 0;
    for (var item in cartItems) {
      newSubtotal +=
          item.cartItem.cartQuantity * item.productModel.productPrice;
    }

    setState(() {
      subtotal = newSubtotal;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Center(
          child: Text(
            textAlign: TextAlign.center,
            "My Cart",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Subtotal text
                  Row(
                    children: [
                      Text(
                        "Subtotal",
                        style: TextStyle(
                          fontSize: 25,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "₹${subtotal.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  //More addition for free delivery text
                  Text(
                    subtotal > 499
                        ? "You are eligible for FREE Delivery"
                        : "Add items worth ${(499 - subtotal).toStringAsFixed(2)} for FREE Delivery",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),

                  //Proceed to buy button
                  SizedBox(
                    height: 10,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        if (cartItems.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Your cart is empty!")),
                          );
                          return;
                        }

                        // Show confirmation dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Confirm Order"),
                            content: Text(
                                "Are you sure you want to place this order of ₹${subtotal.toStringAsFixed(2)}?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close dialog
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors
                                      .grey.shade200, // Light grey background
                                  foregroundColor: Colors.red, // Text color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                ),
                                child: Text("Cancel"),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors
                                      .accent, // Your custom primary color
                                  foregroundColor: Colors.white, // Text color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                ),
                                onPressed: () async {
                                  Navigator.of(context).pop(); // Close dialog

                                  try {
                                    // Step 1: Place the order
                                    await OrderService().placeOrder(
                                      orderTotal: subtotal,
                                      cartItems: cartItems,
                                    );

                                    // Step 2: Remove cart items from Firebase
                                    await FirebaseDatabase.instance
                                        .ref()
                                        .child("users")
                                        .child(currentUserId)
                                        .child("cart_items")
                                        .remove();

                                    // Step 3: Clear UI state after Firebase confirms deletion
                                    setState(() {
                                      cartItems.clear();
                                      subtotal = 0;
                                    });

                                    // Optional: re-fetch to ensure everything's clean
                                    await fetchCartItems();

                                    // Show confirmation
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Order placed successfully!")),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Failed to place order: $e")),
                                    );
                                  }
                                },
                                child: Text("Confirm"),
                              ),
                            ],
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      splashColor: Colors.white.withOpacity(0.2),
                      highlightColor: Colors.white.withOpacity(0.1),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.buy_button_color,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                          child: Text(
                            "Buy now",
                            style: TextStyle(
                              color: AppColors.text,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //Cart items list
                  SizedBox(
                    height: 10,
                  ),
                  CartItemWidget(
                    cartItems: cartItems,
                    onQuantityChanged: () {
                      calculateSubtotal();
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
