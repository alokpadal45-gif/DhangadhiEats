import 'package:flutter/material.dart';
import '../models/restaurant_model.dart';
import '../models/food_item_model.dart';

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

  Future<void> fetchRestaurants() async {
    _isLoading = true;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 1));
      _restaurants = _getDummyRestaurants();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMenuItems(String restaurantId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      _menuItems = _getDummyMenuItems(restaurantId);
    } catch (e) {
      _error = e.toString();
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
      RestaurantModel(
        id: '1',
        name: 'Himalayan Kitchen',
        description: 'Authentic Nepali food and momos',
        address: 'Golpark, Dhangadhi',
        phone: '9841000001',
        rating: 4.5,
        totalReviews: 120,
        deliveryTime: 25,
        deliveryFee: 60,
        minOrder: 100,
        isOpen: true,
        isActive: true,
        categories: ['Nepali', 'Momo'],
        lat: 28.6965,
        lng: 80.5855,
      ),
      RestaurantModel(
        id: '2',
        name: 'Cafe Sudurpaschim',
        description: 'Coffee, snacks and light meals',
        address: 'New Road, Dhangadhi',
        phone: '9841000002',
        rating: 4.2,
        totalReviews: 85,
        deliveryTime: 20,
        deliveryFee: 60,
        minOrder: 150,
        isOpen: true,
        isActive: true,
        categories: ['Cafe', 'Snacks'],
        lat: 28.6970,
        lng: 80.5860,
      ),
      RestaurantModel(
        id: '3',
        name: 'Tandoori House',
        description: 'Best chicken and tandoori in Dhangadhi',
        address: 'Pipalchowk, Dhangadhi',
        phone: '9841000003',
        rating: 4.7,
        totalReviews: 200,
        deliveryTime: 35,
        deliveryFee: 60,
        minOrder: 200,
        isOpen: true,
        isActive: true,
        categories: ['Chicken', 'BBQ'],
        lat: 28.6960,
        lng: 80.5850,
      ),
      RestaurantModel(
        id: '4',
        name: 'Momo Palace',
        description: 'Steam and fried momos, chowmein',
        address: 'Airport Road, Dhangadhi',
        phone: '9841000004',
        rating: 4.3,
        totalReviews: 150,
        deliveryTime: 20,
        deliveryFee: 60,
        minOrder: 100,
        isOpen: false,
        isActive: true,
        categories: ['Momo', 'Chowmein'],
        lat: 28.6975,
        lng: 80.5865,
      ),
    ];
  }

  List<FoodItemModel> _getDummyMenuItems(String restaurantId) {
    return [
      FoodItemModel(
        id: '1',
        restaurantId: restaurantId,
        name: 'Steam Momo (10 pcs)',
        description: 'Juicy steamed dumplings with tomato chutney',
        price: 120,
        category: 'Momo',
        isAvailable: true,
        isVeg: false,
        isFeatured: true,
      ),
      FoodItemModel(
        id: '2',
        restaurantId: restaurantId,
        name: 'Veg Thali',
        description: 'Dal, rice, sabji, pickle and papad',
        price: 180,
        category: 'Thali',
        isAvailable: true,
        isVeg: true,
        isFeatured: true,
      ),
      FoodItemModel(
        id: '3',
        restaurantId: restaurantId,
        name: 'Chicken Chowmein',
        description: 'Stir fried noodles with chicken and vegetables',
        price: 160,
        category: 'Noodles',
        isAvailable: true,
        isVeg: false,
        isFeatured: false,
      ),
      FoodItemModel(
        id: '4',
        restaurantId: restaurantId,
        name: 'Masala Tea',
        description: 'Hot spiced Nepali tea',
        price: 30,
        category: 'Drinks',
        isAvailable: true,
        isVeg: true,
        isFeatured: false,
      ),
      FoodItemModel(
        id: '5',
        restaurantId: restaurantId,
        name: 'Fried Momo (10 pcs)',
        description: 'Crispy fried momos with spicy sauce',
        price: 140,
        category: 'Momo',
        isAvailable: true,
        isVeg: false,
        isFeatured: true,
      ),
    ];
  }
}