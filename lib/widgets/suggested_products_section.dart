import 'dart:math';

import 'package:ecommerce_application/models/product_model.dart';
import 'package:ecommerce_application/screens/product_details_screen.dart';
import 'package:ecommerce_application/utils/colors/app_colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/constants.dart';

class SuggestedProductsSection extends StatefulWidget {
  final String currentProductId;
  const SuggestedProductsSection({super.key, required this.currentProductId});

  @override
  State<SuggestedProductsSection> createState() =>
      _SuggestedProductsSectionState();
}

class _SuggestedProductsSectionState extends State<SuggestedProductsSection> {
  List<ProductModel> suggestedProductsList = [];
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child("products");
  bool isProductLoading = true;

  //Method for fetching the random products from the database
  Future<void> fetchProducts() async {
    try {
      DatabaseEvent event = await databaseReference.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists && snapshot.value != null) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(snapshot.value as Map);
        List<ProductModel> temporarySuggestedProductsList = [];

        for (var suggestedProduct in data.values) {
          Map<String, dynamic> suggestedProductData =
              Map<String, dynamic>.from(suggestedProduct);
          if (suggestedProductData["productId"] != widget.currentProductId) {
            temporarySuggestedProductsList
                .add(ProductModel.fromMap(suggestedProductData));
          }
        }
        temporarySuggestedProductsList.shuffle(Random());

        setState(() {
          isProductLoading = false;
          suggestedProductsList = temporarySuggestedProductsList;
        });
      }
    } catch (e) {
      isProductLoading = false;
      print("Some kind of error: ${e.toString()}");
    }
  }

  //Method to show the shimmer effect
  Widget showShimmerEffect() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      alignment: Alignment.center,
      height: 280,
      child: ListView.builder(
        itemCount: 4,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            shadowColor: AppColors.shadow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            color: Colors.grey[300]!,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Shimmer effect image container
                  Shimmer.fromColors(
                    baseColor: Colors.grey[350]!,
                    highlightColor: Colors.grey[200]!,
                    period: Duration(milliseconds: 1000),
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[350]!,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
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
                      width: 120,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.grey[350]!,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
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
                      width: 100,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.grey[350]!,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
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
                      width: 100,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.grey[350]!,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //Method to show the suggested products
  Widget showSuggestedProducts() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      alignment: Alignment.center,
      height: 280,
      child: ListView.builder(
        itemCount: suggestedProductsList.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetailsScreen(
                            productToShow:
                                suggestedProductsList.elementAt(index),
                          )));
            },
            child: Card(
              elevation: 2,
              shadowColor: AppColors.shadow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              color: AppColors.card_color,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //Image container
                    Container(
                      width: 150,
                      height: 150,
                      color: AppColors.card_color,
                      child: Image.network(
                        suggestedProductsList.elementAt(index).productImageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),

                    //Product name
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 150,
                      child: Text(
                        suggestedProductsList.elementAt(index).productName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    //Product price
                    SizedBox(height: 5),
                    Text(
                      "₹ ${suggestedProductsList.elementAt(index).productPrice}",
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 15,
                      ),
                    ),

                    //Product rating
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 0,
                          children: List.generate(5, (index) {
                            return Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            );
                          }),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("(1)"),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return isProductLoading ? showShimmerEffect() : showSuggestedProducts();
  }
}
