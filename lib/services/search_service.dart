import 'package:ecommerce_application/models/product_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchService {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  //Method for searching products
  Future<List<ProductModel>> searchProducts(String query, BuildContext context) async {
    try {
      DatabaseReference productsNodeRef = databaseReference.child("products");
      DatabaseEvent event = await productsNodeRef.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists && snapshot.value != null) {
        Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map);
        List<ProductModel> result = [];

        for (var product in data.values) {
          Map<String, dynamic> productData = Map<String, dynamic>.from(product);
          ProductModel productModel = ProductModel.fromMap(productData);

          if (productModel.productName.toLowerCase().contains(query.toLowerCase()) || productModel.productDescription.toLowerCase().contains(query.toLowerCase())) {
            result.add(productModel);
          }
        }
        return result;
      } else {
        return [];
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Search error: $e"),
        ),
      );
      return [];
    }
  }
}