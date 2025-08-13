class Order {
  final int? id;
  final int? userId;
  final int? productId;
  final int? quantity;
  final String? shippingAddress;
  final String? status; // e.g., 'pending', 'completed'
  final double? totalPrice;

  Order({
    this.id,
    this.userId,
    this.productId,
    this.quantity,
    this.shippingAddress,
    this.status,
    this.totalPrice,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      shippingAddress: json['shipping_address'],
      status: json['status'],
      totalPrice: (json['total_price'] is num) ? (json['total_price'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (userId != null) data['user_id'] = userId;
    if (productId != null) data['product_id'] = productId;
    if (quantity != null) data['quantity'] = quantity;
    if (shippingAddress != null) data['shipping_address'] = shippingAddress;
    if (status != null) data['status'] = status;
    if (totalPrice != null) data['total_price'] = totalPrice;
    return data;
  }

  @override
  String toString() {
    return 'Order(id: $id, productId: $productId, quantity: $quantity, totalPrice: $totalPrice)';
  }
}