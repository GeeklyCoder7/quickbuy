import 'package:ecommerce_application/models/product_model.dart';
import 'package:ecommerce_application/services/cart_service.dart';
import 'package:ecommerce_application/widgets/select_quantity_spinner_widget.dart';
import 'package:ecommerce_application/widgets/shop_with_confidence_section_widget.dart';
import 'package:ecommerce_application/widgets/suggested_products_section.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/bookmark_service.dart';
import '../utils/colors/app_colors.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel productToShow;
  const ProductDetailsScreen({super.key, required this.productToShow});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  //variables to handle the app's state
  bool isProductBookmarked = false;
  bool isCartIdsLoading = true;

  //Variables to handle database
  String currentUserId = FirebaseAuth.instance.currentUser!.uid.toString();

  //Other variables
  int selectedProductQuantity = 1;
  Set<String> productIdsInCart = {};

  //Method for collecting the product ids that are in user cart
  Future<void> fetchCartItemId() async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid.toString();
      DatabaseReference cartItemsNodeRef = FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(currentUserId)
          .child("cart_items");

      DatabaseEvent event = await cartItemsNodeRef.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists && snapshot.value != null) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(snapshot.value as Map);
        Set<String> tempCartIds = {};

        for (var items in data.values) {
          Map<String, dynamic> cartMap = Map<String, dynamic>.from(items);
          tempCartIds.add(cartMap['productId']);
        }

        setState(() {
          productIdsInCart = tempCartIds;
          isCartIdsLoading = false;
        });
      } else {
        setState(() {
          productIdsInCart = {};
          isCartIdsLoading = false;
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

  //Method for showing the snackbar
  void showSnackbar() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Already in cart")));
  }

  //Method for checking if the product is already bookmarked
  void checkIfBookmarked() async {
    bool isBookmarked = await BookmarkService()
        .isProductBookmarked(widget.productToShow.productId);
    setState(() {
      isProductBookmarked = isBookmarked;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCartItemId();
    checkIfBookmarked();
  }

  @override
  Widget build(BuildContext context) {
    bool productAlreadyInCart =
        productIdsInCart.contains(widget.productToShow.productId);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primary,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search something',
              hintStyle: TextStyle(
                color: AppColors.text,
                fontSize: 18,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                //Product image
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.image_background_color,
                  ),
                  child: Image.network(
                    widget.productToShow.productImageUrl,
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(
                  height: 15,
                ),

                //Other details section
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  margin: EdgeInsets.only(bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Product name
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.productToShow.productName,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.text,
                          ),
                        ),
                      ),

                      //price and ratings section
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //price
                          Text(
                            "₹ ${widget.productToShow.productPrice}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          //ratings and bookmark icon
                          Column(
                            children: [
                              //bookmark icon
                              GestureDetector(
                                child: Icon(
                                  isProductBookmarked
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: AppColors.accent,
                                  size: 35,
                                ),
                                onTap: () async {
                                  await BookmarkService().toggleBookmark(
                                      widget.productToShow.productId, context);
                                  bool updatedBookmarkStatus =
                                      await BookmarkService()
                                          .isProductBookmarked(
                                              widget.productToShow.productId);
                                  setState(() {
                                    isProductBookmarked = updatedBookmarkStatus;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              //ratings
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 0,
                                    children: List.generate(
                                      5,
                                      (index) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("(1)"),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      //delivering details
                      SizedBox(
                        height: 15,
                      ),

                      //Delivery location row
                      Row(
                        children: [
                          //location icon
                          Icon(
                            Icons.location_on_outlined,
                            color: AppColors.accent,
                            size: 20,
                          ),

                          SizedBox(
                            width: 5,
                          ),

                          //location text
                          Text(
                            "Delivering to (delivery location)",
                            style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),

                      //Quantity selection spinner
                      SizedBox(
                        height: 15,
                      ),
                      SelectQuantitySpinnerWidget(
                        dropdownLabel: "Quantity",
                        onQuantitySelected: (selectedValue) {
                          selectedProductQuantity = selectedValue;
                        },
                        quantityNumbersList: [1, 2, 3, 4, 5],
                      ),

                      //Buy and Add buttons Column
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: Column(
                          children: productAlreadyInCart
                              ? [
                                  //Add to cart button
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        showSnackbar();
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      splashColor:
                                          Colors.white.withOpacity(0.2),
                                      highlightColor:
                                          Colors.white.withOpacity(0.1),
                                      child: Container(
                                        width: 200,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          border: Border.all(
                                              color: Colors.amber, width: 1),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Added",
                                            style: TextStyle(
                                              color: Colors.amber,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  //Buy now button
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {},
                                      borderRadius: BorderRadius.circular(20),
                                      splashColor:
                                          Colors.white.withOpacity(0.2),
                                      highlightColor:
                                          Colors.white.withOpacity(0.1),
                                      child: Container(
                                        width: 200,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: AppColors.accent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
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
                                ]
                              : [
                                  //Add to cart button
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () async {
                                        await CartService().addToCart(
                                          userId: currentUserId,
                                          productId:
                                              widget.productToShow.productId,
                                          quantity: selectedProductQuantity,
                                          context: context,
                                        );
                                        // Refresh the cart state after adding
                                        await fetchCartItemId();

                                        // Rebuild the UI with updated productIdsInCart
                                        setState(() {});
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      splashColor:
                                          Colors.white.withOpacity(0.2),
                                      highlightColor:
                                          Colors.white.withOpacity(0.1),
                                      child: Container(
                                        width: 200,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: AppColors.buy_button_color,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Add to cart",
                                            style: TextStyle(
                                              color: AppColors.text,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  //Buy now button
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {},
                                      borderRadius: BorderRadius.circular(20),
                                      splashColor:
                                          Colors.white.withOpacity(0.2),
                                      highlightColor:
                                          Colors.white.withOpacity(0.1),
                                      child: Container(
                                        width: 200,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: AppColors.accent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
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
                                ],
                        ),
                      ),

                      //Shop with confidence section
                      SizedBox(
                        height: 30,
                      ),
                      ShopWithConfidenceSectionWidget(),

                      //Description widget
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        widget.productToShow.productDescription,
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 17,
                        ),
                      ),

                      //Suggested products section
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Suggested products",
                              style: TextStyle(
                                color: AppColors.text,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SuggestedProductsSection(
                              currentProductId: widget.productToShow.productId,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
