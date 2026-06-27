class RiderModel {
  final String id;
  final String userId;
  final String fullName;
  final String phone;
  final String? profileImage;
  final String vehicleType;
  final String vehicleNumber;
  final bool isAvailable;
  final bool isActive;
  final double totalEarnings;
  final int totalDeliveries;
  final double rating;
  final double? currentLat;
  final double? currentLng;

  RiderModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phone,
    this.profileImage,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.isAvailable,
    required this.isActive,
    required this.totalEarnings,
    required this.totalDeliveries,
    required this.rating,
    this.currentLat,
    this.currentLng,
  });

  factory RiderModel.fromJson(Map<String, dynamic> json) {
    return RiderModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profile_image'],
      vehicleType: json['vehicle_type'] ?? 'motorcycle',
      vehicleNumber: json['vehicle_number'] ?? '',
      isAvailable: json['is_available'] ?? false,
      isActive: json['is_active'] ?? true,
      totalEarnings: (json['total_earnings'] ?? 0.0).toDouble(),
      totalDeliveries: json['total_deliveries'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      currentLat: json['current_lat']?.toDouble(),
      currentLng: json['current_lng']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'full_name': fullName,
      'phone': phone,
      'profile_image': profileImage,
      'vehicle_type': vehicleType,
      'vehicle_number': vehicleNumber,
      'is_available': isAvailable,
      'is_active': isActive,
      'total_earnings': totalEarnings,
      'total_deliveries': totalDeliveries,
      'rating': rating,
      'current_lat': currentLat,
      'current_lng': currentLng,
    };
  }
}