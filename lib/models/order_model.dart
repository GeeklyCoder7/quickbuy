class OrderModel {
  String orderId;
  String orderDate;
  double orderTotal;
  String deliveryAddressId;
  Map<String, Map<String, dynamic>> products;  // Updated to Map

  OrderModel({
    required this.orderId,
    required this.orderDate,
    required this.orderTotal,
    required this.deliveryAddressId,
    required this.products,  // Store products as a map
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'orderDate': orderDate,
      'orderTotal': orderTotal,
      'deliveryAddressId': deliveryAddressId,
      'products': products,  // Add products to the map
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'],
      orderDate: map['orderDate'],
      orderTotal: map['orderTotal'],
      deliveryAddressId: map['deliveryAddressId'],
      products: Map<String, Map<String, dynamic>>.from(map['products'] ?? {}),
    );
  }
}
