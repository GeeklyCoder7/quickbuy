import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../utils/colors/app_colors.dart';
import '../services/order_service.dart';  // Import the OrderService

class OrderItemWidget extends StatefulWidget {
  final List<OrderModel> orders;

  const OrderItemWidget({super.key, required this.orders});

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  // Function to handle the cancel action
  void _showCancelConfirmationDialog(OrderModel order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Order'),
          content: Text('Are you sure you want to cancel this order?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // If the user confirms, cancel the order
                Navigator.of(context).pop();
                _cancelOrder(order);
              },
              child: Text('Yes', style: TextStyle(color: AppColors.accent)),
            ),
            TextButton(
              onPressed: () {
                // If the user cancels, just close the dialog
                Navigator.of(context).pop();
              },
              child: Text('No', style: TextStyle(color: AppColors.accent)),
            ),
          ],
        );
      },
    );
  }

  void _cancelOrder(OrderModel order) async {
    try {
      // Call the cancelOrder method from OrderService to update the order status in Firebase
      await OrderService().cancelOrder(order.orderId);

      // Update the status in the UI after cancellation
      setState(() {
        order.orderStatus = 'Cancelled';
      });

      // Display a message or dialog confirming the cancellation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order ${order.orderId} has been cancelled')),
      );
    } catch (e) {
      // Handle errors if the cancelation fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel the order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.orders.length,  // Accessing orders using widget.orders
        itemBuilder: (context, index) {
          final order = widget.orders[index];  // Accessing orders using widget.orders

          return GestureDetector(
            onTap: () {
              // Navigate to order details if needed
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card_color,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.receipt_long, color: AppColors.primary),
                      SizedBox(width: 8),
                      // Wrap the Text widget in an Expanded widget to manage overflow
                      Expanded(
                        child: Text(
                          "Order ID: ${order.orderId}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.text,
                          ),
                          overflow: TextOverflow.ellipsis,  // Add ellipsis for overflow
                          maxLines: 1,  // Ensure only 1 line is used
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.currency_rupee, color: AppColors.added_to_cart_color),
                      SizedBox(width: 8),
                      Text(
                        "Total: ₹${order.orderTotal.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.added_to_cart_color,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: AppColors.accent, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Date: ${order.orderDate}",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.text.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  // Displaying the Order Status
                  Row(
                    children: [
                      // Conditional icon change based on order status
                      Icon(
                        order.orderStatus == 'Cancelled'
                            ? Icons.cancel_outlined  // Icon for cancelled order
                            : Icons.check_circle,    // Icon for normal order
                        color: order.orderStatus == 'Cancelled'
                            ? Colors.red : AppColors.accent,  // Red for cancelled, default for normal
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Status: ${order.orderStatus}",  // Assuming the order model has 'orderStatus' field
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.text.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  // Cancel button
                  if (order.orderStatus != 'Cancelled')  // Show the button only if the order is not cancelled
                    Center(
                      child: ElevatedButton(
                        onPressed: () => _showCancelConfirmationDialog(order),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,  // Set the button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text(
                          'Cancel Order',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
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
}
