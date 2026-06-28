import 'package:flutter/material.dart';
import '../models/restaurant_model.dart';
import '../models/food_item_model.dart';
import '../services/api_service.dart';

class RestaurantProvider extends ChangeNotifier {
  List<RestaurantModel> _restaurants = [];
  List<FoodItemModel> _menuItems = [];
  RestaurantModel? _selectedRestaurant;
  bool _isLoading = false;
  String? _error;

  List<RestaurantModel> get restaurants => _restaurants;
  List<FoodItemModel> get menuItems => _menuItems;
  RestaurantModel? get selectedRestaurant => _selectedRestaurant;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRestaurants({String? search, String? category}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      String endpoint = '/restaurants';
      if (search != null) endpoint += '?search=$search';
      if (category != null) endpoint += '?category=$category';
      final response = await ApiService.get(endpoint);
      if (response['success'] == true) {
        _restaurants = (response['restaurants'] as List)
            .map((r) => RestaurantModel.fromJson(r))
            .toList();
      } else {
        _restaurants = _getDummyRestaurants();
      }
    } catch (e) {
      _restaurants = _getDummyRestaurants();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMenuItems(String restaurantId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await ApiService.get('/restaurants/$restaurantId/menu');
      if (response['success'] == true) {
        _menuItems = (response['menu'] as List)
            .map((item) => FoodItemModel.fromJson(item))
            .toList();
      } else {
        _menuItems = _getDummyMenuItems(restaurantId);
      }
    } catch (e) {
      _menuItems = _getDummyMenuItems(restaurantId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectRestaurant(RestaurantModel restaurant) {
    _selectedRestaurant = restaurant;
    notifyListeners();
  }

  List<RestaurantModel> _getDummyRestaurants() {
    return [
      RestaurantModel(id: '1', name: 'Galaxy Cafe', description: 'Multicuisine — tandoori, pizza, burgers, momos, Chinese & Nepali', address: 'Park Mode, Dhangadhi', phone: '9858426669', image: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=500', rating: 4.3, totalReviews: 384, deliveryTime: 25, deliveryFee: 60, minOrder: 150, isOpen: true, isActive: true, categories: ['Cafe', 'Pizza', 'Burger', 'Tandoori'], lat: 28.6965, lng: 80.5855),
      RestaurantModel(id: '2', name: 'Pepe Pizza', description: 'Best pizza in Dhangadhi with fresh toppings and crispy crust', address: 'New Road, Dhangadhi', phone: '9848000002', image: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=500', rating: 4.4, totalReviews: 210, deliveryTime: 30, deliveryFee: 60, minOrder: 200, isOpen: true, isActive: true, categories: ['Pizza', 'Fast Food'], lat: 28.6970, lng: 80.5860),
      RestaurantModel(id: '3', name: 'Hotel Siddhartha', description: 'Traditional Nepali thali, dal bhat and local specialties', address: 'Pipalchowk, Dhangadhi', phone: '9848000003', image: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500', rating: 4.2, totalReviews: 156, deliveryTime: 20, deliveryFee: 50, minOrder: 100, isOpen: true, isActive: true, categories: ['Nepali', 'Thali'], lat: 28.6960, lng: 80.5850),
      RestaurantModel(id: '4', name: 'Burger House', description: 'Juicy burgers, fried chicken, fries and cold drinks', address: 'Golpark, Dhangadhi', phone: '9848000004', image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500', rating: 4.5, totalReviews: 298, deliveryTime: 20, deliveryFee: 60, minOrder: 150, isOpen: true, isActive: true, categories: ['Burger', 'Fast Food', 'Chicken'], lat: 28.6975, lng: 80.5865),
      RestaurantModel(id: '5', name: 'Athithi Cafe', description: 'Cozy cafe with coffee, snacks, sandwiches and light meals', address: 'Sarkari Tole, Dhangadhi', phone: '9848000005', image: 'https://images.unsplash.com/photo-1521017432531-fbd92d768814?w=500', rating: 4.3, totalReviews: 142, deliveryTime: 15, deliveryFee: 40, minOrder: 100, isOpen: true, isActive: true, categories: ['Cafe', 'Snacks', 'Coffee'], lat: 28.6958, lng: 80.5848),
      RestaurantModel(id: '6', name: 'Root N Fruits', description: 'Fresh juices, smoothies, salads and healthy food', address: 'Airport Road, Dhangadhi', phone: '9848000006', image: 'https://images.unsplash.com/photo-1490474418585-ba9bad8fd0ea?w=500', rating: 4.6, totalReviews: 187, deliveryTime: 15, deliveryFee: 40, minOrder: 100, isOpen: true, isActive: true, categories: ['Healthy', 'Juice', 'Salad'], lat: 28.6962, lng: 80.5852),
      RestaurantModel(id: '7', name: 'Gurung Sekuwa', description: 'Authentic Gurung sekuwa, buff, chicken and local Nepali snacks', address: 'Pipalchowk, Dhangadhi', phone: '9848000007', image: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=500', rating: 4.7, totalReviews: 320, deliveryTime: 30, deliveryFee: 60, minOrder: 200, isOpen: true, isActive: true, categories: ['Sekuwa', 'BBQ', 'Nepali'], lat: 28.6955, lng: 80.5845),
    ];
  }

  List<FoodItemModel> _getDummyMenuItems(String restaurantId) {
    switch (restaurantId) {
      case '1':
        return [
          FoodItemModel(id: '101', restaurantId: restaurantId, name: 'Chicken Pakuwa', description: 'Crispy fried chicken with spicy sauce — Galaxy special', price: 280, category: 'Chicken', isAvailable: true, isVeg: false, isFeatured: true),
          FoodItemModel(id: '102', restaurantId: restaurantId, name: 'Veg Pizza (7 inch)', description: 'Tomato base, cheese, capsicum, onion, mushroom', price: 320, category: 'Pizza', isAvailable: true, isVeg: true, isFeatured: true),
          FoodItemModel(id: '103', restaurantId: restaurantId, name: 'Chicken Tandoori', description: 'Half chicken marinated and grilled in tandoor', price: 450, category: 'Tandoori', isAvailable: true, isVeg: false, isFeatured: true),
          FoodItemModel(id: '104', restaurantId: restaurantId, name: 'Steam Momo (10 pcs)', description: 'Juicy chicken momos with tomato chutney', price: 140, category: 'Momo', isAvailable: true, isVeg: false, isFeatured: false),
          FoodItemModel(id: '105', restaurantId: restaurantId, name: 'Chowmein', description: 'Stir fried noodles with chicken and vegetables', price: 180, category: 'Chinese', isAvailable: true, isVeg: false, isFeatured: false),
          FoodItemModel(id: '106', restaurantId: restaurantId, name: 'Cold Coffee', description: 'Chilled blended coffee with cream', price: 120, category: 'Drinks', isAvailable: true, isVeg: true, isFeatured: false),
        ];
      case '2':
        return [
          FoodItemModel(id: '201', restaurantId: restaurantId, name: 'Chicken Pizza (9 inch)', description: 'Loaded with chicken, cheese and fresh vegetables', price: 420, category: 'Pizza', isAvailable: true, isVeg: false, isFeatured: true),
          FoodItemModel(id: '202', restaurantId: restaurantId, name: 'Margherita Pizza', description: 'Classic tomato sauce, mozzarella and basil', price: 320, category: 'Pizza', isAvailable: true, isVeg: true, isFeatured: true),
          FoodItemModel(id: '203', restaurantId: restaurantId, name: 'BBQ Chicken Pizza', description: 'Smoky BBQ sauce, grilled chicken, red onion', price: 480, category: 'Pizza', isAvailable: true, isVeg: false, isFeatured: false),
          FoodItemModel(id: '204', restaurantId: restaurantId, name: 'Garlic Bread', description: 'Toasted bread with garlic butter and herbs', price: 120, category: 'Snacks', isAvailable: true, isVeg: true, isFeatured: false),
          FoodItemModel(id: '205', restaurantId: restaurantId, name: 'Soft Drink', description: 'Coke, Fanta or Sprite 330ml', price: 60, category: 'Drinks', isAvailable: true, isVeg: true, isFeatured: false),
        ];
      case '3':
        return [
          FoodItemModel(id: '301', restaurantId: restaurantId, name: 'Dal Bhat Tarkari', description: 'Full Nepali thali — dal, rice, sabji, pickle, papad', price: 180, category: 'Thali', isAvailable: true, isVeg: true, isFeatured: true),
          FoodItemModel(id: '302', restaurantId: restaurantId, name: 'Chicken Thali', description: 'Dal, rice, chicken curry, sabji and pickle', price: 250, category: 'Thali', isAvailable: true, isVeg: false, isFeatured: true),
          FoodItemModel(id: '303', restaurantId: restaurantId, name: 'Mutton Thali', description: 'Dal, rice, mutton curry, sabji and pickle', price: 320, category: 'Thali', isAvailable: true, isVeg: false, isFeatured: false),
          FoodItemModel(id: '304', restaurantId: restaurantId, name: 'Aloo Tama Bodi', description: 'Traditional Nepali curry with potato, bamboo shoot and beans', price: 150, category: 'Nepali', isAvailable: true, isVeg: true, isFeatured: false),
          FoodItemModel(id: '305', restaurantId: restaurantId, name: 'Masala Tea', description: 'Hot spiced Nepali tea with ginger and cardamom', price: 30, category: 'Drinks', isAvailable: true, isVeg: true, isFeatured: false),
        ];
      case '4':
        return [
          FoodItemModel(id: '401', restaurantId: restaurantId, name: 'Chicken Burger', description: 'Crispy fried chicken, lettuce, tomato, mayo in sesame bun', price: 220, category: 'Burger', isAvailable: true, isVeg: false, isFeatured: true),
          FoodItemModel(id: '402', restaurantId: restaurantId, name: 'Double Beef Burger', description: 'Double beef patty, cheese, onion rings, special sauce', price: 320, category: 'Burger', isAvailable: true, isVeg: false, isFeatured: true),
          FoodItemModel(id: '403', restaurantId: restaurantId, name: 'Veg Burger', description: 'Aloo tikki, lettuce, tomato, cheese and mayo', price: 160, category: 'Burger', isAvailable: true, isVeg: true, isFeatured: false),
          FoodItemModel(id: '404', restaurantId: restaurantId, name: 'French Fries', description: 'Crispy golden fries with ketchup', price: 100, category: 'Snacks', isAvailable: true, isVeg: true, isFeatured: false),
          FoodItemModel(id: '405', restaurantId: restaurantId, name: 'Fried Chicken (2 pcs)', description: 'Crispy fried chicken pieces with dipping sauce', price: 280, category: 'Chicken', isAvailable: true, isVeg: false, isFeatured: true),
          FoodItemModel(id: '406', restaurantId: restaurantId, name: 'Milkshake', description: 'Chocolate, vanilla or strawberry milkshake', price: 150, category: 'Drinks', isAvailable: true, isVeg: true, isFeatured: false),
        ];
      case '5':
        return [
          FoodItemModel(id: '501', restaurantId: restaurantId, name: 'Cappuccino', description: 'Rich espresso with steamed milk foam', price: 150, category: 'Coffee', isAvailable: true, isVeg: true, isFeatured: true),
          FoodItemModel(id: '502', restaurantId: restaurantId, name: 'Club Sandwich', description: 'Triple decker with chicken, egg, lettuce and tomato', price: 220, category: 'Snacks', isAvailable: true, isVeg: false, isFeatured: true),
          FoodItemModel(id: '503', restaurantId: restaurantId, name: 'Veg Sandwich', description: 'Fresh vegetables with cheese and mayo', price: 160, category: 'Snacks', isAvailable: true, isVeg: true, isFeatured: false),
          FoodItemModel(id: '504', restaurantId: restaurantId, name: 'Chocolate Cake (slice)', description: 'Rich chocolate cake with ganache', price: 120, category: 'Dessert', isAvailable: true, isVeg: true, isFeatured: false),
          FoodItemModel(id: '505', restaurantId: restaurantId, name: 'Lemon Tea', description: 'Refreshing hot lemon tea with honey', price: 80, category: 'Tea', isAvailable: true, isVeg: true, isFeatured: false),
        ];
      case '6':
        return [
          FoodItemModel(id: '601', restaurantId: restaurantId, name: 'Mixed Fruit Juice', description: 'Fresh seasonal fruits blended — apple, mango, orange', price: 120, category: 'Juice', isAvailable: true, isVeg: true, isFeatured: true),
          FoodItemModel(id: '602', restaurantId: restaurantId, name: 'Mango Lassi', description: 'Thick creamy mango lassi with cardamom', price: 130, category: 'Juice', isAvailable: true, isVeg: true, isFeatured: true),
          FoodItemModel(id: '603', restaurantId: restaurantId, name: 'Fruit Salad', description: 'Seasonal fruits with cream and honey', price: 150, category: 'Salad', isAvailable: true, isVeg: true, isFeatured: false),
          FoodItemModel(id: '604', restaurantId: restaurantId, name: 'Green Smoothie', description: 'Spinach, banana, apple and ginger blend', price: 160, category: 'Smoothie', isAvailable: true, isVeg: true, isFeatured: false),
          FoodItemModel(id: '605', restaurantId: restaurantId, name: 'Avocado Toast', description: 'Multigrain toast with avocado spread and seeds', price: 180, category: 'Healthy', isAvailable: true, isVeg: true, isFeatured: false),
        ];
      case '7':
        return [
          FoodItemModel(id: '701', restaurantId: restaurantId, name: 'Buff Sekuwa', description: 'Traditional Gurung style grilled buff with timur and spices', price: 320, category: 'Sekuwa', isAvailable: true, isVeg: false, isFeatured: true),
          FoodItemModel(id: '702', restaurantId: restaurantId, name: 'Chicken Sekuwa', description: 'Juicy grilled chicken with Gurung spice mix', price: 280, category: 'Sekuwa', isAvailable: true, isVeg: false, isFeatured: true),
          FoodItemModel(id: '703', restaurantId: restaurantId, name: 'Mutton Sekuwa', description: 'Tender mutton grilled on charcoal with local herbs', price: 380, category: 'Sekuwa', isAvailable: true, isVeg: false, isFeatured: true),
          FoodItemModel(id: '704', restaurantId: restaurantId, name: 'Aila (Local)', description: 'Traditional Newari rice wine — local special', price: 150, category: 'Drinks', isAvailable: true, isVeg: true, isFeatured: false),
          FoodItemModel(id: '705', restaurantId: restaurantId, name: 'Chiura Sadeko', description: 'Beaten rice with spices, onion and green chili', price: 100, category: 'Snacks', isAvailable: true, isVeg: true, isFeatured: false),
        ];
      default:
        return [
          FoodItemModel(id: 'x1', restaurantId: restaurantId, name: 'Steam Momo (10 pcs)', description: 'Juicy steamed dumplings with tomato chutney', price: 120, category: 'Momo', isAvailable: true, isVeg: false, isFeatured: true),
          FoodItemModel(id: 'x2', restaurantId: restaurantId, name: 'Veg Thali', description: 'Dal, rice, sabji, pickle and papad', price: 180, category: 'Thali', isAvailable: true, isVeg: true, isFeatured: false),
        ];
    }
  }
}