import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../utils/colors/app_colors.dart';

class OrderItemWidget extends StatefulWidget {
  final List<OrderModel> orders;

  const OrderItemWidget({super.key, required this.orders});

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
