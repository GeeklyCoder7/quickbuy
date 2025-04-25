import 'package:ecommerce_application/models/bookmark_model.dart';
import 'package:ecommerce_application/models/wishlist_items_details_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors/app_colors.dart';

class WishlistItemWidget extends StatefulWidget {
  final List<WishlistItemDetailsModel> bookmarkedItemsList;
  final Function(String) onWishlistItemRemoved;

  const WishlistItemWidget({
    super.key,
    required this.bookmarkedItemsList,
    required this.onWishlistItemRemoved,
  });

  @override
  State<WishlistItemWidget> createState() => _WishlistItemWidgetState();
}

class _WishlistItemWidgetState extends State<WishlistItemWidget> {

  @override
  Widget build(BuildContext context) {
    return showBookmarkedItems();
  }

  //Widget for showing the wishlist items
  Widget showBookmarkedItems() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.bookmarkedItemsList.length,
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
                      widget.bookmarkedItemsList[index].productModel
                          .productImageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(
                    width: 20,
                  ),

                  Expanded(
                    child: Container(
                      height: 220,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Product name
                          Text(
                            widget.bookmarkedItemsList[index].productModel
                                .productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.text,
                            ),
                          ),

                          //Product price
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "₹${widget.bookmarkedItemsList[index].productModel.productPrice}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          //Per quantity price
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "(₹${widget.bookmarkedItemsList[index].productModel.productPrice} / count)",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.text,
                            ),
                          ),

                          //Availability text
                          SizedBox(
                            height: 5,
                          ),
                          Text("In stock",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.green.shade600,
                              )),

                          //Product description text
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.bookmarkedItemsList[index].productModel
                                .productDescription,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.text,
                            ),
                          ),

                          //Buttons
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //Remove from cart button
                              OutlinedButton(
                                onPressed: () async {
                                  final bookmarkedItemId = widget.bookmarkedItemsList[index].bookmarkModel.bookmarkedItemId;

                                  //Removing the bookmarked item
                                  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
                                  final userBookmarksRef = FirebaseDatabase.instance.ref().child("users").child(currentUserId).child("bookmarks");

                                  await userBookmarksRef.child(bookmarkedItemId!).remove();
                                  widget.onWishlistItemRemoved(bookmarkedItemId);
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
