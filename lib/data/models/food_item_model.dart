class FoodItemModel {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final double price;
  final String? image;
  final String category;
  final bool isAvailable;
  final bool isVeg;
  final bool isFeatured;

  FoodItemModel({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.price,
    this.image,
    required this.category,
    required this.isAvailable,
    required this.isVeg,
    required this.isFeatured,
  });

  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    return FoodItemModel(
      id: json['id'] ?? '',
      restaurantId: json['restaurant_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      image: json['image'],
      category: json['category'] ?? '',
      isAvailable: json['is_available'] ?? true,
      isVeg: json['is_veg'] ?? false,
      isFeatured: json['is_featured'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'is_available': isAvailable,
      'is_veg': isVeg,
      'is_featured': isFeatured,
    };
  }
}