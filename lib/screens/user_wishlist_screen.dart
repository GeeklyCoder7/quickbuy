import 'package:ecommerce_application/models/wishlist_items_details_model.dart';
import 'package:ecommerce_application/widgets/wishlist_item_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/bookmark_model.dart';
import '../models/product_model.dart';
import '../utils/colors/app_colors.dart';

class UserWishlistScreen extends StatefulWidget {
  const UserWishlistScreen({super.key});

  @override
  State<UserWishlistScreen> createState() => _UserWishlistScreenState();
}

class _UserWishlistScreenState extends State<UserWishlistScreen> {
  //Variables to handle database
  String currentUserId = FirebaseAuth.instance.currentUser!.uid.toString();
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  //Lists to store fetched data
  List<WishlistItemDetailsModel> bookmarkedItemsList = [];

  //Method for fetching the user wishlist
  Future<void> fetchWishlist() async {
    try {
      DatabaseReference wishlistNodeReference = databaseReference
          .child("users")
          .child(currentUserId)
          .child("bookmarks");
      DatabaseEvent event = await wishlistNodeReference.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists && snapshot.value != null) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(snapshot.value as Map);
        List<WishlistItemDetailsModel> temporaryWishlistList = [];

        for (var item in data.values) {
          Map<String, dynamic> bookmarkMap = Map<String, dynamic>.from(item);
          BookmarkModel bookmark = BookmarkModel.fromMap(bookmarkMap);

          //Fetching product details using the product id
          DatabaseReference productNodeReference =
              databaseReference.child("products").child(bookmark.productId);
          DatabaseEvent productEvent = await productNodeReference.once();

          if (productEvent.snapshot.exists &&
              productEvent.snapshot.value != null) {
            Map<String, dynamic> productMap =
                Map<String, dynamic>.from(productEvent.snapshot.value as Map);
            ProductModel product = ProductModel.fromMap(productMap);

            temporaryWishlistList.add(WishlistItemDetailsModel(
                bookmarkModel: bookmark, productModel: product));
          }
        }

        setState(() {
          bookmarkedItemsList = temporaryWishlistList;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchWishlist();
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
            "My Wishlist",
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
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Wishlist items list
                  SizedBox(
                    height: 10,
                  ),
                  WishlistItemWidget(
                    bookmarkedItemsList: bookmarkedItemsList,
                    onWishlistItemRemoved: (removedItemId) {
                      setState(() {
                        bookmarkedItemsList.removeWhere((removedItemId) =>
                            removedItemId.bookmarkModel.bookmarkedItemId ==
                            removedItemId);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
