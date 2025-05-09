import 'package:ecommerce_application/models/product_model.dart';
import 'package:ecommerce_application/screens/main.dart';
import 'package:ecommerce_application/screens/product_details_screen.dart';
import 'package:ecommerce_application/services/cart_service.dart';
import 'package:ecommerce_application/utils/colors/app_colors.dart';
import 'package:ecommerce_application/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RandomProductsSectionWidget extends StatefulWidget {
  final List<ProductModel> productsList;
  final bool isProductLoading;
  const RandomProductsSectionWidget({
    super.key,
    required this.productsList,
    required this.isProductLoading,
  });

  @override
  State<RandomProductsSectionWidget> createState() =>
      _RandomProductsSectionWidgetState();
}

class _RandomProductsSectionWidgetState
    extends State<RandomProductsSectionWidget> with RouteAware {
  Set<String> productIdsInCart = {};
  bool isCartIdsLoading = true;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCartItemId();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    routeObserver.unsubscribe(this);
  }

  @override
  void didPopNext() {
    // TODO: implement didPopNext
    super.didPopNext();
    fetchCartItemId();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.isProductLoading || isCartIdsLoading
          ? showShimmerEffect()
          : showRandomProductsSection(),
    );
  }

  //Widget for showing the random products
  Widget showRandomProductsSection() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.productsList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 20,
        childAspectRatio: 0.7, // Adjusted aspect ratio
      ),
      itemBuilder: (context, index) {
        bool productAlreadyInCart =
        productIdsInCart.contains(widget.productsList[index].productId);
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(
                  productToShow: widget.productsList[index],
                ),
              ),
            );
          },
          child: Card(
            elevation: 4,
            shadowColor: AppColors.shadow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            color: AppColors.card_color,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize:
                MainAxisSize.min, // Important for wrap-content behavior
                children: [
                  // Product image (Flexible for wrap-content behavior)
                  Flexible(
                    flex: 10, // Adjust flex as needed
                    child: Container(
                      width: double.infinity,
                      color: AppColors.card_color,
                      child: Image.network(
                        widget.productsList[index].productImageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  SizedBox(height: 8),

                  // Product name (Flexible for text wrapping)
                  Flexible(
                    flex: 2,
                    child: Text(
                      widget.productsList[index].productName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                      maxLines: 2, // Prevents overflow
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Product price
                  SizedBox(height: 5),
                  Text(
                    "₹ ${widget.productsList[index].productPrice}",
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 15,
                    ),
                  ),

                  // Product rating (Wrap prevents overflow)
                  SizedBox(height: 5),
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

                  SizedBox(height: 8),

                  // Add to cart button (IntrinsicHeight for wrap-content)
                  IntrinsicHeight(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: productAlreadyInCart
                            ? showSnackbar
                            : () {
                          CartService().addToCart(
                            userId: FirebaseAuth.instance.currentUser!.uid
                                .toString(),
                            productId: widget.productsList
                                .elementAt(index)
                                .productId,
                            quantity: 1,
                            context: context,
                          );
                          setState(() {
                            productIdsInCart.add(widget.productsList.elementAt(index).productId);
                          });
                        },
                        borderRadius: BorderRadius.circular(6),
                        splashColor: Colors.white.withOpacity(0.2),
                        highlightColor: Colors.white.withOpacity(0.1),
                        child: Container(
                          padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: productAlreadyInCart
                                ? Colors.white
                                : AppColors.accent,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            border: productAlreadyInCart ? Border.all(color: Colors.amber, width: 1) : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: productAlreadyInCart
                                ? [
                              Text(
                                "Added",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.amber, fontWeight: FontWeight.w400),
                              ),
                            ]
                                : [
                              Icon(Icons.add_outlined,
                                  color: Colors.white, size: 20),
                              SizedBox(width: 5),
                              Text(
                                "Add",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget for showing the shimmer effect
  Widget showShimmerEffect() {
    var deviceHeight = Constants.getDeviceHeight(context);
    var deviceWidth = Constants.getDeviceWidth(context);
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 8,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 20,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          shadowColor: AppColors.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          color: Colors.grey[300]!,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                //Shimmer effect image container
                Shimmer.fromColors(
                  baseColor: Colors.grey[350]!,
                  highlightColor: Colors.grey[200]!,
                  period: Duration(milliseconds: 1000),
                  child: Container(
                    height: 145,
                    width: 180,
                    decoration: BoxDecoration(
                        color: Colors.grey[350]!,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                ),

                //Shimmer effect text container
                SizedBox(
                  height: 10,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[350]!,
                  highlightColor: Colors.grey[200]!,
                  period: Duration(milliseconds: 1000),
                  child: Container(
                    height: 15,
                    width: 140,
                    decoration: BoxDecoration(
                        color: Colors.grey[350]!,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                ),

                //Shimmer effect price container
                SizedBox(
                  height: 10,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[350]!,
                  highlightColor: Colors.grey[200]!,
                  period: Duration(milliseconds: 1000),
                  child: Container(
                    height: 15,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Colors.grey[350]!,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                ),

                //Shimmer effect star container
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    5,
                        (index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[350]!,
                        highlightColor: Colors.grey[200]!,
                        period: Duration(milliseconds: 1000),
                        child: Icon(
                          index == 5 ? Icons.star_border : Icons.star,
                          color: Colors.grey[350]!,
                          size: 16,
                        ),
                      );
                    },
                  ),
                ),

                //Shimmer effect star container
                SizedBox(
                  height: 10,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[350]!,
                  highlightColor: Colors.grey[200]!,
                  period: Duration(milliseconds: 1000),
                  child: Container(
                    height: 30,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[350]!,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}