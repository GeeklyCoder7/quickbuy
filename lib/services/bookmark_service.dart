import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/bookmark_model.dart';

class BookmarkService {
  final DatabaseReference db = FirebaseDatabase.instance.ref();

  Future<void> toggleBookmark(String productId, BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userBookmarksRef = db.child("users").child(userId).child("bookmarks");

    // Check if product is already bookmarked
    DatabaseEvent event = await userBookmarksRef.once();
    final snapshot = event.snapshot;

    bool productExists = false;
    String? existingKey;

    if (snapshot.exists) {
      Map<dynamic, dynamic> data = snapshot.value as Map;
      data.forEach((key, value) {
        if (value['productId'] == productId) {
          productExists = true;
          existingKey = key;
        }
      });
    }

    if (productExists && existingKey != null) {
      // Remove bookmark
      await userBookmarksRef.child(existingKey!).remove();
    } else {
      // Add bookmark
      String newKey = userBookmarksRef.push().key!;
      await userBookmarksRef.child(newKey).set({
        "productId": productId,
        "bookmarkedItemId": newKey,
      });
    }
  }

  Future<bool> isProductBookmarked(String productId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userBookmarksRef = db.child("users").child(userId).child("bookmarks");

    DatabaseEvent event = await userBookmarksRef.once();
    final snapshot = event.snapshot;

    if (snapshot.exists) {
      Map<dynamic, dynamic> data = snapshot.value as Map;
      for (var value in data.values) {
        if (value['productId'] == productId) {
          return true;
        }
      }
    }
    return false;
  }
}
