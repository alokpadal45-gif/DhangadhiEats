class RestaurantModel {
  final String id;
  final String name;
  final String description;
  final String address;
  final String phone;
  final String? image;
  final double rating;
  final int totalReviews;
  final int deliveryTime;
  final double deliveryFee;
  final double minOrder;
  final bool isOpen;
  final bool isActive;
  final List<String> categories;
  final double lat;
  final double lng;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    this.image,
    required this.rating,
    required this.totalReviews,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.minOrder,
    required this.isOpen,
    required this.isActive,
    required this.categories,
    required this.lat,
    required this.lng,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      image: json['image'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
      deliveryTime: json['delivery_time'] ?? 30,
      deliveryFee: (json['delivery_fee'] ?? 0.0).toDouble(),
      minOrder: (json['min_order'] ?? 0.0).toDouble(),
      isOpen: json['is_open'] ?? true,
      isActive: json['is_active'] ?? true,
      categories: List<String>.from(json['categories'] ?? []),
      lat: (json['lat'] ?? 0.0).toDouble(),
      lng: (json['lng'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'phone': phone,
      'image': image,
      'rating': rating,
      'total_reviews': totalReviews,
      'delivery_time': deliveryTime,
      'delivery_fee': deliveryFee,
      'min_order': minOrder,
      'is_open': isOpen,
      'is_active': isActive,
      'categories': categories,
      'lat': lat,
      'lng': lng,
    };
  }
}