import 'package:ecommerce_application/services/address_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import '../models/cart_item_details_model.dart';
import '../models/order_model.dart';

class OrderService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> placeOrder({
    required double orderTotal,
    required List<CartItemDetailsModel> cartItems,  // Pass cart items to the method
  }) async {
    try {
      String orderId = _dbRef.child("orders").push().key!;  // Generate order ID
      String orderDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());  // Format order date

      // Get the default address ID before placing the order
      String deliveryAddressId = await AddressService().getDefaultAddressId();

      // Create a map of products with actual product IDs as keys
      Map<String, Map<String, dynamic>> products = {};
      for (var item in cartItems) {
        // Use productId as the key for each product
        products[item.cartItem.productId] = {
          'productId': item.cartItem.productId,  // Using actual productId
          'quantity': item.cartItem.cartQuantity,  // Store the quantity
        };
      }

      // Create a new order
      OrderModel newOrder = OrderModel(
        orderId: orderId,
        orderDate: orderDate,
        orderTotal: orderTotal,
        deliveryAddressId: deliveryAddressId,  // Use the correct addressId here
        products: products,  // Store products as a map with productId as the key
      );

      // Push the order to Firebase
      await _dbRef
          .child("users")
          .child(_currentUserId)
          .child("orders")
          .child(orderId)
          .set(newOrder.toMap());  // Save the order data

      print("Order placed successfully!");
    } catch (e) {
      throw Exception("Failed to place order: $e");
    }
  }

}