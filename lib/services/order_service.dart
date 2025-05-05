import 'package:ecommerce_application/services/address_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import '../models/cart_item_details_model.dart';
import '../models/order_model.dart';

class OrderService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  // Method to place an order
  Future<void> placeOrder({
    required double orderTotal,
    required List<CartItemDetailsModel> cartItems,
    required String orderStatus,
  }) async {
    try {
      String orderId = _dbRef.child("orders").push().key!;  // Generate order ID
      String orderDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());  // Format order date

      // Get the default address ID before placing the order
      String deliveryAddressId = await AddressService().getDefaultAddressId();

      // Create a new order with only necessary fields
      OrderModel newOrder = OrderModel(
        orderId: orderId,
        orderDate: orderDate,
        orderTotal: orderTotal,
        deliveryAddressId: deliveryAddressId,  // Use the correct addressId here
        orderStatus: orderStatus,
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

  // Method to cancel an order
  Future<void> cancelOrder(String orderId) async {
    try {
      // Update the order status to 'Cancelled' in Firebase
      await _dbRef
          .child("users")
          .child(_currentUserId)
          .child("orders")
          .child(orderId)
          .update({
        'orderStatus': 'Cancelled',
      });

      print("Your order has been cancelled.");
    } catch (e) {
      throw Exception("Failed to cancel the order: $e");
    }
  }
}
