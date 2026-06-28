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
      RestaurantModel(id: '1', name: 'Hotel Siddhartha', description: 'Popular Nepali thali and snacks in Dhangadhi', address: 'Pipalchowk, Dhangadhi', phone: '9848000001', image: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500', rating: 4.5, totalReviews: 120, deliveryTime: 25, deliveryFee: 60, minOrder: 100, isOpen: true, isActive: true, categories: ['Nepali', 'Thali'], lat: 28.6965, lng: 80.5855),
      RestaurantModel(id: '2', name: 'Cafe Himalaya Dhangadhi', description: 'Coffee, snacks, burgers and fast food', address: 'New Road, Dhangadhi', phone: '9848000002', image: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=500', rating: 4.3, totalReviews: 85, deliveryTime: 20, deliveryFee: 60, minOrder: 150, isOpen: true, isActive: true, categories: ['Cafe', 'Snacks'], lat: 28.6970, lng: 80.5860),
      RestaurantModel(id: '3', name: 'Momo Corner Dhangadhi', description: 'Best steam and fried momos in Dhangadhi', address: 'Golpark, Dhangadhi', phone: '9848000003', image: 'https://images.unsplash.com/photo-1626804475297-41608ea09aeb?w=500', rating: 4.6, totalReviews: 200, deliveryTime: 20, deliveryFee: 60, minOrder: 100, isOpen: true, isActive: true, categories: ['Momo', 'Chowmein'], lat: 28.6960, lng: 80.5850),
      RestaurantModel(id: '4', name: 'Hotel Kailali', description: 'Traditional Nepali food and dal bhat', address: 'Airport Road, Dhangadhi', phone: '9848000004', image: 'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=500', rating: 4.2, totalReviews: 150, deliveryTime: 30, deliveryFee: 60, minOrder: 150, isOpen: true, isActive: true, categories: ['Nepali', 'Dal Bhat'], lat: 28.6975, lng: 80.5865),
      RestaurantModel(id: '5', name: 'Tandoori Nights', description: 'Chicken tandoori, naan and BBQ specials', address: 'Sarkari Tole, Dhangadhi', phone: '9848000005', image: 'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=500', rating: 4.7, totalReviews: 180, deliveryTime: 35, deliveryFee: 60, minOrder: 200, isOpen: true, isActive: true, categories: ['Chicken', 'BBQ'], lat: 28.6958, lng: 80.5848),
      RestaurantModel(id: '6', name: 'Sudurpaschim Sweets', description: 'Fresh sweets, mithai and bakery items', address: 'Pipalchowk, Dhangadhi', phone: '9848000006', image: 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=500', rating: 4.4, totalReviews: 95, deliveryTime: 15, deliveryFee: 40, minOrder: 100, isOpen: true, isActive: true, categories: ['Sweets', 'Bakery'], lat: 28.6962, lng: 80.5852),
    ];
  }

  List<FoodItemModel> _getDummyMenuItems(String restaurantId) {
    return [
      FoodItemModel(id: '1', restaurantId: restaurantId, name: 'Steam Momo (10 pcs)', description: 'Juicy steamed dumplings with tomato chutney', price: 120, category: 'Momo', isAvailable: true, isVeg: false, isFeatured: true),
      FoodItemModel(id: '2', restaurantId: restaurantId, name: 'Veg Thali', description: 'Dal, rice, sabji, pickle and papad', price: 180, category: 'Thali', isAvailable: true, isVeg: true, isFeatured: true),
      FoodItemModel(id: '3', restaurantId: restaurantId, name: 'Chicken Chowmein', description: 'Stir fried noodles with chicken and vegetables', price: 160, category: 'Noodles', isAvailable: true, isVeg: false, isFeatured: false),
      FoodItemModel(id: '4', restaurantId: restaurantId, name: 'Masala Tea', description: 'Hot spiced Nepali tea', price: 30, category: 'Drinks', isAvailable: true, isVeg: true, isFeatured: false),
      FoodItemModel(id: '5', restaurantId: restaurantId, name: 'Fried Momo (10 pcs)', description: 'Crispy fried momos with spicy sauce', price: 140, category: 'Momo', isAvailable: true, isVeg: false, isFeatured: true),
    ];
  }
}