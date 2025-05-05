import 'package:ecommerce_application/models/order_model.dart';
import 'package:ecommerce_application/widgets/order_item_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors/app_colors.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  //Variables to handle database
  String currentUserId = FirebaseAuth.instance.currentUser!.uid.toString();
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  List<OrderModel> orders = [];

  //Method for fetching the order items from the database
  Future<void> fetchOrders() async {
    try {
      // Get the current user ID
      final String userId = FirebaseAuth.instance.currentUser!.uid;

      // Reference to the orders data in the database
      DatabaseReference ordersRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userId)
          .child('orders');

      // Fetch data from the database
      DatabaseEvent event = await ordersRef
          .once(); // Use .once() to fetch the data
      DataSnapshot snapshot = event.snapshot;

      // Check if the data exists
      if (snapshot.exists && snapshot.value != null) {
        // Convert the snapshot data into a map
        Map<String, dynamic> data = Map<String, dynamic>.from(
            snapshot.value as Map);

        // List to hold the fetched orders
        List<OrderModel> fetchedOrders = [];

        // Iterate over the fetched data and convert each order to OrderModel
        for (var orderData in data.values) {
          Map<String, dynamic> orderMap = Map<String, dynamic>.from(orderData);
          OrderModel order = OrderModel.fromMap(orderMap);

          // Add the order to the list
          fetchedOrders.add(order);
        }

        // Update the state with the fetched orders
        setState(() {
          orders = fetchedOrders;
        });
      }
    } catch (e) {
      // Handle any errors that occur during the fetch
      print("Error fetching orders: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error fetching orders: $e"),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchOrders();
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
            "My Orders",
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
                  OrderItemWidget(orders: orders,)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
