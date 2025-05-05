class OrderModel {
  String orderId;
  String orderDate;
  double orderTotal;
  String deliveryAddressId;

  OrderModel({
    required this.orderId,
    required this.orderDate,
    required this.orderTotal,
    required this.deliveryAddressId,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'orderDate': orderDate,
      'orderTotal': orderTotal,
      'deliveryAddressId': deliveryAddressId,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'],
      orderDate: map['orderDate'],
      orderTotal: (map['orderTotal'] is int)
          ? (map['orderTotal'] as int).toDouble() // Convert int to double if it's an int
          : (map['orderTotal'] is double)
          ? map['orderTotal'] // If it's already a double, use it as is
          : 0.0, // Default to 0.0 if it's neither an int nor a double
      deliveryAddressId: map['deliveryAddressId'],
    );
  }
}
