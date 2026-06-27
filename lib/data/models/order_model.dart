class OrderItem {
  final String foodItemId;
  final String name;
  final double price;
  int quantity;
  final String? image;

  OrderItem({
    required this.foodItemId,
    required this.name,
    required this.price,
    required this.quantity,
    this.image,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      foodItemId: json['food_item_id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 1,
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'food_item_id': foodItemId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'image': image,
    };
  }

  double get total => price * quantity;
}

class OrderModel {
  final String id;
  final String customerId;
  final String restaurantId;
  final String restaurantName;
  final String? riderId;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String status;
  final String paymentMethod;
  final bool isPaid;
  final String deliveryAddress;
  final DateTime createdAt;
  final DateTime? deliveredAt;

  OrderModel({
    required this.id,
    required this.customerId,
    required this.restaurantId,
    required this.restaurantName,
    this.riderId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.status,
    required this.paymentMethod,
    required this.isPaid,
    required this.deliveryAddress,
    required this.createdAt,
    this.deliveredAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      customerId: json['customer_id'] ?? '',
      restaurantId: json['restaurant_id'] ?? '',
      restaurantName: json['restaurant_name'] ?? '',
      riderId: json['rider_id'],
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => OrderItem.fromJson(e))
          .toList(),
      subtotal: (json['subtotal'] ?? 0.0).toDouble(),
      deliveryFee: (json['delivery_fee'] ?? 0.0).toDouble(),
      total: (json['total'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'pending',
      paymentMethod: json['payment_method'] ?? 'cash',
      isPaid: json['is_paid'] ?? false,
      deliveryAddress: json['delivery_address'] ?? '',
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      deliveredAt: json['delivered_at'] != null
          ? DateTime.parse(json['delivered_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'restaurant_id': restaurantId,
      'restaurant_name': restaurantName,
      'rider_id': riderId,
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'delivery_fee': deliveryFee,
      'total': total,
      'status': status,
      'payment_method': paymentMethod,
      'is_paid': isPaid,
      'delivery_address': deliveryAddress,
      'created_at': createdAt.toIso8601String(),
      'delivered_at': deliveredAt?.toIso8601String(),
    };
  }
}